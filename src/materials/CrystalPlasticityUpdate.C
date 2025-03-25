//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CrystalPlasticityUpdate.h"
#include "libmesh/int_range.h"
#include <cmath>
#include <random>

registerMooseObject("SolidMechanicsApp", CrystalPlasticityUpdate);

InputParameters
CrystalPlasticityUpdate::validParams()
{
  InputParameters params = CrystalPlasticityStressUpdateBase::validParams();
  params.addClassDescription("Kalidindi version of homogeneous crystal plasticity.");
  // Material Parameters
  params.addParam<Real>("b", 2.48E-7,  "burgers vector (mm)");
  params.addParam<Real>("rho0", 10E6,  "Initial Dislocation Density (mm^-2)");
  params.addParam<Real>("mu0", 86E3,  "Shear Modulus (MPa)");
  // Kock-Mecking Parameters
  params.addParam<Real>("k1", 450,  "Dislocation Storage Constant");
  params.addParam<Real>("k20", 14,  "Dislocation Anhilation Constant");
  params.addParam<Real>("gamma_dot_k0", 10E10,  "Kock-Meking shear rate");
  // Adjustable Parameters
  params.addParam<Real>("eta", 100,  "Dislocation Anhalization Efficiency");
  params.addParam<Real>("hn", 0.125,  "dislocation density harding coefficient");
  params.addParam<Real>("hd", 0.625,  "damage loop density hardening coefficient");
  params.addParam<Real>("g0", 90,  "Initial Slip Ressistance (MPa)");
  params.addParam<Real>("ao", 3*10E4,  "Initial Slip Rate ");
  params.addParam<Real>("xm", 0.05,  "Slip Rate Evolution Power Law exponent");
  //Additional Param
  params.addParam<Real>("cell_vol", 27,  "Simulation Cell Volume (mm^3)");
  params.addParam<Real>("number_damage_loops", 100,  "Number of dislocation loop caused by irradiation damage");
  params.addRequiredParam<FileName>(
      "damage_plane_file_name",
      "Name of the file containing the damage planes containing irradiation based damage loop, one damage plane per row"
      " Usually one or more schmid plane");


  params.addParam<MaterialPropertyName>(
      "total_twin_volume_fraction",
      "Total twin volume fraction, if twinning is considered in the simulation");

  return params;
}

CrystalPlasticityUpdate::CrystalPlasticityUpdate(
    const InputParameters & parameters)
  : CrystalPlasticityStressUpdateBase(parameters),
    //Material Parameters
    _b(getParam<Real>("b")),
    _rho0(getParam<Real>("rho0")),
    _mu0(getParam<Real>("mu0")),
    //Kocks-Mecking Parameters
    _k1(getParam<Real>("k1")),
    _k20(getParam<Real>("k20")),
    _number_damage_loops(getParam<Real>("number_damage_loops")),
    _gamma_dot_k0(getParam<Real>("gamma_dot_k0")),
    //_number_possible_damage_plane(getParam<unsigned int>("number_possible_damage_plane")),
    //Adjustable Parameters
    _eta(getParam<Real>("eta")),
    _hn(getParam<Real>("hn")),
    _hd(getParam<Real>("hd")),
    _g0(getParam<Real>("g0")),
    _ao(getParam<Real>("ao")),
    _xm(getParam<Real>("xm")),
    //Additional Parameter
    _cell_vol(getParam<Real>("cell_vol")),
    _dislocation_density_increment(_number_slip_systems, 0.0),
    _damage_plane_file_name(getParam<FileName>("damage_plane_file_name")),
    //_damage_plane_normal(_number_possible_damage_plane),
    _damage_loop_density_increment(RankTwoTensor::initNone),
    // resize local caching vectors used for substepping
    _previous_substep_slip_resistance(_number_slip_systems, 0.0),
    _previous_substep_dislocation_density(_number_slip_systems, 0.0),
    _previous_substep_damage_loop_density(RankTwoTensor::initNone),
    _slip_resistance_before_update(_number_slip_systems, 0.0),
    _dislocation_density_before_update(_number_slip_systems, 0.0),
    _damage_loop_density_before_update(RankTwoTensor::initNone),
    // Initiate State Variables
    _dislocation_density(declareProperty<std::vector<Real>>(_base_name + "dislocation_density")),
    _dislocation_density_old(getMaterialPropertyOld<std::vector<Real>>(_base_name + "dislocation_density")),
    _damage_loop_density(declareProperty<RankTwoTensor>(_base_name + "damage_loop_density")),
    _damage_loop_density_old(getMaterialPropertyOld<RankTwoTensor>(_base_name + "damage_loop_density")),
    // Twinning contributions, if used
    _include_twinning_in_Lp(parameters.isParamValid("total_twin_volume_fraction")),
     _twin_volume_fraction_total(_include_twinning_in_Lp
                                     ? &getMaterialPropertyOld<Real>("total_twin_volume_fraction")
                                     : nullptr)
 {

}

RankTwoTensor
CrystalPlasticityUpdate::initiateDamageLoopDensity()
{
  // read in the damage plane data from auxiliary text file
  MooseUtils::DelimitedFileReader _dreader(_damage_plane_file_name);
  _dreader.setFormatFlag(MooseUtils::DelimitedFileReader::FormatFlag::ROWS);
  _dreader.read();


  const unsigned int number_possible_damage_plane  = _dreader.getData().size();
  std::vector<RealVectorValue> damage_plane_normal(number_possible_damage_plane);

  for (const auto i : make_range(number_possible_damage_plane))
  {
    // initialize to zero
    damage_plane_normal[i].zero();
  }

  if (_crystal_lattice_type == CrystalLatticeType::HCP)
    transformHexagonalMillerBravaisSlipSystems(_dreader);
  else if (_crystal_lattice_type == CrystalLatticeType::BCC ||
           _crystal_lattice_type == CrystalLatticeType::FCC)
  {
    for (const auto i : make_range(number_possible_damage_plane))
    {
      // directly grab the raw data and scale it by the unit cell dimension
      for (const auto j : index_range(_dreader.getData(i)))
      {
          damage_plane_normal[i](j) = _dreader.getData(i)[j] / _unit_cell_dimension[j];
      }
    }
  }

  for (const auto i : make_range(number_possible_damage_plane))
  {
    // normalize
    damage_plane_normal[i] /= damage_plane_normal[i].norm();
  }

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(0, number_possible_damage_plane);

	RankTwoTensor H; 
	RankTwoTensor Identity = RankTwoTensor::Identity();
	//For now single crystal
	RankTwoTensor crysrot = RankTwoTensor::Identity();
	std::vector<Real> local_loop_normal;
    for (const auto i : make_range(_number_damage_loops))
    {
	unsigned int randint =  distrib(gen);
	local_loop_normal.assign(3, 0); //= 0.0;
	for (const auto j : make_range(LIBMESH_DIM))
	  for (const auto k : make_range(LIBMESH_DIM))
	  {
	local_loop_normal[j] +=  crysrot(j, k) *damage_plane_normal[randint](k);
	  }
	for (const auto j : make_range(LIBMESH_DIM))
	  for (const auto k : make_range(LIBMESH_DIM))
	  {
	H(j, k) += 100*_b * (Identity(j, k) - local_loop_normal[j] * local_loop_normal[k]);
    }
}
	H = (3 * H)/_cell_vol;
	return H;
	}

void
CrystalPlasticityUpdate::initQpStatefulProperties()
{
  CrystalPlasticityStressUpdateBase::initQpStatefulProperties();
   _dislocation_density[_qp].resize(_number_slip_systems);
  for (const auto i : make_range(_number_slip_systems))
  {
    _slip_resistance[_qp][i] = _g0;
    _slip_increment[_qp][i] = 0.0;
   _dislocation_density[_qp][i] = _rho0;
  }
  // Randomly choose one of the slip planes
  _damage_loop_density[_qp] = initiateDamageLoopDensity(); 
}


void
CrystalPlasticityUpdate::setInitialConstitutiveVariableValues()
{
  // Would also set old dislocation densities here if included in this model
  _slip_resistance[_qp] = _slip_resistance_old[_qp];
  _previous_substep_slip_resistance = _slip_resistance_old[_qp];
  _dislocation_density[_qp] = _dislocation_density_old[_qp];
  _previous_substep_dislocation_density = _dislocation_density_old[_qp];
  _damage_loop_density[_qp] = _damage_loop_density_old[_qp];
  _previous_substep_damage_loop_density = _damage_loop_density_old[_qp];
}

void
CrystalPlasticityUpdate::setSubstepConstitutiveVariableValues()
{
  // Would also set substepped dislocation densities here if included in this model
  _slip_resistance[_qp] = _previous_substep_slip_resistance;
  _dislocation_density[_qp] = _previous_substep_dislocation_density;
  _damage_loop_density[_qp] = _previous_substep_damage_loop_density;
}

bool
CrystalPlasticityUpdate::calculateSlipRate()
{
  for (const auto i : make_range(_number_slip_systems))
  {
    _slip_increment[_qp][i] =
        _ao * std::pow(std::abs(_tau[_qp][i] / _slip_resistance[_qp][i]), 1.0 / _xm);
    if (_tau[_qp][i] < 0.0)
      _slip_increment[_qp][i] *= -1.0;

    if (std::abs(_slip_increment[_qp][i]) * _substep_dt > _slip_incr_tol)
    {
      if (_print_convergence_message)
        mooseWarning("Maximum allowable slip increment exceeded ",
                     std::abs(_slip_increment[_qp][i]) * _substep_dt);

      return false;
    }
  }
  return true;
}

void
CrystalPlasticityUpdate::calculateEquivalentSlipIncrement(
    RankTwoTensor & equivalent_slip_increment)
{
  // if (_include_twinning_in_Lp)
  // {
  //   for (const auto i : make_range(_number_slip_systems))
  //     equivalent_slip_increment += (1.0 - (*_twin_volume_fraction_total)[_qp]) *
  //                                  _flow_direction[_qp][i] * _slip_increment[_qp][i] * _substep_dt;
  // }
  // else // if no twinning volume fraction material property supplied, use base class
  //   CrystalPlasticityStressUpdateBase::calculateEquivalentSlipIncrement(equivalent_slip_increment);
  CrystalPlasticityStressUpdateBase::calculateEquivalentSlipIncrement(equivalent_slip_increment);
}

void
CrystalPlasticityUpdate::calculateConstitutiveSlipDerivative(
    std::vector<Real> & dslip_dtau)
{
  for (const auto i : make_range(_number_slip_systems))
  {
    if (MooseUtils::absoluteFuzzyEqual(_tau[_qp][i], 0.0))
      dslip_dtau[i] = 0.0;
    else
      dslip_dtau[i] = _ao / _xm *
                      std::pow(std::abs(_tau[_qp][i] / _slip_resistance[_qp][i]), 1.0 / _xm - 1.0) /
                      _slip_resistance[_qp][i];
  }
}

bool
CrystalPlasticityUpdate::areConstitutiveStateVariablesConverged()
{
  return isConstitutiveStateVariableConverged(_slip_resistance[_qp],
                                              _slip_resistance_before_update,
                                              _previous_substep_slip_resistance,
                                              _resistance_tol);
}

void
CrystalPlasticityUpdate::updateSubstepConstitutiveVariableValues()
{
  // Would also set substepped dislocation densities here if included in this model
  _previous_substep_slip_resistance = _slip_resistance[_qp];
  _previous_substep_dislocation_density = _dislocation_density[_qp];
  _previous_substep_damage_loop_density = _damage_loop_density[_qp];
}

void
CrystalPlasticityUpdate::cacheStateVariablesBeforeUpdate()
{
  _slip_resistance_before_update = _slip_resistance[_qp];
  _dislocation_density_before_update = _dislocation_density[_qp];
  _damage_loop_density_before_update = _damage_loop_density[_qp];
}

void
CrystalPlasticityUpdate::calculateStateVariableEvolutionRateComponent()
{
    RankTwoTensor N;
    _damage_loop_density_increment = 0.0;
  for (const auto i : make_range(_number_slip_systems))
  {
    // Clear out increment from the previous iteration
    _dislocation_density_increment[i] = 0.0;

    _dislocation_density_increment[i] = 
	_k1 * std::sqrt( _rho0 * _dislocation_density[_qp][i]) * _slip_increment[_qp][i] - _k20 * _gamma_dot_k0 * _dislocation_density[_qp][i];  

    for (const auto j : make_range(LIBMESH_DIM))
      for (const auto k : make_range(LIBMESH_DIM))
  {
      N(j, k) = _slip_plane_normal[i](j) * _slip_plane_normal[i](k);
  }
    _damage_loop_density_increment += -_eta * N.doubleContraction(_damage_loop_density[_qp]) * N * _slip_increment[_qp][i];

}
}

bool
CrystalPlasticityUpdate::updateStateVariables()
{
    RankTwoTensor N;
  // Now perform the check to see if the slip system should be updated
  _damage_loop_density_increment *= _substep_dt;
  _damage_loop_density[_qp] = _previous_substep_damage_loop_density + _damage_loop_density_increment;
  for (const auto i : make_range(_number_slip_systems))
  {
      _dislocation_density_increment[i] *= _substep_dt;
    if (_dislocation_density_increment[i] < 0.0)
      _dislocation_density[_qp][i] = _previous_substep_dislocation_density[i];
    else
      _dislocation_density[_qp][i] = _previous_substep_dislocation_density[i] + _dislocation_density_increment[i];
      

  for (const auto j : make_range(LIBMESH_DIM))
  for (const auto k : make_range(LIBMESH_DIM))
  {
      N(j, k) = _slip_plane_normal[i](j) * _slip_plane_normal[i](k);
  }
  _slip_resistance[_qp][i] = _g0 + _mu0 * _b * (std::sqrt(_hn * _dislocation_density[_qp][i]) + std::sqrt( _hd * N.doubleContraction( _damage_loop_density[_qp])));  


    if (_slip_resistance[_qp][i] < 0.0)
      return false;
  }

  return true;
}
