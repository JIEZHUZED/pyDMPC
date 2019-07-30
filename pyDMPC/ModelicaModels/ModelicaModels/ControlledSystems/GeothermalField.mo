within ModelicaModels.ControlledSystems;
model GeothermalField

  extends ModelicaModels.Subsystems.Geo.BaseClasses.FieldBaseClass(
    vol(T_start=285.65),
    pump(T_start=285.65),
    vol1(T_start=285.65),
    fixedTemperature(T=285.65),
    pressurePoint(use_T_in=false, T=285.65),
    supplyTemperature(T(fixed=true, start=285.65)),
    returnTemperature(T(fixed=true, start=285.65)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=0,
        origin={-6,42})));
  Modelica.Blocks.Sources.Sine sine(amplitude=10000, freqHz=1/86400)
    annotation (Placement(transformation(extent={{-100,38},{-80,60}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-62,32},{-42,52}})));
  Modelica.Blocks.Interfaces.RealInput heatShare
    "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-120,-18},{-80,22}})));
  Modelica.Blocks.Interfaces.RealInput traj "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
equation
  connect(prescribedHeatFlow.port, vol1.heatPort)
    annotation (Line(points={{6,42},{20,42}}, color={191,0,0}));
  connect(sine.y, product.u1) annotation (Line(points={{-79,49},{-74,49},{-74,
          48},{-64,48}}, color={0,0,127}));
  connect(product.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-41,42},{-41,42},{-18,42}}, color={0,0,127}));
  connect(product.u2, heatShare) annotation (Line(points={{-64,36},{-76,36},{
          -76,2},{-100,2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GeothermalField;
