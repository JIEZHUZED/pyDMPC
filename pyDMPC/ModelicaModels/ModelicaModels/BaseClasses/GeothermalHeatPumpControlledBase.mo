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
    annotation (Placement(transformation(extent={{180,60},{200,80}})));
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
  Modelica.Blocks.Math.Gain negate(k=-1)
    annotation (Placement(transformation(extent={{134,-4},{126,4}})));
  Modelica.Blocks.Math.Gain negate1(k=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=180,
        origin={130,-24})));
  AixLib.ThermalZones.ReducedOrder.ThermalZone.ThermalZoneEquipped thermalZone(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    zoneParam=AixLib.DataBase.ThermalZones.OfficePassiveHouse.OPH_1_Office(),
    ROM(extWallRC(thermCapExt(each der_T(fixed=true))), intWallRC(thermCapInt(
            each der_T(fixed=true)))),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15)
    "Thermal zone"
    annotation (Placement(transformation(extent={{204,4},{184,24}})));
  AixLib.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=AixLib.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://ModelicaModels/Subsystems/Geo/BaseClasses/TEASER_BuildingSets/DEU_BW_Mannheim_107290_TRY2010_12_Jahr_BBSR.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{248,28},{228,48}})));

  Modelica.Blocks.Sources.Constant const(k=0.2)
    "Infiltration rate"
    annotation (Placement(transformation(extent={{200,-26},{190,-16}})));
  Modelica.Blocks.Sources.CombiTimeTable internalGains(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableName="UserProfiles",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://AixLib/Resources/LowOrder_ExampleData/UserProfiles_18599_SIA_Besprechung_Sitzung_Seminar.txt"),
    columns={2,3,4},
    tableOnFile=false,
    table=[0,0,0.1,0,0; 3540,0,0.1,0,0; 3600,0,0.1,0,0; 7140,0,0.1,0,0; 7200,0,
        0.1,0,0; 10740,0,0.1,0,0; 10800,0,0.1,0,0; 14340,0,0.1,0,0; 14400,0,0.1,
        0,0; 17940,0,0.1,0,0; 18000,0,0.1,0,0; 21540,0,0.1,0,0; 21600,0,0.1,0,0;
        25140,0,0.1,0,0; 25200,0,0.1,0,0; 28740,0,0.1,0,0; 28800,0,0.1,0,0;
        32340,0,0.1,0,0; 32400,0.6,0.6,1,1; 35940,0.6,0.6,1,1; 36000,1,1,1,1;
        39540,1,1,1,1; 39600,0.4,0.4,1,1; 43140,0.4,0.4,1,1; 43200,0,0.1,0,0;
        46740,0,0.1,0,0; 46800,0,0.1,0,0; 50340,0,0.1,0,0; 50400,0.6,0.6,1,1;
        53940,0.6,0.6,1,1; 54000,1,1,1,1; 57540,1,1,1,1; 57600,0.4,0.4,1,1;
        61140,0.4,0.4,1,1; 61200,0,0.1,0,0; 64740,0,0.1,0,0; 64800,0,0.1,0,0;
        68340,0,0.1,0,0; 68400,0,0.1,0,0; 71940,0,0.1,0,0; 72000,0,0.1,0,0;
        75540,0,0.1,0,0; 75600,0,0.1,0,0; 79140,0,0.1,0,0; 79200,0,0.1,0,0;
        82740,0,0.1,0,0; 82800,0,0.1,0,0; 86340,0,0.1,0,0; 86400,0,0.1,0,0;
        89940,0,0.1,0,0; 90000,0,0.1,0,0; 93540,0,0.1,0,0; 93600,0,0.1,0,0;
        97140,0,0.1,0,0; 97200,0,0.1,0,0; 100740,0,0.1,0,0; 100800,0,0.1,0,0;
        104340,0,0.1,0,0; 104400,0,0.1,0,0; 107940,0,0.1,0,0; 108000,0,0.1,0,0;
        111540,0,0.1,0,0; 111600,0,0.1,0,0; 115140,0,0.1,0,0; 115200,0,0.1,0,0;
        118740,0,0.1,0,0; 118800,0.6,0.6,1,1; 122340,0.6,0.6,1,1; 122400,1,1,1,
        1; 125940,1,1,1,1; 126000,0.4,0.4,1,1; 129540,0.4,0.4,1,1; 129600,0,0.1,
        0,0; 133140,0,0.1,0,0; 133200,0,0.1,0,0; 136740,0,0.1,0,0; 136800,0.6,
        0.6,1,1; 140340,0.6,0.6,1,1; 140400,1,1,1,1; 143940,1,1,1,1; 144000,0.4,
        0.4,1,1; 147540,0.4,0.4,1,1; 147600,0,0.1,0,0; 151140,0,0.1,0,0; 151200,
        0,0.1,0,0; 154740,0,0.1,0,0; 154800,0,0.1,0,0; 158340,0,0.1,0,0; 158400,
        0,0.1,0,0; 161940,0,0.1,0,0; 162000,0,0.1,0,0; 165540,0,0.1,0,0; 165600,
        0,0.1,0,0; 169140,0,0.1,0,0; 169200,0,0.1,0,0; 172740,0,0.1,0,0; 172800,
        0,0.1,0,0; 176340,0,0.1,0,0; 176400,0,0.1,0,0; 179940,0,0.1,0,0; 180000,
        0,0.1,0,0; 183540,0,0.1,0,0; 183600,0,0.1,0,0; 187140,0,0.1,0,0; 187200,
        0,0.1,0,0; 190740,0,0.1,0,0; 190800,0,0.1,0,0; 194340,0,0.1,0,0; 194400,
        0,0.1,0,0; 197940,0,0.1,0,0; 198000,0,0.1,0,0; 201540,0,0.1,0,0; 201600,
        0,0.1,0,0; 205140,0,0.1,0,0; 205200,0.6,0.6,1,1; 208740,0.6,0.6,1,1;
        208800,1,1,1,1; 212340,1,1,1,1; 212400,0.4,0.4,1,1; 215940,0.4,0.4,1,1;
        216000,0,0.1,0,0; 219540,0,0.1,0,0; 219600,0,0.1,0,0; 223140,0,0.1,0,0;
        223200,0.6,0.6,1,1; 226740,0.6,0.6,1,1; 226800,1,1,1,1; 230340,1,1,1,1;
        230400,0.4,0.4,1,1; 233940,0.4,0.4,1,1; 234000,0,0.1,0,0; 237540,0,0.1,
        0,0; 237600,0,0.1,0,0; 241140,0,0.1,0,0; 241200,0,0.1,0,0; 244740,0,0.1,
        0,0; 244800,0,0.1,0,0; 248340,0,0.1,0,0; 248400,0,0.1,0,0; 251940,0,0.1,
        0,0; 252000,0,0.1,0,0; 255540,0,0.1,0,0; 255600,0,0.1,0,0; 259140,0,0.1,
        0,0; 259200,0,0.1,0,0; 262740,0,0.1,0,0; 262800,0,0.1,0,0; 266340,0,0.1,
        0,0; 266400,0,0.1,0,0; 269940,0,0.1,0,0; 270000,0,0.1,0,0; 273540,0,0.1,
        0,0; 273600,0,0.1,0,0; 277140,0,0.1,0,0; 277200,0,0.1,0,0; 280740,0,0.1,
        0,0; 280800,0,0.1,0,0; 284340,0,0.1,0,0; 284400,0,0.1,0,0; 287940,0,0.1,
        0,0; 288000,0,0.1,0,0; 291540,0,0.1,0,0; 291600,0.6,0.6,1,1; 295140,0.6,
        0.6,1,1; 295200,1,1,1,1; 298740,1,1,1,1; 298800,0.4,0.4,1,1; 302340,0.4,
        0.4,1,1; 302400,0,0.1,0,0; 305940,0,0.1,0,0; 306000,0,0.1,0,0; 309540,0,
        0.1,0,0; 309600,0.6,0.6,1,1; 313140,0.6,0.6,1,1; 313200,1,1,1,1; 316740,
        1,1,1,1; 316800,0.4,0.4,1,1; 320340,0.4,0.4,1,1; 320400,0,0.1,0,0;
        323940,0,0.1,0,0; 324000,0,0.1,0,0; 327540,0,0.1,0,0; 327600,0,0.1,0,0;
        331140,0,0.1,0,0; 331200,0,0.1,0,0; 334740,0,0.1,0,0; 334800,0,0.1,0,0;
        338340,0,0.1,0,0; 338400,0,0.1,0,0; 341940,0,0.1,0,0; 342000,0,0.1,0,0;
        345540,0,0.1,0,0; 345600,0,0.1,0,0; 349140,0,0.1,0,0; 349200,0,0.1,0,0;
        352740,0,0.1,0,0; 352800,0,0.1,0,0; 356340,0,0.1,0,0; 356400,0,0.1,0,0;
        359940,0,0.1,0,0; 360000,0,0.1,0,0; 363540,0,0.1,0,0; 363600,0,0.1,0,0;
        367140,0,0.1,0,0; 367200,0,0.1,0,0; 370740,0,0.1,0,0; 370800,0,0.1,0,0;
        374340,0,0.1,0,0; 374400,0,0.1,0,0; 377940,0,0.1,0,0; 378000,0.6,0.6,1,
        1; 381540,0.6,0.6,1,1; 381600,1,1,1,1; 385140,1,1,1,1; 385200,0.4,0.4,1,
        1; 388740,0.4,0.4,1,1; 388800,0,0.1,0,0; 392340,0,0.1,0,0; 392400,0,0.1,
        0,0; 395940,0,0.1,0,0; 396000,0.6,0.6,1,1; 399540,0.6,0.6,1,1; 399600,1,
        1,1,1; 403140,1,1,1,1; 403200,0.4,0.4,1,1; 406740,0.4,0.4,1,1; 406800,0,
        0.1,0,0; 410340,0,0.1,0,0; 410400,0,0.1,0,0; 413940,0,0.1,0,0; 414000,0,
        0.1,0,0; 417540,0,0.1,0,0; 417600,0,0.1,0,0; 421140,0,0.1,0,0; 421200,0,
        0.1,0,0; 424740,0,0.1,0,0; 424800,0,0.1,0,0; 428340,0,0.1,0,0; 428400,0,
        0.1,0,0; 431940,0,0.1,0,0; 432000,0,0,0,0; 435540,0,0,0,0; 435600,0,0,0,
        0; 439140,0,0,0,0; 439200,0,0,0,0; 442740,0,0,0,0; 442800,0,0,0,0;
        446340,0,0,0,0; 446400,0,0,0,0; 449940,0,0,0,0; 450000,0,0,0,0; 453540,
        0,0,0,0; 453600,0,0,0,0; 457140,0,0,0,0; 457200,0,0,0,0; 460740,0,0,0,0;
        460800,0,0,0,0; 464340,0,0,0,0; 464400,0,0,0,0; 467940,0,0,0,0; 468000,
        0,0,0,0; 471540,0,0,0,0; 471600,0,0,0,0; 475140,0,0,0,0; 475200,0,0,0,0;
        478740,0,0,0,0; 478800,0,0,0,0; 482340,0,0,0,0; 482400,0,0,0,0; 485940,
        0,0,0,0; 486000,0,0,0,0; 489540,0,0,0,0; 489600,0,0,0,0; 493140,0,0,0,0;
        493200,0,0,0,0; 496740,0,0,0,0; 496800,0,0,0,0; 500340,0,0,0,0; 500400,
        0,0,0,0; 503940,0,0,0,0; 504000,0,0,0,0; 507540,0,0,0,0; 507600,0,0,0,0;
        511140,0,0,0,0; 511200,0,0,0,0; 514740,0,0,0,0; 514800,0,0,0,0; 518340,
        0,0,0,0; 518400,0,0,0,0; 521940,0,0,0,0; 522000,0,0,0,0; 525540,0,0,0,0;
        525600,0,0,0,0; 529140,0,0,0,0; 529200,0,0,0,0; 532740,0,0,0,0; 532800,
        0,0,0,0; 536340,0,0,0,0; 536400,0,0,0,0; 539940,0,0,0,0; 540000,0,0,0,0;
        543540,0,0,0,0; 543600,0,0,0,0; 547140,0,0,0,0; 547200,0,0,0,0; 550740,
        0,0,0,0; 550800,0,0,0,0; 554340,0,0,0,0; 554400,0,0,0,0; 557940,0,0,0,0;
        558000,0,0,0,0; 561540,0,0,0,0; 561600,0,0,0,0; 565140,0,0,0,0; 565200,
        0,0,0,0; 568740,0,0,0,0; 568800,0,0,0,0; 572340,0,0,0,0; 572400,0,0,0,0;
        575940,0,0,0,0; 576000,0,0,0,0; 579540,0,0,0,0; 579600,0,0,0,0; 583140,
        0,0,0,0; 583200,0,0,0,0; 586740,0,0,0,0; 586800,0,0,0,0; 590340,0,0,0,0;
        590400,0,0,0,0; 593940,0,0,0,0; 594000,0,0,0,0; 597540,0,0,0,0; 597600,
        0,0,0,0; 601140,0,0,0,0; 601200,0,0,0,0; 604740,0,0,0,0])
    "Table with profiles for internal gains"
    annotation(Placement(transformation(extent={{200,-48},{190,-37}})));

  AixLib.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{236,-22},{202,10}}),
    iconTransformation(extent={{-70,-12},{-50,8}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature idealConditioning(T=294.15)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={160,22})));
  Modelica.Blocks.Sources.RealExpression HeatFlowBuildingNeed(y=-
        idealConditioning.port.Q_flow) "Need of Building" annotation (Placement(
        transformation(
        extent={{-28,-11},{28,11}},
        rotation=180,
        origin={172,49})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=180,
        origin={150,0})));
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=180,
        origin={150,-24})));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold annotation (
      Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=0,
        origin={123,49})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    "Infiltration rate"
    annotation (Placement(transformation(extent={{200,-64},{190,-54}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature cellarTemperature(T=284.15)
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={194,-76})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=94672800)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-144,-94})));
equation
  connect(getTStorageLower.y, coldStorageTemperature) annotation (Line(points={{-139,58},
          {78,58},{78,80}},                 color={0,0,127}));
  connect(getTStorageUpper.y, heatStorageTemperature) annotation (Line(points={{-139,74},
          {-122,74},{-122,60},{60,60},{60,80}},
        color={0,0,127}));
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
  connect(negate.y, prescribedHeatFlow1.Q_flow)
    annotation (Line(points={{125.6,0},{96,0},{96,2}},
                                                color={0,0,127}));
  connect(prescribedHeatFlow.Q_flow, negate1.y)
    annotation (Line(points={{116,-28},{116,-24},{125.6,-24}},
                                                     color={0,0,127}));
  connect(weaDat.weaBus,thermalZone. weaBus) annotation (Line(
      points={{228,38},{220,38},{220,16},{212,16},{212,14},{204,14}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{228,38},{219,38},{219,-6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(thermalZone.ventTemp,weaBus. TDryBul) annotation (Line(points={{205.3,
          10.1},{235.35,10.1},{235.35,-6},{219,-6}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(const.y,thermalZone. ventRate) annotation (Line(points={{189.5,-21},{
          189.5,-4},{201,-4},{201,5.6}},              color={0,0,127}));
  connect(internalGains.y,thermalZone. intGains)
    annotation (Line(points={{189.5,-42.5},{186,-42.5},{186,5.6}},
                                                          color={0,0,127}));
  connect(idealConditioning.port, thermalZone.intGainsRad) annotation (Line(
        points={{166,22},{174,22},{174,13},{184,13}}, color={191,0,0}));
  connect(negate.u, switch1.y) annotation (Line(points={{134.8,0},{140,0},{140,
          1.11022e-15},{141.2,1.11022e-15}}, color={0,0,127}));
  connect(switch2.y, negate1.u)
    annotation (Line(points={{141.2,-24},{134.8,-24}}, color={0,0,127}));
  connect(HeatFlowBuildingNeed.y, switch1.u1) annotation (Line(points={{141.2,
          49},{132,49},{132,12},{170,12},{170,6.4},{159.6,6.4}}, color={0,0,127}));
  connect(HeatFlowBuildingNeed.y, switch2.u3) annotation (Line(points={{141.2,
          49},{132,49},{132,12},{170,12},{170,-30.4},{159.6,-30.4}}, color={0,0,
          127}));
  connect(HeatFlowBuildingNeed.y, lessEqualThreshold.u) annotation (Line(points=
         {{141.2,49},{134.6,49},{134.6,49},{129,49}}, color={0,0,127}));
  connect(lessEqualThreshold.y, switch1.u2) annotation (Line(points={{117.5,49},
          {114,49},{114,-10},{164,-10},{164,0},{159.6,0}}, color={255,0,255}));
  connect(lessEqualThreshold.y, switch2.u2) annotation (Line(points={{117.5,49},
          {114,49},{114,-10},{164,-10},{164,-24},{159.6,-24}}, color={255,0,255}));
  connect(const1.y, switch2.u1) annotation (Line(points={{189.5,-59},{168,-59},
          {168,-17.6},{159.6,-17.6}},color={0,0,127}));
  connect(const1.y, switch1.u3) annotation (Line(points={{189.5,-59},{168,-59},
          {168,-6.4},{159.6,-6.4}},color={0,0,127}));
  connect(cellarTemperature.port, coldStorage.heatPort)
    annotation (Line(points={{188,-76},{50,-76},{50,6},{49.2,6}},
                                                        color={191,0,0}));
  connect(cellarTemperature.port, heatStorage.heatPort)
    annotation (Line(points={{188,-76},{49.2,-76}},         color={191,0,0}));
  connect(returnTemperature, movMea.y)
    annotation (Line(points={{-144,-120},{-144,-100.6}}, color={0,0,127}));
  connect(returnTemSensor.T, movMea.u) annotation (Line(points={{-107,9.2},{
          -107,-86},{-144,-86},{-144,-86.8}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-160,-120},{200,80}})),
    Icon(coordinateSystem(extent={{-160,-120},{200,80}})));
end GeothermalHeatPumpControlledBase;
