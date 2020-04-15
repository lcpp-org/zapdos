dom0Scale=25.4e-3

[GlobalParams]
  potential_units = kV
  use_moles = true
[]

[Mesh]
  [./file]
    type = FileMeshGenerator
    file = 'Lymberopoulos.msh'
  [../]
  [./left]
    type = SideSetsFromNormalsGenerator
    normals = '-1 0 0'
    new_boundary = 'left'
    input = file
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

#Action the supplies the drift-diffusion equations
#This action also adds JouleHeating and the ChargeSourceMoles_KV Kernels
[DriftDiffusionAction]
  [./Plasma]
    electrons = em
    charged_particle = Ar+
    Neutrals = Ar*
    mean_energy = mean_en
    potential = potential
    Is_potential_unique = true
    using_offset = false
    position_units = ${dom0Scale}
    Additional_Outputs = 'ElectronTemperature Current EField'
  [../]
[]

#The Kernels supply the sources terms
[Kernels]
    #Net electron production from ionization
    [./em_ionization]
      type = EEDFReactionLog
      variable = em
      electrons = em
      target = Ar
      mean_energy = mean_en
      reaction = 'em + Ar -> em + em + Ar+'
      coefficient = 1
    [../]
    #Net electron production from step-wise ionization
    [./em_stepwise_ionization]
      type = EEDFReactionLog
      variable = em
      electrons = em
      target = Ar*
      mean_energy = mean_en
      reaction = 'em + Ar* -> em + em + Ar+'
      coefficient = 1
    [../]
    #Net electron production from metastable pooling
    [./em_pooling]
      type = ReactionSecondOrderLog
      variable = em
      v = Ar*
      w = Ar*
      reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
      coefficient = 1
    [../]

    #Net ion production from ionization
    [./Ar+_ionization]
      type = EEDFReactionLog
      variable = Ar+
      electrons = em
      target = Ar
      mean_energy = mean_en
      reaction = 'em + Ar -> em + em + Ar+'
      coefficient = 1
    [../]
    #Net ion production from step-wise ionization
    [./Ar+_stepwise_ionization]
      type = EEDFReactionLog
      variable = Ar+
      electrons = em
      target = Ar*
      mean_energy = mean_en
      reaction = 'em + Ar* -> em + em + Ar+'
      coefficient = 1
    [../]
    #Net ion production from metastable pooling
    [./Ar+_pooling]
      type = ReactionSecondOrderLog
      variable = Ar+
      v = Ar*
      w = Ar*
      reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
      coefficient = 1
    [../]

      #Net excited Argon production from excitation
      [./Ar*_excitation]
        type = EEDFReactionLog
        variable = Ar*
        electrons = em
        target = Ar
        mean_energy = mean_en
        reaction = 'em + Ar -> em + Ar*'
        coefficient = 1
      [../]
      #Net excited Argon loss from step-wise ionization
      [./Ar*_stepwise_ionization]
        type = EEDFReactionLog
        variable = Ar*
        electrons = em
        target = Ar*
        mean_energy = mean_en
        reaction = 'em + Ar* -> em + em + Ar+'
        coefficient = -1
        _target_eq_u = true
      [../]
      #Net excited Argon loss from superelastic collisions
      [./Ar*_collisions]
        type = EEDFReactionLog
        variable = Ar*
        electrons = em
        target = Ar*
        mean_energy = mean_en
        reaction = 'em + Ar* -> em + Ar'
        coefficient = -1
        _target_eq_u = true
      [../]
      #Net excited Argon loss from quenching to resonant
      [./Ar*_quenching]
        type = EEDFReactionLog
        variable = Ar*
        electrons = em
        target = Ar*
        mean_energy = mean_en
        reaction = 'em + Ar* -> em + Ar_r'
        coefficient = -1
        _target_eq_u = true
      [../]
      #Net excited Argon loss from  metastable pooling
      [./Ar*_pooling]
        type = ReactionSecondOrderLog
        variable = Ar*
        v = Ar*
        w = Ar*
        reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
        coefficient = -2
        _v_eq_u = true
        _w_eq_u = true
      [../]
      #Net excited Argon loss from two-body quenching
      [./Ar*_2B_quenching]
        type = ReactionSecondOrderLog
        variable = Ar*
        v = Ar*
        w = Ar
        reaction = 'Ar* + Ar -> Ar + Ar'
        coefficient = -1
        _v_eq_u = true
      [../]
      #Net excited Argon loss from three-body quenching
      [./Ar*_3B_quenching]
        type = ReactionThirdOrderLog
        variable = Ar*
        v = Ar*
        w = Ar
        x = Ar
        reaction = 'Ar* + Ar + Ar -> Ar_2 + Ar'
        coefficient = -1
        _v_eq_u = true
      [../]

    #Energy loss from ionization
    [./Ionization_Loss]
      type = EEDFEnergyLog
      variable = mean_en
      electrons = em
      target = Ar
      reaction = 'em + Ar -> em + em + Ar+'
      coefficient = 1
      threshold_energy = -15.7
      position_units = ${dom0Scale}
    [../]
    #Energy loss from excitation
    [./Excitation_Loss]
      type = EEDFEnergyLog
      variable = mean_en
      electrons = em
      target = Ar
      coefficient = 1
      reaction = 'em + Ar -> em + Ar*'
      threshold_energy = -11.56
      position_units = ${dom0Scale}
    [../]
    #Energy loss from step-wise ionization
    [./Stepwise_Ionization_Loss]
      type = EEDFEnergyLog
      variable = mean_en
      electrons = em
      target = Ar*
      coefficient = 1
      reaction = 'em + Ar* -> em + em + Ar+'
      threshold_energy = -4.14
      position_units = ${dom0Scale}
    [../]
    #Energy gain from superelastic collisions
    [./Collisions_Loss]
      type = EEDFEnergyLog
      variable = mean_en
      electrons = em
      target = Ar*
      coefficient = 1
      reaction = 'em + Ar* -> em + Ar'
      threshold_energy = 11.56
      position_units = ${dom0Scale}
    [../]
  []


[AuxVariables]
  [./x_node]
  [../]

  [./rho]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Ar]
  [../]

  [./emRate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./exRate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./swRate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./deexRate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./quRate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./poolRate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./TwoBRate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./ThreeBRate]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./emRate]
    type = ProcRateForRateCoeff
    variable = emRate
    v = em
    w = Ar
    reaction = 'em + Ar -> em + em + Ar+'
  [../]
  [./exRate]
    type = ProcRateForRateCoeff
    variable = exRate
    v = em
    w = Ar*
    reaction = 'em + Ar -> em + Ar*'
  [../]
  [./swRate]
    type = ProcRateForRateCoeff
    variable = swRate
    v = em
    w = Ar*
    reaction = 'em + Ar* -> em + em + Ar+'
  [../]
  [./deexRate]
    type = ProcRateForRateCoeff
    variable = deexRate
    v = em
    w = Ar*
    reaction = 'em + Ar* -> em + Ar'
  [../]
  [./quRate]
    type = ProcRateForRateCoeff
    variable = quRate
    v = em
    w = Ar*
    reaction = 'em + Ar* -> em + Ar_r'
  [../]
  [./poolRate]
    type = ProcRateForRateCoeff
    variable = poolRate
    v = Ar*
    w = Ar*
    reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
  [../]
  [./TwoBRate]
    type = ProcRateForRateCoeff
    variable = TwoBRate
    v = Ar*
    w = Ar
    reaction = 'Ar* + Ar -> Ar + Ar'
  [../]
  [./ThreeBRate]
    type = ProcRateForRateCoeffThreeBody
    variable = ThreeBRate
    v = Ar*
    w = Ar
    vv = Ar
    reaction = 'Ar* + Ar + Ar -> Ar_2 + Ar'
  [../]

  [./x_ng]
    type = Position
    variable = x_node
    position_units = ${dom0Scale}
  [../]

  [./Ar_val]
    type = ConstantAux
    variable = Ar
    # value = 3.22e22
    value = -2.928623
    execute_on = INITIAL
  [../]
[]


[BCs]
#Voltage Boundary Condition, same as in paper
  [./potential_left]
    type = FunctionDirichletBC
    variable = potential
    boundary = 'left'
    function = potential_bc_func
  [../]
  [./potential_dirichlet_right]
    type = DirichletBC
    variable = potential
    boundary = 'right'
    value = 0
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
    property_tables_file = Argon_reactions_paper_RateCoefficients/electron_moments.txt
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
  [./reaction_0]
    type = ZapdosEEDFRateConstant
    mean_energy = mean_en
    sampling_format = electron_energy
    property_file = 'Argon_reactions_paper_RateCoefficients/ar_excitation.txt'
    reaction = 'em + Ar -> em + Ar*'
    position_units = ${dom0Scale}
    file_location = ''
    electrons = em
  [../]
  [./reaction_1]
    type = ZapdosEEDFRateConstant
    mean_energy = mean_en
    sampling_format = electron_energy
    property_file = 'Argon_reactions_paper_RateCoefficients/ar_ionization.txt'
    reaction = 'em + Ar -> em + em + Ar+'
    position_units = ${dom0Scale}
    file_location = ''
    electrons = em
  [../]
  [./reaction_2]
    type = ZapdosEEDFRateConstant
    mean_energy = mean_en
    sampling_format = electron_energy
    property_file = 'Argon_reactions_paper_RateCoefficients/ar_deexcitation.txt'
    reaction = 'em + Ar* -> em + Ar'
    position_units = ${dom0Scale}
    file_location = ''
    electrons = em
  [../]
  [./reaction_3]
    type = ZapdosEEDFRateConstant
    mean_energy = mean_en
    sampling_format = electron_energy
    property_file = 'Argon_reactions_paper_RateCoefficients/ar_excited_ionization.txt'
    reaction = 'em + Ar* -> em + em + Ar+'
    position_units = ${dom0Scale}
    file_location = ''
    electrons = em
  [../]
  [./reaction_4]
    type = GenericRateConstant
    reaction = 'em + Ar* -> em + Ar_r'
    #reaction_rate_value = 2e-13
    reaction_rate_value = 1.2044e11
  [../]
  [./reaction_5]
    type = GenericRateConstant
    reaction = 'Ar* + Ar* -> Ar+ + Ar + em'
    #reaction_rate_value = 6.2e-16
    reaction_rate_value = 373364000
  [../]
  [./reaction_6]
    type = GenericRateConstant
    reaction = 'Ar* + Ar -> Ar + Ar'
    #reaction_rate_value = 3e-21
    reaction_rate_value = 1806.6
  [../]
  [./reaction_7]
    type = GenericRateConstant
    reaction = 'Ar* + Ar + Ar -> Ar_2 + Ar'
    #reaction_rate_value = 1.1e-42
    reaction_rate_value = 398909.324
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
  end_time = 3e-7
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
  petsc_options_value = 'lu NONZERO 1.e-10 fgmres 1e-3'

  dtmin = 1e-14
  l_max_its = 20

  scheme = bdf2
  dt = 1e-9
[]

[Outputs]
  file_base = 'RF_out'
  perf_graph = true
  [./out]
    type = Exodus
  [../]
[]
