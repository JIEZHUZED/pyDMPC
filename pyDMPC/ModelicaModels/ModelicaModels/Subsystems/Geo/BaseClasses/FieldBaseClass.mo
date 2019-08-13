within ModelicaModels.Subsystems.Geo.BaseClasses;
model FieldBaseClass "Simplified model of geothermal field"

 replaceable package Water = AixLib.Media.Water;

  parameter ModelicaModels.DataBase.Geo.GeoRecord baseParam
  "The basic paramters";

  AixLib.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_small=50,
    nPorts=3,
    p_start=100000,
    m_flow_nominal=16,
    V=2)                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,42})));
  AixLib.Fluid.Movers.FlowControlled_m_flow pump(
      nominalValuesDefineDefaultPressureCurve=true,
      redeclare package Medium = Water,
    m_flow_nominal=baseParam.m_flow_tot,
    inputType=AixLib.Fluid.Types.InputType.Constant,
    constantMassFlowRate=baseParam.m_flow_tot)
                                        "Main geothermal pump"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  AixLib.Fluid.FixedResistances.PressureDrop res(m_flow_nominal=16, dp_nominal(
        displayUnit="bar") = 100000, redeclare package Medium = Water)
        "total resistance" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,32})));
  Modelica.Fluid.Sources.Boundary_pT pressurePoint(
    redeclare package Medium = Water,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={42,-34})));
  AixLib.Fluid.Sensors.Temperature supplyTemperature(T(start=285), redeclare
      package Medium = Water) "Temperature of supply water"
    annotation (Placement(transformation(extent={{82,34},{102,54}})));
  AixLib.Fluid.Sensors.MassFlowRate massFlow(redeclare package Medium =
        Water)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=270,
        origin={80,12})));
  AixLib.Fluid.Sensors.Temperature returnTemperature(redeclare package Medium =
        Water, T(start=285.15)) "Temperature of supply water"
    annotation (Placement(transformation(extent={{44,-78},{64,-58}})));
  AixLib.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Water,
    m_flow_small=50,
    nPorts=2,
    V=9000,
    p_start=150000,
    T_start=285.15,
    m_flow_nominal=16)              annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,-2})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=285.15)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-24,-62})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=50)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-24,-34})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin
    annotation (Placement(transformation(extent={{106,36},{118,48}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=94672800)
    annotation (Placement(transformation(extent={{126,32},{136,42}})));
equation
  connect(res.port_b, vol1.ports[1])
    annotation (Line(points={{56,32},{27.3333,32}},
                                              color={0,127,255}));
  connect(pressurePoint.ports[1], pump.port_a)
    annotation (Line(points={{42,-24},{42,0},{46,0}}, color={0,127,255}));
  connect(pump.port_b, massFlow.port_a)
    annotation (Line(points={{66,0},{80,0},{80,6}}, color={0,127,255}));
  connect(massFlow.port_b, res.port_a)
    annotation (Line(points={{80,18},{80,32},{76,32}}, color={0,127,255}));
  connect(supplyTemperature.port, pump.port_b)
    annotation (Line(points={{92,34},{92,0},{66,0}}, color={0,127,255}));
  connect(thermalConductor.port_b, vol.heatPort)
    annotation (Line(points={{-24,-28},{-24,-2},{-18,-2}}, color={191,0,0}));
  connect(fixedTemperature.port, thermalConductor.port_a)
    annotation (Line(points={{-24,-56},{-24,-40}}, color={191,0,0}));
  connect(vol.ports[1], pump.port_a) annotation (Line(points={{-10,-12},{20,
          -12},{20,0},{46,0}},
                          color={0,127,255}));
  connect(vol1.ports[2], vol.ports[2]) annotation (Line(points={{30,32},{-40,32},
          {-40,-12},{-6,-12}}, color={0,127,255}));
  connect(vol1.ports[3], returnTemperature.port) annotation (Line(points={{32.6667,
          32},{-40,32},{-40,-80},{54,-80},{54,-78}},         color={0,127,255}));
  connect(supplyTemperature.T, fromKelvin.Kelvin) annotation (Line(points={{99,
          44},{102,44},{102,42},{104.8,42}}, color={0,0,127}));
  connect(fromKelvin.Celsius, movMea.u) annotation (Line(points={{118.6,42},{
          122,42},{122,37},{125,37}}, color={0,0,127}));
  annotation (experiment(StopTime=94608000, Interval=86400),
      __Dymola_experimentSetupOutput);
end FieldBaseClass;
