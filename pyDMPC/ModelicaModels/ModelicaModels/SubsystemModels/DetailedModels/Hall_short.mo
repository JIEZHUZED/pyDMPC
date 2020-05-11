within ModelicaModels.SubsystemModels.DetailedModels;
model Hall_short
  extends
    ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass(
      weather(fileName="../weather.mat"), volume(nPorts=2));

  Modelica.Blocks.Sources.CombiTimeTable variation(
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableOnFile=false,
    table=[0.0,0.0],
    columns={2})                    "Table with control input"
                                                            annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,18})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin hallTemperature1
    annotation (Placement(transformation(extent={{-128,12},{-116,24}})));
  Modelica.Blocks.Sources.Constant currentWaterTemperature(k=22)
    "Can be an iniitial value"
    annotation (Placement(transformation(extent={{-88,-110},{-68,-90}})));
  Modelica.Blocks.Sources.Constant solar(k=0)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
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
  Modelica.Blocks.Sources.Constant AirVolumeFlow(k=8000)
    "Air volume flow rate, could be an initial value"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Modelica.Blocks.Math.Gain V2m(k=1.2/3600) "Volume to mass flow"
    annotation (Placement(transformation(extent={{-126,34},{-114,46}})));
  Modelica.Fluid.Sources.Boundary_pT IntakeAirSink(
    nPorts=1,
    redeclare package Medium = MediumAir,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300)
    annotation (Placement(transformation(extent={{190,2},{170,22}})));
  Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
    tableOnFile=false,
    table=[0.0,0.0],
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2},
    fileName="decisionVariables.mat")
    "Table with decision variables"              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-110})));
equation
  connect(variation.y[1], hallTemperature1.Celsius)
    annotation (Line(points={{-139,18},{-129.2,18}}, color={0,0,127}));
  connect(IntakeAirSource.T_in, hallTemperature1.Kelvin) annotation (Line(
        points={{-102,24},{-108,24},{-108,18},{-115.4,18}}, color={0,0,127}));
  connect(waterTemperature.Celsius, currentWaterTemperature.y)
    annotation (Line(points={{-29.2,-100},{-67,-100}}, color={0,0,127}));
  connect(solar.y, SolarShare.u)
    annotation (Line(points={{21,-40},{32.8,-40}}, color={0,0,127}));
  connect(AirVolumeFlow.y,V2m. u) annotation (Line(points={{-139,50},{-132,50},
          {-132,40},{-127.2,40}}, color={0,0,127}));
  connect(V2m.y,IntakeAirSource. m_flow_in) annotation (Line(points={{-113.4,
          40},{-108,40},{-108,28},{-100,28}}, color={0,0,127}));
  connect(IntakeAirSource.ports[1], volume.ports[2]) annotation (Line(points={{
          -80,20},{-6,20},{-6,-98},{72,-98},{72,-90},{100,-90}}, color={0,127,
          255}));
  connect(res.port_b, IntakeAirSink.ports[1]) annotation (Line(points={{152,
          -110},{168,-110},{168,12},{170,12}}, color={0,127,255}));
  connect(weather.y[1], outdoorAir.T) annotation (Line(points={{-79,-70},{-40,
          -70},{-40,-80},{-2,-80}}, color={0,0,127}));
end Hall_short;
