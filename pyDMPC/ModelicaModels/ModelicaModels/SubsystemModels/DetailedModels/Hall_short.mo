within ModelicaModels.SubsystemModels.DetailedModels;
model Hall_short
  extends
    ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass(
      weather(fileName="../weather.mat"));

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
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Modelica.Blocks.Sources.Constant solar(k=0)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
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
equation
  connect(variation.y[1], hallTemperature1.Celsius)
    annotation (Line(points={{-139,18},{-129.2,18}}, color={0,0,127}));
  connect(waterTemperature.Celsius, currentWaterTemperature.y)
    annotation (Line(points={{-107.2,-24},{-132,-24},{-132,-20},{-139,-20}},
                                                       color={0,0,127}));
  connect(solar.y, SolarShare.u)
    annotation (Line(points={{-59,70},{-54,70},{-54,36},{-45.2,36}},
                                                   color={0,0,127}));
  connect(hallTemperature1.Kelvin, IntakeAirSource.T_in) annotation (Line(
        points={{-115.4,18},{-108,18},{-108,24},{-102,24}}, color={0,0,127}));
end Hall_short;
