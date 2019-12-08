import time
import numpy as np
import requests
import scipy.io as sio

# Global paths
glob_lib_paths = [r'D:\Git\pyDMPC\pyDMPC\ModelicaModels\ModelicaModels',
    r'D:\Git\modelica-buildings\Buildings',
    r'D:\Git\AixLib-master\AixLib']
glob_res_path = r'D:\TEMP'
glob_dym_path = r'C:\Program Files\Dymola 2018 FD01\Modelica\Library\python_interface\dymola.egg'

# Working directory
timestr = time.strftime("%Y%m%d_%H%M%S")
name_wkdir = r'pyDMPC_' + 'wkdir' + timestr

# Controlled system
contr_sys_typ = "PLC"
ads_id = '5.53.34.234.1.1'
ads_port = 851
name_fmu = 'pyDMPCFMU_AHU.fmu'
orig_fmu_path = glob_res_path + '\\' + name_fmu
dest_fmu_path = glob_res_path + '\\' + name_wkdir + '\\' + name_fmu
time_incr = 120

# Number of subsystems
n = 1

# States
inputs = [None for _ in range(n)]
input_names = [None for _ in range(n)]
traj_points = [None for _ in range(n)]
input_variables = [None for _ in range(n)]
commands = [None for _ in range(n)]
command_variables = [None for _ in range(n)]
output_names = [None for _ in range(n)]
set_points = [None for _ in range(n)]
state_var_names = [None for _ in range(n)]
model_state_var_names = [None for _ in range(n)]
traj_var = [None for _ in range(n)]

# Times
start = [None for _ in range(n)]
stop = [None for _ in range(n)]
incr = [None for _ in range(n)]
opt_time = [None for _ in range(n)]
samp_time = [None for _ in range(n)]

# Paths
lib_paths = [None for _ in range(n)]
res_path = [None for _ in range(n)]
dym_path = [None for _ in range(n)]
mod_path = [None for _ in range(n)]
command_names = [None for _ in range(n)]

# Modifiers
cost_fac = [[1] for _ in range(n)]
state_factors = [[1] for _ in range(n)]
state_offsets = [[0] for _ in range(n)]
input_factors = [[1] for _ in range(n)]
input_offsets = [[0] for _ in range(n)]
output_factors = [[1] for _ in range(n)]
output_offsets = [[0] for _ in range(n)]

# Variation
min_var = [None for _ in range(n)]
max_var = [None for _ in range(n)]
inc_var = [None for _ in range(n)]

# Subsystem Config
model_type = [None for _ in range(n)]
name = [None for _ in range(n)]
sys_id = [None for _ in range(n)]
ups_neigh = [None for _ in range(n)]
downs_neigh = [None for _ in range(n)]
par_neigh = [None for _ in range(n)]

# Subsystems
sys_id[0] = 0
name[0] = "Hall-long"
model_type[0] = "Modelica"
#ups_neigh[0] = 2
#par_neigh[0] = [1]
input_names[0] = ["GVL.fAHUTempSUP"]
input_variables[0] = [r"variation.table[1, 2]"]
inputs[0] = [1]
#inputs[0] = [i for i in range(280, 325, 1)]
output_names[0] = ["supplyAirTemperature.T"]
mod_path[0] = "ModelicaModels.SubsystemModels.DetailedModels.Hall_long"
set_points[0] = [295]
state_var_names[0] = ["GVL.fAHUTempSUP"]
model_state_var_names[0] = ["volume.T_start"]
state_offsets[0] = [273]
#model_state_var_names[0] = ["AirVolumeFlow.k","volume.T_start", "concreteFloor.T"]
start[0] = 0.
stop[0] = 2*24*3600
incr[0] = 100.
opt_time[0] = 6*3600
samp_time[0] = time_incr
lib_paths[0] = glob_lib_paths
res_path[0] = glob_res_path + "\\" + name_wkdir
dym_path[0] = glob_dym_path
command_names[0] = ["GVL.fTemperatureAmbientADS"]
command_variables[0] = [r"decisionVariables.table[1, 2]"]
commands[0] = [[i] for i in range(8, 14, 3)]
traj_points[0] = []
traj_var[0] = []
cost_fac[0] = [0.1, 0.0, 1.0]

def custom():
    key = np.loadtxt(glob_res_path + "\\" + "key.txt", str)
    url = (r"http://api.openweathermap.org/data/2.5/forecast?id=6553047&APPID=" +
              str(key))  

    r = requests.get(url).json()

    r = r['list']
    
    for k in range(0,1000):
    
        try:
            dic = r[k]
            tim = dic['dt']
                
            mai = dic['main']
            temp = float(mai['temp'])
            
            if k == 0:
                start_tim = tim
                values = [[0.0,temp]]
            else:
                values += [[tim-start_tim,temp]]
                
        except:
            break
                
    sio.savemat((res_path[0] + 
                 '\\' + 'weather.mat'),{'InputTable' : np.array(values)})