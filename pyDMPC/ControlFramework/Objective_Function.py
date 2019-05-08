##################################################################
# Objective function module that can be used by each of the agents in
# order to determine costs
##################################################################

import Init
import numpy as np
from joblib import dump, load
from sklearn.neural_network import MLPClassifier, MLPRegressor
from sklearn.preprocessing import StandardScaler
import time
import random

'''Global variables used for simulation handling'''
# Variable indicating if the subsystem model is compiled
gl_model_compiled = [False]*(Init.amount_consumer+Init.amount_generator)

# Variable indicating if dymola instance is active
dymola = None

# Global output of the subsystems
gl_output = None

# Results of the subsystem
gl_res_grid = np.zeros([2,1])

def TranslateModel(model_path, name, position):
    """
    Function to handle the Compilation of Modelica models
    inputs
        model_path: path of the model
        name: name of the subsystems
        position: position number of the subsystems
    returns:
        None
    """
    """
    global gl_model_compiled
    if  gl_model_compiled[position-1] == False:
        import os
        import sys
        global dymola

        #Dymola configurations
        if dymola is None:
            # Work-around for the environment variable
            sys.path.insert(0, os.path.join(r'C:\Program Files\Dymola 2018 FD01\Modelica\Library\python_interface\dymola.egg'))

            # Import Dymola Package
            from dymola.dymola_interface import DymolaInterface

            # Start the interface
            dymola = DymolaInterface()

        #Compilation
        # Open dymola library
        for lib in Init.path_lib:
            check1 = dymola.openModel(os.path.join(lib,'package.mo'))
            print("Opening successful " + str(check1))

        # Force Dymola to use 64 bit compiler
        dymola.ExecuteCommand("Advanced.CompileWith64=2")
        dymola.cd(Init.path_res +'\\'+Init.name_wkdir+'\\' + name)

        # Translate the model
        check2 =dymola.translateModel(model_path)
        print("Translation successful " + str(check2))
        if check2 is True:
            gl_model_compiled[position-1] = True
    """
    
    gl_model_compiled[position-1] = True

def Obj(values_DVs, BC, s):
    """
    Function to compute the objective function value
    inputs:
        values_DVs: values of the decision variables
        BC: current boundary conditions
        s: subsystem object
    returns:
        None
    """
    import Init
    import os
    from modelicares import SimRes
    import numpy as np
    import scipy.interpolate as interpolate
    import scipy.io as sio

    # Open dymola library
    TranslateModel(s._model_path, s._name, s.position)

    global dymola
    obj_fnc_val = 'objectiveFunction'

    """ Store two .mat-files that can be read by Dymola """
    #This file contains the input setting BC1/ BC2/..
    BC_array = np.empty([1,len(BC)+1])
    BC_array[0,0] = 0
    for i,val in enumerate(BC):
        BC_array[0][i+1] = val

    final_names = [obj_fnc_val]

    """Run the actual simulations"""
    # Max. 3 attempts to simulate
    # Different function call if no initialization is intended
    if s._model_type == "Modelica":
        for k in range(3):
            try:
                if s._initial_names is None:
                    simStat = dymola.simulateExtendedModel(
                    problem=s._model_path,
                    startTime=Init.start_time,
                    stopTime=Init.stop_time,
                    outputInterval=Init.incr,
                    method="Dassl",
                    tolerance=Init.tol,
                    resultFile= subsys_path  +'\dsres',
                    finalNames = final_names,
                    )
                else:
                    simStat = dymola.simulateExtendedModel(
                        problem=s._model_path,
                        startTime=Init.start_time,
                        stopTime=Init.stop_time,
                        outputInterval=Init.incr,
                        method="Dassl",
                        tolerance=Init.tol,
                        resultFile= subsys_path  +'\dsres',
                        finalNames = final_names,
                        initialNames = s._initial_names,
                        initialValues = s._initial_values,
                    )

                k = 4

            except:
                if k < 3:
                    print('Repeating simulation attempt')
                else:
                    print('Final simulation error')

                k += 1

        # Get the simulation result
        sim = SimRes(os.path.join(subsys_path, 'dsres.mat'))

        #store output
        output_traj = []
        output_list = []
        if s._output_vars is not None:
            for val in s._output_vars:
                output_vals = sim[val].values()
                output_list.append(output_vals[-1])
                output_traj.append(sim[val].values())

    else:
        command = [[] for l in range(4)] 
        T_cur = []

        output_traj = []
        output_list = []
        MLPModel = load("C:\\TEMP\Dymola\\" + s._name + ".joblib")
        scaler = load("C:\\TEMP\\Dymola\\" + s._name + "_scaler.joblib")

        for t in range(60):
            #for l in range(4):
                #command[l].append(float(values_DVs[l]))
            
            command[0].append(float(values_DVs[0]))
            command[1].append(float(values_DVs[1]))
            command[2].append(0.0)
            command[3].append(float(values_DVs[2]))

            T_cur.append(s.measurements[1])


        x_test = np.stack((command[0],command[1],command[2],command[3],T_cur),axis=1)

        scaled_instances = scaler.transform(x_test)
        traj = MLPModel.predict(scaled_instances)
        traj += 273*np.ones(len(traj))
        if s._output_vars is not None:
            output_traj = [traj, (0.3+random.uniform(0.0,0.01))*np.ones(60)]

            output_list.append(traj[-1])
            output_list.append(0.3+random.uniform(0.0,0.01))

        #print(values_DVs)
        #print(BC[0])
        #print(traj)


    if s._output_vars is not None:
        global gl_output
        gl_output = output_list

    cost_total = 0

    """all other subsystems + costs of downstream system"""
    if s._type_subSyst != "consumer":
        
        #print(output_traj)

        for l,tout in enumerate(output_traj[0]):
            #for m in range(1,s._num_DVs-1):
            cost_total += (abs(values_DVs[1])+abs(values_DVs[2]))*s._cost_factor
            
            cost_total += 10*(max(abs(tout-273-Init.set_point[0])-Init.tolerance,0))**2
        if s._model_type == "Modelica":
            cost_total = cost_total/len(output_traj[0])
        else:
            cost_total = cost_total/len(output_traj[0])
        #print(s._name + " actuators : " + str(values_DVs))
        #print("cost_total: " + str(cost_total))
        #print("output: " + str(tout))
        #time.sleep(2)

    else:
        for l,tout in enumerate(output_traj[0]):
            if l > 100 or s._model_type == "MLP":
                cost_total += 10*(max(abs(tout-273-Init.set_point[0])-Init.tolerance,0))**2

        cost_total = cost_total/len(output_traj[0])
        #print(s._name + " actuators : " + str(values_DVs))
        #print("cost_total: " + str(cost_total))
        #print("output: " + str(tout))


    """ Track Optimizer """
    #print(values_DVs)
    #print(cost_total)

    return cost_total


def CloseDymola():
    global dymola
    if dymola is not None:
        dymola.close()
        dymola = None
        global gl_model_compiled
        gl_model_compiled = False

def ChangeDir(name):
    global dymola
    if dymola is not None:
        dymola.cd(Init.path_res +'\\'+ Init.name_wkdir +'\\' + name)


def GetOutputVars():
    global gl_output
    return gl_output

def GetOptTrack():
    global gl_res_grid
    gl_res_grid = np.delete(gl_res_grid,0,1)
    return gl_res_grid

def DelLastTrack():
    global gl_res_grid
    gl_res_grid =np.zeros([2,1])
