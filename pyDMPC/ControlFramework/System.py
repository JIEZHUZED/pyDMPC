import Subsystem
import ControlledSystem
import Modeling
import Init
import Time

class System:
    """This class represents the overall control system that creates the agents
    that are assigned to the subsystems.

    Parameters
    ----------

    Class attributes
    ----------
    contr_sys : ControlledSystem
        The controlled system object
    contr_sys_typ : string
        The type of the controlled system

    Attributes
    ----------
    wkdir : string
        The current work directory
    amo_subsys : int
        The total amount of subsystems
    subsystems : Subsystem objects
        The subsystem control agents
    sys_time : float
        The current time of the system

    """

    contr_sys = None
    contr_sys_typ = Init.contr_sys_typ

    def __init__(self):
        self.wkdir = Init.glob_res_path + "\\" + Init.name_wkdir
        self.prep_mod()
        self.prep_wkdir()
        self.amo_subsys = len(Init.sys_id)
        self.subsystems = self.gen_subsys()
        self.sys_time = Time.Time()

    def prep_wkdir(self):
        """Prepares the working directory for the current experiment
        """

        import os
        os.mkdir(self.wkdir)
        os.chdir(self.wkdir)

    def gen_subsys(self):
        """Generates the subsystems/agent.

        Parameters
        ----------

        Returns
        ----------
        subsystems : list of Subsystem objects
            The created subsystem objects
        """
        import os
        subsystems = []

        for i in range(self.amo_subsys):
            subsystems.append(Subsystem.Subsystem(i))

        for sys in subsystems:
            os.mkdir(self.wkdir + "\\" + sys.name)

        return subsystems

    def prep_mod(self):
        """Checks if the model type of any of the subsystems is Modelica and
        in that case establishes the Dymola environment.
        """

        for i,typ in enumerate(Init.model_type):
            if typ == "Modelica":
                Modeling.ModelicaMod.make_dymola()
                print('Dymola established')
                break

    def close_mod(self):
        """Checks if the model type of any of the subsystems is Modelica and
        in that case destroys the Dymola environment.
        """
        for i,typ in enumerate(Init.model_type):
            if typ == "Modelica":
                Modeling.ModelicaMod.del_dymola()
                break

    def find_times(self):
        """ This method finds the minimum sample rate and the minimum
        optimization interval of all subsystems

        Returns
        ----------
        subsystems : list of floats
            The found minimum optimization and sampling times of all subsystems
        """

        opt_inter = []
        samp_inter = []

        for i,sub in enumerate(self.subsystems):
            opt_inter.append(sub.model.times.opt_time)
            samp_inter.append(sub.model.times.samp_time)

        min_opt_inter = min(opt_inter)
        min_samp_inter = min(samp_inter)

        return [min_opt_inter, min_samp_inter]


    @classmethod
    def prep_cont_sys(cls):
        """Creates a controlled system object, which is either a Modelica
        simulation or a pyads PLC object
        """
        if cls.contr_sys_typ == "PLC":
            cls.contr_sys = ControlledSystem.PLCSys()
        elif cls.contr_sys_typ == "Modelica":
            cls.contr_sys = ControlledSystem.ModelicaSys()

    @classmethod
    def close_cont_sys(cls):
        """Terminates the Modelica simulation or closes the connection to the
        pyads PLC, respectively.
        """
        if cls.contr_sys_typ == "PLC":
            cls.contr_sys.close()
        if cls.contr_sys_typ == "Modelica":
            cls.contr_sys.close()

    @classmethod
    def read_cont_sys(cls, datapoint):
        """ This method reads the value of a certain data point in the
        controlled system.

        Parameters
        ----------
        datapoint : string
            The considered data point identifier

        Returns
        ----------
        value : float
            The the value of the data point
        """

        return cls.contr_sys.read(datapoint)

    @classmethod
    def write_cont_sys(cls, datapoint, value):
        """ This method writes a value of a certain data point in the
        controlled system.

        Parameters
        ----------
        datapoint : string
            The considered data point identifier

        value : float
            The the value of the data point to be written
        """

        #print("datapoint: " + str(datapoint))
        #print("value: " + str(value))
        cls.contr_sys.write(datapoint, value)

    @classmethod
    def proceed(cls, cur_time, incr):
        """ This method makes a step in the controlled system if it is a
        Modelica simulation

        Parameters
        ----------
        cur_time : float
            The ccurrent time

        incr : The time increment = step size
        """

        if cls.contr_sys_typ == "Modelica":
            cls.contr_sys.proceed(cur_time, incr)

    def broadcast(self, sys_list = None):
        """ This method broadcasts the values of relevant variables among
        neighboring subsystems/agents.

        """
        if sys_list == None:
            sys_list = range(len(self.subsystems))

        for i in sys_list:
            if self.subsystems[i].ups_neigh is not None:
                cost = [self.subsystems[i].cost_send]
                if self.subsystems[i].par_neigh is not None:
                    for j in self.subsystems[i].par_neigh:
                        cost.append(self.subsystems[j].cost_send)
                else:
                    j = 0

                self.subsystems[self.subsystems[i].ups_neigh].cost_rec = cost

            else:
                j = 0

            if self.subsystems[i].downs_neigh is not None:
                for k in self.subsystems[i].downs_neigh:
                    #print(k)
                    #print(self.subsystems[k])
                    self.subsystems[k].coup_vars_rec = self.subsystems[i].coup_vars_send
                    #print(f"{self.subsystems[k].name}: #{self.subsystems[k].coup_vars_rec}")

            i += j



class Bexmoc(System):

    def __init__(self):
        super().__init__()
        self.ma_process = False

    def initialize(self):
        for i,sub in enumerate(self.subsystems):
            if Bexmoc.contr_sys_typ == "Modelica":
                sub.get_inputs()
        self.inpt = 293
        self.prev_inpt = 290


    def execute(self):
        import time

        for i in range(len(self.subsystems)):
            if i == 0:
                if self.ma_process == False:
                    self.subsystems[i].optimize(interp=True)
            else:
                self.subsystems[i].optimize(interp=True)
            if self.subsystems[i].par_neigh is not None:
                for j in self.subsystems[i].par_neigh:
                    self.subsystems[j].optimize(interp=True)
                self.broadcast([i] + self.subsystems[i].par_neigh)
            else:
                #print(f"Broadcasting: {i}")
                self.broadcast([i])
                
        for i,sub in enumerate(self.subsystems):
            sub.get_inputs()
            cur_time = Time.Time.get_time()
            if i == 0:
                if cur_time != 0:
                    if self.ma_process == False and abs(self.prev_outputs[0][-1] - self.outputs[0][-1])/max(self.prev_outputs[0][-1], 0.001) > 0.001:
                        sub.interp(iter_real = "real")
                else:
                    sub.interp(iter_real = "real")   
            else:
                sub.interp(iter_real = "real")
    
            if i == 0:
                self.inpt = self.read_cont_sys("coolerTemperature.T")
                self.inpt = self.inpt[0]
                #print(self.inpt)
    
                cur_time = Time.Time.get_time()
                
                if cur_time == 0:
                    #prev_prediction = self.subsystems[0].fin_coup_vars[0]
                    self.outputs = self.subsystems[0].get_outputs()
                    self.prev_command = self.subsystems[0].fin_command
                    self.prev_outputs = self.outputs
        
        
                if (self.ma_process and 
                    abs(self.prev_outputs[0][-1] - 
                    self.outputs[0][-1])/max(self.prev_outputs[0][-1], 0.001) 
                    < 0.001 and cur_time != 0):
                    
                    self.dif = self.outputs[0] - self.output_model_1[-1]
                    #print(f"self.dif: {self.dif[-1]}")
                    grad_plant = (self.outputs[0][-1] - self.prev_outputs[0][-1])/(self.command_2 - self.command_1)
    
                    #print(f"grad_plant: {grad_plant}")
    
                    grad_model = (self.output_model_2[0][-1] - self.output_model_1) /(self.command_2 - self.command_1)
    
                    #print(f"grad_model: {grad_model[-1]}")
    
                    dif_grad = grad_plant - grad_model
    
                    
    
                    print(f"self.dif: {self.dif[-1]}")
    
                    #print(self.output_model_1)
    
                    self.output_model_1 = self.output_model_1[0][-1] + self.dif[-1]
                    
                    print(f"dif_grad: {dif_grad[-1][-1]}")
                    
                    #print(f"self.command_1: {self.command_1}")
                    print(f"self.output_model_1: {self.output_model_1}")
    
    
                    cost_1 = self.subsystems[0].calc_cost(self.command_1, self.output_model_1)
    
                    print(f"cost_1: {cost_1}")
    
                    self.command_3 = min(100, self.command_2 * 1.05)
                    self.output_model_3 = self.subsystems[0].predict(self.subsystems[0].model.states.inputs, self.command_3)
                    self.output_model_3 = self.output_model_3[0][-1] + self.dif[-1] - dif_grad[-1][-1] * (self.command_3 - self.command_1)
                    print(f"self.output_model_3: {self.output_model_3}")
    
                    #print(f"self.output_model_3: {self.output_model_3}")
    
                    cost_2 = self.subsystems[0].calc_cost(self.command_3, self.output_model_3[-1])
                    
                    #print(f"self.command_3: {self.command_3}")
                    #print(f"self.output_model_3: {self.output_model_3}")
                    print(f"cost_2: {cost_2}")
    
    
                    if cost_2 < cost_1:
                        self.subsystems[0].fin_command = self.command_3
                    else:
                        self.subsystems[0].fin_command = self.command_2/1.05
                        
                    #self.subsystems[0].send_commands()
    
                    #print(f"self.subsystems[0].fin_command: {self.subsystems[0].fin_command}")
                    
                    
                    
    
                    #self.ma_process = False
                    self.prev_outputs = self.outputs
    
                self.command_1 = self.subsystems[0].fin_command
    
                #print(f"self.prev_outputs: {self.prev_outputs[0][-1]}")
    
                #print(f"self.outputs: {self.outputs[0][-1]}")
    
               # test = abs(self.prev_outputs[0][-1] - self.outputs[0][-1])/max(self.prev_outputs[0][-1], 0.001)
    

    
                if (abs(self.prev_outputs[0][-1] - 
                        self.outputs[0][-1])/max(self.prev_outputs[0][-1], 0.001) < 0.001 
                        and self.ma_process == False 
                        and abs(self.command_1 - self.prev_command)<0.1 
                        and cur_time != 0):
                    self.subsystems[0].fin_command = self.subsystems[0].fin_command * 1.05
                    self.command_2 = self.subsystems[0].fin_command
                    self.subsystems[0].send_commands()
                    self.output_model_1 = self.subsystems[0].predict(self.subsystems[0].model.states.inputs, self.command_1)
                    self.output_model_2 = self.subsystems[0].predict(self.subsystems[0].model.states.inputs, self.command_2)
                    
                    self.ma_process = True
    
                else:
                    self.ma_process = False
                    self.outputs = self.subsystems[0].get_outputs()
                    self.prev_outputs = self.outputs
                    
            print(self.command_1)
            print(self.prev_command)
            print(self.ma_process)
            time.sleep(2)
            sub.send_commands()
            self.prev_command = self.subsystems[0].fin_command
            

        if Bexmoc.contr_sys_typ == "Modelica":
            cur_time = Time.Time.get_time()

            Bexmoc.proceed(cur_time, Time.Time.time_incr)
            tim = Time.Time.set_time()
            #print("Time: " + str(tim))

    def iterate(self):
        import time
        for i,sub in enumerate(self.subsystems):
            print(sub.name)

            sub.get_inputs()
            inputs = sub.model.states.inputs[0]

            if i == 1:
                sub.inputs = [inputs[0] - 0.1, inputs[0] + 0.1]
            else:
                sub.inputs = [inputs[0], sub.model.states.set_points[0]]

            sub.inputs.sort()
            #print(sub.inputs)
            #time.sleep(2)
            sub.optimize(interp = True)
            #sub.interp(iter_real = "iter")
            self.broadcast([i])


        for ino in range(0,8,1):
            for i,sub in enumerate(self.subsystems):
                if i == 1:
                    sub.get_inputs()
                    #print(f"Measurement: {sub.model.states.inputs[0]}")
                    #time.sleep(2)
                    inputs = sub.model.states.inputs[0]
                    sub.inputs = [inputs[0] - 0.1, inputs[0] + 0.1]

                else:
                    #print(sub.coup_vars_rec)
                    if sub.coup_vars_rec != []:
                        #print(f"Coupling: {sub.coup_vars_rec[0]}")
                        if (self.subsystems[1].inputs[0] <
                            self.subsystems[1].model.states.set_points[0]):
                            sub.inputs = [min(sub.coup_vars_rec[0],               sub.model.states.set_points[0] - 0.5), sub.model.states.set_points[0]]
                        else:
                            sub.inputs = [max(sub.coup_vars_rec[1],
                                        sub.model.states.set_points[0] + 0.5), sub.model.states.set_points[0]]

                sub.inputs.sort()
                print(f"{sub.name}: {sub.inputs}")

                sub.optimize(interp = True)
                #sub.interp(iter_real = "iter")
                #print(f"{sub.name}: {sub.command_send}")

                self.broadcast([i])


        for i,sub in enumerate(self.subsystems):
            sub.interp(iter_real = "iter")
            sub.send_commands()
            #print(f"{sub.name}: {sub.fin_command}")
            #time.sleep(2)

        if Bexmoc.contr_sys_typ == "Modelica":
            cur_time = Time.Time.get_time()

            Bexmoc.proceed(cur_time, Time.Time.time_incr)
            tim = Time.Time.set_time()
            #print("Time: " + str(tim))

    def terminate(self):
        Bexmoc.close_cont_sys()
