# Global paths
glob_lib_paths = [#r'N:\Forschung\EBC0332_BMWi_MODI_GA\Students\mba-nre\01-notes\HiWi Nadja\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
                 #r'N:\Forschung\EBC0332_BMWi_MODI_GA\Students\mba-nre\01-notes\HiWi Nadja\Git\modelica-buildings\Buildings',
                 #r'N:\Forschung\EBC0332_BMWi_MODI_GA\Students\mba-nre\01-notes\HiWi Nadja\Git\AixLib\AixLib',
                 r'N:\Forschung\EBC0332_BMWi_MODI_GA\Students\mba-nre\01-notes\HiWi Nadja\Git\pyDMPC\pyDMPC\tests\Testing'] #Testing environment
glob_res_path = r'D:\dymola'
glob_dym_path = r'C:\Program Files\Dymola 2020\Modelica\Library\python_interface\dymola.egg'

# Working directory
import time
timestr = time.strftime("%Y%m%d_%H%M%S")
name_wkdir = r'pyDMPC_' + 'wkdir' + timestr

# Controlled system
contr_sys_typ = "Modelica"
ads_id = '5.59.199.202.1.1'
ads_port = 851
name_fmu = 'ModelicaModels_ControlledSystems_ControlledSystemBoundaries.fmu'
orig_fmu_path = glob_res_path + '\\' + name_fmu
dest_fmu_path = glob_res_path + '\\' + name_wkdir + '\\' + name_fmu
time_incr = 120

# States
inputs = []
input_names = []
traj_points = []
input_variables = []
commands = []
command_variables = []
output_names = []
set_points = []
state_var_names = []
model_state_var_names = []
traj_var = []

# Times
start = []
stop = []
incr = []
opt_time = []
samp_time = []

# Paths
lib_paths = []
res_path = []
dym_path = []
mod_path = []
command_names = []

# Modifiers
cost_fac = []

# Variation
min_var = []
max_var = []
inc_var = []

# Subsystem Config
model_type = []
name = []
sys_id = []
ups_neigh = []
downs_neigh = []
par_neigh = []

factors = []

# Subsystems
sys_id.append(0)
name.append("Heater")
model_type.append("Scikit")
ups_neigh.append(1)
downs_neigh.append(None)
par_neigh.append(None)
input_names.append(["coolerTemperature.T"])
input_variables.append([r"variation.table[1,2]"])
inputs.append([i for i in range(280,325,1)])
output_names.append(["supplyAirTemperature.T"])
set_points.append([303])
state_var_names.append(["heaterInitials[1].y"])
model_state_var_names.append(["mas1.k"])
start.append(0.)
stop.append(3600)
incr.append(10.)
opt_time.append(600)
samp_time.append(time_incr)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
#mod_path.append(f'{glob_res_path}\\heater')
mod_path.append(r'N:\Forschung\EBC0332_BMWi_MODI_GA\Students\mba-nre\01-notes\HiWi Nadja\Git\pyDMPC\pyDMPC\SpecialStudies\FrozenModels\AHU\heater')
command_names.append(["valveHeater"])
command_variables.append(["decisionVariables.table[1,2]"])
commands.append([[i,i]  for i in range(0,100,5)])
traj_points.append([])
traj_var.append([])
cost_fac.append([0.1, 0.0, 1.0])
factors.append(0)

sys_id.append(1)
name.append("Cooler")
model_type.append("Scikit")
ups_neigh.append(None)
downs_neigh.append([0])
par_neigh.append(None)
input_names.append(["preHeaterTemperature.T"])
input_variables.append(["external"])
inputs.append([i for i in range(280,325,1)])
output_names.append(["supplyAirTemperature.T"])
set_points.append([303])
state_var_names.append(["coolerInitials[1].y"])
model_state_var_names.append(["hex.ele[1].mas.T"])
start.append(0.)
stop.append(3600.)
incr.append(10.)
opt_time.append(600)
samp_time.append(time_incr)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
#mod_path.append(f'{glob_res_path}\\cooler')
mod_path.append(r'N:\Forschung\EBC0332_BMWi_MODI_GA\Students\mba-nre\01-notes\HiWi Nadja\Git\pyDMPC\pyDMPC\SpecialStudies\FrozenModels\AHU\cooler')
command_names.append(["valveCooler"])
command_variables.append(["decisionVariables.table[1,2]"])
commands.append([[i,i]  for i in range(0,100,5)])
traj_points.append([])
traj_var.append([])
cost_fac.append([0.0, 1.0, 0])
factors.append(0)

#Test-Subsystem for Modelica: ALWAYS LAST ENTRY
sys_id.append(len(sys_id))
name.append("ModelicaTest")
model_type.append("Modelica")
ups_neigh.append(None)
downs_neigh.append(None)
par_neigh.append(None)
input_names.append(None)
input_variables.append(["testPurposes"])
inputs.append([i for i in range(280,325,1)])
output_names.append(["Test.y"])
set_points.append(None)
state_var_names.append(['TestSystem'])
model_state_var_names.append(['Test.k'])
start.append(0.)
stop.append(3600.)
incr.append(10.)
opt_time.append(600)
samp_time.append(time_incr)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
mod_path.append('Testing.Subsystem.ModelicaTest')
command_names.append(None)
command_variables.append(None)
commands.append([i,i] for i in range(0,100,5))
traj_points.append([])
traj_var.append([])
cost_fac.append([0.0, 1.0, 0])
factors.append(0)