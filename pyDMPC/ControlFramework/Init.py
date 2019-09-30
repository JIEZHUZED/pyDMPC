# Global paths
glob_lib_paths = [r'C:\mst\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
             r'C:\mst\modelica-buildings\Buildings',
             r'C:\mst\AixLib\AixLib']
glob_res_path = r'C:\mst\dymola'
glob_dym_path = r'C:\Program Files (x86)\Dymola 2018\Modelica\Library\python_interface\dymola.egg'

# Working directory
import time
timestr = time.strftime("%Y%m%d_%H%M%S")
name_wkdir = r'pyDMPC_' + 'wkdir' + timestr

# Controlled system
contr_sys_typ = "Modelica"
ads_id = '5.59.199.202.1.1'
ads_port = 851
name_fmu = 'pyDMPCFMU_Geo.fmu'
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
factors = []

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

# Subsystems
sys_id.append(0)
name.append("Building")
model_type.append("Modelica")
ups_neigh.append(None)
downs_neigh.append(1)
input_names.append(["supplyTemperature"])   #controlled System
input_variables.append([r"variation.table[1,2]"])       #subsystem
inputs.append(range(280,290,5))
output_names.append(["returnTemperature"])  #controlled System
set_points.append([287])
state_var_names.append(["switch2.y"])         #controlled System
model_state_var_names.append(["const.k"])    #subsystem
start.append(0.)
stop.append(7200.)
incr.append(10.)
opt_time.append(3600)
samp_time.append(10)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.Geo.GeothermalHeatPump')
command_names.append(["T_set_HeatStorage"])     #controlled System
command_variables.append(["decisionVariables.table[1,2]"])      #subsystem
commands.append(range(308,313,5))
traj_points.append([])
traj_var.append([])
cost_fac.append([-1.0, 0.0, 1000.0, -1000.0, 2000.0, -2000.0, 3000.0, -3000.0, 10.0, 2.0])
factors.append([1, -10./4.18/8./100.])

sys_id.append(1)
name.append("Field")
model_type.append("Modelica")
ups_neigh.append(0)
downs_neigh.append(None)
input_names.append(["returnTemperature"])
input_variables.append(["external"])
inputs.append([])
output_names.append(["movMea.y"])
set_points.append([285.65])
state_var_names.append(["supplyTemperature"])
model_state_var_names.append(["vol.T_start"])
start.append(0.)
stop.append(3600.0*24*365.25*3)
incr.append(3600.)
opt_time.append(86400)
samp_time.append(10)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.Geo.Field')
command_names.append(["traj"])
command_variables.append(["decisionVariables.table[1,2]"])
commands.append(range(0,105,5))
traj_points.append(range(280,290,1))
traj_var.append(["supplyTemperature.T"])
cost_fac.append([-1.0, 0.0, 10.0, -10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])   
factors.append([0,0])
#Legend: cost_fac.append([real_cost_field, cost_downstr_neigh, cost_dev_setpoint_penalty, cost_dev_setpoint_reward, cost_integ_penalty, cost_integ_reward, cost_diff_penalty, cost_diff_reward, real_cost_boiler, real_cost_heatpump])