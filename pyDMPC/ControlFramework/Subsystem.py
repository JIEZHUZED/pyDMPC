import Init
import Modeling
import System
import Time
import numpy as np

class Subsystem:

    """This class represents the the agents that are assigned to the subsystems.
    The agents can predict the behavior of their subsystems and store the
    current costs, coupling variables and states.

    Parameters
    ----------
    sys_id : int
        The unique identifier of a subsystem as specified in the Init

    Attributes
    ----------
    sys_id : int
        The unique identifier of a subsystem as specified in the Init
    name : string

    model_type : string
        The type of the model that this subsystem uses
    model : Model
        The model object created according to the model type
    ups_neigh : int or None
        The ID of the upstream neighbor if it exists
    downs_neigh : int
        The ID of the downstream neighbor if it exists
    coup_vars_send : list of floats
        A list of the current values of coupling variables that should be sent
    coup_vars_rec : list of floats
        A list of the current values of coupling variables that are received
    cost_send : list of floats
        A list of the current values of cost variables that should be sent
    cost_rec : list of floats
        A list of the current values of cost variables that are received
    command_send : list of floats
        A list of the current values of command variables that should be sent
    command_rec : list of floats
        A list of the current values of cost variablesare received
    cost_fac : list of floats
        The cost factors are essential to select which types of costs should
        be considered and how they should be weighted. The first element in the
        list is the cost related to the control effort. The second is the cost
        that is received from the dowmstream neighbor and the third is the cost
        due to deviations form the set point.
    last_opt : float
        Time when the last optimization was conducted
    last_read : float
        Time when the last measurement was taken
    last_write : float
        Time when the last command was sent
    commands : list of floats
        The possible commands of a subsystem
    inputs : list of floats
        The considered inputs of a subsystem
    fin_command : float
        The final command that results from the optimization
    traj_var : list of strings
        The variable in the subsystem that represents a trajectory that other
        subsystems should follow
    traj_points : list of floats
        Possible values of the trajectory variable considered in advance to
        calculate the cost of deviating from the ideal value
    """

    def __init__(self, sys_id):
        self.sys_id = sys_id
        print(sys_id)
        self.name = Init.name[sys_id]
        self.model_type = Init.model_type[sys_id]
        self.model = self.prepare_model()
        self.ups_neigh = Init.ups_neigh[sys_id]
        self.downs_neigh = Init.downs_neigh[sys_id]
        self.coup_vars_send = []
        self.coup_vars_rec = []
        self.cost_send = []
        self.cost_rec = []
        self.setpoint_rec = []
        self.setpoint_send = []
        self.setpoint_prev = []
        self.command_send = []
        self.command_rec = []
        self.err_prop = 0
        self.err_integ = 0
        self.err_prev = 0
        self.err_curr = 0
        self.err_diff = 0
        self.cost_fac = Init.cost_fac[sys_id]
        self.last_opt = 0
        self.last_read = 0
        self.last_write = 0
        self.commands = Init.commands[sys_id]
        self.inputs = Init.inputs[sys_id]
        self.fin_command = 0
        self.traj_var = Init.traj_var[sys_id]
        self.traj_points = Init.traj_points[sys_id]
        self.phase = 0

    def prepare_model(self):
        """Prepares the model of a subsystem according to the subsystem's model
        type.

        Parameters
        ----------

        Returns
        ----------
        model : Model
            The created model object
        """

        if self.model_type == "Modelica":
            model = Modeling.ModelicaMod(self.sys_id)
            model.translate()
        elif self.model_type == "Scikit":
            model = Modeling.SciMod(self.sys_id)
            model.load_mod()
        elif self.model_type == "Linear":
            model = Modeling.LinMod(self.sys_id)
        elif self.model_type == "const":
            model = Modeling.ConstMod(self.sys_id)
        else:
            model = Modeling.FuzMod(self.sys_id)
        return model

    def predict(self, inputs, commands):

        state_vars = []

        if self.model.states.state_var_names != []:
            for i,nam in enumerate(self.model.states.state_var_names):
                print("State variable names: " + str(nam))
                state_vars.append(System.Bexmoc.read_cont_sys(nam))

        if inputs != "external":
            if type(inputs) is not list:
                inputs = [inputs]

        self.model.states.inputs = inputs
        self.model.states.commands = commands
        self.model.predict()

        return self.model.states.outputs

    def optimize(self, interp):

        cur_time = Time.Time.get_time()

        if (cur_time - self.last_opt) >= self.model.times.opt_time:
            self.last_opt = cur_time

            self.interp_minimize(interp)

    def interp_minimize(self, interp):

        from scipy import interpolate as it

        print('minimizing')

        opt_costs = []
        opt_outputs =  []
        opt_command = []

        states = self.get_state_vars()
        if states != []:
            self.model.states.state_vars = states[0]

        if self.model.states.input_variables[0] != "external":
            if self.inputs == []:
                self.get_inputs()
                inputs = self.model.states.inputs[0]
            else:
                inputs = self.inputs
        else:
            if self.inputs == []:
                inputs = [-1.0]
            else:
                inputs = self.inputs


        for inp in inputs:

            outputs = []
            costs = []

            for com in self.commands:
                results = self.predict(inp, [com])
                outputs.append(results)
                costs.append(self.calc_cost(com, results[-1][-1]))

            min_ind = costs.index(min(costs))
            print("costs: " + str(costs))
            print("index: " + str(min_ind))

            opt_costs.append(costs[min_ind])
            temp = outputs[min_ind]
            opt_outputs.append(temp[0][-1])
            opt_command.append(self.commands[min_ind])

        if self.traj_var != []:
            #traj_costs = []
            traj = self.model.get_results(self.traj_var[0])
            self.setpoint_prev = self.setpoint_send
            self.setpoint_send = traj[10]

        else:

            if len(inputs) >= 2:
                if interp:
                    self.cost_send = it.interp1d(inputs, opt_costs,
                                               fill_value = "extrapolate")
                else:
                    self.cost_send = opt_costs

            else:
                self.cost_send = opt_costs[0]

        if len(inputs) >= 2:
            if interp:
                self.coup_vars_send = it.interp1d(inputs, opt_outputs,
                                             fill_value = "extrapolate")
                self.command_send = it.interp1d(inputs, opt_command,
                                             fill_value = "extrapolate")
            else:
                print("self.coup_vars_send: " + str(self.coup_vars_send))
                self.coup_vars_send = opt_outputs
                self.command_send = opt_command

        else:
            self.command_send = opt_command[0]
            
            if self.traj_var != []:
                self.command_send = self.setpoint_send
            else:
                self.coup_vars_send = opt_outputs[0]
            
    def calc_cost(self, command, outputs):
        import scipy.interpolate
        
        cost = 0
        
        #Langzeitsimulation: Abweichungen von der mittleren Temperatur müssen bestraft werden
        #if self.setpoint_send != []:
        cost += self.cost_fac[0]*(outputs - self.model.states.set_points[0])**2
        #else:
        #    cost += 0

        if self.setpoint_rec != []:
            setpoint = self.setpoint_rec
        else:
            setpoint = self.model.states.set_points[0]
     #   
#        if self.setpoint_rec != []:
#            self.
            
            #self.phase = self.setpoint_prev - self.setpoint_rec
            #
            #if > 0: field for heating the building, if < 0: field for cooling the building 
            
            
        #Regelung in Anlehnung an PID Regelverhalten
        #Proportionalanteil
        self.err_prop = outputs - setpoint                          #Deviation from setpoint (proportional & integral)
        
        #if self.phase > 0:#if field cools off
        if self.err_prop < 0:                                  
            cost += self.cost_fac[1]*(setpoint - outputs)              #Penalty Deviation (proportional)
        else:
            cost += self.cost_fac[2]*(setpoint - outputs)           #Reward Deviation (proportional)
        #else:#if field heats up, i.e. cooling demand
#        if self.err_prop > 0:
#            cost += self.cost_fac[1]*self.err_prop              #Penalty Deviation (proportional)
#        else:
#            cost += self.cost_fac[2]*(setpoint - outputs)           #Reward Deviation (proportional)
        
        #Integralteil
        self.err_integ += outputs - setpoint
        
        #if self.cost_rec != []:    
            #if self.phase > 0:                                      #if field cools off
        if self.err_integ < 0:
            cost += self.cost_fac[3] * (-(self.err_integ))       #Integral penalty
        else:
            cost += self.cost_fac[4] * self.err_integ       #Integral reward
#       else:
#            if self.err_integ > 0:
#                cost += self.cost_fac[3] * self.err_integ       #Integral penalization
#            else:
#                cost += self.cost_fac[4] * (-(self.err_integ))       #Integral reward
        #Differentialteil 
        self.err_prev = self.err_curr
        self.err_curr = outputs - setpoint              #same as proportional error
        self.err_diff = self.err_curr - self.err_prev        #differentieller Fehler
            
        #if self.phase > 0:#field cools off (heating demand building)
        if self.err_prop < 0:    
            if self.err_diff > 0:
                cost += self.cost_fac[6] * self.err_diff        #Differential penalization
            else:
                cost += self.cost_fac[5] * (-(self.err_diff))   #Differential reward
        else:
            if self.err_diff > 0:
                cost += self.cost_fac[5] * self.err_diff
            else:
                cost += self.cost_fac[6] * (-(self.err_diff))
            #else:#field heats up (cooling demand building)
#            if self.err_prop > 0:
#                if self.err_diff > 0:
#                    cost += self.cost_fac[5] * self.err_diff
#                else:
#                    cost += self.cost_fac[6] * (-(self.err_diff))
#            else:
#                if self.err_diff > 0:
#                    cost += self.cost_fac[6] * self.err_diff
#                else:
#                    cost += self.cost_fac[5] * (-(self.err_diff))
        
        if self.cost_rec != []:
            energy_heater = self.model.get_results("chemicalEnergy[-1]")
            cost += cost_fac[7] * energy_heater        #Realkosten Chiller/Heater
            energy_heatpump = self.model.get_results("heatPumpEnergy[-1]")
            cost += cost_fac[8] * energy_heatpump      #Realkosten Strom Wärmepumpe
        
        print(cost)
        return cost
    
    def interp(self, iter_real):
        import scipy.interpolate

        if iter_real == "iter":
            inp = self.coup_vars_rec
        else:
            inp = self.model.states.inputs

        if self.command_send != []:
            if type(self.command_send) is scipy.interpolate.interpolate.interp1d:
                self.fin_command = self.command_send(inp[0])
            else:
                self.fin_command = self.command_send
                print("Final command: " + str(self.fin_command))

        if self.coup_vars_send != []:
            if type(self.coup_vars_send) is scipy.interpolate.interpolate.interp1d:
                self.fin_coup_vars = self.coup_vars_send(inp[0])
            else:
                self.fin_coup_vars = self.coup_vars_send


    def get_inputs(self):

        cur_time = Time.Time.get_time()
        print("Time: " + str(cur_time))
        print("Sample time: " + str(self.model.times.samp_time))

        inputs = []
        print("Input variables: "+ str(self.model.states.input_variables))

        if self.model.states.input_variables is not None:
            for nam in self.model.states.input_names:
                print("check")
                inputs.append(System.Bexmoc.read_cont_sys(nam))
                print("Inputs" + str(inputs))

        self.model.states.inputs = inputs

    def get_state_vars(self):

        cur_time = Time.Time.get_time()

        states = []

        if self.model.states.state_var_names is not None:
            for nam in self.model.states.state_var_names:
                states.append(System.Bexmoc.read_cont_sys(nam))

        return states

    def send_commands(self):

        cur_time = Time.Time.get_time()

        if (cur_time - self.last_write) > self.model.times.samp_time:
            self.last_write = cur_time

            if self.model.states.command_names is not None:
                for nam in self.model.states.command_names:
                   System.Bexmoc.write_cont_sys(nam, self.fin_command)
