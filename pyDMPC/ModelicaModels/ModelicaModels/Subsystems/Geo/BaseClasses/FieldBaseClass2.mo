within ModelicaModels.Subsystems.Geo.BaseClasses;
model FieldBaseClass2 "Simplified model of geothermal field"

   replaceable package Water = AixLib.Media.Water;
   replaceable package Dowcal10 =
      AixLib.Media.Antifreeze.PropyleneGlycolWater (                           property_T=293.15, X_a=0.36);
    parameter ModelicaModels.DataBase.Geo.GeoRecord baseParam   "The basic paramters";
  parameter ModelicaModels.DataBase.Geo.borFieDat borFieDat;

  AixLib.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Dowcal10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_small=50,
    nPorts=3,
    m_flow_nominal=16,
    V=2,
    p_start=100000,
    T_start=285.15)              annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,42})));
  AixLib.Fluid.Movers.FlowControlled_m_flow pump(
      nominalValuesDefineDefaultPressureCurve=true,
      redeclare package Medium = Dowcal10,
    m_flow_nominal=baseParam.m_flow_tot,
    inputType=AixLib.Fluid.Types.InputType.Constant,
    constantMassFlowRate=baseParam.m_flow_tot)
                                        "Main geothermal pump"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  AixLib.Fluid.FixedResistances.PressureDrop res(m_flow_nominal=16, dp_nominal(
        displayUnit="bar") = 100000, redeclare package Medium = Dowcal10)
        "total resistance" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,32})));
  Modelica.Fluid.Sources.Boundary_pT pressurePoint(
    redeclare package Medium = Dowcal10,
    use_T_in=false,
    use_X_in=false,
    use_p_in=false,
    p(displayUnit="Pa") = 101300,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={42,-34})));
  AixLib.Fluid.Sensors.Temperature supplyTemperature(T(start=285), redeclare
      package Medium = Dowcal10) "Temperature of supply water"
    annotation (Placement(transformation(extent={{82,34},{102,54}})));
  AixLib.Fluid.Sensors.MassFlowRate massFlow(redeclare package Medium =
        Dowcal10)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=270,
        origin={80,16})));
  AixLib.Fluid.Sensors.Temperature returnTemperature(redeclare package Medium =
        Dowcal10, T(start=285.15)) "Temperature of supply water"
    annotation (Placement(transformation(extent={{44,-78},{64,-58}})));
  AixLib.Fluid.Geothermal.Borefields.TwoUTubes
            borFie(redeclare package Medium = Dowcal10,
    tLoaAgg=21600,
    borFieDat(
      filDat(
        kFil=2,
        cFil=800,
        dFil=1600),
      conDat(
        borCon=AixLib.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        mBor_flow_nominal=0.4,
        mBorFie_flow_nominal=16,
        dp_nominal=50000,
        hBor=100,
        rBor=0.076,
        dBor=100,
        cooBor=[6.02,49.93; 15.08,51.43; 24.14,49.93; 33.2,49.93; 42.26,
            49.93; 51.25,49.93; 60.32,49.93; 22.98,41.07; 10.65,35.27;
            22.91,32; 6.08,27.5; 15.15,27.5; 22.98,14; 35.58,6.77; 44.65,
            6.77; 53.64,6.77; 62.63,6.77; 71.69,6.77; 80.75,6.77; 89.75,
            6.77; 98.81,6.77; 107.8,6.77; 115.5,11.48; 106.58,16.32; 91.04,
            16.32; 98.81,20.82; 114.41,20.82; 106.64,25.32; 91.04,25.39;
            98.81,29.96; 114.41,29.82; 106.64,34.45; 98.81,38.95; 114.41,
            38.89; 91.04,43.52; 106.58,43.52; 98.81,48.02; 114.41,47.95;
            78.3,49.93; 69.31,49.93],
        rTub=0.016,
        kTub=0.38,
        eTub=0.0029,
        xC=0.048),
      soiDat(
        dSoi=2700,
        kSoi=3.85,
        cSoi=18)),
    TExt0_start=285.65)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin
    annotation (Placement(transformation(extent={{102,38},{114,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=94672800)
    annotation (Placement(transformation(extent={{120,38},{130,48}})));
equation
  connect(res.port_b, vol1.ports[1])
    annotation (Line(points={{56,32},{27.3333,32}},
                                              color={0,127,255}));
  connect(pump.port_b, massFlow.port_a)
    annotation (Line(points={{66,0},{80,0},{80,10}},color={0,127,255}));
  connect(massFlow.port_b, res.port_a)
    annotation (Line(points={{80,22},{80,32},{76,32}}, color={0,127,255}));
  connect(supplyTemperature.port, pump.port_b)
    annotation (Line(points={{92,34},{92,0},{66,0}}, color={0,127,255}));
  connect(borFie.port_b, pump.port_a)
    annotation (Line(points={{0,0},{46,0}}, color={0,127,255}));
  connect(borFie.port_a, vol1.ports[2]) annotation (Line(points={{-20,0},{
          -40,0},{-40,32},{30,32}}, color={0,127,255}));
  connect(returnTemperature.port, vol1.ports[3]) annotation (Line(points={{54,-78},
          {54,-80},{-40,-80},{-40,32},{32.6667,32}},         color={0,127,
          255}));
  connect(pressurePoint.ports[1], pump.port_a)
    annotation (Line(points={{42,-24},{42,0},{46,0}}, color={0,127,255}));
  connect(supplyTemperature.T, fromKelvin.Kelvin)
    annotation (Line(points={{99,44},{100.8,44}}, color={0,0,127}));
  connect(fromKelvin.Celsius, movMea.u) annotation (Line(points={{114.6,44},{
          116,44},{116,43},{119,43}}, color={0,0,127}));
  annotation (experiment(StopTime=94608000, Interval=86400),
      __Dymola_experimentSetupOutput);
end FieldBaseClass2;
