# -*- coding: utf-8 -*-
"""
Created on Sun May 26 10:16:05 2019

@author: mba
"""

import Init

class States:
    
    def __init__(self, sys_id):
        self.inputs = []
        self.input_names = Init.input_names[sys_id]
        self.outputs = []
        self.output_names = Init.output_names[sys_id]
        self.set_points = Init.set_points[sys_id]
        self.set_point_names = Init.set_point_names[sys_id]
        self.state_vars = []
        self.state_var_names = Init.state_var_names[sys_id]
        self.commands = []
        self.command_names = Init.command_names[sys_id]

class Times:
    
    def __init__(self, sys_id):
        self.start = Init.start[sys_id] 
        self.stop = Init.stop[sys_id]
        self.incr = Init.incr[sys_id]
        self.opt_time = Init.opt_time[sys_id]
        self.samp_time = Init.samp_time[sys_id]
        
class Paths:
    
    def __init__(self, sys_id):
        self.lib_paths = Init.lib_paths[sys_id]
        self.res_path = Init.res_path[sys_id]
        self.dym_path = Init.dym_path[sys_id]
        self.mod_path = Init.mod_path[sys_id]

class Modifs:
    def __init__(self, sys_id):
        self.factors = Init.factors[sys_id]
    

class Model:
    
    def __init__(self, sys_id):
        self.model_type = Init.model_type[sys_id]
        self.states = States(sys_id)
        self.times = Times(sys_id)
        self.paths = Paths(sys_id)
        

class ModelicaMod(Model):
    
    dymola = None
    lib_paths = Init.glob_lib_paths
    dym_path = Init.glob_dym_path

    def __init__(self, sys_id):
        super().__init__(sys_id)
    
    @classmethod
    def make_dymola(cls):
        
        import sys
        import os
        
        if cls.dymola == None:
            # Work-around for the environment variable
            sys.path.insert(0, os.path.join(cls.dym_path))
            # Import Dymola Package
            print(cls.dym_path)
            global dymola
            from dymola.dymola_interface import DymolaInterface
            # Start the interface
            cls.dymola = DymolaInterface()
        
        for i,path in enumerate(cls.lib_paths):
            print(path)
            check = cls.dymola.openModel(os.path.join(path,'package.mo'))
            print('Opening successful ' + str(check))
            
    @classmethod   
    def del_dymola(cls):
        if cls.dymola is not None:
            cls.dymola.close()
            cls.dymola = None
            
    def write_inputs(self):
        pass

    def translate(self):
        ModelicaMod.dymola.cd(self.paths.res_path)
        check = ModelicaMod.dymola.translateModel(self.paths.mod_path)
        print("Translation successful " + str(check))
        
    def simulate(self):
        ModelicaMod.dymola.cd(self.paths.res_path)
        for k in range(3):
            try:
                if self.states.state_var_names is None:
                        print(ModelicaMod.dymola.simulateExtendedModel(
                        problem=self.paths.mod_path,
                        startTime=self.times.start,
                        stopTime=self.times.stop,
                        outputInterval=self.times.incr,
                        method="Dassl",
                        tolerance=0.001,
                        resultFile= self.paths.res_path  + r'\dsres',
                        finalNames = self.states.output_names))

                else:
                    print(ModelicaMod.dymola.simulateExtendedModel(
                        problem=self.paths.mod_path,
                        startTime=self.times.start,
                        stopTime=self.times.stop,
                        outputInterval=self.times.incr,
                        method="Dassl",
                        tolerance=0.001,
                        resultFile= self.paths.res_path + r'\dsres',
                        finalNames = self.states.output_names,
                        initialNames = self.states.state_var_names,
                        initialValues = self.states.state_vars))

                print("Simulation successful")
                break

            except:
                if k < 3:
                    print('Repeating simulation attempt')
                else:
                    print('Final simulation error')
                    
    def get_outputs(self):
        from modelicares import SimRes
        import os
        # Get the simulation result
        sim = SimRes(os.path.join(self.paths.res_path, 'dsres.mat'))
        self.states.outputs = []
        
        if self.states.output_names is not None:
            for i,out in enumerate(self.states.output_names):
                self.states.outputs.append(sim[out].values())
                    
class SciMod(Model):
    def __init__(self, sys_id):
        super().__init__(sys_id)
    
    def load_mod(self):
        from joblib import load
        self.model = load(self.paths.mod_path + r".joblib")
        self.scaler = load(self.paths.mod_path + r"_scaler.joblib")
        
    def write_inputs(self):
        import numpy as np
        
        commands = [com for com in self.states.commands]
        inputs = [inp for inp in self.states.inputs]
        
        inputs = np.stack((commands + inputs), axis = 1)
        
        self.scal_inputs = self.scaler.transform(inputs)
        
    def predict(self):
        self.states.outputs = self.model.predict(self.scal_inputs)
        
class LinMod(Model):
    
    def __init__(self, sys_id):
        super().__init__(sys_id)
        self.modifs = Modifs(sys_id)
        
    def predict(self, start_val):
        self.states.outputs = (start_val + 
                               self.modifs.factors[0] * self.states.inputs[0] + 
                               self.modifs.factors[1] * self.states.commands[0])
        
class FuzMod(Model):
    
    def __init__(self, sys_id):
        super().__init__(sys_id)

    def predict(self):
        import functions.fuzzy as fuz
        self.states.outputs = self.states.inputs[0]
        self.states.set_points = fuz.control(self.states.inputs[0],
                                             self.states.inputs[1])
        
        
    
    
    
        
    

        