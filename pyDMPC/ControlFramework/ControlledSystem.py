import Init

class PLCSys:

    def __init__(self):
        import pyads
        self.plc_typ = pyads.PLCTYPE_REAL
        self.ads_id = Init.ads_id
        self.ads_port = Init.ads_port

    def connect(self):
        import pyads
        self.contr_sys = pyads.Connection(self.ads_id, self.ads_port)
        self.contr_sys.open()

    def close(self):
        self.contr_sys.close()

    def read(self, datapoint):
        return self.contr_sys.read_by_name(datapoint, self.plc_typ)

    def write(self, datapoint, value):
        self.contr_sys.write_by_name(datapoint, value, self.plc_typ)

class ModelicaSys:

    def __init__(self):
        self.orig_fmu_path = Init.orig_fmu_path
        self.dest_fmu_path = Init.dest_fmu_path
        self.get_fmu()

    def get_fmu(self):

        import shutil
        from fmpy import read_model_description, extract
        from fmpy.fmi2 import FMU2Slave

        shutil.copyfile(self.orig_fmu_path, self.dest_fmu_path)

        # read the model description
        self.model_description = read_model_description(self.dest_fmu_path)

        # collect the value references
        self.vrs = {}
        for variable in self.model_description.modelVariables:
            self.vrs[variable.name] = variable.valueReference

        #print(variable)

        # extract the FMU
        self.unzipdir = extract(self.dest_fmu_path)

        self.contr_sys = FMU2Slave(guid=self.model_description.guid,
                unzipDirectory=self.unzipdir,
                modelIdentifier=
                self.model_description.coSimulation.modelIdentifier,
                instanceName='instance1')

        #print(self.contr_sys)

        self.contr_sys.instantiate()
        self.contr_sys.setupExperiment(startTime=0.0)
        self.contr_sys.enterInitializationMode()
        self.contr_sys.exitInitializationMode()

    def read(self, datapoint):
        name = self.vrs[datapoint]
        value = self.contr_sys.getReal([name])
        #print(value)
        return value

    def write(self, datapoint, value):
        name = self.vrs[datapoint]
        self.contr_sys.setReal([name], [value])

    def proceed(self, cur_time, incr):
        #print("Time: " + str(cur_time))
        #print("Increment: " + str(incr))
        self.contr_sys.doStep(currentCommunicationPoint = cur_time,
                               communicationStepSize = incr)

    def close(self):
        import shutil
        self.contr_sys.terminate()
        self.contr_sys.freeInstance()
        shutil.rmtree(self.unzipdir)

class API:

    def __init__(self):
        self.auth = Init.auth
        self.project_id = Init.project_id
        self.base_url = Init.base_url

    def read(self, dataPointID):

        import datetime
        import requests
                
        params = {'project_id': self.project_id,
                'dataPointID': dataPointID,
                'end': datetime.datetime.now(),
                'max' : 1,
                'short': False}

        r = requests.get(f"{self.base_url}/timeseries", auth = self.auth, params=params)

        val = (r.json())
        val = val["data"]
        val = val[0]
        val = val["value"]

        print(f"{dataPointID}: {val}")

        return [val]
        
    def write(self, dataPointID, val):

        import requests

        print(f"{dataPointID}: {val}")
        
        params = {'dataPointID': dataPointID,
                'project_id': self.project_id,
                'value' : val,
                'priority': 13,
                'acked' : False,
                'dryrun': False}

        requests.post(f"{self.base_url}/setpoint", auth = self.auth, params = params)
