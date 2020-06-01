within ModelicaModels.SubsystemModels.DetailedModels;
model Hall_long
  extends
    ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass(
      weather(
      table=[0.0,293],
      tableOnFile=true,
      smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
      fileName="../weather.mat",
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      startTime=startTime));

      parameter Real startTime = 0;

  Modelica.Blocks.Sources.Constant Tnormal(k=273 + 24)
    "Average Temperature of supply air or forecast"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Modelica.Blocks.Sources.Constant solar(k=0)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=35 -
        decisionVariables.y[1])
    annotation (Placement(transformation(extent={{-196,-40},{-140,-22}})));
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
        origin={-130,-12})));
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
        origin={-130,-90})));
  Modelica.Blocks.Sources.Constant AirVolumeFlow(k=8000)
    "Air volume flow rate, could be an initial value"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Modelica.Blocks.Math.Gain V2m(k=1.2/3600) "Volume to mass flow"
    annotation (Placement(transformation(extent={{-126,34},{-114,46}})));
  Modelica.Blocks.Math.Max max
    annotation (Placement(transformation(extent={{-128,14},{-118,24}})));
equation
  connect(solar.y, SolarShare.u)
    annotation (Line(points={{-59,70},{-52,70},{-52,36},{-45.2,36}},
                                                   color={0,0,127}));
  connect(realExpression.y, waterTemperature.Celsius) annotation (Line(points={{-137.2,
          -31},{-116,-31},{-116,-24},{-107.2,-24}},             color={0,0,127}));
  connect(AirVolumeFlow.y,V2m. u) annotation (Line(points={{-139,50},{-132,50},
          {-132,40},{-127.2,40}}, color={0,0,127}));
  connect(weather.y[1], max.u2) annotation (Line(points={{-119,-50},{-90,-50},{-90,
          4},{-134,4},{-134,16},{-129,16}},
                               color={0,0,127}));
  connect(Tnormal.y, max.u1) annotation (Line(points={{-139,20},{-134,20},{-134,
          22},{-129,22}}, color={0,0,127}));
  connect(max.y, IntakeAirSource.T_in) annotation (Line(points={{-117.5,19},{-108,
          19},{-108,24},{-102,24}}, color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=10));
end Hall_long;
