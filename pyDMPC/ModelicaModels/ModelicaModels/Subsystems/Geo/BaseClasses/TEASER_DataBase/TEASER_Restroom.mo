within ModelicaModels.Subsystems.Geo.BaseClasses.TEASER_DataBase;
record TEASER_Restroom "TEASER_Restroom"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 126.0,
    AZone = 36.0,
    alphaRad = 5.0,
    lat = 0.88645272708792,
    nOrientations = 6,
    AWin = {1.5834300444138203, 0.0, 1.5834300444138203, 1.0342016521968527, 0.0, 1.0342016521968527},
    ATransparent = {1.5834300444138203, 0.0, 1.5834300444138203, 1.0342016521968527, 0.0, 1.0342016521968527},
    alphaWin = 2.6999999999999997,
    RWin = 0.06842233681837134,
    gWin = 0.67,
    UWin= 1.8936557576825381,
    ratioWinConRad = 0.03,
    AExt = {4.75029013324146, 10.35, 4.75029013324146, 3.1026049565905587, 10.35, 3.1026049565905587},
    alphaExt = 2.131409127563372,
    nExt = 1,
    RExt = {0.0008751644202251357},
    RExtRem = 0.04835683850800078,
    CExt = {11205715.175427586},
    AInt = 159.0,
    alphaInt = 2.3603773584905663,
    nInt = 1,
    RInt = {0.0004143493584035729},
    CInt = {18657624.848936398},
    AFloor = 0.0,
    alphaFloor = 0.0,
    nFloor = 1,
    RFloor = {0.00001},
    RFloorRem =  0.00001,
    CFloor = {0.00001},
    ARoof = 0.0,
    alphaRoof = 0.0,
    nRoof = 1,
    RRoof = {0.00001},
    RRoofRem = 0.00001,
    CRoof = {0.00001},
    nOrientationsRoof = 1,
    tiltRoof = {0.0},
    aziRoof = {0.0},
    wfRoof = {0.0},
    aRoof = 0.0,
    aExt = 0.5,
    TSoil = 286.15,
    alphaWallOut = 20.000000000000004,
    alphaRadWall = 5.0,
    alphaWinOut = 20.0,
    alphaRoofOut = 0.0,
    alphaRadRoof = 0.0,
    tiltExtWalls = {1.5707963267948966, 0.0, 1.5707963267948966, 1.5707963267948966, 0.0, 1.5707963267948966},
    aziExtWalls = {0.0, 0.0, 3.141592653589793, -1.5707963267948966, 0.0, 1.5707963267948966},
    wfWall = {0.12770320628717274, 0.2600068892923347, 0.12770320628717274, 0.08340808449287808, 0.0, 0.08340808449287808},
    wfWin = {0.3024547048509644, 0.0, 0.3024547048509644, 0.19754529514903565, 0.0, 0.19754529514903565},
    wfGro = 0.3177705291475636,
    nrPeople = 0.0,
    ratioConvectiveHeatPeople = 0.5,
    nrPeopleMachines = 0.0,
    ratioConvectiveHeatMachines = 0.75,
    lightingPower = 11.1,
    ratioConvectiveHeatLighting = 0.9,
    useConstantACHrate = false,
    baseACH = 0.2,
    maxUserACH = 1.0,
    maxOverheatingACH = {3.0, 2.0},
    maxSummerACH = {1.0, 283.15, 290.15},
    winterReduction = {0.2, 273.15, 283.15},
    withAHU = false,
    minAHU = 0.0,
    maxAHU = 8.0,
    hHeat = 1044.4970411101394,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = true,
    hCool = 0,
    lCool = 0.0,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false);
end TEASER_Restroom;
