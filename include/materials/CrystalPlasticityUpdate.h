//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "CrystalPlasticityStressUpdateBase.h"

class CrystalPlasticityUpdate;

/**
 * CrystalPlasticityKalidindiUpdate uses the multiplicative decomposition of the
 * deformation gradient and solves the PK2 stress residual equation at the
 * intermediate configuration to evolve the material state. The internal
 * variables are updated using an interative predictor-corrector algorithm.
 * Backward Euler integration rule is used for the rate equations.
 */

class CrystalPlasticityUpdate : public CrystalPlasticityStressUpdateBase
{
public:
  static InputParameters validParams();

  CrystalPlasticityUpdate(const InputParameters & parameters);

protected:
/**
 * Initializes the irradiated damaged planes  
 */
void getDamageSystem();
/**
 * Initializes the damage tensor
 */

void initiateDamageLoopDensity();
  /**
   * initializes the stateful properties such as
   * stress, plastic deformation gradient, slip system resistances, etc.
   */
  virtual void initQpStatefulProperties() override;

  /**
   * Sets the value of the current and previous substep iteration slip system
   * resistance to the old value at the start of the PK2 stress convergence
   * while loop.
   */
  virtual void setInitialConstitutiveVariableValues() override;

  /**
   * Sets the current slip system resistance value to the previous substep value.
   * In cases where only one substep is taken (or when the first) substep is taken,
   * this method just sets the current value to the old slip system resistance
   * value again.
   */
  virtual void setSubstepConstitutiveVariableValues() override;

  /**
   * Stores the current value of the slip system resistance into a separate
   * material property in case substepping is needed.
   */
  virtual void updateSubstepConstitutiveVariableValues() override;

  virtual bool calculateSlipRate() override;

  virtual void
  calculateEquivalentSlipIncrement(RankTwoTensor & /*equivalent_slip_increment*/) override;

  virtual void calculateConstitutiveSlipDerivative(std::vector<Real> & dslip_dtau) override;

  // Cache the slip system value before the update for the diff in the convergence check
  virtual void cacheStateVariablesBeforeUpdate() override;

  /**
   * Following the Constitutive model for slip system resistance as given in
   * Kalidindi, S.R., C.A. Bronkhorst, and L. Anand. Crystallographic texture
   * evolution in bulk deformation processing of FCC metals. Journal of the
   * Mechanics and Physics of Solids 40, no. 3 (1992): 537-569. Eqns 40 - 43.
   * The slip system resistant increment is calculated as
   * $\Delta g = \left| \Delta \gamma \cdot q^{\alpha \beta} \cdot h^{\beta} \right|$
   * and a convergence check is performed on the slip system resistance increment
   */
  virtual void calculateStateVariableEvolutionRateComponent() override;

  /*
   * Finalizes the values of the state variables and slip system resistance
   * for the current timestep after convergence has been reached.
   */
  virtual bool updateStateVariables() override;

  /*
   * Determines if the state variables, e.g. damage densities, have converged
   * by comparing the change in the values over the iteration period.
   */
  virtual bool areConstitutiveStateVariablesConverged() override;

  /*
  ///@{Varibles used in the Kalidindi 1992 slip system resistance constiutive model
  Real _T;
  Real _T_critical;
  Real _theta;
  const Real _r;
  const Real _h;
  const Real _tau_sat;
  const Real _gss_a;
  const Real _ao;
  const Real _xm;
  const Real _gss_initial;
  ///@}
  */
  /// @{ Material Parameters
  const Real _b;
  const Real _rho0;
  const Real _mu0;
  ///@}
  /// @{ Kocks-Mecking Parameters
  const Real _k1;
  const Real _k20;
  unsigned int _number_damage_loops;
  const Real _gamma_dot_k0;
  ///Maximum number of possible irradiation damage plane in the  crystalline material being modeled
  //const unsigned int _number_possible_damage_plane;
  ///@}
  /// @{ Adjustable parameters
  const Real _eta;
  const Real _hn;
  const Real _hd;
  const Real _g0;
  const Real _ao;
  const Real _xm;
  const Real _cell_vol;
  const Real _rho_l;
  ///

  /**
   * Slip system interaction matrix used to calculate the hardening contributions
   * from the self and latent slip systems, from Kalidindi et al (1992).
   */

  /// Increment of increased dislocation multiplier (h) for each slip system
  std::vector<Real> _dislocation_density_increment;
  /// File should contain damage plane normal vectors
  const unsigned int _number_possible_damage_plane;
  std::string _damage_plane_file_name;
  std::vector<RealVectorValue> _damage_plane_normal;
  /// Increment of increased damage loop for each slip system
  RankTwoTensor _damage_loop_density_initial;
  RankTwoTensor _damage_loop_density_increment;

  /**
   * Stores the values of the slip system resistance from the previous substep
   * In classes which use dislocation densities, analogous dislocation density
   * substep vectors will be required.
   */
  std::vector<Real> _previous_substep_slip_resistance;
  std::vector<Real> _previous_substep_dislocation_density;
  RankTwoTensor _previous_substep_damage_loop_density;

  /**
   * Caches the value of the current slip system resistance immediately prior
   * to the update of the slip system resistance, and is used to calculate the
   * the slip system resistance increment for the current substep (or step if
   * only one substep is taken) for the convergence check tolerance comparison.
   * In classes which use dislocation densities, analogous dislocation density
   * caching vectors will also be required.
   */
  std::vector<Real> _slip_resistance_before_update;
  std::vector<Real> _dislocation_density_before_update;
  RankTwoTensor _damage_loop_density_before_update;

  /**
   * Dislocation Density Material Property Variables
   */
  MaterialProperty<std::vector<Real>> &  _dislocation_density;
  const MaterialProperty<std::vector<Real>> &  _dislocation_density_old;
  /**
   * Damage Density Material Property Variables
   */
  MaterialProperty<RankTwoTensor> & _damage_loop_density;
  const MaterialProperty<RankTwoTensor> & _damage_loop_density_old;
  MaterialProperty<RankTwoTensor> & _equivalent_slip_increment;
  MaterialProperty<Real> & _effective_equivalent_slip_increment;
  MaterialProperty<Real> & _avg_slip_resistance_dislocation;
  MaterialProperty<Real> & _avg_slip_resistance_damage;
  MaterialProperty<std::vector<Real>> & _slip_resistance_damage;
  ///@}


  /**
   * Flag to include the total twin volume fraction in the plastic velocity
   * gradient calculation, per Kalidindi IJP (2001).
   */
  const bool _include_twinning_in_Lp;

  /**
   * User-defined material property name for the total volume fraction of twins
   * in a twinning propagation constitutive model, when this class is used in
   * conjunction with the twinning propagation model.
   * Note that this value is the OLD material property and thus lags the current
   * value by a single timestep.
   */
  const MaterialProperty<Real> * const _twin_volume_fraction_total;
};
