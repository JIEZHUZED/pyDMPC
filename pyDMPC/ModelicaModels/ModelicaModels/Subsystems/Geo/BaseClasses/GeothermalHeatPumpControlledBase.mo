within ModelicaModels.Subsystems.Geo.BaseClasses;
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
</html>", revisions="<html>
<ul>
<li>
May 19, 2017, by Marc Baranski:<br/>
First implementation.
</li>
</ul>
</html>"));
end GeothermalHeatPumpControlledBase;
