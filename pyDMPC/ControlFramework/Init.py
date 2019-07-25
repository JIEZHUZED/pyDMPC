# Global paths
glob_lib_paths = [r'D:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
             r'D:\Git\modelica-buildings\Buildings',
             r'D:\Git\AixLib\AixLib-master']
glob_res_path = r'D:\dymola'
glob_dym_path = r'D:\Program Files\Dymola 2018 FD01\Modelica\Library\python_interface\dymola.egg'

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
output_names = []
traj_points = []
input_variables = []
commands = []
command_variables = []
output_variables = []
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

# Subsystems
sys_id.append(0)
name.append("Heater")
model_type.append("Scikit")
ups_neigh.append(1)
downs_neigh.append(None)
par_neigh.append(None)
input_names.append(["coolerTemperature.T"])
input_variables.append([r"variation.table[1,2]"])
inputs.append(range(280,325,5))
output_names.append([r"heaterTemperature.T"])
output_variables.append(["supplyAirTemperature.T"])
set_points.append([306])
state_var_names.append(["heaterInitials[1].y"])
model_state_var_names.append(["mas1.k"])
start.append(0.)
stop.append(3600)
incr.append(10.)
opt_time.append(120)
samp_time.append(120)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
mod_path.append(r'D:\dymola\heater')
command_names.append(["valveHeater"])
command_variables.append(["decisionVariables.table[1,2]"])
commands.append(range(0,105,5))
traj_points.append([])
traj_var.append([])
cost_fac.append([0.0, 0.0, 1.0])

sys_id.append(1)
name.append("Cooler")
model_type.append("Scikit")
ups_neigh.append(None)
downs_neigh.append([0])
par_neigh.append(None)
input_names.append(["preHeaterTemperature.T"])
input_variables.append([r"variation.table[1,2]"])
inputs.append(range(280,325,5))
output_names.append([r"coolerTemperature.T"])
output_variables.append(["supplyAirTemperature.T"])
set_points.append([300])
state_var_names.append(["coolerInitials[1].y"])
model_state_var_names.append(["hex.ele[1].mas.T"])
start.append(0.)
stop.append(3600.)
incr.append(10.)
opt_time.append(120)
samp_time.append(120)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
mod_path.append(r'D:\dymola\cooler')
command_names.append(["valveCooler"])
command_variables.append(["decisionVariables.table[1,2]"])
commands.append(range(0,105,5))
traj_points.append([])
traj_var.append([])
cost_fac.append([0.1, 1.0, 0])
