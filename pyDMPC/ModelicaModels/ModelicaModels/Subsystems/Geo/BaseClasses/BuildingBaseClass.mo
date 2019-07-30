within ModelicaModels.Subsystems.Geo.BaseClasses;
model BuildingBaseClass "Simplified building model"

  replaceable package Water = AixLib.Media.Water;

  parameter ModelicaModels.DataBase.Geo.GeoRecord baseParam
  "The basic paramters";

  AixLib.Fluid.MixingVolumes.MixingVolume vol1(redeclare package Medium =
        Water,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_small=50,
    p_start=100000,
    m_flow_nominal=16,
    V=2,
    nPorts=2)                    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={24,42})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-34,-66},{-14,-46}})));
  Modelica.Blocks.Sources.Constant const(k=-10000)
    annotation (Placement(transformation(extent={{-92,-90},{-72,-70}})));
  AixLib.Fluid.FixedResistances.PressureDrop res(
    m_flow_nominal=16,
    dp_nominal(displayUnit="bar") = 100000,
    redeclare package Medium = Water)
        "total resistance" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={48,32})));
  AixLib.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Water,
    use_T_in=true,
    nPorts=1,
    m_flow=baseParam.m_flow_tot)
              annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  AixLib.Fluid.Sources.Boundary_pT bou(
  redeclare package Medium = Water,
  nPorts=1) annotation (Placement(
        transformation(
        extent={{-10,-11},{10,11}},
        rotation=180,
        origin={90,-1})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem(
  redeclare package Medium = Water, m_flow_nominal=16)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,18})));
  Modelica.Blocks.Interfaces.RealOutput returnTemperature
    "Temperature of the passing fluid"
    annotation (Placement(transformation(extent={{82,50},{102,70}})));
equation
  connect(vol1.ports[1], res.port_a)
    annotation (Line(points={{22,32},{38,32}}, color={0,127,255}));
  connect(res.port_b, senTem.port_a)
    annotation (Line(points={{58,32},{70,32},{70,28}},
                                               color={0,127,255}));
  connect(senTem.port_b, bou.ports[1]) annotation (Line(points={{70,8},{70,-1},{
          80,-1}},          color={0,127,255}));
  connect(senTem.T, returnTemperature)
    annotation (Line(points={{81,18},{81,60},{92,60}}, color={0,0,127}));
  connect(boundary.ports[1], vol1.ports[2]) annotation (Line(points={{-60,0},{-52,
          0},{-52,32},{26,32}}, color={0,127,255}));
  connect(const.y, product1.u2) annotation (Line(points={{-71,-80},{-52,-80},{-52,
          -62},{-36,-62}}, color={0,0,127}));
end BuildingBaseClass;
