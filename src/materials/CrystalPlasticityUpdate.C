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

registerMooseObject("SolidMechanicsApp", CrystalPlasticityUpdate);

InputParameters
CrystalPlasticityUpdate::validParams()
{
  InputParameters params = CrystalPlasticityStressUpdateBase::validParams();
  params.addClassDescription("Kalidindi version of homogeneous crystal plasticity.");
  /*
  params.addParam<Real>("T", 295.0, "temperature");
  params.addParam<Real>("T_critical", 400.0, "critical temperature");
  params.addParam<Real>("r", 1.0, "Latent hardening coefficient");
  params.addParam<Real>("h", 541.5, "hardening constants");
  params.addParam<Real>("t_sat", 109.8, "saturated slip system strength");
  params.addParam<Real>("gss_a", 2.5, "coefficient for hardening");
  params.addParam<Real>("ao", 0.001, "slip rate coefficient");
  params.addParam<Real>("xm", 0.1, "exponent for slip rate");
  params.addParam<Real>("gss_initial", 60.8, "initial lattice friction strength of the material");
  */
  // Material Parameters
  params.addParam<Real>("b", 2.48E-10,  "burgers vector");
  params.addParam<Real>("rho0", 10E12,  "Initial Dislocation Density");
  params.addParam<Real>("mu0", 86E3,  "Shear Modulus");
  // Kock-Mecking Parameters
  params.addParam<Real>("k1", 450,  "Dislocation Storage Constant");
  params.addParam<Real>("k20", 14,  "Dislocation Anhilation Constant");
  params.addParam<Real>("gamma_dot_k0", 10E10,  "Kock-Meking shear rate");
  params.addParam<Real>("n", 100,  "Number of damage loop");
  // Adjustable Parameters
  params.addParam<Real>("eta", 100,  "Kock-Meking shear rate");
  params.addParam<Real>("hn", 0.125,  "Kock-Meking shear rate");
  params.addParam<Real>("hd", 0.0.625,  "Kock-Meking shear rate");
  params.addParam<Real>("g0", 90,  "Initial Slip Ressistance");
  params.addParam<Real>("gamma_dot_0", 3*10E4,  "Initial Slip Rate");
  params.addParam<Real>("xm", 0.05,  "Slip Rate Evolution Power Law exponent");


  params.addParam<MaterialPropertyName>(
      "total_twin_volume_fraction",
      "Total twin volume fraction, if twinning is considered in the simulation");

  return params;
}

CrystalPlasticityUpdate::CrystalPlasticityUpdate(
    const InputParameters & parameters)
  : CrystalPlasticityStressUpdateBase(parameters),
    /*
    // Constitutive values
    _T(getParam<Real>("T")),
    _T_critical(getParam<Real>("T_critical")),
    _r(getParam<Real>("r")),
    _h(getParam<Real>("h")),
    _tau_sat(getParam<Real>("t_sat")),
    _gss_a(getParam<Real>("gss_a")),
    _ao(getParam<Real>("ao")),
    _xm(getParam<Real>("xm")),
    _gss_initial(getParam<Real>("gss_initial")),
    */
    //Material Parameters
    _b(getParam<Real>("b")),
    _rho0(getParam<Real>("rho0")),
    _mu0(getParam<Real>("mu0")),
    //Kocks-Mecking Parameters
    _k1(getParam<Real>("k1")),
    _k20(getParam<Real>("k20")),
    _gamma_dot_k0(getParam<Real>("gamma_dot_k0")),
    //Adjustable Parameters
    _eta(getParam<Real>("eta")),
    _hn(getParam<Real>("hn")),
    _hd(getParam<Real>("hd")),
    _g0(getParam<Real>("g0")),
    _gamma_dot_0(getParam<Real>("gamma_dot_0")),
    _xm(getParam<Real>("xm")),

    // resize vectors used in the consititutive slip hardening
    //_hb(_number_slip_systems, 0.0),
//    _slip_resistance_increment(_number_slip_systems, 0.0),
    _dislocation_density_increment(_number_slip_systems, 0.0),
    _damage_loop_density_increment(LIBMESH_DIM, LIBMESH_DIM, 0.0)
    // resize local caching vectors used for substepping
    _previous_substep_slip_resistance(_number_slip_systems, 0.0),
    _slip_resistance_before_update(_number_slip_systems, 0.0),
    _previous_substep_dislocation_density(_number_slip_systems, 0.0),
    _dislocation_density_before_update(_number_slip_systems, 0.0),
    _previous_substep_damage_loop_density(LIBMESH_DIM, LIBMESH_DIM, 0.0)
    _damage_loop_density_before_update(LIBMESH_DIM, LIBMESH_DIM, 0.0)
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
CrystalPlasticityUpdate::initiateDamageLoopDensity( std::vector<RealVectorValue> & plane_normal_vector)
{
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(0, _number_slip_systems);

	RankTwoTensor H = 0; 
	RankTwoTensor Identity = RankTwoTensor::Identity();
	//For now single crystal
	RankTwoTensor crysrot = RankTwoTensor::Identity();
	std::vector<Real> local_loop_normal;
    for (const auto i : make_range(_number_damage_loop))
    {
	unsigned int randint =  distrib(gen);
	local_loop_normal.zero();
	for (const auto j : make_range(LIBMESH_DIM))
	  for (const auto k : make_range(LIBMESH_DIM))
	  {
	local_loop_normal(j) +=  crysrot(j, k) * plane_normal_vector[randint](k);
	  }
	for (const auto j : make_range(LIBMESH_DIM))
	  for (const auto k : make_range(LIBMESH_DIM))
	  {
	H(j, k) += _dl * (Identity(j, k) - local_loop_normal(j) * local_loop_normal(k));
    }
}
	H = (3 * H)/_cell_vol;
	return H;
	}

void
CrystalPlasticityUpdate::initQpStatefulProperties()
{
  CrystalPlasticityStressUpdateBase::initQpStatefulProperties();
  for (const auto i : make_range(_number_slip_systems))
  {
    _slip_resistance[_qp][i] = _g0;
    _slip_increment[_qp][i] = 0.0;
    _dislocation_density[_qp][i] = _rho0;
  }
  // Randomly choose one of the slip planes
  _damage_loop_density[_qp] = initiateDamageLoopDensity( _slip_plane_normal); 
}


void
CrystalPlasticityUpdate::setInitialConstitutiveVariableValues()
{
  // Would also set old dislocation densities here if included in this model
  _slip_resistance[_qp] = _slip_resistance_old[_qp];
  _previous_substep_slip_resistance = _slip_resistance_old[_qp];
  _dislocation_density[_qp] = _dislocation_density[_qp];
  _previous_substep_dislocation_density = _dislocation_density[_qp];
  _damage_loop_density[_qp] = _damage_loop_density_old[_qp];
  _previous_substep_damage_loop_density[_qp] = _damage_loop_density_old[_qp];
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
  _damage_loop_denisity_before_update = _damage_loop_denisity[_qp];
}

void
CrystalPlasticityUpdate::calculateStateVariableEvolutionRateComponent()
{
    _damage_loop_density_increment[i].zero() ;
  for (const auto i : make_range(_number_slip_systems))
  {
    // Clear out increment from the previous iteration
    //_slip_resistance_increment[i] = 0.0;
    _dislocation_density_increment[i].zero() ;
    //
    _dislocation_density_increment[i] = 
	_k1 * std::sqrt( _rho0 * _dislocation_density[_qp][i]) * _slip_increment[_qp][i] - _k20 * _gamma_dot_k0 * _dislocation_density[_qp][i];  

  for (const auto j : make_range(_number_slip_systems))
  for (const auto k : make_range(_number_slip_systems))
  {
      N(j, k) = _slip_plane_normal[i](j) * _slip_plane_normal[i](k);
  }
    _damage_loop_density_increment += -_eta * N.doubleContraction(_damage_loop_density[_qp]) * N * _slip_increment[_qp][i];
    /*

    _hb[i] = _h * std::pow(std::abs(1.0 - _slip_resistance[_qp][i] / _tau_sat), _gss_a);
    const Real hsign = 1.0 - _slip_resistance[_qp][i] / _tau_sat;
    if (hsign < 0.0)
      _hb[i] *= -1.0;
  }

  for (const auto i : make_range(_number_slip_systems))
  {
    for (const auto j : make_range(_number_slip_systems))
    {
      unsigned int iplane, jplane;
      iplane = i / 3;
      jplane = j / 3;

      if (iplane == jplane) // self vs. latent hardening
        _slip_resistance_increment[i] +=
            std::abs(_slip_increment[_qp][j]) * _hb[j]; // q_{ab} = 1.0 for self hardening
      else
        _slip_resistance_increment[i] +=
            std::abs(_slip_increment[_qp][j]) * _r * _hb[j]; // latent hardenign
    }
  }
  */

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
      _dislocation_density[_qp][i] = _previous_substep_dislocation_density[i] + _dislocation_density_increment[i];
      
      /*
    _slip_resistance_increment[i] *= _substep_dt;
    if (_previous_substep_slip_resistance[i] < _zero_tol && _slip_resistance_increment[i] < 0.0)
      _slip_resistance[_qp][i] = _previous_substep_slip_resistance[i];
    else
      _slip_resistance[_qp][i] =
          _previous_substep_slip_resistance[i] + _slip_resistance_increment[i];
	  */
  for (const auto j : make_range(_number_slip_systems))
  for (const auto k : make_range(_number_slip_systems))
  {
      N(j, k) = _slip_plane_normal[i](j) * _slip_plane_normal[i](k);
  }
  _slip_resistance[_qp][i] = _g0 + _mu0 * _b * (std::sqrt(_hn * _dislocation_density[_qp][i]) + std::sqrt( _hd * N.doubleContraction( _damage_loop_density[_qp])));  


    if (_slip_resistance[_qp][i] < 0.0)
      return false;
  }

  return true;
}
