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
                
    def test_times(self):
        
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

@unittest.skipUnless('Modelica' in Init.model_type, "no Modelica model used")
class TestModelicaModClass (unittest.TestCase):
    
                      
    def testMakeDymola(self):
        
        for i in Init.sys_id:
            with self.subTest(i=i):
                self.model = Modeling.ModelicaMod(i)
                self.assertIn(Init.name[i], self.model.dym_path)

    #def testDelDymola(self):
        
    #def testTranslate(self):
        
    #def testSimulate(self):
        
    #def testGetOutputs(self):
        
    #def testGetResults(self):
        
    #def testPredict(self):
    
@unittest.skipUnless('Scikit' in Init.model_type, "no Scikit model used")
class TestSciModClass (unittest.TestCase):
              
    def testSciMod(self):
        for i in Init.sys_id:
            with self.subTest(i=i):
                self.model = Modeling.SciMod(i)
                
                #self.assertEqual(6, 5)
        
@unittest.skipUnless('Linear' in Init.model_type, "no Linear model used")
class TestLinModClass (unittest.TestCase):
            
    def testLinMod(self):
       for i in Init.sys_id:
            with self.subTest(i=i):
                self.model = Modeling.LinMod(i)
                
                self.assertEqual(3,5)
    
#@unittest.skipUnless('Fuzzy'/None ?? in Init.model_type )           
          
if __name__ == '__main__':
   unittest.main()