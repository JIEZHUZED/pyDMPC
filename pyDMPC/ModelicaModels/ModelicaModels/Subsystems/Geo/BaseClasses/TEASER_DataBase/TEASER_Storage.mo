within ModelicaModels.Subsystems.Geo.BaseClasses.TEASER_DataBase;
record TEASER_Storage "TEASER_Storage"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start = 293.15,
    withAirCap = true,
    VAir = 472.5,
    AZone = 135.0,
    alphaRad = 5.0,
    lat = 0.88645272708792,
    nOrientations = 6,
    AWin = {5.937862666551826, 0.0, 5.937862666551826, 3.878256195738198, 0.0, 3.878256195738198},
    ATransparent = {5.937862666551826, 0.0, 5.937862666551826, 3.878256195738198, 0.0, 3.878256195738198},
    alphaWin = 2.7000000000000006,
    RWin = 0.01824595648489902,
    gWin = 0.67,
    UWin= 1.8936557576825384,
    ratioWinConRad = 0.030000000000000002,
    AExt = {17.813587999655475, 38.8125, 17.813587999655475, 11.634768587214595, 38.8125, 11.634768587214595},
    alphaExt = 2.131409127563372,
    nExt = 1,
    RExt = {0.00023337717872670306},
    RExtRem = 0.012895156935466874,
    CExt = {42021431.90785344},
    AInt = 438.75,
    alphaInt = 2.2384615384615385,
    nInt = 1,
    RInt = {0.0001284624220490031},
    CInt = {60871378.62002252},
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
    alphaWallOut = 20.0,
    alphaRadWall = 5.0,
    alphaWinOut = 20.000000000000004,
    alphaRoofOut = 0.0,
    alphaRadRoof = 0.0,
    tiltExtWalls = {1.5707963267948966, 0.0, 1.5707963267948966, 1.5707963267948966, 0.0, 1.5707963267948966},
    aziExtWalls = {0.0, 0.0, 3.141592653589793, -1.5707963267948966, 0.0, 1.5707963267948966},
    wfWall = {0.12770320628717274, 0.26000688929233473, 0.12770320628717274, 0.08340808449287807, 0.0, 0.08340808449287807},
    wfWin = {0.3024547048509643, 0.0, 0.3024547048509643, 0.19754529514903565, 0.0, 0.19754529514903565},
    wfGro = 0.31777052914756365,
    nrPeople = 0.0,
    ratioConvectiveHeatPeople = 0.5,
    nrPeopleMachines = 0.0,
    ratioConvectiveHeatMachines = 0.75,
    lightingPower = 11.3,
    ratioConvectiveHeatLighting = 0.9,
    useConstantACHrate = false,
    baseACH = 0.2,
    maxUserACH = 1.0,
    maxOverheatingACH = {3.0, 2.0},
    maxSummerACH = {1.0, 283.15, 290.15},
    winterReduction = {0.2, 273.15, 283.15},
    withAHU = false,
    minAHU = 0.0,
    maxAHU = 0.5,
    hHeat = 3916.8639041630227,
    lHeat = 0,
    KRHeat = 10000,
    TNHeat = 1,
    HeaterOn = true,
    hCool = 0,
    lCool = 0.0,
    KRCool = 10000,
    TNCool = 1,
    CoolerOn = false);
end TEASER_Storage;
