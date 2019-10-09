# -*- coding: utf-8 -*-
"""
Created on Tue Oct  8 11:05:11 2019

@author: mba-nre
"""

import unittest
import Init

class TestInitListsClass(unittest.TestCase):
    
    def test_lengthoflists(self):
        
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
        
        #min_var
        #max_var
        #inc_var
        
if __name__ == '__main__':
    unittest.main()