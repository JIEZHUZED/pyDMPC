# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 11:05:11 2019

@author: mba-nre
"""

import unittest
import Init

class TestInitClass(unittest.TestCase):
        
    def test_controlledSystem(self):
    
        self.assertTrue(Init.contr_sys_typ)
        self.assertTrue(Init.ads_id)
        self.assertTrue(Init.ads_port)
        self.assertTrue(Init.time_incr)
        self.assertTrue(Init.name_fmu)
        
        self.assertEqual(Init.orig_fmu_path, Init.glob_res_path + '\\' + Init.name_fmu)
        self.assertEqual(Init.dest_fmu_path, Init.glob_res_path + '\\' + Init.name_wkdir + '\\' + Init.name_fmu)
    
    
    def test_emptyLists(self):
           
        self.assertTrue(Init.sys_id)
        self.assertTrue(Init.name)
        self.assertTrue(Init.model_type)
        self.assertTrue(Init.ups_neigh)
        self.assertTrue(Init.downs_neigh)
        self.assertTrue(Init.par_neigh)
        self.assertTrue(Init.input_names)
        self.assertTrue(Init.input_variables)
        self.assertTrue(Init.inputs)
        self.assertTrue(Init.output_names)
        self.assertTrue(Init.set_points)
        self.assertTrue(Init.state_var_names)
        self.assertTrue(Init.model_state_var_names)
        self.assertTrue(Init.start)
        self.assertTrue(Init.stop)
        self.assertTrue(Init.incr)
        self.assertTrue(Init.opt_time)
        self.assertTrue(Init.samp_time)
        self.assertTrue(Init.lib_paths)
        self.assertTrue(Init.res_path)
        self.assertTrue(Init.dym_path)
        self.assertTrue(Init.mod_path)
        self.assertTrue(Init.command_names)
        self.assertTrue(Init.command_variables)
        self.assertTrue(Init.commands)
        self.assertTrue(Init.traj_points)
        self.assertTrue(Init.traj_var)
        self.assertTrue(Init.cost_fac)
        
        #self.assertTrue(Init.factors) factors existiert nicht in Init
        #self.assertTrue(Init.min_var) in welchem Skript benötigt?
        #self.assertTrue(Init.max_var) in welchem Skript benötigt?
        #self.assertTrue(Init.inc_var) in welchem Skript benötigt?
    
    def test_sameLengthOfLists(self):
        
        self.assertEqual(len(Init.sys_id), len(Init.name))
        self.assertEqual(len(Init.name), len(Init.model_type))
        self.assertEqual(len(Init.model_type), len(Init.ups_neigh))
        self.assertEqual(len(Init.ups_neigh), len(Init.downs_neigh))
        self.assertEqual(len(Init.downs_neigh), len(Init.par_neigh))
        self.assertEqual(len(Init.par_neigh), len(Init.input_names))
        self.assertEqual(len(Init.input_names), len(Init.input_variables))
        self.assertEqual(len(Init.input_variables), len(Init.inputs))
        self.assertEqual(len(Init.inputs), len(Init.output_names))
        self.assertEqual(len(Init.output_names), len(Init.set_points))
        self.assertEqual(len(Init.set_points), len(Init.state_var_names))
        self.assertEqual(len(Init.state_var_names), len(Init.model_state_var_names))
        self.assertEqual(len(Init.model_state_var_names), len(Init.start))
        self.assertEqual(len(Init.start), len(Init.stop))
        self.assertEqual(len(Init.stop), len(Init.incr))
        self.assertEqual(len(Init.incr), len(Init.opt_time))
        self.assertEqual(len(Init.opt_time), len(Init.samp_time))
        self.assertEqual(len(Init.samp_time), len(Init.lib_paths))
        self.assertEqual(len(Init.lib_paths), len(Init.res_path))
        self.assertEqual(len(Init.res_path), len(Init.dym_path))
        self.assertEqual(len(Init.dym_path), len(Init.mod_path))
        self.assertEqual(len(Init.mod_path), len(Init.command_names))
        self.assertEqual(len(Init.command_names), len(Init.command_variables))
        self.assertEqual(len(Init.command_variables), len(Init.commands))
        self.assertEqual(len(Init.commands), len(Init.traj_points))
        self.assertEqual(len(Init.traj_points), len(Init.traj_var))
        self.assertEqual(len(Init.traj_var), len(Init.cost_fac))
        self.assertEqual(len(Init.cost_fac), len(Init.sys_id))
        
    def test_paths(self):
        
        self.assertIn('ModelicaModels', Init.glob_lib_paths[0])
        self.assertIn('Buildings', Init.glob_lib_paths[1])
        self.assertIn('AixLib', Init.glob_lib_paths[2])
        
        self.assertIn('dymola', Init.glob_res_path)
        self.assertIn('dymola.egg', Init.glob_dym_path)
        
        
if __name__ == '__main__':
    unittest.main()