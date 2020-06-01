within ModelicaModels.SubsystemModels.DetailedModels;
package BaseClasses

  model Selector "Select from various signal sources"
    Modelica.Blocks.Routing.Extractor extractor(nin=2)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Step step
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.Blocks.Sources.Step step1
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    Modelica.Blocks.Interfaces.RealOutput y1
                 "Connector of Real output signal"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealInput u
      annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
    Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(u) +
          1)
      annotation (Placement(transformation(extent={{-48,-44},{-28,-24}})));
  equation
    connect(step.y, extractor.u[1]) annotation (Line(points={{-39,70},{-20,70},
            {-20,-1},{-12,-1}}, color={0,0,127}));
    connect(step1.y, extractor.u[2]) annotation (Line(points={{-39,30},{-30,30},
            {-30,1},{-12,1}}, color={0,0,127}));
    connect(extractor.y, y1)
      annotation (Line(points={{11,0},{100,0}}, color={0,0,127}));
    connect(integerExpression.y, extractor.index)
      annotation (Line(points={{-27,-34},{0,-34},{0,-12}}, color={255,127,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Selector;

  model RoomBaseClass

    replaceable package MediumAir = AixLib.Media.Air;
    replaceable package MediumWater = AixLib.Media.Water;

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)=100*1.2/3600;

    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
          MediumAir)
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
          MediumAir)
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    AixLib.Fluid.MixingVolumes.MixingVolume
                                        volume(
      T_start=295.15,
      redeclare package Medium = MediumAir,
      m_flow_nominal=m_flow_nominal,
      nPorts=2,
      V=60)      annotation (Placement(transformation(extent={{-8,0},{12,20}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
      annotation (Placement(transformation(extent={{0,50},{20,70}})));
    Modelica.Blocks.Interfaces.RealOutput T1
      "Absolute temperature as output signal"
      annotation (Placement(transformation(extent={{90,50},{110,70}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
      annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
    AixLib.Fluid.FixedResistances.PressureDrop res(
      redeclare package Medium = MediumAir,
      m_flow_nominal=300*1.2/3600,
      dp_nominal=50)
      annotation (Placement(transformation(extent={{42,-10},{62,10}})));
  equation
    connect(port_a, volume.ports[1])
      annotation (Line(points={{-100,0},{0,0}},  color={0,127,255}));
    connect(temperatureSensor.port, volume.heatPort) annotation (Line(points={{0,60},
            {-20,60},{-20,10},{-8,10}}, color={191,0,0}));
    connect(temperatureSensor.T, T1)
      annotation (Line(points={{20,60},{100,60}}, color={0,0,127}));
    connect(prescribedHeatFlow.port, volume.heatPort) annotation (Line(points={
            {-50,40},{-40,40},{-40,10},{-8,10}}, color={191,0,0}));
    connect(volume.ports[2], res.port_a)
      annotation (Line(points={{4,0},{42,0}}, color={0,127,255}));
    connect(res.port_b, port_b)
      annotation (Line(points={{62,0},{100,0}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end RoomBaseClass;

  model HallBaseClass "Simplified model of hall 1"
    replaceable package MediumAir = AixLib.Media.Air;
    replaceable package MediumWater = AixLib.Media.Water;

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)=8000*1.2/3600
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

    AixLib.Fluid.MixingVolumes.MixingVolume
                                        volume(
    redeclare package Medium = MediumAir,
      m_flow_nominal=m_flow_nominal,
      nPorts=2,
      T_start=295.15,
      V=36*10*10)
                 annotation (Placement(transformation(extent={{12,-14},{32,6}})));
    AixLib.Fluid.FixedResistances.PressureDrop res(redeclare package Medium = MediumAir,
    m_flow_nominal=m_flow_nominal,
        dp_nominal=200)
      annotation (Placement(transformation(extent={{54,-44},{74,-24}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor outdoorAirConductor(G=500)
                "Conducts heat from/to outdoor air"
      annotation (Placement(transformation(extent={{-50,-10},{-38,2}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature outdoorAir
      annotation (Placement(transformation(extent={{-78,-14},{-58,6}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
      annotation (Placement(transformation(extent={{-20,26},{0,46}})));
    Modelica.Blocks.Math.Gain SolarShare(k=100)
      "Share of the total radiation that is actually transported into the hall"
      annotation (Placement(transformation(extent={{-44,30},{-32,42}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor
                                    CCAConductor(G=24000)
      "Conducts heat from water to concrete"
      annotation (Placement(transformation(extent={{-48,-84},{-28,-64}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor concreteFloor(C=10^6, T(
          fixed=true, start=295.15))
      annotation (Placement(transformation(extent={{-18,-68},{2,-48}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor FloorConductor(G=500)
      "Conducts heat from floor to air"
      annotation (Placement(transformation(extent={{10,-82},{30,-62}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature SupplyWater
      "Supply water to concrete core activiation"
      annotation (Placement(transformation(extent={{-78,-84},{-58,-64}})));
    Modelica.Thermal.HeatTransfer.Celsius.ToKelvin waterTemperature
      annotation (Placement(transformation(extent={{-106,-30},{-94,-18}})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    Modelica.Blocks.Sources.CombiTimeTable weather(
      tableOnFile=true,
      extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
      columns={2},
      tableName="InputTable",
      fileName="weather.mat",
      smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Table with weather forecast" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-50})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
      supplyAirTemperature
      annotation (Placement(transformation(extent={{28,76},{48,96}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walls(C=10^7, T(
          fixed=true, start=295.15))
      annotation (Placement(transformation(extent={{54,52},{74,72}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor WallConductor(G=1000)
      "Conducts heat from floor to air"
      annotation (Placement(transformation(extent={{20,36},{40,56}})));
    Modelica.Fluid.Sources.MassFlowSource_T IntakeAirSource(
      m_flow=0.5,
      redeclare package Medium = MediumAir,
      X={0.03,0.97},
      T=30 + 273.15,
      use_T_in=true,
      use_m_flow_in=true,
      use_X_in=false,
      nPorts=1)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
      nPorts=1,
      redeclare package Medium = MediumAir,
      use_T_in=false,
      use_X_in=false,
      use_p_in=false,
      p(displayUnit="Pa") = 101300)
      annotation (Placement(transformation(extent={{100,-44},{80,-24}})));
    Modelica.Blocks.Sources.Constant AirVolumeFlow(k=8000)
      "Air volume flow rate, could be an initial value"
      annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
    Modelica.Blocks.Math.Gain V2m(k=1.2/3600) "Volume to mass flow"
      annotation (Placement(transformation(extent={{-126,34},{-114,46}})));
    AixLib.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = MediumAir,
        m_flow_nominal=1.2*8000/3600)
      annotation (Placement(transformation(extent={{-64,10},{-44,30}})));
    Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
      annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=90,
          origin={14,-42})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walls1(C=10^6, T(
          fixed=true, start=295.15))
      annotation (Placement(transformation(extent={{-40,4},{-20,24}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor outdoorAirConductor1(G=1000)
                "Conducts heat from/to outdoor air"
      annotation (Placement(transformation(extent={{-20,-10},{-8,2}})));
  equation
    connect(volume.ports[1], res.port_a) annotation (Line(points={{20,-14},{42,-14},
            {42,-34},{54,-34}},color={0,127,255}));
    connect(outdoorAirConductor.port_a, outdoorAir.port)
      annotation (Line(points={{-50,-4},{-58,-4}},
                                                 color={191,0,0}));
    connect(prescribedHeatFlow.port, volume.heatPort) annotation (Line(points={{0,36},{
            2,36},{2,-4},{12,-4}},         color={191,0,0}));
    connect(prescribedHeatFlow.Q_flow, SolarShare.y)
      annotation (Line(points={{-20,36},{-31.4,36}}, color={0,0,127}));
    connect(CCAConductor.port_b, concreteFloor.port)
      annotation (Line(points={{-28,-74},{-8,-74},{-8,-68}},   color={191,0,0}));
    connect(SupplyWater.port, CCAConductor.port_a)
      annotation (Line(points={{-58,-74},{-48,-74}}, color={191,0,0}));
    connect(concreteFloor.port, FloorConductor.port_a)
      annotation (Line(points={{-8,-68},{-8,-72},{10,-72}},    color={191,0,0}));
    connect(waterTemperature.Kelvin, SupplyWater.T) annotation (Line(points={{-93.4,
            -24},{-92,-24},{-92,-74},{-80,-74}},    color={0,0,127}));
    connect(supplyAirTemperature.port, volume.heatPort) annotation (Line(points={{28,86},
            {6,86},{6,-4},{12,-4}},               color={191,0,0}));
    connect(WallConductor.port_b,walls. port)
      annotation (Line(points={{40,46},{64,46},{64,52}}, color={191,0,0}));
    connect(WallConductor.port_a, volume.heatPort) annotation (Line(points={{20,46},
            {6,46},{6,-4},{12,-4}},           color={191,0,0}));
    connect(res.port_b,IntakeAirSink. ports[1]) annotation (Line(points={{74,-34},
            {80,-34}},                           color={0,127,255}));
    connect(AirVolumeFlow.y,V2m. u) annotation (Line(points={{-139,50},{-132,50},
            {-132,40},{-127.2,40}}, color={0,0,127}));
    connect(V2m.y, IntakeAirSource.m_flow_in) annotation (Line(points={{-113.4,40},
            {-108,40},{-108,28},{-100,28}}, color={0,0,127}));
    connect(weather.y[1], outdoorAir.T) annotation (Line(points={{-119,-50},{-86,-50},
            {-86,-4},{-80,-4}}, color={0,0,127}));
    connect(IntakeAirSource.ports[1], senTem.port_a)
      annotation (Line(points={{-80,20},{-64,20}}, color={0,127,255}));
    connect(senTem.port_b, volume.ports[2]) annotation (Line(points={{-44,20},{-10,
            20},{-10,-14},{24,-14}}, color={0,127,255}));
    connect(FloorConductor.port_b, heatFlowSensor.port_a) annotation (Line(
          points={{30,-72},{42,-72},{42,-56},{14,-56},{14,-50}}, color={191,0,0}));
    connect(heatFlowSensor.port_b, volume.heatPort) annotation (Line(points={{
            14,-34},{14,-20},{0,-20},{0,-4},{12,-4}}, color={191,0,0}));
    connect(outdoorAirConductor.port_b, walls1.port) annotation (Line(points={{
            -38,-4},{-34,-4},{-34,4},{-30,4}}, color={191,0,0}));
    connect(walls1.port, outdoorAirConductor1.port_a) annotation (Line(points={
            {-30,4},{-24,4},{-24,-4},{-20,-4}}, color={191,0,0}));
    connect(outdoorAirConductor1.port_b, volume.heatPort)
      annotation (Line(points={{-8,-4},{12,-4}}, color={191,0,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},
              {100,100}})),                                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}})),
      experiment(StopTime=3841200, Interval=10),
      __Dymola_experimentSetupOutput,
      __Dymola_experimentFlags(
        Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
        Evaluate=false,
        OutputCPUtime=false,
        OutputFlatModelica=false));
  end HallBaseClass;

  model ControllerBaseClass

    extends ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.RoomBaseClass;
    AixLib.Controls.Continuous.LimPID conPID(controllerType=Modelica.Blocks.Types.SimpleController.PI)
      annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
    Modelica.Blocks.Interfaces.RealInput u_s1
                  "Connector of setpoint input signal"
      annotation (Placement(transformation(extent={{-120,60},{-80,100}})));
  equation
    connect(conPID.u_s, u_s1)
      annotation (Line(points={{-62,80},{-100,80}}, color={0,0,127}));
    connect(conPID.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-39,
            80},{-26,80},{-26,100},{-80,100},{-80,40},{-70,40}}, color={0,0,127}));
    connect(temperatureSensor.T, conPID.u_m) annotation (Line(points={{20,60},{
            30,60},{30,40},{-40,40},{-40,60},{-50,60},{-50,68}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ControllerBaseClass;
end BaseClasses;
