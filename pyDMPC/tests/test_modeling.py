# -*- coding: utf-8 -*-
"""
Created on Mon Sep  9 15:57:00 2019

@author: mba-nre
"""

import unittest
import Modeling
import Init
      
class TestStatesClass(unittest.TestCase):
          
    def test_states(self):
        
        print(Init.sys_id[-1])
        for i in Init.sys_id:
            with self.subTest(i=i):
                
                self.model = Modeling.States(i) 
           
                self.assertEqual(Init.input_names[i], self.model.input_names)
                self.assertEqual(Init.input_variables[i], self.model.input_variables)
                self.assertEqual(Init.output_names[i], self.model.output_names)
                self.assertEqual(Init.set_points[i], self.model.set_points)
                self.assertEqual(Init.model_state_var_names[i], self.model.model_state_var_names)
                self.assertEqual(Init.state_var_names[i], self.model.state_var_names)
                self.assertEqual(Init.command_names[i], self.model.command_names)
                self.assertEqual(Init.command_variables[i], self.model.command_variables)
            
                self.assertIsInstance(self.model.inputs, list)
                self.assertIsInstance(self.model.outputs, list)
                self.assertIsInstance(self.model.state_vars, list)
                self.assertIsInstance(self.model.commands, list)
                           
class TestTimesClass (unittest.TestCase):            
    
    def test_times(self):
         
        for i in Init.sys_id:
            with self.subTest(i=i):
                
                self.model = Modeling.Times(i) 
                
                self.assertEqual(Init.start[i], self.model.start)
                self.assertEqual(Init.stop[i], self.model.stop)
                self.assertEqual(Init.incr[i], self.model.incr)
                self.assertEqual(Init.opt_time[i], self.model.opt_time)
                self.assertEqual(Init.samp_time[i], self.model.samp_time)
            
class TestPathsClass (unittest.TestCase):
                
    def test_paths(self):
        
        for i in Init.sys_id:
            with self.subTest(i=i):
                
                self.model = Modeling.Paths(i)
            
                self.assertEqual(Init.lib_paths[i], self.model.lib_paths)
                self.assertEqual(Init.res_path[i] + "\\" + Init.name[i], self.model.res_path)
                self.assertEqual(Init.dym_path[i], self.model.dym_path)
                self.assertEqual(Init.mod_path[i], self.model.mod_path)
            
class TestModelClass (unittest.TestCase):
                       
    def test_model(self):
        
        for i in Init.sys_id:
            with self.subTest(i=i):
               
                self.model = Modeling.Model(i)
               
                self.assertEqual(Init.model_type[i], self.model.model_type)
                self.assertIsInstance(self.model.states, Modeling.States)
                self.assertIsInstance(self.model.times, Modeling.Times)
                self.assertIsInstance(self.model.paths, Modeling.Paths) 
                
class TestModifsClass (unittest.TestCase):
    
    def test_modifs (self): 
        
        for i in Init.sys_id:
            with self.subTest(i=i):
                
                self.modifs = Modeling.Modifs(i)
                
                self.assertEqual(self.modifs.factors, Init.factors[i])
                
class TestModelicaModClass (unittest.TestCase):
    
    def test_Init(self):

        for i in Init.sys_id:
            with self.subTest(i=i):
                
                self.model = Modeling.ModelicaMod(i)
               
                self.assertEqual(Init.model_type[i], self.model.model_type)
                self.assertIsInstance(self.model.states, Modeling.States)
                self.assertIsInstance(self.model.times, Modeling.Times)
                self.assertIsInstance(self.model.paths, Modeling.Paths)  
   
    def test_makeDymola(self):
        
        i = Init.sys_id[-1]
                
        self.model = Modeling.ModelicaMod(i)
        self.dymola = self.model.make_dymola()
                
        self.assertEqual(self.model.dym_path, Init.glob_dym_path)
        self.assertEqual(self.model.lib_paths, Init.glob_lib_paths)
        self.assertNotEqual(self.model.dymola, None)
 
        self.translate = self.model.translate()
        self.simulate = self.model.simulate()
        results = self.model.get_results(Init.output_names[i][0])

        self.assertEqual(results[0], 20)
               
    def test_delDymola(self):
        
        i = Init.sys_id[-1]
              
        self.model = Modeling.ModelicaMod(i)
        self.delete = self.model.del_dymola()
                
        self.assertEqual(self.model.dymola, None) 
                        
    def test_translate(self):
        
        i = Init.sys_id[-1]
                
        self.model = Modeling.ModelicaMod(i)
        #for change directory
        self.assertEqual(Init.res_path[i] + "\\" + Init.name[i], self.model.paths.res_path)    
        #for translating Model
        self.assertEqual(Init.mod_path[i], self.model.paths.mod_path)
                  
class TestSciModClass (unittest.TestCase):
              
    def test_SciMod(self):
        
        i = Init.sys_id[-2]
                
        self.model = Modeling.SciMod(i)
                
        self.assertEqual(Init.model_type[i], self.model.model_type)
        self.assertIsInstance(self.model.states, Modeling.States)
        self.assertIsInstance(self.model.times, Modeling.Times)
        self.assertIsInstance(self.model.paths, Modeling.Paths)
                
        self.load = self.model.load_mod()
        self.predict = self.model.predict()
        
        self.assertAlmostEqual(1, self.predict[0][0], 5)
                
class TestLinModClass (unittest.TestCase):
            
    def test_LinMod(self):
       for i in Init.sys_id:
            with self.subTest(i=i):
                
                self.model = Modeling.LinMod(i)
                
                self.assertEqual(self.model.modifs.factors, Init.factors[i])
                
                print('LinMod Class Test successful')
        
if __name__ == '__main__':
   unittest.main()