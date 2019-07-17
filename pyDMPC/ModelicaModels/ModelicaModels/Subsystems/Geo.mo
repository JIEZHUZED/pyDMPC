within ModelicaModels.Subsystems;
package Geo
  package BaseClasses
    model BuildingBaseClass "Simplified building model"

      replaceable package Water = AixLib.Media.Water;

      parameter ModelicaModels.DataBase.Geo.GeoRecord baseParam
      "The basic paramters";

      AixLib.Fluid.MixingVolumes.MixingVolume vol1(redeclare package Medium =
            Water,
        energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
        m_flow_small=50,
        p_start=100000,
        m_flow_nominal=16,
        V=2,
        nPorts=2)                    annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={24,42})));
      Modelica.Blocks.Math.Product product1
        annotation (Placement(transformation(extent={{-34,-66},{-14,-46}})));
      Modelica.Blocks.Sources.Constant const(k=-10000)
        annotation (Placement(transformation(extent={{-92,-90},{-72,-70}})));
      AixLib.Fluid.FixedResistances.PressureDrop res(
        m_flow_nominal=16,
        dp_nominal(displayUnit="bar") = 100000,
        redeclare package Medium = Water)
            "total resistance" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={48,32})));
      AixLib.Fluid.Sources.MassFlowSource_T boundary(
        redeclare package Medium = Water,
        use_T_in=true,
        nPorts=1,
        m_flow=baseParam.m_flow_tot)
                  annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
      AixLib.Fluid.Sources.Boundary_pT bou(
      redeclare package Medium = Water,
      nPorts=1) annotation (Placement(
            transformation(
            extent={{-10,-11},{10,11}},
            rotation=180,
            origin={90,-1})));
      AixLib.Fluid.Sensors.TemperatureTwoPort senTem(
      redeclare package Medium = Water, m_flow_nominal=16)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=270,
            origin={70,18})));
      Modelica.Blocks.Interfaces.RealOutput returnTemperature
        "Temperature of the passing fluid"
        annotation (Placement(transformation(extent={{82,50},{102,70}})));
    equation
      connect(vol1.ports[1], res.port_a)
        annotation (Line(points={{22,32},{38,32}}, color={0,127,255}));
      connect(res.port_b, senTem.port_a)
        annotation (Line(points={{58,32},{70,32},{70,28}},
                                                   color={0,127,255}));
      connect(senTem.port_b, bou.ports[1]) annotation (Line(points={{70,8},{70,-1},{
              80,-1}},          color={0,127,255}));
      connect(senTem.T, returnTemperature)
        annotation (Line(points={{81,18},{81,60},{92,60}}, color={0,0,127}));
      connect(boundary.ports[1], vol1.ports[2]) annotation (Line(points={{-60,0},{-52,
              0},{-52,32},{26,32}}, color={0,127,255}));
      connect(const.y, product1.u2) annotation (Line(points={{-71,-80},{-52,-80},{-52,
              -62},{-36,-62}}, color={0,0,127}));
    end BuildingBaseClass;

    model FieldBaseClass "Simplified model of geothermal field"

     replaceable package Water = AixLib.Media.Water;

      parameter ModelicaModels.DataBase.Geo.GeoRecord baseParam
      "The basic paramters";

      AixLib.Fluid.MixingVolumes.MixingVolume vol1(
        redeclare package Medium = Water,
        energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
        m_flow_small=50,
        nPorts=3,
        p_start=100000,
        m_flow_nominal=16,
        V=2)                         annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={30,42})));
      AixLib.Fluid.Movers.FlowControlled_m_flow pump(
          nominalValuesDefineDefaultPressureCurve=true,
          redeclare package Medium = Water,
        m_flow_nominal=baseParam.m_flow_tot,
        inputType=AixLib.Fluid.Types.InputType.Constant,
        constantMassFlowRate=baseParam.m_flow_tot)
                                            "Main geothermal pump"
        annotation (Placement(transformation(extent={{46,-10},{66,10}})));
      AixLib.Fluid.FixedResistances.PressureDrop res(m_flow_nominal=16, dp_nominal(
            displayUnit="bar") = 100000, redeclare package Medium = Water)
            "total resistance" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={66,32})));
      Modelica.Fluid.Sources.Boundary_pT pressurePoint(
        redeclare package Medium = Water,
        use_T_in=false,
        use_X_in=false,
        use_p_in=false,
        p(displayUnit="Pa") = 101300,
        nPorts=1)
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=270,
            origin={42,-34})));
      AixLib.Fluid.Sensors.Temperature supplyTemperature(T(start=285), redeclare
          package Medium = Water) "Temperature of supply water"
        annotation (Placement(transformation(extent={{82,34},{102,54}})));
      AixLib.Fluid.Sensors.MassFlowRate massFlow(redeclare package Medium =
            Water)
        annotation (Placement(transformation(extent={{6,-6},{-6,6}},
            rotation=270,
            origin={80,12})));
      AixLib.Fluid.Sensors.Temperature returnTemperature(redeclare package Medium =
            Water, T(start=285.15)) "Temperature of supply water"
        annotation (Placement(transformation(extent={{44,-78},{64,-58}})));
      AixLib.Fluid.MixingVolumes.MixingVolume vol(
        redeclare package Medium = Water,
        m_flow_small=50,
        nPorts=2,
        V=9000,
        p_start=150000,
        T_start=285.15,
        m_flow_nominal=16)              annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-8,-2})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=285.15)
        annotation (Placement(transformation(
            extent={{-6,-6},{6,6}},
            rotation=90,
            origin={-24,-62})));
      Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=50)
        annotation (Placement(transformation(
            extent={{-6,-6},{6,6}},
            rotation=90,
            origin={-24,-34})));
      Modelica.Blocks.Math.ContinuousMean continuousMeanTemperature
        annotation (Placement(transformation(extent={{84,-76},{100,-60}})));
      Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin
        annotation (Placement(transformation(extent={{66,-74},{78,-62}})));
    equation
      connect(res.port_b, vol1.ports[1])
        annotation (Line(points={{56,32},{27.3333,32}},
                                                  color={0,127,255}));
      connect(pressurePoint.ports[1], pump.port_a)
        annotation (Line(points={{42,-24},{42,0},{46,0}}, color={0,127,255}));
      connect(pump.port_b, massFlow.port_a)
        annotation (Line(points={{66,0},{80,0},{80,6}}, color={0,127,255}));
      connect(massFlow.port_b, res.port_a)
        annotation (Line(points={{80,18},{80,32},{76,32}}, color={0,127,255}));
      connect(supplyTemperature.port, pump.port_b)
        annotation (Line(points={{92,34},{92,0},{66,0}}, color={0,127,255}));
      connect(thermalConductor.port_b, vol.heatPort)
        annotation (Line(points={{-24,-28},{-24,-2},{-18,-2}}, color={191,0,0}));
      connect(fixedTemperature.port, thermalConductor.port_a)
        annotation (Line(points={{-24,-56},{-24,-40}}, color={191,0,0}));
      connect(vol.ports[1], pump.port_a) annotation (Line(points={{-10,-12},{20,
              -12},{20,0},{46,0}},
                              color={0,127,255}));
      connect(vol1.ports[2], vol.ports[2]) annotation (Line(points={{30,32},{-40,32},
              {-40,-12},{-6,-12}}, color={0,127,255}));
      connect(vol1.ports[3], returnTemperature.port) annotation (Line(points={{32.6667,
              32},{-40,32},{-40,-80},{54,-80},{54,-78}},         color={0,127,255}));
      connect(returnTemperature.T, fromKelvin.Kelvin)
        annotation (Line(points={{61,-68},{64.8,-68}}, color={0,0,127}));
      connect(continuousMeanTemperature.u, fromKelvin.Celsius)
        annotation (Line(points={{82.4,-68},{78.6,-68}}, color={0,0,127}));
      annotation (experiment(StopTime=94608000, Interval=86400),
          __Dymola_experimentSetupOutput);
    end FieldBaseClass;

    model FieldBaseClass2 "Simplified model of geothermal field"

       replaceable package Water = AixLib.Media.Water;
       replaceable package Dowcal10 =
          AixLib.Media.Antifreeze.PropyleneGlycolWater (                           property_T=293.15, X_a=0.36);
        parameter ModelicaModels.DataBase.Geo.GeoRecord baseParam   "The basic paramters";
      parameter ModelicaModels.DataBase.Geo.borFieDat borFieDat;

      AixLib.Fluid.MixingVolumes.MixingVolume vol1(
        redeclare package Medium = Dowcal10,
        energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
        m_flow_small=50,
        nPorts=3,
        m_flow_nominal=16,
        V=2,
        p_start=100000,
        T_start=285.15)              annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={30,42})));
      AixLib.Fluid.Movers.FlowControlled_m_flow pump(
          nominalValuesDefineDefaultPressureCurve=true,
          redeclare package Medium = Dowcal10,
        m_flow_nominal=baseParam.m_flow_tot,
        inputType=AixLib.Fluid.Types.InputType.Constant,
        constantMassFlowRate=baseParam.m_flow_tot)
                                            "Main geothermal pump"
        annotation (Placement(transformation(extent={{46,-10},{66,10}})));
      AixLib.Fluid.FixedResistances.PressureDrop res(m_flow_nominal=16, dp_nominal(
            displayUnit="bar") = 100000, redeclare package Medium = Dowcal10)
            "total resistance" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={66,32})));
      Modelica.Fluid.Sources.Boundary_pT pressurePoint(
        redeclare package Medium = Dowcal10,
        use_T_in=false,
        use_X_in=false,
        use_p_in=false,
        p(displayUnit="Pa") = 101300,
        nPorts=1)
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=270,
            origin={42,-34})));
      AixLib.Fluid.Sensors.Temperature supplyTemperature(T(start=285), redeclare
          package Medium = Dowcal10) "Temperature of supply water"
        annotation (Placement(transformation(extent={{82,34},{102,54}})));
      AixLib.Fluid.Sensors.MassFlowRate massFlow(redeclare package Medium =
            Dowcal10)
        annotation (Placement(transformation(extent={{6,-6},{-6,6}},
            rotation=270,
            origin={80,16})));
      AixLib.Fluid.Sensors.Temperature returnTemperature(redeclare package Medium =
            Dowcal10, T(start=285.15)) "Temperature of supply water"
        annotation (Placement(transformation(extent={{44,-78},{64,-58}})));
      AixLib.Fluid.Geothermal.Borefields.TwoUTubes
                borFie(redeclare package Medium = Dowcal10,
        tLoaAgg=21600,
        borFieDat(
          filDat(
            kFil=2,
            cFil=800,
            dFil=1600),
          conDat(
            borCon=AixLib.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,

            mBor_flow_nominal=0.4,
            mBorFie_flow_nominal=16,
            dp_nominal=50000,
            hBor=100,
            rBor=0.076,
            dBor=100,
            cooBor=[6.02,49.93; 15.08,51.43; 24.14,49.93; 33.2,49.93; 42.26,
                49.93; 51.25,49.93; 60.32,49.93; 22.98,41.07; 10.65,35.27;
                22.91,32; 6.08,27.5; 15.15,27.5; 22.98,14; 35.58,6.77; 44.65,
                6.77; 53.64,6.77; 62.63,6.77; 71.69,6.77; 80.75,6.77; 89.75,
                6.77; 98.81,6.77; 107.8,6.77; 115.5,11.48; 106.58,16.32; 91.04,
                16.32; 98.81,20.82; 114.41,20.82; 106.64,25.32; 91.04,25.39;
                98.81,29.96; 114.41,29.82; 106.64,34.45; 98.81,38.95; 114.41,
                38.89; 91.04,43.52; 106.58,43.52; 98.81,48.02; 114.41,47.95;
                78.3,49.93; 69.31,49.93],
            rTub=0.016,
            kTub=0.38,
            eTub=0.0029,
            xC=0.048),
          soiDat(
            dSoi=2700,
            kSoi=3.85,
            cSoi=18)),
        TExt0_start=285.65)
        annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
      Modelica.Blocks.Math.ContinuousMean continuousMeanTemperature
        annotation (Placement(transformation(extent={{84,-76},{100,-60}})));
      Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin
        annotation (Placement(transformation(extent={{66,-74},{78,-62}})));
    equation
      connect(res.port_b, vol1.ports[1])
        annotation (Line(points={{56,32},{27.3333,32}},
                                                  color={0,127,255}));
      connect(pump.port_b, massFlow.port_a)
        annotation (Line(points={{66,0},{80,0},{80,10}},color={0,127,255}));
      connect(massFlow.port_b, res.port_a)
        annotation (Line(points={{80,22},{80,32},{76,32}}, color={0,127,255}));
      connect(supplyTemperature.port, pump.port_b)
        annotation (Line(points={{92,34},{92,0},{66,0}}, color={0,127,255}));
      connect(borFie.port_b, pump.port_a)
        annotation (Line(points={{0,0},{46,0}}, color={0,127,255}));
      connect(borFie.port_a, vol1.ports[2]) annotation (Line(points={{-20,0},{
              -40,0},{-40,32},{30,32}}, color={0,127,255}));
      connect(returnTemperature.port, vol1.ports[3]) annotation (Line(points={{
              54,-78},{54,-80},{-40,-80},{-40,32},{32.6667,32}}, color={0,127,
              255}));
      connect(continuousMeanTemperature.u, fromKelvin.Celsius)
        annotation (Line(points={{82.4,-68},{78.6,-68}}, color={0,0,127}));
      connect(fromKelvin.Kelvin, returnTemperature.T)
        annotation (Line(points={{64.8,-68},{61,-68}}, color={0,0,127}));
      connect(pressurePoint.ports[1], pump.port_a)
        annotation (Line(points={{42,-24},{42,0},{46,0}}, color={0,127,255}));
      annotation (experiment(StopTime=94608000, Interval=86400),
          __Dymola_experimentSetupOutput);
    end FieldBaseClass2;

    partial model GeothermalHeatPumpControlledBase
      "Example of a geothermal heat pump system with controllers"
      extends
        ModelicaModels.Subsystems.Geo.BaseClasses.GeothermalHeatPumpBase;
      Modelica.Blocks.Sources.RealExpression getTStorageUpper(y=heatStorage.layer[
            heatStorage.n].T) "Gets the temperature of upper heat storage layer"
        annotation (Placement(transformation(extent={{-160,64},{-140,84}})));
      Modelica.Blocks.Sources.RealExpression getTStorageLower(y=coldStorage.layer[1].T)
        "Gets the temperature of lower cold storage layer"
        annotation (Placement(transformation(extent={{-160,42},{-140,62}})));
      Modelica.Blocks.Interfaces.RealOutput coldStorageTemperature(
        final quantity="ThermodynamicTemperature",
        final unit="K",
        displayUnit="degC",
        min=0,
        start=T_start_cold[1]) "Temperature in the cold storage" annotation (
          Placement(transformation(
            origin={-60,80},
            extent={{-10,-10},{10,10}},
            rotation=90), iconTransformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-100,-110})));
      Modelica.Blocks.Interfaces.RealOutput heatStorageTemperature(
        final quantity="ThermodynamicTemperature",
        final unit="K",
        displayUnit="degC",
        min=0,
        start=T_start_warm[heatStorage.n]) "Temperature in the heat storage"
        annotation (Placement(transformation(
            origin={-80,80},
            extent={{-10,-10},{10,10}},
            rotation=90), iconTransformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-140,-110})));
      Modelica.Blocks.Interfaces.RealOutput chemicalEnergyFlowRate(final unit="W")
        "Flow of primary (chemical) energy into boiler " annotation (Placement(
            transformation(
            extent={{-10,10},{10,-10}},
            rotation=270,
            origin={-61.5,-119.5}), iconTransformation(extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-20.5,-109})));
      Modelica.Blocks.Interfaces.RealOutput heatPumpPower(final unit="W")
        "Electrical power of the heat pump" annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=270,
            origin={-39.5,-119.5}), iconTransformation(extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-60.5,-109})));
      inner Modelica.Fluid.System system
        annotation (Placement(transformation(extent={{140,60},{160,80}})));
      Modelica.Blocks.Logical.LessEqualThreshold    lessEqualThreshold
        annotation (Placement(transformation(extent={{160,12},{140,32}})));
      Modelica.Blocks.Logical.Switch switch1
        annotation (Placement(transformation(extent={{152,-30},{132,-10}})));
      Modelica.Blocks.Math.Gain negate(k=-1) "negate" annotation (Placement(
            transformation(
            extent={{6,-6},{-6,6}},
            rotation=0,
            origin={118,-20})));
      Modelica.Blocks.Sources.CombiTimeTable variation(
        fileName="../../Geo_long/variation.mat",
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
        tableName="tab1",
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
        tableOnFile=false,
        table=[0,10000; 2635200,12000; 5270400,9000; 7905600,3000; 10540800,-5000;
            13176000,-12000; 15811200,-12000; 18446400,-13000; 21081600,-5000;
            23716800,4000; 26352000,8000; 28987200,12000; 31622400,10000; 34257600,
            12000; 36892800,9000; 39528000,3000; 42163200,-5000; 44798400,-12000;
            47433600,-12000; 50068800,-13000; 52704000,-5000; 55339200,4000;
            57974400,8000; 60609600,12000; 63244800,10000; 65880000,12000; 68515200,
            9000; 71150400,3000; 73785600,-5000; 76420800,-12000; 79056000,-12000;
            81691200,-13000; 84326400,-5000; 86961600,4000; 89596800,8000; 92232000,
            12000],
        columns={2}) "Table with control input" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-150,-10})));
      Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
        table=[0.0,0.0],
        columns={2},
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
        annotation (Placement(transformation(extent={{136,-116},{156,-96}})));
      Modelica.Blocks.Interfaces.RealOutput returnTemperature(
        final quantity="ThermodynamicTemperature",
        final unit="K",
        displayUnit="degC",
        min=0,
        start=T_start_cold[1]) "Temperature in the cold storage" annotation (
          Placement(transformation(
            origin={-144,-120},
            extent={{10,-10},{-10,10}},
            rotation=90), iconTransformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-100,-110})));
    equation
      connect(heatPumpTab.Power, heatPumpPower) annotation (Line(points={{-22,
              -12.3},{-22,-40},{-39.5,-40},{-39.5,-119.5}},      color={0,0,127}));
      connect(getTStorageLower.y, coldStorageTemperature) annotation (Line(points={{-139,52},
              {-60,52},{-60,80}},               color={0,0,127}));
      connect(getTStorageUpper.y, heatStorageTemperature) annotation (Line(points={{-139,74},
              {-122,74},{-122,60},{-80,60},{-80,80}},
            color={0,0,127}));
      connect(returnTemSensor.T, returnTemperature) annotation (Line(points={{
              -107,9.2},{-107,-94},{-144,-94},{-144,-120}}, color={0,0,127}));
      connect(boundary.T_in, variation.y[1]) annotation (Line(points={{-153.6,
              -50.8},{-153.6,-28},{-128,-28},{-128,-10},{-139,-10}}, color={0,0,
              127}));
      annotation (experiment(StopTime=86400, Interval=10), Documentation(info="<html>
<p>Base class of an example demonstrating the use of a heat pump connected to two storages and a geothermal source. A replaceable model is connected in the flow line of the heating circuit. A peak load device can be added here.  This model also includes basic controllers.</p>
</html>",     revisions="<html>
<ul>
<li>
May 19, 2017, by Marc Baranski:<br/>
First implementation.
</li>
</ul>
</html>"));
    end GeothermalHeatPumpControlledBase;

    partial model GeothermalHeatPumpBase
      "Base class of the geothermal heat pump system"

      replaceable package Medium = AixLib.Media.Water
        "Medium model used for hydronic components";

      parameter Modelica.SIunits.Temperature T_start_cold[5] = 300*ones(5)
        "Initial temperature of cold components";

      parameter Modelica.SIunits.Temperature T_start_warm[5] = 300*ones(5)
        "Initial temperature of warm components";

      parameter Modelica.SIunits.Temperature T_start_hot = 300
        "Initial temperature of high temperature components";

      AixLib.Fluid.HeatPumps.HeatPumpSimple heatPumpTab(
        volumeEvaporator(T_start=T_start_cold[1]),
        volumeCondenser(T_start=T_start_warm[5]),
        redeclare package Medium = Medium,
        tablePower=[0,266.15,275.15,280.15,283.15,293.15; 308.15,3300,3400,3500,
            3700,3800; 323.15,4500,4400,4600,5000,5100],
        tableHeatFlowCondenser=[0,266.16,275.15,280.15,283.15,293.15; 308.15,
            9700,11600,13000,14800,16300; 323.15,10000,11200,12900,16700,17500])
        "Base load energy conversion unit"
        annotation (Placement(transformation(extent={{-40,-14},{-4,20}})));

        replaceable AixLib.Fluid.Interfaces.PartialTwoPortTransport PeakLoadDevice(
          redeclare package Medium = Medium)                                       constrainedby
        AixLib.Fluid.Interfaces.PartialTwoPort
        annotation (Placement(transformation(extent={{108,-56},{120,-44}})));

      AixLib.Fluid.Storage.Storage coldStorage(
        layer_HE(T_start=T_start_cold),
        layer(T_start=T_start_cold),
        redeclare package Medium = Medium,
        n=5,
        lambda_ins=0.075,
        s_ins=0.2,
        alpha_in=100,
        alpha_out=10,
        k_HE=300,
        h=1.5,
        V_HE=0.02,
        A_HE=7,
        d=1) "Storage tank for buffering cold demand"
        annotation (Placement(transformation(extent={{52,-8},{24,20}})));
      AixLib.Fluid.FixedResistances.PressureDrop resistanceColdStorage(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        dp_nominal=15000) "Resistance in evaporator circuit" annotation (
          Placement(transformation(
            extent={{-6,-7},{6,7}},
            rotation=180,
            origin={-34,38})));
      AixLib.Fluid.Sources.Boundary_pT geothFieldSource(
        redeclare package Medium = Medium,
        T=284.15,
        nPorts=2) "Source representing geothermal field"
        annotation (Placement(transformation(extent={{-6,-6},{6,6}},
            rotation=-90,
            origin={-110,-48})));
      AixLib.Fluid.FixedResistances.PressureDrop resistanceGeothermalSource(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        dp_nominal=15000) "Resistance in geothermal field circuit" annotation (
          Placement(transformation(
            extent={{-6,-7},{6,7}},
            rotation=0,
            origin={-70,-54})));
      AixLib.Fluid.FixedResistances.PressureDrop resistanceColdConsumerFlow(
        redeclare package Medium = Medium,
        m_flow_nominal=0.2,
        dp_nominal=10000) "Resistance in cold consumer flow line" annotation (
          Placement(transformation(
            extent={{-7,-7},{7,7}},
            rotation=0,
            origin={87,-20})));
      AixLib.Fluid.Actuators.Valves.TwoWayQuickOpening valveHeatSink(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        dpValve_nominal=5000)
        "Valve connecting geothermal field to the condenser of the heat pump"
        annotation (Placement(transformation(extent={{-36,-61},{-24,-47}})));
      AixLib.Fluid.Actuators.Valves.TwoWayQuickOpening valveHeatSource(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        dpValve_nominal=5000)
        "Valve connecting geothermal field to the evaporator of the heat pump"
        annotation (Placement(transformation(
            extent={{-6,-7},{6,7}},
            rotation=90,
            origin={-60,1})));
      AixLib.Fluid.Storage.Storage heatStorage(
        layer_HE(T_start=T_start_warm),
        layer(T_start=T_start_warm),
        redeclare package Medium = Medium,
        n=5,
        lambda_ins=0.075,
        s_ins=0.2,
        alpha_in=100,
        alpha_out=10,
        k_HE=300,
        A_HE=3,
        h=1,
        V_HE=0.01,
        d=1) "Storage tank for buffering heat demand"
        annotation (Placement(transformation(extent={{52,-90},{24,-62}})));
      AixLib.Fluid.FixedResistances.PressureDrop resistanceHeatStorage(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        dp_nominal=15000) "Resistance in condenser circuit" annotation (
          Placement(transformation(
            extent={{-6,-7},{6,7}},
            rotation=90,
            origin={-18,-78})));
      AixLib.Fluid.Sources.Boundary_pT geothField_sink1(redeclare package
          Medium =
            Medium, nPorts=2) "One of two sinks representing geothermal field"
        annotation (Placement(transformation(extent={{-158,20},{-146,32}})));
      AixLib.Fluid.FixedResistances.PressureDrop resistanceHeatConsumerFlow(
        redeclare package Medium = Medium,
        m_flow_nominal=0.2,
        dp_nominal=10000) "Resistance in heat consumer flow line" annotation (
          Placement(transformation(
            extent={{-7,-7},{7,7}},
            rotation=0,
            origin={87,-50})));
      AixLib.Fluid.Actuators.Valves.TwoWayQuickOpening valveColdStorage(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        dpValve_nominal=5000)
        "Valve connecting cold storage to the evaporator of the heat pump"
        annotation (Placement(transformation(
            extent={{-6,7},{6,-7}},
            rotation=180,
            origin={-52,38})));
      AixLib.Fluid.Actuators.Valves.TwoWayQuickOpening valveHeatStorage(
        redeclare package Medium = Medium,
        m_flow_nominal=0.5,
        dpValve_nominal=5000)
        "Valve connecting heat storage to the condenser of the heat pump"
        annotation (Placement(transformation(
            extent={{-6,-7},{6,7}},
            rotation=90,
            origin={-18,-63})));

      AixLib.Fluid.Movers.FlowControlled_dp pumpColdConsumer(
        m_flow_nominal=0.05,
        redeclare package Medium = Medium,
        addPowerToMedium=false,
        T_start=T_start_cold[1])
        "Pump moving fluid from storage tank to cold consumers"
        annotation (Placement(transformation(extent={{58,-27},{72,-13}})));
      AixLib.Fluid.Movers.FlowControlled_dp pumpHeatConsumer(
        m_flow_nominal=0.05,
        redeclare package Medium = Medium,
        addPowerToMedium=false,
        T_start=T_start_warm[5])
        "Pump moving fluid from storage tank to heat consumers"
        annotation (Placement(transformation(extent={{58,-57},{72,-43}})));
      AixLib.Fluid.FixedResistances.PressureDrop resistanceColdConsumerReturn(
        redeclare package Medium = Medium,
        m_flow_nominal=0.2,
        dp_nominal=10000) "Resistance in cold consumer return line" annotation
        (Placement(transformation(
            extent={{-7,-7},{7,7}},
            rotation=180,
            origin={87,32})));
      AixLib.Fluid.FixedResistances.PressureDrop resistanceHeatConsumerReturn(
        redeclare package Medium = Medium,
        m_flow_nominal=0.2,
        dp_nominal=10000) "Resistance in heat consumer return line" annotation
        (Placement(transformation(
            extent={{-7,-7},{7,7}},
            rotation=180,
            origin={87,-106})));
      AixLib.Fluid.Movers.FlowControlled_dp pumpCondenser(
        m_flow_nominal=0.05,
        redeclare package Medium = Medium,
        addPowerToMedium=false,
        T_start=T_start_cold[1])
        "Pump moving fluid from storage tank to condenser of heat pump"
                                 annotation (Placement(transformation(
            extent={{-7,7},{7,-7}},
            rotation=180,
            origin={-1,-98})));
      AixLib.Fluid.Movers.FlowControlled_dp pumpEvaporator(
        m_flow_nominal=0.05,
        redeclare package Medium = Medium,
        addPowerToMedium=false,
        T_start=T_start_cold[1])
        "Pump moving fluid from storage tank to evaporator of heat pump"
                                 annotation (Placement(transformation(
            extent={{-7,7},{7,-7}},
            rotation=180,
            origin={7,36})));
      AixLib.Fluid.Movers.FlowControlled_dp pumpGeothermalSource(
        m_flow_nominal=0.05,
        redeclare package Medium = Medium,
        addPowerToMedium=false,
        T_start=T_start_cold[1])
        "Pump moving fluid from geothermal source into system" annotation (
          Placement(transformation(
            extent={{-7,-7},{7,7}},
            rotation=0,
            origin={-89,-54})));
      AixLib.Controls.Interfaces.HeatPumpControlBus heatPumpControlBus
        annotation (Placement(transformation(extent={{-21,60},{20,98}})));
      AixLib.Fluid.Sensors.TemperatureTwoPort returnTemSensor(redeclare package
          Medium = Water, m_flow_nominal=16) annotation (Placement(
            transformation(
            extent={{7,8},{-7,-8}},
            rotation=0,
            origin={-107,18})));
      AixLib.Fluid.Sources.MassFlowSource_T boundary(
        redeclare package Medium = Water,
        use_T_in=true,
        nPorts=1,
        m_flow=baseParam.m_flow_tot)
                  annotation (Placement(transformation(extent={{-152,-62},{-136,
                -46}})));
    equation

      connect(resistanceGeothermalSource.port_b, valveHeatSink.port_a) annotation (
          Line(
          points={{-64,-54},{-36,-54}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(valveHeatSource.port_a, valveHeatSink.port_a) annotation (Line(
          points={{-60,-5},{-60,-54},{-36,-54}},
          color={0,127,255},
          smooth=Smooth.None));

      connect(resistanceColdStorage.port_b, valveColdStorage.port_a) annotation (
          Line(
          points={{-40,38},{-46,38}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(resistanceHeatStorage.port_b, valveHeatStorage.port_a) annotation (
          Line(
          points={{-18,-72},{-18,-69}},
          color={0,127,255},
          smooth=Smooth.None));

      connect(coldStorage.port_a_consumer, pumpColdConsumer.port_a) annotation (
          Line(points={{38,-8},{38,-20},{58,-20}},           color={0,127,255}));
      connect(pumpColdConsumer.port_b, resistanceColdConsumerFlow.port_a)
        annotation (Line(points={{72,-20},{80,-20}}, color={0,127,255}));
      connect(pumpHeatConsumer.port_b, resistanceHeatConsumerFlow.port_a)
        annotation (Line(points={{72,-50},{80,-50}}, color={0,127,255}));
      connect(valveHeatSource.port_b, heatPumpTab.port_a_source) annotation (Line(
            points={{-60,7},{-60,14.9},{-38.2,14.9}}, color={0,127,255}));
      connect(valveColdStorage.port_b, heatPumpTab.port_a_source) annotation (Line(
            points={{-58,38},{-62,38},{-62,14.9},{-38.2,14.9}}, color={0,127,255}));
      connect(valveHeatSink.port_b, heatPumpTab.port_a_sink) annotation (Line(
            points={{-24,-54},{-16,-54},{-5.8,-54},{-5.8,-8.9}}, color={0,127,255}));
      connect(valveHeatStorage.port_b, heatPumpTab.port_a_sink) annotation (Line(
            points={{-18,-57},{-18,-54},{-5.8,-54},{-5.8,-8.9}}, color={0,127,255}));
      connect(heatPumpTab.port_b_sink, geothField_sink1.ports[1]) annotation (Line(
            points={{-5.8,14.9},{2,14.9},{2,27.2},{-146,27.2}},
                                                            color={0,127,255}));
      connect(heatStorage.port_a_heatGenerator, heatPumpTab.port_b_sink)
        annotation (Line(points={{26.24,-63.68},{10,-63.68},{10,14.9},{-5.8,
              14.9}},
            color={0,127,255}));
      connect(heatStorage.port_b_consumer, pumpHeatConsumer.port_a) annotation (
          Line(points={{38,-62},{38,-50},{58,-50}},          color={0,127,255}));
      connect(resistanceColdConsumerReturn.port_b, coldStorage.port_b_consumer)
        annotation (Line(points={{80,32},{38,32},{38,20}}, color={0,127,255}));
      connect(resistanceHeatConsumerReturn.port_b, heatStorage.port_a_consumer)
        annotation (Line(points={{80,-106},{38,-106},{38,-90}},           color={0,127,
              255}));
      connect(heatPumpTab.port_b_source, coldStorage.port_b_heatGenerator)
        annotation (Line(points={{-38.2,-8.9},{-38.2,-24},{18,-24},{18,-5.2},{
              26.24,-5.2}},
                       color={0,127,255}));
      connect(pumpEvaporator.port_b, resistanceColdStorage.port_a) annotation (Line(
            points={{-8.88178e-016,36},{-8.88178e-016,38},{-28,38}}, color={0,127,255}));
      connect(coldStorage.port_a_heatGenerator, pumpEvaporator.port_a) annotation (
          Line(points={{26.24,18.32},{20,18.32},{20,36},{14,36}}, color={0,127,255}));
      connect(heatStorage.port_b_heatGenerator, pumpCondenser.port_a) annotation (
          Line(points={{26.24,-87.2},{16,-87.2},{16,-98},{6,-98}}, color={0,127,255}));
      connect(pumpCondenser.port_b, resistanceHeatStorage.port_a) annotation (Line(
            points={{-8,-98},{-18,-98},{-18,-84}}, color={0,127,255}));
      connect(pumpGeothermalSource.port_b, resistanceGeothermalSource.port_a)
        annotation (Line(points={{-82,-54},{-79,-54},{-76,-54}}, color={0,127,255}));
      connect(heatPumpTab.OnOff, heatPumpControlBus.onOff) annotation (Line(points={
              {-22,16.6},{-22,16.6},{-22,60},{-0.3975,60},{-0.3975,79.095}}, color={
              255,0,255}), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(resistanceHeatConsumerFlow.port_b, PeakLoadDevice.port_a) annotation (
         Line(points={{94,-50},{102,-50},{108,-50}}, color={0,127,255}));
      connect(geothField_sink1.ports[2], returnTemSensor.port_b) annotation (
          Line(points={{-146,24.8},{-138,24.8},{-138,18},{-114,18}}, color={0,
              127,255}));
      connect(returnTemSensor.port_a, heatPumpTab.port_b_source) annotation (
          Line(points={{-100,18},{-76,18},{-76,-8.9},{-38.2,-8.9}}, color={0,
              127,255}));
      connect(boundary.ports[1], geothFieldSource.ports[1])
        annotation (Line(points={{-136,-54},{-108.8,-54}}, color={0,127,255}));
      connect(pumpGeothermalSource.port_a, geothFieldSource.ports[2])
        annotation (Line(points={{-96,-54},{-111.2,-54}}, color={0,127,255}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
              -120},{160,80}})),              Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-160,-120},{160,80}})),
        experiment(StopTime=3600, Interval=10),
        __Dymola_experimentSetupOutput(
          states=false,
          derivatives=false,
          inputs=false,
          auxiliaries=false),
        Documentation(info="<html>
<p>Base class of an example demonstrating the use of a heat pump connected to
two storages and a geothermal source. A replaceable model is connected in the
flow line of the heating circuit. A peak load device can be added here. </p>
</html>",     revisions="<html>
<ul>
<li>
May 19, 2017, by Marc Baranski:<br/>
First implementation.
</li>
</ul>
</html>"));
    end GeothermalHeatPumpBase;
  end BaseClasses;
end Geo;
