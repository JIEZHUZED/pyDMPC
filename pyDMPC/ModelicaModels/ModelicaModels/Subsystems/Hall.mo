within ModelicaModels.Subsystems;
model Hall "Subsystem of the hall part of the new test hall building"

  extends
    ModelicaModels.SubsystemModels.DetailedModels.BaseClasses.HallBaseClass(
      weather(
      fileName="../weather.mat",
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic));

  Modelica.Blocks.Interfaces.RealInput T_CCA "Input signal connector"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=35 - T_CCA)
    annotation (Placement(transformation(extent={{-198,-30},{-142,-12}})));
  Modelica.Blocks.Sources.Constant solar(k=0)
    annotation (Placement(transformation(extent={{-86,26},{-66,46}})));
  Modelica.Blocks.Interfaces.RealInput T_in "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-160,-2},{-120,38}})));
  Modelica.Blocks.Interfaces.RealOutput V_flow
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{90,80},{110,100}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin
    annotation (Placement(transformation(extent={{56,16},{76,36}})));
  Modelica.Blocks.Interfaces.RealOutput T_hall
    annotation (Placement(transformation(extent={{90,16},{110,36}})));
  Modelica.Blocks.Interfaces.RealOutput T_CCA_act "Value of Real output"
    annotation (Placement(transformation(extent={{88,-74},{108,-54}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin1
    annotation (Placement(transformation(extent={{56,-8},{76,12}})));
  Modelica.Blocks.Interfaces.RealOutput T_AHU
    annotation (Placement(transformation(extent={{90,-8},{110,12}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=1)
    annotation (Placement(transformation(extent={{58,-74},{78,-54}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin waterTemperature1
    annotation (Placement(transformation(extent={{-118,18},{-106,30}})));
  Modelica.Blocks.Sources.Constant solar1(k=296)
    annotation (Placement(transformation(extent={{-124,-12},{-114,-2}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort1
                      "Heat port for heat exchange with the control volume"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/3600000)
    annotation (Placement(transformation(extent={{58,-100},{78,-80}})));
  Modelica.Blocks.Interfaces.RealOutput CCA_energy
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{90,-100},{110,-80}})));
equation
  connect(realExpression.y, waterTemperature.Celsius) annotation (Line(points={{-139.2,
          -21},{-120,-21},{-120,-24},{-107.2,-24}},             color={0,0,127}));
  connect(solar.y, SolarShare.u)
    annotation (Line(points={{-65,36},{-45.2,36}}, color={0,0,127}));
  connect(weather.y[1], outdoorAir.T) annotation (Line(points={{-119,-50},{-88,
          -50},{-88,-4},{-80,-4}}, color={0,0,127}));
  connect(AirVolumeFlow.y, V_flow) annotation (Line(points={{-139,50},{-132,50},
          {-132,70},{-28,70},{-28,90},{100,90}}, color={0,0,127}));
  connect(supplyAirTemperature.T, fromKelvin.Kelvin) annotation (Line(points={{
          20,64},{48,64},{48,26},{54,26}}, color={0,0,127}));
  connect(fromKelvin.Celsius, T_hall)
    annotation (Line(points={{77,26},{100,26}}, color={0,0,127}));
  connect(senTem.T, fromKelvin1.Kelvin) annotation (Line(points={{-54,31},{-54,
          56},{4,56},{4,14},{46,14},{46,2},{54,2}}, color={0,0,127}));
  connect(fromKelvin1.Celsius, T_AHU)
    annotation (Line(points={{77,2},{100,2}}, color={0,0,127}));
  connect(realExpression.y, firstOrder.u) annotation (Line(points={{-139.2,-21},
          {-120,-21},{-120,-36},{48,-36},{48,-64},{56,-64}}, color={0,0,127}));
  connect(firstOrder.y, T_CCA_act)
    annotation (Line(points={{79,-64},{98,-64}}, color={0,0,127}));
  connect(IntakeAirSource.T_in, waterTemperature1.Kelvin)
    annotation (Line(points={{-102,24},{-105.4,24}}, color={0,0,127}));
  connect(T_in, waterTemperature1.Celsius) annotation (Line(points={{-140,18},{
          -129.6,18},{-129.6,24},{-119.2,24}}, color={0,0,127}));
  connect(volume.heatPort, heatPort1) annotation (Line(points={{12,-4},{-14,-4},
          {-14,-26},{-82,-26},{-82,-100},{-140,-100}}, color={191,0,0}));
  connect(integrator.y, CCA_energy)
    annotation (Line(points={{79,-90},{100,-90}}, color={0,0,127}));
  connect(heatFlowSensor.Q_flow, integrator.u) annotation (Line(points={{22,-42},
          {46,-42},{46,-90},{56,-90}}, color={0,0,127}));
  annotation (experiment(StopTime=86400, Interval=10));
end Hall;
