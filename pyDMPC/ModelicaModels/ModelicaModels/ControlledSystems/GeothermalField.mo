within ModelicaModels.ControlledSystems;
model GeothermalField

  extends ModelicaModels.Subsystems.Geo.BaseClasses.FieldBaseClass(
    vol(T_start=282.15),
    pump(T_start=282.15),
    vol1(V=2, T_start=282.15),
    fixedTemperature(T=285.65),
    pressurePoint(use_T_in=false, T=282.15),
    supplyTemperature(T(fixed=true, start=285.65)),
    returnTemperature(T(fixed=true, start=285.65)),
    thermalConductor(G=1000));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-12,-12},{12,12}},
        rotation=0,
        origin={-6,42})));
  Modelica.Blocks.Sources.Constant Error;
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-62,32},{-42,52}})));
  Modelica.Blocks.Interfaces.RealInput heatShare
    "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-120,-18},{-80,22}})));
  Modelica.Blocks.Interfaces.RealInput traj "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}})));
  Modelica.Blocks.Math.Gain percent(k=0.01) "Convert from percent" annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=-90,
        origin={-74,20})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin
    annotation (Placement(transformation(extent={{-74,-60},{-54,-40}})));
  Modelica.Blocks.Sources.Constant const(k=-60000)
    annotation (Placement(transformation(extent={{-100,38},{-80,58}})));
equation
  connect(prescribedHeatFlow.port, vol1.heatPort)
    annotation (Line(points={{6,42},{20,42}}, color={191,0,0}));
  connect(heatShare, percent.u)
    annotation (Line(points={{-100,2},{-74,2},{-74,12.8}}, color={0,0,127}));
  connect(percent.y, product.u2)
    annotation (Line(points={{-74,26.6},{-74,36},{-64,36}}, color={0,0,127}));
  connect(product.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-41,42},{-18,42}}, color={0,0,127}));
  connect(traj, fromKelvin.Kelvin)
    annotation (Line(points={{-100,-50},{-76,-50}}, color={0,0,127}));
  connect(const.y, product.u1)
    annotation (Line(points={{-79,48},{-64,48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GeothermalField;
