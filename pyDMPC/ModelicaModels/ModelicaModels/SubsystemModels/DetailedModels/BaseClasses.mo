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
      nPorts=1,
      V=26*10*10,
      T_start=295.15)
                 annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
    AixLib.Fluid.FixedResistances.PressureDrop res(redeclare package Medium = MediumAir,
    m_flow_nominal=m_flow_nominal,
        dp_nominal=200)
      annotation (Placement(transformation(extent={{132,-120},{152,-100}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor outdoorAirConductor(G=500)
                "Conducts heat from/to outdoor air"
      annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature outdoorAir
      annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
      annotation (Placement(transformation(extent={{58,-50},{78,-30}})));
    Modelica.Blocks.Math.Gain SolarShare(k=100)
      "Share of the total radiation that is actually transported into the hall"
      annotation (Placement(transformation(extent={{34,-46},{46,-34}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor
                                    CCAConductor(G=24000)
      "Conducts heat from water to concrete"
      annotation (Placement(transformation(extent={{30,-160},{50,-140}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor concreteFloor(C=
          100000000, T(fixed=true, start=295.15))
      annotation (Placement(transformation(extent={{60,-144},{80,-124}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor FloorConductor(G=1000)
      "Conducts heat from floor to air"
      annotation (Placement(transformation(extent={{88,-158},{108,-138}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature SupplyWater
      "Supply water to concrete core activiation"
      annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
    Modelica.Thermal.HeatTransfer.Celsius.ToKelvin waterTemperature
      annotation (Placement(transformation(extent={{-28,-106},{-16,-94}})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{-100,158},{-80,178}})));
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
        origin={-90,-70})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
      supplyAirTemperature
      annotation (Placement(transformation(extent={{78,-22},{98,-2}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walls(C=1000000000,
        T(fixed=true, start=295.15))
      annotation (Placement(transformation(extent={{132,-24},{152,-4}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor WallConductor(G=1000)
      "Conducts heat from floor to air"
      annotation (Placement(transformation(extent={{98,-40},{118,-20}})));
  equation
    connect(volume.ports[1], res.port_a) annotation (Line(points={{100,-90},{120,-90},
            {120,-110},{132,-110}},
                               color={0,127,255}));
    connect(outdoorAirConductor.port_b, volume.heatPort)
      annotation (Line(points={{50,-80},{90,-80}},
                                                 color={191,0,0}));
    connect(outdoorAirConductor.port_a, outdoorAir.port)
      annotation (Line(points={{30,-80},{20,-80}},
                                                 color={191,0,0}));
    connect(prescribedHeatFlow.port, volume.heatPort) annotation (Line(points={{78,-40},
            {80,-40},{80,-80},{90,-80}},   color={191,0,0}));
    connect(prescribedHeatFlow.Q_flow, SolarShare.y)
      annotation (Line(points={{58,-40},{46.6,-40}}, color={0,0,127}));
    connect(CCAConductor.port_b, concreteFloor.port)
      annotation (Line(points={{50,-150},{70,-150},{70,-144}}, color={191,0,0}));
    connect(SupplyWater.port, CCAConductor.port_a)
      annotation (Line(points={{20,-150},{30,-150}}, color={191,0,0}));
    connect(concreteFloor.port, FloorConductor.port_a)
      annotation (Line(points={{70,-144},{70,-148},{88,-148}}, color={191,0,0}));
    connect(FloorConductor.port_b, volume.heatPort) annotation (Line(points={{108,
            -148},{120,-148},{120,-132},{92,-132},{92,-96},{78,-96},{78,-80},{90,-80}},
                                                                            color=
           {191,0,0}));
    connect(waterTemperature.Kelvin, SupplyWater.T) annotation (Line(points={{-15.4,
            -100},{-14,-100},{-14,-150},{-2,-150}}, color={0,0,127}));
    connect(supplyAirTemperature.port, volume.heatPort) annotation (Line(points=
           {{78,-12},{54,-12},{54,-80},{90,-80}}, color={191,0,0}));
    connect(WallConductor.port_b,walls. port)
      annotation (Line(points={{118,-30},{142,-30},{142,-24}},
                                                         color={191,0,0}));
    connect(WallConductor.port_a, volume.heatPort) annotation (Line(points={{98,
            -30},{84,-30},{84,-80},{90,-80}}, color={191,0,0}));
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
