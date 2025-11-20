[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  [./fmg]
    type = FileMeshGenerator
    file = six_grain_poly.msh
    allow_renumbering = False
  []
  [scale_down]
    type = TransformGenerator
    input = fmg
    transform = SCALE
    vector_value = '1.5e-3 1.5e-3 1.5e-3'
  []
[]

[MeshDivisions]
  [block_div]
    type = SubdomainsDivision
  []
[]

[UserObjects]
  [prop_read]
    type = PropertyReadFile
    prop_file_name = 'euler_ang_six_grain.txt'
    #use_random_voronoi = false
    read_type = 'block'
    nblock = 6
    nprop = 3
  []
[]

[AuxVariables]
  [eff_plastic_strain_inc]
    order = CONSTANT
    family = MONOMIAL
  []
  [avg_slip_resistance_dislocation_comp]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_hydro]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_vm]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [fp_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_0]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_1]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_2]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_3]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_4]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_5]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_6]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_7]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_8]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_9]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_10]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_increment_11]
    order = CONSTANT
    family = MONOMIAL
  []
  [euler_angle_1]
      order = CONSTANT
      family = MONOMIAL
   []
  [euler_angle_2]
      order = CONSTANT
      family = MONOMIAL
   []
  [euler_angle_3]
      order = CONSTANT
      family = MONOMIAL
   []
[]

[Physics/SolidMechanics/QuasiStatic/all]
  strain = FINITE
  add_variables = true
[]

[AuxKernels]
  [eff_plastic_strain_inc]
    type = MaterialRealAux
    variable = eff_plastic_strain_inc
    property = effective_equivalent_slip_increment
    execute_on = timestep_end
  []
  [avg_slip_resistance_dislocation_comp]
    type = MaterialRealAux
    variable = avg_slip_resistance_dislocation_comp
    property = avg_slip_resistance_dislocation
    execute_on = timestep_end
  []
  [stress_hydro]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = stress_hydro
    scalar_type = Hydrostatic
    execute_on = timestep_end
  []
  [stress_vm]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = stress_vm
    scalar_type = VonMisesStress
    execute_on = timestep_end
  []
  [stress_xx]
    type = RankTwoAux
    variable = stress_xx
    rank_two_tensor = stress
    index_j = 0
    index_i = 0
    execute_on = timestep_end
  []
  [fp_xx]
    type = RankTwoAux
    variable = fp_xx
    rank_two_tensor = plastic_deformation_gradient
    index_j = 0
    index_i = 0
    execute_on = timestep_end
  []
  [slip_increment_0]
   type = MaterialStdVectorAux
   variable = slip_increment_0
   property = slip_increment
   index = 0
   execute_on = timestep_end
  []
  [slip_increment_1]
   type = MaterialStdVectorAux
   variable = slip_increment_1
   property = slip_increment
   index = 1
   execute_on = timestep_end
  []
  [slip_increment_2]
   type = MaterialStdVectorAux
   variable = slip_increment_2
   property = slip_increment
   index = 2
   execute_on = timestep_end
  []
  [slip_increment_3]
   type = MaterialStdVectorAux
   variable = slip_increment_3
   property = slip_increment
   index = 3
   execute_on = timestep_end
  []
  [slip_increment_4]
   type = MaterialStdVectorAux
   variable = slip_increment_4
   property = slip_increment
   index = 4
   execute_on = timestep_end
  []
  [slip_increment_5]
   type = MaterialStdVectorAux
   variable = slip_increment_5
   property = slip_increment
   index = 5
   execute_on = timestep_end
  []
  [slip_increment_6]
   type = MaterialStdVectorAux
   variable = slip_increment_6
   property = slip_increment
   index = 6
   execute_on = timestep_end
  []
  [slip_increment_7]
   type = MaterialStdVectorAux
   variable = slip_increment_7
   property = slip_increment
   index = 7
   execute_on = timestep_end
  []
  [slip_increment_8]
   type = MaterialStdVectorAux
   variable = slip_increment_8
   property = slip_increment
   index = 8
   execute_on = timestep_end
  []
  [slip_increment_9]
   type = MaterialStdVectorAux
   variable = slip_increment_9
   property = slip_increment
   index = 9
   execute_on = timestep_end
  []
  [slip_increment_10]
   type = MaterialStdVectorAux
   variable = slip_increment_10
   property = slip_increment
   index = 10
   execute_on = timestep_end
  []
  [slip_increment_11]
   type = MaterialStdVectorAux
   variable = slip_increment_11
   property = slip_increment
   index = 11
   execute_on = timestep_end
  []
  [euler_angle_1]
    type = MaterialRealVectorValueAux
    variable = euler_angle_1
    property = updated_Euler_angle
    component = 0
    execute_on = timestep_end
  []
  [euler_angle_2]
    type = MaterialRealVectorValueAux
    variable = euler_angle_2
    property = updated_Euler_angle
    component = 1 
    execute_on = timestep_end
  []
  [euler_angle_3]
    type = MaterialRealVectorValueAux
    variable = euler_angle_3
    property = updated_Euler_angle
    component = 2
    execute_on = timestep_end
  []
[]

[BCs]
  [fix_y]
    type = DirichletBC
    variable = disp_y
    preset = true
    boundary = 'bottom'
    value = 0
  []
  [fix_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'left'
    value = 0
  []
  [fix_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'back'
    value = 0
  []
  [tdisp]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 'right' 
    function = '0.3*t'
  []
[]

[Materials]
  [elasticity_tensor]
    type = ComputeElasticityTensorCP
    #C_ijkl = '2.04e5 1.36e5 1.36e5 2.04e5 1.36e5 2.04e5 1.26e5 1.26e5 1.26e5' # roughly austenitic steel
    C_ijkl = '2.24e5 1.496e5 1.496e5 2.464e5 1.1496e5 2.464e5 1.386e5 1.386e5 1.386e5' # roughly austenitic steel
    fill_method = symmetric9
    read_prop_user_object = prop_read
  []
  [stress]
    type = ComputeMultipleCrystalPlasticityStress
    crystal_plasticity_models = 'slip_xtalpl'
    tan_mod_type = exact
  []
  [slip_xtalpl]
    type = CrystalPlasticityUpdateIrr
    number_slip_systems = 12
    slip_sys_file_name = input_slip_sys_fcc12.txt
    read_prop_user_object = prop_read
    mu0 = 80E3 # shear modulus in GPa
    g0 = 90 # CRSS MPa
    ao = 3E4 # initial slip rate
    # Disloction Hardening Params
    rho0 = 10E6 # An arbritary dislocation density
    rho_n = 10E6 # Initial dislocation density
    k1 = 450E2 # Kock-Mecking Storage Parameters
    k20 = 14 # Kock-Mecking Anhiliation Parameters
    gamma_dot_k0 = 3E4 # Reference Strain Rate
    # Irradiation Hardening Params
    number_possible_damage_plane = 16
    damage_plane_file_name = input_damage_plane_fcc.txt
    damage_loop_diameter = 5.5E-6 # 5.5 nm diameter
    rho_l = 3E14 # irradiation damage loop density
    eta = 66.6 # Anahiliation Efficiency
    hn = 0.125
    hd = 0.625
    xm = 0.05
    #Stochasticity Parameters
#    stochastic_inhomogenity = true
#    shape_parameter = 0.5
    irradiation = false
  []
  [updated_euler_angle]
    type = ComputeUpdatedEulerAngle
  []
[]

[Postprocessors]
  [eff_plastic_strain_inc]
    type = ElementAverageValue
    variable = eff_plastic_strain_inc
  []
  [gb_eff_plastic_strain_inc_avg]
    type = SideAverageValue
    variable = eff_plastic_strain_inc
    boundary = 'grain_boundary'
  []
  [gb_eff_plastic_strain_inc_max]
    type = SideExtremeValue
    variable = eff_plastic_strain_inc
    boundary = 'grain_boundary'
  []
  [avg_slip_resistance_dislocation_comp]
    type = ElementAverageValue
    variable = avg_slip_resistance_dislocation_comp
  []
  [stress_hydro]
    type = ElementAverageValue
    variable = stress_hydro
  []
  [gb_stress_hydro_avg]
    type = SideAverageValue
    variable = stress_hydro
    boundary = 'grain_boundary'
  []
  [gb_stress_hydro_max]
    type = SideExtremeValue
    variable = stress_hydro
    boundary = 'grain_boundary'
  []
  [stress_vm]
    type = ElementAverageValue
    variable = stress_vm
  []
  [gb_stress_vm_avg]
    type = SideAverageValue
    variable = stress_vm
    boundary = 'grain_boundary'
  []
  [gb_stress_vm_max]
    type = SideExtremeValue
    variable = stress_vm
    boundary = 'grain_boundary'
  []
  [stress_xx]
    type = ElementAverageValue
    variable = stress_xx
  []
  [fp_xx]
    type = ElementAverageValue
    variable = fp_xx
  []
  [slip_increment_0]
    type = ElementAverageValue
    variable = slip_increment_0
  []
  [slip_increment_1]
    type = ElementAverageValue
    variable = slip_increment_1
  []
  [slip_increment_2]
    type = ElementAverageValue
    variable = slip_increment_2
  []
  [slip_increment_3]
    type = ElementAverageValue
    variable = slip_increment_3
  []
  [slip_increment_4]
    type = ElementAverageValue
    variable = slip_increment_4
  []
  [slip_increment_5]
    type = ElementAverageValue
    variable = slip_increment_5
  []
  [slip_increment_6]
    type = ElementAverageValue
    variable = slip_increment_6
  []
  [slip_increment_7]
    type = ElementAverageValue
    variable = slip_increment_7
  []
  [slip_increment_8]
    type = ElementAverageValue
    variable = slip_increment_8
  []
  [slip_increment_9]
    type = ElementAverageValue
    variable = slip_increment_9
  []
  [slip_increment_10]
    type = ElementAverageValue
    variable = slip_increment_10
  []
  [slip_increment_11]
    type = ElementAverageValue
    variable = slip_increment_11
  []
  [euler_angle_1]
    type = ElementAverageValue
    variable = euler_angle_1
  []
  [euler_angle_2]
    type = ElementAverageValue
    variable = euler_angle_2
  []
  [euler_angle_3]
    type = ElementAverageValue
    variable = euler_angle_3
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = ' asm      2              lu            gmres     200'
  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-4
  nl_abs_step_tol = 1e-3

  dt = 1E-5
  dtmin = 1E-25
#  num_steps = 100
  end_time = 5e-3
#  [./Adaptivity]
#      refine_fraction = 0.3
#      max_h_level = 7
#      cycles_per_step = 2
#    [Indicators]
#        [error]
#          type = AnalyticalIndicator
#          variable = c
#          function = solution
#        []
#      []
#    [Markers]
#        [errorfrac]
#          type = ErrorFractionMarker
#          coarsen = 0.0
#          indicator = error
#          refine = 0.1
#        []
#      []
#    [../]
[]

[Outputs]
  execute_on = timestep_end
  exodus = true
  csv = true
  perf_graph = true
  [out]
    type = Checkpoint
    time_step_interval = 10
    num_files = 5
    wall_time_interval = 3600 # seconds
  []
[]
