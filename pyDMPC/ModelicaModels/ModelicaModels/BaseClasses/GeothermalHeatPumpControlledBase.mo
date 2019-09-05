within ModelicaModels.BaseClasses;
partial model GeothermalHeatPumpControlledBase
  "Example of a geothermal heat pump system with controllers"
  extends ModelicaModels.BaseClasses.GeothermalHeatPumpBase(
    pumpGeothermalSource(m_flow_nominal=baseParam.m_flow_tot),
    pumpCondenser(m_flow_nominal=baseParam.m_flow_tot),
    pumpHeatConsumer(m_flow_nominal=baseParam.m_flow_tot),
    pumpColdConsumer(m_flow_nominal=baseParam.m_flow_tot),
    pumpEvaporator(m_flow_nominal=baseParam.m_flow_tot));

  parameter ModelicaModels.DataBase.Geo.GeoRecord baseParam
  "The basic paramters";
  Modelica.Blocks.Sources.RealExpression getTStorageUpper(y=heatStorage.layer[
        heatStorage.n].T) "Gets the temperature of upper heat storage layer"
    annotation (Placement(transformation(extent={{-160,64},{-140,84}})));
  Modelica.Blocks.Sources.RealExpression getTStorageLower(y=coldStorage.layer[1].T)
    "Gets the temperature of lower cold storage layer"
    annotation (Placement(transformation(extent={{-160,48},{-140,68}})));
  Modelica.Blocks.Interfaces.RealOutput coldStorageTemperature(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0,
    start=T_start_cold[1]) "Temperature in the cold storage" annotation (
      Placement(transformation(
        origin={78,80},
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
        origin={60,80},
        extent={{-10,-10},{10,10}},
        rotation=90), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-140,-110})));
  Modelica.Blocks.Interfaces.RealOutput chemicalEnergy(final unit="W")
    "Flow of primary (chemical) energy into boiler " annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-61.5,-119.5}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20.5,-109})));
  Modelica.Blocks.Interfaces.RealOutput heatPumpEnergy(final unit="W")
    "Electrical power of the heat pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-39.5,-119.5}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60.5,-109})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
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
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={116,-34})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={96,8})));

  Modelica.Blocks.Continuous.Integrator integrator annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-62,-94})));
  Modelica.Blocks.Continuous.Integrator integrator1 annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-40,-94})));
  Modelica.Blocks.Interfaces.RealOutput supplyTemperature(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0,
    start=T_start_cold[1]) "Temperature in the cold storage" annotation (
      Placement(transformation(
        origin={-116,-120},
        extent={{10,-10},{-10,10}},
        rotation=90), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-100,-110})));
  AixLib.ThermalZones.ReducedOrder.Multizone.MultizoneEquipped multizone(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    buildingID=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    VAir=3500.0,
    ABuilding=1000.0,
    ASurTot=4961.336840410235,
    numZones=6,
    heatAHU=true,
    coolAHU=true,
    dehuAHU=true,
    huAHU=true,
    BPFDehuAHU=0.2,
    HRS=true,
    sampleRateAHU=1800,
    effFanAHU_sup=0.7,
    effFanAHU_eta=0.7,
    effHRSAHU_enabled=0.65,
    effHRSAHU_disabled=0.2,
    zone(ROM(
        extWallRC(thermCapExt(each der_T(fixed=true))),
        intWallRC(thermCapInt(each der_T(fixed=true))),
        floorRC(thermCapExt(each der_T(fixed=true))),
        roofRC(thermCapExt(each der_T(fixed=true))))),
    redeclare model thermalZone =
        AixLib.ThermalZones.ReducedOrder.ThermalZone.ThermalZoneEquipped,
    redeclare model corG =
        AixLib.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane,
    redeclare model AHUMod = AixLib.Airflow.AirHandlingUnit.AHU,
    T_start=293.15,
    zoneParam={Subsystems.Geo.BaseClasses.TEASER_DataBase.TEASER_Office(),
        Subsystems.Geo.BaseClasses.TEASER_DataBase.TEASER_Floor(),
        Subsystems.Geo.BaseClasses.TEASER_DataBase.TEASER_Storage(),
        Subsystems.Geo.BaseClasses.TEASER_DataBase.TEASER_Meeting(),
        Subsystems.Geo.BaseClasses.TEASER_DataBase.TEASER_Restroom(),
        Subsystems.Geo.BaseClasses.TEASER_DataBase.TEASER_ICT()},
    dpAHU_sup=800,
    dpAHU_eta=800) "Multizone"
    annotation (Placement(transformation(extent={{164,0},{144,20}})));
  AixLib.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=AixLib.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource("modelica://ModelicaModels/Subsystems/Geo/BaseClasses/TEASER_BuildingSets/DEU_BW_Mannheim_107290_TRY2010_12_Jahr_BBSR.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{188,32},{168,52}})));
  Modelica.Blocks.Sources.CombiTimeTable tableAHU(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableName="AHU",
    columns=2:5,
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://ModelicaModels/Subsystems/Geo/BaseClasses/TEASER_BuildingSets/ERC/AHU_ERC.mat"))
    "Boundary conditions for air handling unit"
    annotation (Placement(transformation(extent={{188,2},{172,18}})));
  Modelica.Blocks.Sources.CombiTimeTable tableTSet(
    tableOnFile=true,
    tableName="Tset",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://ModelicaModels/Subsystems/Geo/BaseClasses/TEASER_BuildingSets/Tset_ERC.mat"),
    columns=2:7)
    "Set points for heater"
    annotation (Placement(transformation(extent={{188,-46},{172,-30}})));
  Modelica.Blocks.Sources.CombiTimeTable tableInternalGains(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableName="Internals",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://ModelicaModels/Subsystems/Geo/BaseClasses/TEASER_BuildingSets/InternalGains_ERC.mat"),
    columns=2:19)
    "Profiles for internal gains"
    annotation (Placement(transformation(extent={{188,-68},{172,-52}})));
  Modelica.Blocks.Sources.Constant const[6](each k=0)
    "Set point for cooler"
    annotation (Placement(transformation(extent={{188,-22},{172,-6}})));
  Modelica.Blocks.Math.Gain negate(k=-1)
    annotation (Placement(transformation(extent={{110,-2},{102,6}})));
  Modelica.Blocks.Math.Gain negate1(k=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={116,-18})));
  Modelica.Blocks.Math.Sum sum1(nin=2, k={1,1}) annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={132,-12})));
  Modelica.Blocks.Math.Sum sum2(nin=2, k={1,1}) annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=180,
        origin={116,2})));
equation
  connect(getTStorageLower.y, coldStorageTemperature) annotation (Line(points={{-139,58},
          {78,58},{78,80}},                 color={0,0,127}));
  connect(getTStorageUpper.y, heatStorageTemperature) annotation (Line(points={{-139,74},
          {-122,74},{-122,60},{60,60},{60,80}},
        color={0,0,127}));
  connect(returnTemSensor.T, returnTemperature) annotation (Line(points={{
          -107,9.2},{-107,-94},{-144,-94},{-144,-120}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, vol2.heatPort)
    annotation (Line(points={{116,-40},{116,-44}}, color={191,0,0}));
  connect(vol1.heatPort, prescribedHeatFlow1.port)
    annotation (Line(points={{96,20},{96,14}}, color={191,0,0}));
  connect(chemicalEnergy, integrator.y) annotation (Line(points={{-61.5,-119.5},
          {-62,-119.5},{-62,-100.6}}, color={0,0,127}));
  connect(integrator1.y, heatPumpEnergy) annotation (Line(points={{-40,-100.6},
          {-40,-119.5},{-39.5,-119.5}}, color={0,0,127}));
  connect(integrator1.u, heatPumpTab.Power) annotation (Line(points={{-40,-86.8},
          {-40,-30},{-22,-30},{-22,-12.3}}, color={0,0,127}));
  connect(supplyTemSensor.T, supplyTemperature) annotation (Line(points={{-115,-62.8},
          {-115,-67.4},{-116,-67.4},{-116,-120}}, color={0,0,127}));
  connect(weaDat.weaBus,multizone. weaBus) annotation (Line(
      points={{168,42},{166,42},{166,14},{162,14}},
      color={255,204,51},
      thickness=0.5));
  connect(tableInternalGains.y,multizone. intGains)
    annotation (Line(points={{171.2,-60},{148,-60},{148,-1}},
                                                           color={0,0,127}));
  connect(tableAHU.y,multizone. AHU)
    annotation (Line(points={{171.2,10},{163,10}},     color={0,0,127}));
  connect(tableTSet.y,multizone. TSetHeat) annotation (Line(points={{171.2,-38},
          {159.2,-38},{159.2,-1}},
                                 color={0,0,127}));
  connect(const.y,multizone. TSetCool) annotation (Line(points={{171.2,-14},{
          162,-14},{162,-2},{161.4,-2},{161.4,-1}},  color={0,0,127}));
  connect(negate1.u,sum1. y) annotation (Line(points={{116,-13.2},{124,-13.2},{124,
          -16.4},{132,-16.4}},        color={0,0,127}));
  connect(negate.u,sum2. y)
    annotation (Line(points={{110.8,2},{111.6,2}}, color={0,0,127}));
  connect(multizone.PCooler[1],sum2. u[1]) annotation (Line(points={{145,
          0.166667},{122,0.166667},{122,2.4},{120.8,2.4}}, color={0,0,127}));
  connect(multizone.PHeater[1],sum1. u[1]) annotation (Line(points={{145,2.16667},
          {131.6,2.16667},{131.6,-7.2}},          color={0,0,127}));
  connect(multizone.PCoolAHU,sum2. u[2]) annotation (Line(points={{145,5},{122,
          5},{122,1.6},{120.8,1.6}}, color={0,0,127}));
  connect(multizone.PHeatAHU,sum1. u[2]) annotation (Line(points={{145,7},{132.4,
          7},{132.4,-7.2}},       color={0,0,127}));
  connect(negate.y, prescribedHeatFlow1.Q_flow)
    annotation (Line(points={{101.6,2},{96,2}}, color={0,0,127}));
  connect(prescribedHeatFlow.Q_flow, negate1.y)
    annotation (Line(points={{116,-28},{116,-22.4}}, color={0,0,127}));
  annotation (experiment(StopTime=86400, Interval=10), Documentation(info="<html>
<p>Base class of an example demonstrating the use of a heat pump connected to two storages and a geothermal source. A replaceable model is connected in the flow line of the heating circuit. A peak load device can be added here.  This model also includes basic controllers.</p>
</html>", revisions="<html>
<ul>
<li>
May 19, 2017, by Marc Baranski:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-120},{140,80}})),
    Icon(coordinateSystem(extent={{-160,-120},{140,80}})));
end GeothermalHeatPumpControlledBase;
