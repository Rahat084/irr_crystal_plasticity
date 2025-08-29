[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  [./fmg]
    type = FileMeshGenerator
    file = EightGrains.msh
    allow_renumbering = False
  []
  [scale_down]
    type = TransformGenerator
    input = fmg
    transform = SCALE
    vector_value = '3e-3 3e-3 3e-3'
  []
[]

[UserObjects]
  [prop_read]
    type = PropertyReadFile
    prop_file_name = 'euler_ang_file.txt'
    use_random_voronoi = false
    read_type = 'voronoi'
    nvoronoi = 8 
    nprop = 3
  []
[]

[AuxVariables]
  [eff_plastic_strain_inc]
    order = CONSTANT
    family = MONOMIAL
  []
  [gb_eff_plastic_strain_inc]
    order = CONSTANT
    family = MONOMIAL
  []
  [avg_slip_resistance_dislocation_comp]
    order = CONSTANT
    family = MONOMIAL
  []
  [avg_slip_resistance_damage_comp]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_vm]
    order = CONSTANT
    family = MONOMIAL
  []
  [gb_stress_vm]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [fp_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [total_twin_volume_fraction]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_0]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_1]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_2]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_3]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_4]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_5]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_6]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_7]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_8]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_9]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_10]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_11]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_12]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_13]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_14]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_15]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_16]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_17]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_18]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_19]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_20]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_21]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_22]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_23]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_24]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_25]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_26]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_27]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_28]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_29]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_30]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_31]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_32]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_33]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_34]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_35]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_36]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_37]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_38]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_39]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_40]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_41]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_42]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_43]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_44]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_45]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_46]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_47]
    order = CONSTANT
    family = MONOMIAL
  []
  [slip_resistance_damage_48]
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
    variable = gb_eff_plastic_strain_inc
    property = effective_equivalent_slip_increment
    execute_on = timestep_end
  []
  [gb_eff_plastic_strain_inc]
    type = MaterialRealAux
    variable = gb_eff_plastic_strain_inc
    property = effective_equivalent_slip_increment
    boundary = 195
    check_boundary_restricted = false
    execute_on = timestep_end
  []
  [avg_slip_resistance_dislocation_comp]
    type = MaterialRealAux
    variable = avg_slip_resistance_dislocation_comp
    property = avg_slip_resistance_dislocation
    execute_on = timestep_end
  []
  [avg_slip_resistance_damage_comp]
    type = MaterialRealAux
    variable = avg_slip_resistance_damage_comp
    property = avg_slip_resistance_damage
    execute_on = timestep_end
  []
  [stress_vm]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = stress_vm
    scalar_type = VonMisesStress
    execute_on = timestep_end
  []
  [gb_stress_vm]
    type = RankTwoScalarAux
    rank_two_tensor = stress
    variable = gb_stress_vm
    scalar_type = VonMisesStress
    boundary = 195
    check_boundary_restricted = false
    execute_on = timestep_end
  []
  [stress_zz]
    type = RankTwoAux
    variable = stress_zz
    rank_two_tensor = stress
    index_j = 2
    index_i = 2
    execute_on = timestep_end
  []
  [fp_zz]
    type = RankTwoAux
    variable = fp_zz
    rank_two_tensor = plastic_deformation_gradient
    index_j = 2
    index_i = 2
    execute_on = timestep_end
  []
  [slip_resistance_damage_0]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_0
   property = slip_resistance_damage
   index = 0
   execute_on = timestep_end
  []
  [slip_resistance_damage_1]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_1
   property = slip_resistance_damage
   index = 1
   execute_on = timestep_end
  []
  [slip_resistance_damage_2]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_2
   property = slip_resistance_damage
   index = 2
   execute_on = timestep_end
  []
  [slip_resistance_damage_3]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_3
   property = slip_resistance_damage
   index = 3
   execute_on = timestep_end
  []
  [slip_resistance_damage_4]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_4
   property = slip_resistance_damage
   index = 4
   execute_on = timestep_end
  []
  [slip_resistance_damage_5]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_5
   property = slip_resistance_damage
   index = 5
   execute_on = timestep_end
  []
  [slip_resistance_damage_6]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_6
   property = slip_resistance_damage
   index = 6
   execute_on = timestep_end
  []
  [slip_resistance_damage_7]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_7
   property = slip_resistance_damage
   index = 7
   execute_on = timestep_end
  []
  [slip_resistance_damage_8]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_8
   property = slip_resistance_damage
   index = 8
   execute_on = timestep_end
  []
  [slip_resistance_damage_9]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_9
   property = slip_resistance_damage
   index = 9
   execute_on = timestep_end
  []
  [slip_resistance_damage_10]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_10
   property = slip_resistance_damage
   index = 10
   execute_on = timestep_end
  []
  [slip_resistance_damage_11]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_11
   property = slip_resistance_damage
  []
  [slip_resistance_damage_12]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_12
   property = slip_resistance_damage
   index = 12
   execute_on = timestep_end
  []
  [slip_resistance_damage_13]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_13
   property = slip_resistance_damage
   index = 13
   execute_on = timestep_end
  []
  [slip_resistance_damage_14]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_14
   property = slip_resistance_damage
   index = 14
   execute_on = timestep_end
  []
  [slip_resistance_damage_15]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_15
   property = slip_resistance_damage
   index = 15
   execute_on = timestep_end
  []
  [slip_resistance_damage_16]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_16
   property = slip_resistance_damage
   index = 16
   execute_on = timestep_end
  []
  [slip_resistance_damage_17]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_17
   property = slip_resistance_damage
   index = 17
   execute_on = timestep_end
  []
  [slip_resistance_damage_18]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_18
   property = slip_resistance_damage
   index = 18
   execute_on = timestep_end
  []
  [slip_resistance_damage_19]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_19
   property = slip_resistance_damage
   index = 19
   execute_on = timestep_end
  []
  [slip_resistance_damage_20]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_20
   property = slip_resistance_damage
   index = 20
   execute_on = timestep_end
  []
  [slip_resistance_damage_21]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_21
   property = slip_resistance_damage
   index = 21
   execute_on = timestep_end
  []
  [slip_resistance_damage_22]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_22
   property = slip_resistance_damage
   index = 22
   execute_on = timestep_end
  []
  [slip_resistance_damage_23]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_23
   property = slip_resistance_damage
   index = 23
   execute_on = timestep_end
  []
  [slip_resistance_damage_24]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_24
   property = slip_resistance_damage
   index = 24
   execute_on = timestep_end
  []
  [slip_resistance_damage_25]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_25
   property = slip_resistance_damage
   index = 25
   execute_on = timestep_end
  []
  [slip_resistance_damage_26]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_26
   property = slip_resistance_damage
   index = 26
   execute_on = timestep_end
  []
  [slip_resistance_damage_27]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_27
   property = slip_resistance_damage
   index = 27
   execute_on = timestep_end
  []
  [slip_resistance_damage_28]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_28
   property = slip_resistance_damage
   index = 28
   execute_on = timestep_end
  []
  [slip_resistance_damage_29]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_29
   property = slip_resistance_damage
   index = 29
   execute_on = timestep_end
  []
  [slip_resistance_damage_30]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_30
   property = slip_resistance_damage
   index = 30
   execute_on = timestep_end
  []
  [slip_resistance_damage_31]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_31
   property = slip_resistance_damage
   index = 31
   execute_on = timestep_end
  []
  [slip_resistance_damage_32]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_32
   property = slip_resistance_damage
   index = 32
   execute_on = timestep_end
  []
  [slip_resistance_damage_33]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_33
   property = slip_resistance_damage
   index = 33
   execute_on = timestep_end
  []
  [slip_resistance_damage_34]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_34
   property = slip_resistance_damage
   index = 34
   execute_on = timestep_end
  []
  [slip_resistance_damage_35]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_35
   property = slip_resistance_damage
   index = 35
   execute_on = timestep_end
  []
  [slip_resistance_damage_36]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_36
   property = slip_resistance_damage
   index = 36
   execute_on = timestep_end
  []
  [slip_resistance_damage_37]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_37
   property = slip_resistance_damage
   index = 37
   execute_on = timestep_end
  []
  [slip_resistance_damage_38]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_38
   property = slip_resistance_damage
   index = 38
   execute_on = timestep_end
  []
  [slip_resistance_damage_39]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_39
   property = slip_resistance_damage
   index = 39
   execute_on = timestep_end
  []
  [slip_resistance_damage_40]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_40
   property = slip_resistance_damage
   index = 40
   execute_on = timestep_end
  []
  [slip_resistance_damage_41]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_41
   property = slip_resistance_damage
   index = 41
   execute_on = timestep_end
  []
  [slip_resistance_damage_42]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_42
   property = slip_resistance_damage
   index = 42
   execute_on = timestep_end
  []
  [slip_resistance_damage_43]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_43
   property = slip_resistance_damage
   index = 43
   execute_on = timestep_end
  []
  [slip_resistance_damage_44]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_44
   property = slip_resistance_damage
   index = 44
   execute_on = timestep_end
  []
  [slip_resistance_damage_45]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_45
   property = slip_resistance_damage
   index = 45
   execute_on = timestep_end
  []
  [slip_resistance_damage_46]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_46
   property = slip_resistance_damage
   index = 46
   execute_on = timestep_end
  []
  [slip_resistance_damage_47]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_47
   property = slip_resistance_damage
   index = 47
   execute_on = timestep_end
  []
  [slip_resistance_damage_48]
   type = MaterialStdVectorAux
   variable = slip_resistance_damage_48
   property = slip_resistance_damage
   index = 48
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
    variable = disp_z
    boundary = front
    function = '0.3*t'
  []
[]

[Materials]
  [elasticity_tensor]
    type = ComputeElasticityTensorCP
    C_ijkl = '2.36e5 1.34e5 1.34e5 2.36e5 1.34e5 2.36e5 1.19e5 1.19e5 1.19e5' # roughly Iron
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
    number_slip_systems = 48
    slip_sys_file_name = input_slip_sys_bcc48.txt
    number_possible_damage_plane = 12
    damage_plane_file_name = input_damage_plane_bcc.txt
    read_prop_user_object = prop_read
    #gamma_dot_k0 = 1E6
    #k1 = 450E1
  []
[]

[Postprocessors]
  [eff_plastic_strain_inc]
    type = ElementAverageValue
    variable = eff_plastic_strain_inc
  []
  [gb_eff_plastic_strain_inc_avg]
    type = ElementAverageValue
    variable = gb_eff_plastic_strain_inc
  []
  [gb_eff_plastic_strain_inc_max]
    type = ElementExtremeValue
    variable = gb_eff_plastic_strain_inc
    value_type = max
  []
  [avg_slip_resistance_dislocation_comp]
    type = ElementAverageValue
    variable = avg_slip_resistance_dislocation_comp
  []
  [avg_slip_resistance_damage_comp]
    type = ElementAverageValue
    variable = avg_slip_resistance_damage_comp
  []
  [stress_vm]
    type = ElementAverageValue
    variable = stress_vm
  []
  [gb_stress_vm_avg]
    type = ElementAverageValue
    variable = gb_stress_vm
  []
  [gb_stress_vm_max]
    type = ElementExtremeValue
    variable = gb_stress_vm
    value_type = max
  []
  [stress_zz]
    type = ElementAverageValue
    variable = stress_zz
  []
  [fp_zz]
    type = ElementAverageValue
    variable = fp_zz
  []
  [total_twin_volume_fraction]
    type = ElementAverageValue
    variable = total_twin_volume_fraction
  []
  [slip_resistance_damage_0]
    type = ElementAverageValue
    variable = slip_resistance_damage_0
  []
  [slip_resistance_damage_1]
    type = ElementAverageValue
    variable = slip_resistance_damage_1
  []
  [slip_resistance_damage_2]
    type = ElementAverageValue
    variable = slip_resistance_damage_2
  []
  [slip_resistance_damage_3]
    type = ElementAverageValue
    variable = slip_resistance_damage_3
  []
  [slip_resistance_damage_4]
    type = ElementAverageValue
    variable = slip_resistance_damage_4
  []
  [slip_resistance_damage_5]
    type = ElementAverageValue
    variable = slip_resistance_damage_5
  []
  [slip_resistance_damage_6]
    type = ElementAverageValue
    variable = slip_resistance_damage_6
  []
  [slip_resistance_damage_7]
    type = ElementAverageValue
    variable = slip_resistance_damage_7
  []
  [slip_resistance_damage_8]
    type = ElementAverageValue
    variable = slip_resistance_damage_8
  []
  [slip_resistance_damage_9]
    type = ElementAverageValue
    variable = slip_resistance_damage_9
  []
  [slip_resistance_damage_10]
    type = ElementAverageValue
    variable = slip_resistance_damage_10
  []
  [slip_resistance_damage_11]
    type = ElementAverageValue
    variable = slip_resistance_damage_11
  []
  [slip_resistance_damage_12]
    type = ElementAverageValue
    variable = slip_resistance_damage_12
  []
  [slip_resistance_damage_13]
    type = ElementAverageValue
    variable = slip_resistance_damage_13
  []
  [slip_resistance_damage_14]
    type = ElementAverageValue
    variable = slip_resistance_damage_14
  []
  [slip_resistance_damage_15]
    type = ElementAverageValue
    variable = slip_resistance_damage_15
  []
  [slip_resistance_damage_16]
    type = ElementAverageValue
    variable = slip_resistance_damage_16
  []
  [slip_resistance_damage_17]
    type = ElementAverageValue
    variable = slip_resistance_damage_17
  []
  [slip_resistance_damage_18]
    type = ElementAverageValue
    variable = slip_resistance_damage_18
  []
  [slip_resistance_damage_19]
    type = ElementAverageValue
    variable = slip_resistance_damage_19
  []
  [slip_resistance_damage_20]
    type = ElementAverageValue
    variable = slip_resistance_damage_20
  []
  [slip_resistance_damage_21]
    type = ElementAverageValue
    variable = slip_resistance_damage_21
  []
  [slip_resistance_damage_22]
    type = ElementAverageValue
    variable = slip_resistance_damage_22
  []
  [slip_resistance_damage_23]
    type = ElementAverageValue
    variable = slip_resistance_damage_23
  []
  [slip_resistance_damage_24]
    type = ElementAverageValue
    variable = slip_resistance_damage_24
  []
  [slip_resistance_damage_25]
    type = ElementAverageValue
    variable = slip_resistance_damage_25
  []
  [slip_resistance_damage_26]
    type = ElementAverageValue
    variable = slip_resistance_damage_26
  []
  [slip_resistance_damage_27]
    type = ElementAverageValue
    variable = slip_resistance_damage_27
  []
  [slip_resistance_damage_28]
    type = ElementAverageValue
    variable = slip_resistance_damage_28
  []
  [slip_resistance_damage_29]
    type = ElementAverageValue
    variable = slip_resistance_damage_29
  []
  [slip_resistance_damage_30]
    type = ElementAverageValue
    variable = slip_resistance_damage_30
  []
  [slip_resistance_damage_31]
    type = ElementAverageValue
    variable = slip_resistance_damage_31
  []
  [slip_resistance_damage_32]
    type = ElementAverageValue
    variable = slip_resistance_damage_32
  []
  [slip_resistance_damage_33]
    type = ElementAverageValue
    variable = slip_resistance_damage_33
  []
  [slip_resistance_damage_34]
    type = ElementAverageValue
    variable = slip_resistance_damage_34
  []
  [slip_resistance_damage_35]
    type = ElementAverageValue
    variable = slip_resistance_damage_35
  []
  [slip_resistance_damage_36]
    type = ElementAverageValue
    variable = slip_resistance_damage_36
  []
  [slip_resistance_damage_37]
    type = ElementAverageValue
    variable = slip_resistance_damage_37
  []
  [slip_resistance_damage_38]
    type = ElementAverageValue
    variable = slip_resistance_damage_38
  []
  [slip_resistance_damage_39]
    type = ElementAverageValue
    variable = slip_resistance_damage_39
  []
  [slip_resistance_damage_40]
    type = ElementAverageValue
    variable = slip_resistance_damage_40
  []
  [slip_resistance_damage_41]
    type = ElementAverageValue
    variable = slip_resistance_damage_41
  []
  [slip_resistance_damage_42]
    type = ElementAverageValue
    variable = slip_resistance_damage_42
  []
  [slip_resistance_damage_43]
    type = ElementAverageValue
    variable = slip_resistance_damage_43
  []
  [slip_resistance_damage_44]
    type = ElementAverageValue
    variable = slip_resistance_damage_44
  []
  [slip_resistance_damage_45]
    type = ElementAverageValue
    variable = slip_resistance_damage_45
  []
  [slip_resistance_damage_46]
    type = ElementAverageValue
    variable = slip_resistance_damage_46
  []
  [slip_resistance_damage_47]
    type = ElementAverageValue
    variable = slip_resistance_damage_47
  []
  [slip_resistance_damage_48]
    type = ElementAverageValue
    variable = slip_resistance_damage_48
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
  nl_abs_tol = 1e-10
  nl_rel_tol = 1e-10
  nl_abs_step_tol = 1e-10

  dt = 1E-5
  dtmin = 1E-8
  num_steps = 50
[]

[Outputs]
  exodus = true
  csv = true
  perf_graph = true
[]
