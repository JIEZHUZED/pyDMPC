# Global paths
glob_lib_paths = [r'N:\Forschung\EBC0377_BMWi-GeoBase_GA\Students\mba-mst\05-Python\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
             r'N:\Forschung\EBC0377_BMWi-GeoBase_GA\Students\mba-mst\02-Models\modelica-buildings\Buildings',
             r'N:\Forschung\EBC0377_BMWi-GeoBase_GA\Students\mba-mst\02-Models\AixLib\AixLib']
glob_res_path = r'C:\TEMP\Dymola'
glob_dym_path = r'C:\Program Files\Dymola 2019\Modelica\Library\python_interface\dymola.egg'

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
name.append("Field")
model_type.append("Modelica")
ups_neigh.append(None)
downs_neigh.append(1)
input_names.append(["returnTemperature.T"])
input_variables.append(["external"])
inputs.append([])
output_names.append(["movMea.y"])
set_points.append([285.65])
state_var_names.append(["supplyTemperature.T"])
model_state_var_names.append(["vol1.T_start"])
start.append(0.)
stop.append(3600.0*24*365.25*3)
incr.append(3600.)
opt_time.append(86400)
samp_time.append(10)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.Geo.Field2')
command_names.append(["traj"])
command_variables.append(["decisionVariables.table[1,2]"])
commands.append(range(0,100,1))
traj_points.append(range(283,291,1))
traj_var.append(["fromKelvin.Celsius"])
cost_fac.append([0.0, 0.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 0.0])
#cost factors: ([0: reale Kosten Feld, 1: reale Kosten sek. Erzeuger, 2: reale Kosten WP, 3: downstream neigh, 4: Abweichung setpoint, 5: I-Anteil Bestrafung, 6: I-Anteil Belohnung, 7: D-Anteil Bestrafung, 8: D-Anteil Vergütung])

sys_id.append(1)
name.append("Building")
model_type.append("Modelica")
ups_neigh.append(0)
downs_neigh.append(None)
input_names.append(["supplyTemperature.T"])
input_variables.append([r"variation.table[1,2]"])
inputs.append(range(280.15,290.15,0.05))
output_names.append(["returnTemperature"])
set_points.append([287])
state_var_names.append(["sine.y"])
model_state_var_names.append(["const.k"])
start.append(0.)
stop.append(7200.)
incr.append(10.)
opt_time.append(3600)
samp_time.append(10)
lib_paths.append(glob_lib_paths)
res_path.append(glob_res_path + "\\" + name_wkdir)
dym_path.append(glob_dym_path)
mod_path.append(r'ModelicaModels.SubsystemModels.DetailedModels.Geo.GeothermalHeatPump')
command_names.append(["heatShare"])
command_variables.append(["TStorageSet"])
commands.append(range(0,100,5))
traj_points.append([])
traj_var.append([])
cost_fac.append([-0.5, 0.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 0.0])
#cost factors: ([0: reale Kosten Feld, 1: reale Kosten sek. Erzeuger, 2: reale Kosten WP, 3: downstream neigh, 4: Abweichung setpoint, 5: I-Anteil Bestrafung, 6: I-Anteil Belohnung, 7: D-Anteil Bestrafung, 8: D-Anteil Vergütung])