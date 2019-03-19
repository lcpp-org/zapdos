dom0Scale = 1
dom0Size = 6E-6 #m
vhigh = 175E-3 #kV

[GlobalParams]
#       offset = 20
        potential_units = kV
#        potential_units = V
        use_moles = true
[]

[Mesh]
        type = FileMesh
        file = 'Geometry.msh'
[]

[MeshModifiers]
#       [./interface]
#               type = SideSetsBetweenSubdomains
#               master_block = '0'
#               paired_block = '1'
#               new_boundary = right
#       [../]
#       [./interface_again]
#               type = SideSetsBetweenSubdomains
#               master_block = '1'
#               paired_block = '0'
#               new_boundary = 'master1_interface'
#                depends_on = 'box'
#       [../]
        [./left]
                type = SideSetsFromNormals
                normals = '-1 0 0'
                new_boundary = 'left'
        [../]
        [./right]
                type = SideSetsFromNormals
                normals = '1 0 0'
                new_boundary = 'right'
        [../]
[]

[Problem]
        type = FEProblem
#        kernel_coverage_check = false
[]

[Preconditioning]
        [./smp]
                type = SMP
                full = true
        [../]
[]

[Executioner]
        type = Transient
        line_search = none
        end_time = 10E-6
        trans_ss_check = 1
        ss_check_tol = 1E-15
        petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
        solve_type = NEWTON
        petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
        petsc_options_value = 'lu NONZERO 1.e-10 preonly 1e-3'
        nl_rel_tol = 5e-14
        nl_abs_tol = 1e-13
        ss_tmin = 1E-6
        dtmin = 1e-18
        dtmax = 0.1E-7
        nl_max_its = 200
        [./TimeStepper]
                type = IterationAdaptiveDT
                cutback_factor = 0.9
                dt = 1e-13
                growth_factor = 1.2
                optimal_iterations = 100
                nl_max_its = 200
        [../]
[]

[Outputs]
        perf_graph = true
        print_linear_residuals = false
        [./out]
                type = Exodus
#               execute_on = 'final'
        [../]
[]

[Debug]
        show_var_residual_norms = true
[]

[UserObjects]
        [./data_provider]
                type = ProvideMobility
                electrode_area = 5.02e-7 # Formerly 3.14e-6
                ballast_resist = 1e6
                e = 1.6e-19
        [../]
[]

[Kernels]
        [./em_time_deriv]
                type = ElectronTimeDerivative
                variable = em
                block = 0
        [../]
        [./em_advection]
                type = EFieldAdvectionElectrons
                variable = em
                potential = potential
                mean_en = mean_en
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./em_diffusion]
                type = CoeffDiffusionElectrons
                variable = em
                mean_en = mean_en
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./em_ionization]
                type = ElectronsFromIonization
    em = em
                variable = em
                potential = potential
                mean_en = mean_en
                block = 0
                position_units = ${dom0Scale}
        [../]
#       [./em_log_stabilization]
#               type = LogStabilizationMoles
#               variable = em
#               block = 0
#       [../]

        [./potential_diffusion_dom1]
                type = CoeffDiffusionLin
                variable = potential
                block = 0
                position_units = ${dom0Scale}
        [../]

        [./Arp_charge_source]
                type = ChargeSourceMoles_KV
                variable = potential
                charged = Arp
                block = 0
        [../]
        [./em_charge_source]
                type = ChargeSourceMoles_KV
                variable = potential
                charged = em
                block = 0
        [../]

        [./Arp_time_deriv]
                type = ElectronTimeDerivative
                variable = Arp
                block = 0
        [../]
        [./Arp_advection]
                type = EFieldAdvection
                variable = Arp
                potential = potential
                position_units = ${dom0Scale}
                block = 0
        [../]
        [./Arp_diffusion]
                type = CoeffDiffusion
                variable = Arp
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./Arp_ionization]
                type = IonsFromIonization
                variable = Arp
                potential = potential
                em = em
                mean_en = mean_en
                block = 0
                position_units = ${dom0Scale}
        [../]
#       [./Arp_log_stabilization]
#               type = LogStabilizationMoles
#               variable = Arp
#               block = 0
#       [../]

        [./mean_en_time_deriv]
                type = ElectronTimeDerivative
                variable = mean_en
                block = 0
        [../]
        [./mean_en_advection]
                type = EFieldAdvectionEnergy
                variable = mean_en
                potential = potential
                em = em
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./mean_en_diffusion]
                type = CoeffDiffusionEnergy
                variable = mean_en
                em = em
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./mean_en_joule_heating]
                type = JouleHeating
                variable = mean_en
                potential = potential
                em = em
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./mean_en_ionization]
                type = ElectronEnergyLossFromIonization
                variable = mean_en
                potential = potential
                em = em
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./mean_en_elastic]
                type = ElectronEnergyLossFromElastic
                variable = mean_en
                potential = potential
                em = em
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./mean_en_excitation]
                type = ElectronEnergyLossFromExcitation
                variable = mean_en
                potential = potential
                em = em
                block = 0
                position_units = ${dom0Scale}
        [../]
#       [./mean_en_log_stabilization]
#               type = LogStabilizationMoles
#               variable = mean_en
#               block = 0
#               offset = 15
#       [../]
#       [./mean_en_advection_stabilization]
#               type = EFieldArtDiff
#               variable = mean_en
#               potential = potential
#               block = 0
#       [../]
[]

[Variables]
        [./potential]
        [../]
        [./em]
                block = 0
        [../]
        [./Arp]
                block = 0
        [../]
        [./mean_en]
                block = 0
        [../]

[]

[AuxVariables]
        [./e_temp]
                block = 0
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
                block = 0
        [../]
        [./em_lin]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
        [./Arp_lin]
                order = CONSTANT
                family = MONOMIAL
                block = 0
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
        [./Current_Arp]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
        [./tot_gas_current]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
        [./EFieldAdvAux_em]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
        [./DiffusiveFlux_em]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
        [./PowerDep_em]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
        [./PowerDep_Arp]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
        [./ProcRate_el]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
        [./ProcRate_ex]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
        [./ProcRate_iz]
                order = CONSTANT
                family = MONOMIAL
                block = 0
        [../]
[]

[AuxKernels]
        [./PowerDep_em]
                type = PowerDep
                density_log = em
                potential = potential
                art_diff = false
                potential_units = kV
                variable = PowerDep_em
                position_units = ${dom0Scale}
                block = 0
        [../]
        [./PowerDep_Arp]
                type = PowerDep
                density_log = Arp
                potential = potential
                art_diff = false
                potential_units = kV
                variable = PowerDep_Arp
                position_units = ${dom0Scale}
                block = 0
        [../]
        [./ProcRate_el]
                type = ProcRate
                em = em
                potential = potential
                proc = el
                variable = ProcRate_el
                position_units = ${dom0Scale}
                block = 0
        [../]
        [./ProcRate_ex]
                type = ProcRate
                em = em
                potential = potential
                proc = ex
                variable = ProcRate_ex
                position_units = ${dom0Scale}
                block = 0
        [../]
        [./ProcRate_iz]
                type = ProcRate
                em = em
                potential = potential
                proc = iz
                variable = ProcRate_iz
                position_units = ${dom0Scale}
                block = 0
        [../]
        [./e_temp]
                type = ElectronTemperature
                variable = e_temp
                electron_density = em
                mean_en = mean_en
                block = 0
        [../]
        [./x_g]
                type = Position
                variable = x
                position_units = ${dom0Scale}
                block = 0
        [../]
        [./x_ng]
                type = Position
                variable = x_node
                position_units = ${dom0Scale}
                block = 0
        [../]
        [./rho]
                type = ParsedAux
                variable = rho
                args = 'em_lin Arp_lin'
                function = 'Arp_lin - em_lin'
                execute_on = 'timestep_end'
                block = 0
        [../]
        [./tot_gas_current]
                type = ParsedAux
                variable = tot_gas_current
                args = 'Current_em Current_Arp'
                function = 'Current_em + Current_Arp'
                execute_on = 'timestep_end'
                block = 0
        [../]
        [./em_lin]
                type = Density
#               convert_moles = true
                variable = em_lin
                density_log = em
                block = 0
        [../]
        [./Arp_lin]
                type = Density
#               convert_moles = true
                variable = Arp_lin
                density_log = Arp
                block = 0
        [../]
        [./Efield_g]
                type = Efield
                component = 0
                potential = potential
                variable = Efield
                position_units = ${dom0Scale}
                block = 0
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
        [./Current_Arp]
                type = Current
                potential = potential
                density_log = Arp
                variable = Current_Arp
                art_diff = false
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./EFieldAdvAux_em]
                type = EFieldAdvAux
                potential = potential
                density_log = em
                variable = EFieldAdvAux_em
                block = 0
                position_units = ${dom0Scale}
        [../]
        [./DiffusiveFlux_em]
                type = DiffusiveFlux
                density_log = em
                variable = DiffusiveFlux_em
                block = 0
                position_units = ${dom0Scale}
        [../]
[]

[BCs]
## Potential boundary conditions ##
        [./potential_left]
                type = NeumannCircuitVoltageMoles_KV
                variable = potential
                boundary = left
                function = potential_bc_func
                ip = Arp
                data_provider = data_provider
                em = em
                mean_en = mean_en
                r = 0
                position_units = ${dom0Scale}
        [../]

        [./potential_dirichlet_right]
                type = DirichletBC
                variable = potential
                boundary = right
                value = 0
        [../]

## Electron boundary conditions ##
        [./Emission_left]
                type = SecondaryElectronBC
                variable = em
                boundary = 'left'
                potential = potential
                ip = Arp
                mean_en = mean_en
                r = 1
                position_units = ${dom0Scale}
        [../]

        [./em_physical_left]
                type = HagelaarElectronBC
                variable = em
                boundary = 'left'
                potential = potential
                mean_en = mean_en
                r = 0
                position_units = ${dom0Scale}
        [../]

        [./em_physical_right]
                type = HagelaarElectronBC
                variable = em
                boundary = right
                potential = potential
                mean_en = mean_en
                r = 0
                position_units = ${dom0Scale}
        [../]

## Argon boundary conditions ##
        [./Arp_physical_left_diffusion]
                type = HagelaarIonDiffusionBC
                variable = Arp
                boundary = 'left'
                r = 0
                position_units = ${dom0Scale}
        [../]
        [./Arp_physical_left_advection]
                type = HagelaarIonAdvectionBC
                variable = Arp
                boundary = 'left'
                potential = potential
                r = 0
                position_units = ${dom0Scale}
        [../]

        [./Arp_physical_right_diffusion]
                type = HagelaarIonDiffusionBC
                variable = Arp
                boundary = right
                r = 0
                position_units = ${dom0Scale}
        [../]
        [./Arp_physical_right_advection]
                type = HagelaarIonAdvectionBC
                variable = Arp
                boundary = right
                potential = potential
                r = 0
                position_units = ${dom0Scale}
        [../]

## Mean energy boundary conditions ##
        [./mean_en_physical_left]
                type = HagelaarEnergyBC
                variable = mean_en
                boundary = 'left'
                potential = potential
                em = em
                ip = Arp
                r = 0
                position_units = ${dom0Scale}
        [../]

        [./mean_en_physical_right]
                type = HagelaarEnergyBC
                variable = mean_en
                boundary = right
                potential = potential
                em = em
                ip = Arp
                r = 0
                position_units = ${dom0Scale}
        [../]
[]

[ICs]
        [./potential_ic]
                type = FunctionIC
                variable = potential
                function = potential_ic_func
        [../]

        [./em_ic]
                type = ConstantIC
                variable = em
                value = -36
                block = 0
        [../]

        [./Arp_ic]
                type = ConstantIC
                variable = Arp
                value = -36
                block = 0
        [../]

        [./mean_en_ic]
                type = ConstantIC
                variable = mean_en
                value = -36
                block = 0
        [../]
[]

[Functions]
        [./potential_bc_func]
                type = ParsedFunction
                vars = 'VHigh'
                vals = '${vhigh}')
                value = 'VHigh'
        [../]
        [./potential_ic_func]
                type = ParsedFunction
                value = '-${vhigh} * (${dom0Size} - x) / ${dom0Size}'
        [../]
[]

[Materials]
        [./gas_block]
                type = Gas
                interp_trans_coeffs = true
                interp_elastic_coeff = true
                ramp_trans_coeffs = false
                em = em
                potential = potential
                ip = Arp
                mean_en = mean_en
                user_se_coeff = 0.01
                user_work_function = 4.55 # eV
                user_field_enhancement = 55
                user_Richardson_coefficient = 80E4
                user_cathode_temperature = 1273
                property_tables_file = td_argon_mean_en.txt
                block = 0
        [../]
[]
