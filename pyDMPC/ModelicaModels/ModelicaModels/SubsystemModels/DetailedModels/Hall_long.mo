within ModelicaModels.SubsystemModels.DetailedModels;
model Hall_long
  extends ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass(
      decisionVariables(tableOnFile=false, table=[0.0,0.0]), weather(
      table=[0.0,293],
      tableOnFile=true,
      smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
      fileName="../weather.mat"));

  Modelica.Blocks.Sources.Constant Tnormal(k=273 + 22)
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
equation
  connect(Tnormal.y, IntakeAirSource.T_in) annotation (Line(points={{-139,20},{
          -120,20},{-120,24},{-102,24}}, color={0,0,127}));
  connect(solar.y, SolarShare.u)
    annotation (Line(points={{21,-40},{32.8,-40}}, color={0,0,127}));
  connect(realExpression.y, waterTemperature.Celsius) annotation (Line(points={
          {-47.2,-101},{-37.6,-101},{-37.6,-100},{-29.2,-100}}, color={0,0,127}));
  annotation (experiment(StopTime=172800, Interval=10));
end Hall_long;
