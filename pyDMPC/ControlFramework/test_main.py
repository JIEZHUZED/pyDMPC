"""
This is a test module for new implementations.
"""

import System
import Subsystem
import Init
import time
import numpy as np
import scipy.io as sio
from pathos.multiprocessing import ProcessingPool as Pool
import Objective_Function
from pyfmi import load_fmu
import os
import sys
import configparser
import matplotlib.pyplot as plt

def main():
    """Create a system and multiple subsystems"""
    AHU = System.System()
    subsystems = AHU.GenerateSubSys()

    """Prepare the working Directory"""
    os.chdir(Init.path_res)
    os.mkdir(str(Init.name_wkdir))
    os.chdir(str(Init.name_wkdir))

    """Create one directory for each of the subsystems and one for the inputs"""
    for s in subsystems:
        os.mkdir(s._name)

    os.mkdir("Inputs")

    """Load the FMU model, set the experiment and initialize the inputs"""
    global dymola
    dymola = None
    # Work-around for the environment variable
    sys.path.insert(0, os.path.join(str(Init.path_dymola)))

    # Import Dymola Package
    from dymola.dymola_interface import DymolaInterface

    # Start the interface
    dymola = DymolaInterface()

    """ Simulation """
    # Open dymola library

    for lib in Init.path_lib:
        check1 = dymola.openModel(os.path.join(lib,'package.mo'))
        print('Opening successful ' + str(check1))

    dymola.cd(Init.path_res + '\\' + Init.name_wkdir)

    # Translate the model to FMU
    dymola.ExecuteCommand('Advanced.CompileWith64=2')
    dymola.ExecuteCommand('translateModelFMU("'+Init.path_fmu+'", true, "'+ Init.name_fmu+'", "1", "cs", false, 0)')

    log = dymola.getLastErrorLog()
    print(log)

    model = load_fmu(Init.path_res+'\\'+Init.name_wkdir +'\\'+Init.name_fmu+'.fmu')

    model.set('humidifierWSP1',0)
    model.set('valveHRS',0)
    model.set('valvePreHeater',0)
    model.set('valveHeater',0)
    model.set('valveCooler',0)
    model.initialize()

    """Variables storing (time) steps"""
    time_step = 0
    time_storage = 0
    start = time.time()
    counter = 0

    """Variables storing commands"""
    storage_commands = np.zeros([5,1])

    """There are currently three different options:
    1. NC-OPT algorithm
    2. NC-OPT algorithm using parallel computing
    3. BExMoC algorithm
    """

    """The algorithms work with a discrete *time_step*. In each step, the current measurements are taken using the :func:`GetMeasurements' method. """
    while time_step <= Init.sync_rate*Init.stop_time:

        command_all = []

        if Init.algorithm == 'NC_DMPC':

            """ Consider the subsystems in multiple iterations, either in parallel or in sequential order """
            for k in range(2):
                if Init.parallelization:
                    def f(s):
                        commands = s.CalcDVvalues(time_step, time_storage,k,model)
                        return commands

                    p = Pool(4)
                    commands = p.map(f, [subsystems[0], subsystems[1], subsystems[2], subsystems[3], subsystems[4]])

                else:
                    for s in subsystems:
                        commands = s.CalcDVvalues(time_step, time_storage,k,model)

                    command_all.append(commands)

        elif Init.algorithm == 'BExMoC':

            #Consider each subsystem sequentially
            for s in subsystems:
                print(s._name)

                """The main calculations are carried out by invoking the :func:'CalcDVvalues' method. The BExMoC algorithm exchanges tables between the subsystems in a .mat format"""
                commands = (s.CalcDVvalues(time_step, time_storage,0, model))

                command_all.append(commands)

                #Save the look-up tables in .mat files
                (sio.savemat((Init.path_res + '\\' + Init.name_wkdir + '\\' + s._name + '\\' +
                'DV_lookUpTable' + str(counter) + '.mat' ),
                {'DV_lookUpTable': s.lookUpTables[1]}))

                (sio.savemat((Init.path_res + '\\' + Init.name_wkdir + '\\' + s._name + '\\' +
                'Costs_lookUpTable' + str(counter) + '.mat' ),
                {'Cost_lookUpTable': s.lookUpTables[0]}))

                (sio.savemat((Init.path_res + '\\' + Init.name_wkdir + '\\' + s._name + '\\' +
                'Output_Table' + str(counter) + '.mat' ),
                {'Output_Table': s.lookUpTables[2]}))

                (sio.savemat((Init.path_res + '\\' + Init.name_wkdir + '\\' + s._name + '\\' +
                'command' + str(counter) + '.mat' ),
                {'Output_Table': commands}))



        #For real time experiments, the excecution needs to be paused
        if Init.realtime:
            if time_step > 0:
                time.sleep(max(Init.sync_rate-time.time()+start,0))
                start = time.time()
        else:
            for l,val in enumerate(command_all):
                model.set(Init.names_DVs[3-l], max(0, min(val, 100)))
                print(val)

            '''Plot the current temperature trajectory'''
            plt.close('all')
            contr_var.append(values[9])
            input.append(values[10])
            plt.plot(contr_var)
            plt.show(block=False)
            plt.savefig('supplyTemp'+str(counter),format='pdf')

            model.do_step(time_step, Init.sync_rate)

        if time_step-time_storage >= Init.optimization_interval:
            time_storage = time_step
        time_step += Init.sync_rate
        counter += 1

    Objective_Function.CloseDymola()

if __name__=="__main__": main()
