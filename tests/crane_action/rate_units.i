# THIS FILE IS BASED ON Lymberopoulos_with_argon_metastables.i

dom0Scale=25.4e-3

[GlobalParams]
  potential_units = kV
  use_moles = true
[]

[Mesh]
  [./geo]
    type = FileMeshGenerator
    file = 'rate_units.msh'
  [../]
  [./left]
    type = SideSetsFromNormalsGenerator
    normals = '-1 0 0'
    new_boundary = 'left'
    input = geo
  [../]
  [./right]
    type = SideSetsFromNormalsGenerator
    normals = '1 0 0'
    new_boundary = 'right'
    input = left
  [../]
[]

[Problem]
  type = FEProblem
[]

[Variables]
  [./em]
  [../]

  [./Ar+]
  [../]

  [./Ar*]
  [../]

  [./mean_en]
  [../]

  [./potential]
  [../]
[]

[Kernels]
  #Electron Equations (Same as in paper)
    #Time Derivative term of electron
    [./em_time_deriv]
      type = ElectronTimeDerivative
      variable = em
    [../]
    #Advection term of electron
    [./em_advection]
      type = EFieldAdvectionElectrons
      variable = em
      potential = potential
      mean_en = mean_en
      position_units = ${dom0Scale}
    [../]
    #Diffusion term of electrons
    [./em_diffusion]
      type = CoeffDiffusionElectrons
      variable = em
      mean_en = mean_en
      position_units = ${dom0Scale}
    [../]

  #Argon Ion Equations (Same as in paper)
    #Time Derivative term of the ions
    [./Ar+_time_deriv]
      type = ElectronTimeDerivative
      variable = Ar+
    [../]
    #Advection term of ions
    [./Ar+_advection]
      type = EFieldAdvection
      variable = Ar+
      potential = potential
      position_units = ${dom0Scale}
    [../]
    [./Ar+_diffusion]
      type = CoeffDiffusion
      variable = Ar+
      position_units = ${dom0Scale}
    [../]
      #Time Derivative term of excited Argon
      [./Ar*_time_deriv]
        type = ElectronTimeDerivative
        variable = Ar*
      [../]
      #Diffusion term of excited Argon
      [./Ar*_diffusion]
        type = CoeffDiffusion
        variable = Ar*
        position_units = ${dom0Scale}
      [../]

  #Voltage Equations (Same as in paper)
    #Voltage term in Poissons Eqaution
    [./potential_diffusion_dom0]
      type = CoeffDiffusionLin
      variable = potential
      position_units = ${dom0Scale}
    [../]
    #Ion term in Poissons Equation
    [./Ar+_charge_source]
      type = ChargeSourceMoles_KV
      variable = potential
      charged = Ar+
    [../]
    #Electron term in Poissons Equation
    [./em_charge_source]
      type = ChargeSourceMoles_KV
      variable = potential
      charged = em
    [../]


  #Since the paper uses electron temperature as a variable, the energy equation is in
  #a different form but should be the same physics
    #Time Derivative term of electron energy
    [./mean_en_time_deriv]
      type = ElectronTimeDerivative
      variable = mean_en
    [../]
    #Advection term of electron energy
    [./mean_en_advection]
      type = EFieldAdvectionEnergy
      variable = mean_en
      potential = potential
      em = em
      position_units = ${dom0Scale}
    [../]
    #Diffusion term of electrons energy
    [./mean_en_diffusion]
      type = CoeffDiffusionEnergy
      variable = mean_en
      em = em
      position_units = ${dom0Scale}
    [../]
    #Joule Heating term
    [./mean_en_joule_heating]
      type = JouleHeating
      variable = mean_en
      potential = potential
      em = em
      position_units = ${dom0Scale}
    [../]
  []


[AuxVariables]
  [./emDeBug]
  [../]
  [./Ar+_DeBug]
  [../]
  [./Ar*_DeBug]
  [../]
  [./mean_enDeBug]
  [../]

  [./Te]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./x]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./x_node]
  [../]

  [./rho]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./em_lin]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Ar+_lin]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Ar*_lin]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Ar]
  [../]

  [./Efield]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Current_em]
    order = CONSTANT
    family = MONOMIAL
    block = 0
  [../]
  [./Current_Ar]
    order = CONSTANT
    family = MONOMIAL
    block = 0
  [../]
[]

[AuxKernels]
  [./emDeBug]
    type = DebugResidualAux
    variable = emDeBug
    debug_variable = em
    #execute_on = 'LINEAR NONLINEAR TIMESTEP_BEGIN'
  [../]
  [./Ar+_DeBug]
    type = DebugResidualAux
    variable = Ar+_DeBug
    debug_variable = Ar+
    #execute_on = 'LINEAR NONLINEAR TIMESTEP_BEGIN'
  [../]
  [./mean_enDeBug]
    type = DebugResidualAux
    variable = mean_enDeBug
    debug_variable = mean_en
    #execute_on = 'LINEAR NONLINEAR TIMESTEP_BEGIN'
  [../]
  [./Ar*_DeBug]
    type = DebugResidualAux
    variable = Ar*_DeBug
    debug_variable = Ar*
    #execute_on = 'LINEAR NONLINEAR TIMESTEP_BEGIN'
  [../]

  [./Te]
    type = ElectronTemperature
    variable = Te
    electron_density = em
    mean_en = mean_en
  [../]
  [./x_g]
    type = Position
    variable = x
    position_units = ${dom0Scale}
  [../]

  [./x_ng]
    type = Position
    variable = x_node
    position_units = ${dom0Scale}
  [../]

  [./em_lin]
    type = DensityMoles
    convert_moles = true
    variable = em_lin
    density_log = em
  [../]
  [./Ar+_lin]
    type = DensityMoles
    convert_moles = true
    variable = Ar+_lin
    density_log = Ar+
  [../]
  [./Ar*_lin]
    type = DensityMoles
    convert_moles = true
    variable = Ar*_lin
    density_log = Ar*
  [../]

  [./Ar_val]
    type = ConstantAux
    variable = Ar
    # value = 3.22e22
    value = -2.928623
    execute_on = INITIAL
  [../]

  [./Efield_calc]
    type = Efield
    component = 0
    potential = potential
    variable = Efield
    position_units = ${dom0Scale}
  [../]
  [./Current_em]
    type = Current
    potential = potential
    density_log = em
    variable = Current_em
    art_diff = false
    block = 0
    position_units = ${dom0Scale}
  [../]
  [./Current_Ar]
    type = Current
    potential = potential
    density_log = Ar+
    variable = Current_Ar
    art_diff = false
    block = 0
    position_units = ${dom0Scale}
  [../]
[]


[BCs]
#Voltage Boundary Condition, same as in paper
  [./potential_left]
    type = FunctionDirichletBC
    variable = potential
    boundary = 'left'
    function = potential_bc_func
    preset = false
  [../]
  [./potential_dirichlet_right]
    type = DirichletBC
    variable = potential
    boundary = 'right'
    value = 0
    preset = false
  [../]

#New Boundary conditions for electons, same as in paper
  [./em_physical_right]
    type = LymberopoulosElectronBC
    variable = em
    boundary = 'right'
    gamma = 0.01
    #gamma = 1
    ks = 1.19e5
    #ks = 0.0
    ion = Ar+
    potential = potential
    position_units = ${dom0Scale}
  [../]
  [./em_physical_left]
    type = LymberopoulosElectronBC
    variable = em
    boundary = 'left'
    gamma = 0.01
    #gamma = 1
    ks = 1.19e5
    #ks = 0.0
    ion = Ar+
    potential = potential
    position_units = ${dom0Scale}
  [../]

#New Boundary conditions for ions, should be the same as in paper
  [./Ar+_physical_right_advection]
    type = LymberopoulosIonBC
    variable = Ar+
    potential = potential
    boundary = 'right'
    position_units = ${dom0Scale}
  [../]
  [./Ar+_physical_left_advection]
    type = LymberopoulosIonBC
    variable = Ar+
    potential = potential
    boundary = 'left'
    position_units = ${dom0Scale}
  [../]

#New Boundary conditions for ions, should be the same as in paper
#(except the metastables are not set to zero, since Zapdos uses log form)
  [./Ar*_physical_right_diffusion]
    type = LogDensityDirichletBC
    variable = Ar*
    boundary = 'right'
    value = 100
  [../]
  [./Ar*_physical_left_diffusion]
    type = LogDensityDirichletBC
    variable = Ar*
    boundary = 'left'
    value = 100
  [../]

#New Boundary conditions for mean energy, should be the same as in paper
  [./mean_en_physical_right]
    type = ElectronTemperatureDirichletBC
    variable = mean_en
    em = em
    value = 0.5
    boundary = 'right'
  [../]
  [./mean_en_physical_left]
    type = ElectronTemperatureDirichletBC
    variable = mean_en
    em = em
    value = 0.5
    boundary = 'left'
  [../]

[]


[ICs]
  [./em_ic]
    type = FunctionIC
    variable = em
    function = density_ic_func
  [../]
  [./Ar+_ic]
    type = FunctionIC
    variable = Ar+
    function = density_ic_func
  [../]
  [./Ar*_ic]
    type = FunctionIC
    variable = Ar*
    function = density_ic_func
  [../]
  [./mean_en_ic]
    type = FunctionIC
    variable = mean_en
    function = energy_density_ic_func
  [../]

  [./potential_ic]
    type = FunctionIC
    variable = potential
    function = potential_ic_func
  [../]
[]

[Functions]
  [./potential_bc_func]
    type = ParsedFunction
    value = '0.100*sin(2*3.1415926*13.56e6*t)'
  [../]
  [./potential_ic_func]
    type = ParsedFunction
    value = '0.100 * (25.4e-3 - x)'
  [../]
  [./density_ic_func]
    type = ParsedFunction
    value = 'log((1e13 + 1e15 * (1-x/1)^2 * (x/1)^2)/6.022e23)'
  [../]
  [./energy_density_ic_func]
    type = ParsedFunction
    value = 'log(3./2.) + log((1e13 + 1e15 * (1-x/1)^2 * (x/1)^2)/6.022e23)'
  [../]
[]

[Materials]
  [./GasBasics]
    type = GasElectronMoments
    interp_trans_coeffs = false
    interp_elastic_coeff = false
    ramp_trans_coeffs = false
    user_p_gas = 133.322
    em = em
    potential = potential
    mean_en = mean_en
    user_electron_mobility = 30.0
    user_electron_diffusion_coeff = 119.8757763975
    property_tables_file = rate_coefficients/electron_moments.txt
    position_units = ${dom0Scale}
  [../]
  [./gas_species_0]
    type = HeavySpeciesMaterial
    heavy_species_name = Ar+
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 1.0
    mobility = 0.144409938
    diffusivity = 6.428571e-3
  [../]
  [./gas_species_1]
    type = HeavySpeciesMaterial
    heavy_species_name = Ar*
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 0.0
    diffusivity = 7.515528e-3
  [../]
  [./gas_species_2]
    type = HeavySpeciesMaterial
    heavy_species_name = Ar
    heavy_species_mass = 6.64e-26
    heavy_species_charge = 0.0
  [../]
[]

#New postprocessor that calculates the inverse of the plasma frequency
[Postprocessors]
  [./InversePlasmaFreq]
    type = PlasmaFrequencyInverse
    variable = em
    use_moles = true
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  [../]
[]


[Preconditioning]
  active = 'smp'
  [./smp]
    type = SMP
    full = true
  [../]

  [./fdp]
    type = FDP
    full = true
  [../]
[]


[Executioner]
  type = Transient
  #end_time = 0.00737463126
  end_time = 3e-7
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
  petsc_options_value = 'lu NONZERO 1.e-10 fgmres 1e-3'
  nl_rel_tol = 1e-08
  #nl_abs_tol = 7.6e-5 #Commit out do to test falure on Mac
  dtmin = 1e-14
  l_max_its = 20

  #Time steps based on the inverse of the plasma frequency
  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = InversePlasmaFreq
  [../]
[]

[Outputs]
  perf_graph = true
  [./out]
    type = Exodus
    execute_on = 'final'
  [../]
[]

[Reactions]
  [./Argon]
    species = 'Ar* em Ar+'
    aux_species = 'Ar'
    reaction_coefficient_format = 'rate'
    gas_species = 'Ar'
    electron_energy = 'mean_en'
    electron_density = 'em'
    include_electrons = true
    file_location = 'rate_coefficients'
    potential = 'potential'
    use_log = true
    position_units = ${dom0Scale}
    block = 0
    reactions = 'em + Ar -> em + Ar*        : EEDF [-11.56] (reaction1)
                 em + Ar -> em + em + Ar+   : EEDF [-15.7] (reaction2)
                 em + Ar* -> em + Ar        : EEDF [11.56] (reaction3)
                 em + Ar* -> em + em + Ar+  : EEDF [-4.14] (reaction4)
                 em + Ar* -> em + Ar_r      : 1.2044e11
                 Ar* + Ar* -> Ar+ + Ar + em : 373364000
                 Ar* + Ar -> Ar + Ar        : 1806.6
                 Ar* + Ar + Ar -> Ar_2 + Ar : 398909.324'
  [../]
[]
