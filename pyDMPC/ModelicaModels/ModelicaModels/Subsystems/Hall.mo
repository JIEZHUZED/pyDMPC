within ModelicaModels.Subsystems;
model Hall "Subsystem of the hall part of the new test hall building"

  extends
    ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass(
      volume(nPorts=2));

  Modelica.Blocks.Interfaces.RealInput u1
                         "Input signal connector"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{90,-26},{110,-6}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=35 - u1)
    annotation (Placement(transformation(extent={{-106,-110},{-50,-92}})));
  Modelica.Blocks.Sources.Constant solar(k=0)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
equation
  connect(realExpression.y, waterTemperature.Celsius) annotation (Line(points={
          {-47.2,-101},{-38.6,-101},{-38.6,-100},{-29.2,-100}}, color={0,0,127}));
  connect(solar.y, SolarShare.u)
    annotation (Line(points={{21,-40},{32.8,-40}}, color={0,0,127}));
  connect(port_b, res.port_b) annotation (Line(points={{100,-16},{116,-16},{116,
          -68},{152,-68},{152,-110}}, color={0,127,255}));
  connect(port_a, volume.ports[2]) annotation (Line(points={{-140,0},{-6,0},{-6,
          -100},{70,-100},{70,-90},{100,-90}}, color={0,127,255}));
  annotation (experiment(StartTime=1000));
end Hall;
