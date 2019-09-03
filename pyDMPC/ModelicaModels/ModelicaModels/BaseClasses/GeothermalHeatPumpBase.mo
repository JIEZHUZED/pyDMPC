within ModelicaModels.BaseClasses;
partial model GeothermalHeatPumpBase
  "Base class of the geothermal heat pump system"

  replaceable package Water = AixLib.Media.Water
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
    redeclare package Medium = Water,
    tablePower=[0,266.15,275.15,280.15,283.15,293.15; 308.15,3300,3400,3500,
        3700,3800; 323.15,4500,4400,4600,5000,5100],
    tableHeatFlowCondenser=[0,266.16,275.15,280.15,283.15,293.15; 308.15,
        9700,11600,13000,14800,16300; 323.15,10000,11200,12900,16700,17500])
    "Base load energy conversion unit"
    annotation (Placement(transformation(extent={{-40,-14},{-4,20}})));

    replaceable AixLib.Fluid.Interfaces.PartialTwoPortTransport PeakLoadDevice(
      redeclare package Medium = Water)                                       constrainedby
    AixLib.Fluid.Interfaces.PartialTwoPort
    annotation (Placement(transformation(extent={{86,-56},{98,-44}})));

  AixLib.Fluid.Storage.Storage coldStorage(
    layer_HE(T_start=T_start_cold),
    layer(T_start=T_start_cold),
    redeclare package Medium = Water,
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
    redeclare package Medium = Water,
    m_flow_nominal=0.5,
    dp_nominal=15000) "Resistance in evaporator circuit" annotation (
      Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=180,
        origin={-34,38})));
  AixLib.Fluid.FixedResistances.PressureDrop resistanceGeothermalSource(
    redeclare package Medium = Water,
    m_flow_nominal=0.5,
    dp_nominal=15000) "Resistance in geothermal field circuit" annotation (
      Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=0,
        origin={-70,-54})));
  AixLib.Fluid.FixedResistances.PressureDrop resistanceColdConsumerFlow(
    redeclare package Medium = Water,
    m_flow_nominal=0.2,
    dp_nominal=10000) "Resistance in cold consumer flow line" annotation (
      Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={73,-20})));
  AixLib.Fluid.Actuators.Valves.TwoWayQuickOpening valveHeatSink(
    redeclare package Medium = Water,
    m_flow_nominal=0.5,
    dpValve_nominal=5000)
    "Valve connecting geothermal field to the condenser of the heat pump"
    annotation (Placement(transformation(extent={{-36,-61},{-24,-47}})));
  AixLib.Fluid.Actuators.Valves.TwoWayQuickOpening valveHeatSource(
    redeclare package Medium = Water,
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
    redeclare package Medium = Water,
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
    redeclare package Medium = Water,
    m_flow_nominal=0.5,
    dp_nominal=15000) "Resistance in condenser circuit" annotation (
      Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=90,
        origin={-18,-78})));
  AixLib.Fluid.Sources.Boundary_pT geothField_sink1(redeclare package Medium =
        Water, nPorts=3) "One of two sinks representing geothermal field"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-150,30})));
  AixLib.Fluid.FixedResistances.PressureDrop resistanceHeatConsumerFlow(
    redeclare package Medium = Water,
    m_flow_nominal=0.2,
    dp_nominal=10000) "Resistance in heat consumer flow line" annotation (
      Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={73,-50})));
  AixLib.Fluid.Actuators.Valves.TwoWayQuickOpening valveColdStorage(
    redeclare package Medium = Water,
    m_flow_nominal=0.5,
    dpValve_nominal=5000)
    "Valve connecting cold storage to the evaporator of the heat pump"
    annotation (Placement(transformation(
        extent={{-6,7},{6,-7}},
        rotation=180,
        origin={-52,38})));
  AixLib.Fluid.Actuators.Valves.TwoWayQuickOpening valveHeatStorage(
    redeclare package Medium = Water,
    m_flow_nominal=0.5,
    dpValve_nominal=5000)
    "Valve connecting heat storage to the condenser of the heat pump"
    annotation (Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=90,
        origin={-18,-63})));

  AixLib.Fluid.Movers.FlowControlled_dp pumpColdConsumer(
    m_flow_nominal=0.05,
    redeclare package Medium = Water,
    addPowerToMedium=false,
    T_start=T_start_cold[1])
    "Pump moving fluid from storage tank to cold consumers"
    annotation (Placement(transformation(extent={{48,-27},{62,-13}})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpHeatConsumer(
    m_flow_nominal=0.05,
    redeclare package Medium = Water,
    addPowerToMedium=false,
    T_start=T_start_warm[5])
    "Pump moving fluid from storage tank to heat consumers"
    annotation (Placement(transformation(extent={{48,-57},{62,-43}})));
  AixLib.Fluid.FixedResistances.PressureDrop resistanceColdConsumerReturn(
    redeclare package Medium = Water,
    m_flow_nominal=0.2,
    dp_nominal=10000) "Resistance in cold consumer return line" annotation (
     Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={73,32})));
  AixLib.Fluid.FixedResistances.PressureDrop resistanceHeatConsumerReturn(
    redeclare package Medium = Water,
    m_flow_nominal=0.2,
    dp_nominal=10000) "Resistance in heat consumer return line" annotation (
     Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={93,-106})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpCondenser(
    m_flow_nominal=0.05,
    redeclare package Medium = Water,
    addPowerToMedium=false,
    T_start=T_start_cold[1])
    "Pump moving fluid from storage tank to condenser of heat pump"
                             annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={-1,-98})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpEvaporator(
    m_flow_nominal=0.05,
    redeclare package Medium = Water,
    addPowerToMedium=false,
    T_start=T_start_cold[1])
    "Pump moving fluid from storage tank to evaporator of heat pump"
                             annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={7,36})));
  AixLib.Fluid.Movers.FlowControlled_dp pumpGeothermalSource(
    m_flow_nominal=0.05,
    redeclare package Medium = Water,
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
  AixLib.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_small=50,
    p_start=100000,
    m_flow_nominal=16,
    V=2,
    nPorts=2)                    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={96,30})));
  AixLib.Fluid.MixingVolumes.MixingVolume vol2(
    redeclare package Medium = Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_small=50,
    p_start=100000,
    m_flow_nominal=16,
    V=2,
    nPorts=2)                    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={116,-54})));
  AixLib.Fluid.Geothermal.Borefields.TwoUTubes
            borFie(redeclare package Medium = Water,
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
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-150,-6})));
  AixLib.Fluid.Sensors.TemperatureTwoPort supplyTemSensor(redeclare package
      Medium = Water, m_flow_nominal=16) annotation (Placement(transformation(
        extent={{-7,8},{7,-8}},
        rotation=0,
        origin={-115,-54})));
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
      Line(points={{38,-8},{38,-20},{48,-20}},           color={0,127,255}));
  connect(pumpColdConsumer.port_b, resistanceColdConsumerFlow.port_a)
    annotation (Line(points={{62,-20},{66,-20}}, color={0,127,255}));
  connect(pumpHeatConsumer.port_b, resistanceHeatConsumerFlow.port_a)
    annotation (Line(points={{62,-50},{66,-50}}, color={0,127,255}));
  connect(valveHeatSource.port_b, heatPumpTab.port_a_source) annotation (Line(
        points={{-60,7},{-60,14.9},{-38.2,14.9}}, color={0,127,255}));
  connect(valveColdStorage.port_b, heatPumpTab.port_a_source) annotation (Line(
        points={{-58,38},{-62,38},{-62,14.9},{-38.2,14.9}}, color={0,127,255}));
  connect(valveHeatSink.port_b, heatPumpTab.port_a_sink) annotation (Line(
        points={{-24,-54},{-16,-54},{-5.8,-54},{-5.8,-8.9}}, color={0,127,255}));
  connect(valveHeatStorage.port_b, heatPumpTab.port_a_sink) annotation (Line(
        points={{-18,-57},{-18,-54},{-5.8,-54},{-5.8,-8.9}}, color={0,127,255}));
  connect(heatPumpTab.port_b_sink, geothField_sink1.ports[1]) annotation (Line(
        points={{-5.8,14.9},{2,14.9},{2,24},{-148.4,24}},
                                                        color={0,127,255}));
  connect(heatStorage.port_a_heatGenerator, heatPumpTab.port_b_sink)
    annotation (Line(points={{26.24,-63.68},{10,-63.68},{10,14.9},{-5.8,
          14.9}},
        color={0,127,255}));
  connect(heatStorage.port_b_consumer, pumpHeatConsumer.port_a) annotation (
      Line(points={{38,-62},{38,-50},{48,-50}},          color={0,127,255}));
  connect(resistanceColdConsumerReturn.port_b, coldStorage.port_b_consumer)
    annotation (Line(points={{66,32},{38,32},{38,20}}, color={0,127,255}));
  connect(resistanceHeatConsumerReturn.port_b, heatStorage.port_a_consumer)
    annotation (Line(points={{86,-106},{38,-106},{38,-90}},           color={0,127,
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
     Line(points={{80,-50},{86,-50}},            color={0,127,255}));
  connect(geothField_sink1.ports[2], returnTemSensor.port_b) annotation (
      Line(points={{-150,24},{-138,24},{-138,18},{-114,18}},     color={0,
          127,255}));
  connect(returnTemSensor.port_a, heatPumpTab.port_b_source) annotation (
      Line(points={{-100,18},{-76,18},{-76,-8.9},{-38.2,-8.9}}, color={0,
          127,255}));
  connect(resistanceColdConsumerFlow.port_b, vol1.ports[1])
    annotation (Line(points={{80,-20},{86,-20},{86,28}}, color={0,127,255}));
  connect(vol1.ports[2], resistanceColdConsumerReturn.port_a)
    annotation (Line(points={{86,32},{80,32}}, color={0,127,255}));
  connect(PeakLoadDevice.port_b, vol2.ports[1]) annotation (Line(points={{98,
          -50},{106,-50},{106,-52}}, color={0,127,255}));
  connect(resistanceHeatConsumerReturn.port_a, vol2.ports[2]) annotation (Line(
        points={{100,-106},{106,-106},{106,-56}}, color={0,127,255}));
  connect(geothField_sink1.ports[3], borFie.port_a) annotation (Line(points={{-151.6,
          24},{-150,24},{-150,4}}, color={0,127,255}));
  connect(supplyTemSensor.port_b, pumpGeothermalSource.port_a)
    annotation (Line(points={{-108,-54},{-96,-54}}, color={0,127,255}));
  connect(borFie.port_b, supplyTemSensor.port_a) annotation (Line(points={{-150,
          -16},{-150,-54},{-122,-54}}, color={0,127,255}));
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
</html>", revisions="<html>
<ul>
<li>
May 19, 2017, by Marc Baranski:<br/>
First implementation.
</li>
</ul>
</html>"));
end GeothermalHeatPumpBase;
