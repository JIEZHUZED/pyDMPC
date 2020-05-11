within ModelicaModels.SubsystemModels.DetailedModels;
model Hall_long
  extends
    ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass(
      weather(
      table=[0.0,293],
      tableOnFile=true,
      smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
      fileName="../weather.mat"), volume(nPorts=2));

  Modelica.Blocks.Sources.Constant Tnormal(k=273 + 24)
    "Average Temperature of supply air or forecast"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Modelica.Blocks.Sources.Constant solar(k=0)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=35 -
        decisionVariables.y[1])
    annotation (Placement(transformation(extent={{-106,-110},{-50,-92}})));
  Modelica.Blocks.Sources.CombiTimeTable variation(
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2},
    fileName="decisionVariables.mat",
    tableOnFile=false,
    table=[0.0,0.0]) "Table with decision variables" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-32})));
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
  Modelica.Blocks.Math.Max max
    annotation (Placement(transformation(extent={{-68,-40},{-48,-20}})));
equation
  connect(solar.y, SolarShare.u)
    annotation (Line(points={{21,-40},{32.8,-40}}, color={0,0,127}));
  connect(realExpression.y, waterTemperature.Celsius) annotation (Line(points={
          {-47.2,-101},{-37.6,-101},{-37.6,-100},{-29.2,-100}}, color={0,0,127}));
  connect(AirVolumeFlow.y,V2m. u) annotation (Line(points={{-139,50},{-132,50},
          {-132,40},{-127.2,40}}, color={0,0,127}));
  connect(V2m.y,IntakeAirSource. m_flow_in) annotation (Line(points={{-113.4,
          40},{-108,40},{-108,28},{-100,28}}, color={0,0,127}));
  connect(IntakeAirSource.ports[1], volume.ports[2]) annotation (Line(points={{
          -80,20},{-8,20},{-8,-98},{70,-98},{70,-90},{100,-90}}, color={0,127,
          255}));
  connect(res.port_b, IntakeAirSink.ports[1]) annotation (Line(points={{152,
          -110},{168,-110},{168,12},{170,12}}, color={0,127,255}));
  connect(weather.y[1], outdoorAir.T) annotation (Line(points={{-79,-70},{-40,
          -70},{-40,-80},{-2,-80}}, color={0,0,127}));
  connect(weather.y[1], max.u2) annotation (Line(points={{-79,-70},{-76,-70},{
          -76,-36},{-70,-36}}, color={0,0,127}));
  connect(Tnormal.y, max.u1) annotation (Line(points={{-139,20},{-112,20},{-112,
          -24},{-70,-24}}, color={0,0,127}));
  connect(max.y, IntakeAirSource.T_in) annotation (Line(points={{-47,-30},{-34,
          -30},{-34,6},{-108,6},{-108,24},{-102,24}}, color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=10));
end Hall_long;
