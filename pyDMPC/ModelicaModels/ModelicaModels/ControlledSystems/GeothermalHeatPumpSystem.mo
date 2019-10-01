within ModelicaModels.ControlledSystems;
model GeothermalHeatPumpSystem
  "Example of a geothermal heat pump systemreplaceable package Water = AixLib.Media.Water;"
  extends Modelica.Icons.Example;
  extends ModelicaModels.BaseClasses.GeothermalHeatPumpControlledBase(
    geothField(T=285.15),
    redeclare
      AixLib.Fluid.Examples.GeothermalHeatPump.Components.BoilerStandAlone
      PeakLoadDevice(redeclare package Medium = Water),
    vol1(V=0.5,
      nPorts=3,
      T_start=279.15),
    vol2(V=0.5,
      nPorts=3,
      T_start=318.15),
    resistanceGeothermalSource(m_flow_nominal=baseParam.m_flow_tot),
    pumpGeothermalSource(T_start=285.15),
    pumpHeatConsumer(T_start=285.15),
    pumpCondenser(T_start=285.15),
    pumpEvaporator(T_start=285.15),
    pumpColdConsumer(T_start=279.15),
    thermalZone(zoneParam=
          Subsystems.Geo.BaseClasses.TEASER_DataBase.TEASER_Office()),
    negate1(k=-1),
    negate(k=-1),
    heatPumpTab(tablePower=[0,266.15,275.15,280.15,283.15,293.15; 308.15,1650,1700,
          1750,1850,1900; 323.15,2250,2200,2300,2500,2550],
        tableHeatFlowCondenser=[0,266.16,275.15,280.15,283.15,293.15; 308.15,4850,
          5800,6500,7400,8150; 323.15,5000,5600,6450,8350,8750]),
    movMea(delta=7200));


  AixLib.Fluid.Sources.Boundary_pT coldConsumerFlow(redeclare package Medium =
        Water,
    nPorts=1,
    T=279.15)            annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={100,-20})));
  AixLib.Fluid.Sources.Boundary_pT heatConsumerReturn(
    redeclare package Medium = Water,
    nPorts=1,
    T=313.15) "Source representing heat consumer" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={118,-106})));
  Modelica.Blocks.Sources.Constant pressureDifference(k=60000)
    "Pressure difference used for all pumps"                   annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={72,6})));
  Subsystems.Geo.BaseClasses.geothermalFieldController                       geothermalFieldControllerCold(bandwidth=
       275.15)
    "Controls the heat exchange with the geothermal field and the cold storage"
    annotation (Placement(transformation(extent={{-104,40},{-88,56}})));
  Subsystems.Geo.BaseClasses.geothermalFieldController                       geothermalFieldControllerHeat(bandwidth=
       275.15)
    "Controls the heat exchange with the geothermal field and the heat storage"
    annotation (Placement(transformation(extent={{-100,-34},{-84,-18}})));
  Modelica.Blocks.Interfaces.RealInput traj "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-170,-90},{-150,-70}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin fromKelvin
    annotation (Placement(transformation(extent={{-144,-86},{-132,-74}})));
  AixLib.Controls.HeatPump.HPControllerOnOff hPControllerOnOff(bandwidth=5)
    "Controls the temperature in the heat storage by switching the heat pump on or off"
    annotation (Placement(transformation(extent={{-78,62},{-58,82}})));
  Modelica.Blocks.Interfaces.RealInput T_set_HeatStorage
    "Setpoint of the Heat Storage"
    annotation (Placement(transformation(extent={{-166,8},{-154,20}}),
        iconTransformation(extent={{-160,20},{-120,60}})));
  Modelica.Blocks.Sources.Constant const2(k=4)
    "Infiltration rate"
    annotation (Placement(transformation(extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-153,29})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{-134,16},{-124,26}})));
  Modelica.Blocks.Sources.Constant T_set_ColdStorage(k=279.15)
    "Infiltration rate" annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-153,45})));
equation
  connect(pressureDifference.y, pumpColdConsumer.dp_in) annotation (Line(points={{65.4,6},
          {55,6},{55,-11.6}},                        color={0,0,127}));
  connect(pressureDifference.y, pumpHeatConsumer.dp_in) annotation (Line(points={{65.4,6},
          {62,6},{62,-36},{55,-36},{55,-41.6}},                        color={0,
          0,127}));
  connect(pressureDifference.y, pumpEvaporator.dp_in) annotation (Line(points={{65.4,6},
          {56,6},{56,54},{7,54},{7,44.4}},                        color={0,0,
          127}));
  connect(pressureDifference.y, pumpCondenser.dp_in) annotation (Line(points={{65.4,6},
          {62,6},{62,-36},{-1,-36},{-1,-89.6}},               color={0,0,127}));
  connect(pumpGeothermalSource.dp_in,pressureDifference. y) annotation (Line(
        points={{-89,-45.6},{-89,-36},{62,-36},{62,6},{65.4,6}},       color={0,
          0,127}));
  connect(getTStorageLower.y,geothermalFieldControllerCold. temperature)
    annotation (Line(points={{-139,58},{-108,58},{-108,48},{-104,48}},
        color={0,0,127}));
  connect(geothermalFieldControllerCold.valveOpening2, valveHeatSource.y)
    annotation (Line(points={{-87.04,43.2},{-86,43.2},{-86,1},{-68.4,1}}, color=
         {0,0,127}));
  connect(getTStorageUpper.y,geothermalFieldControllerHeat. temperature)
    annotation (Line(points={{-139,74},{-122,74},{-122,-26},{-100,-26}}, color=
          {0,0,127}));
  connect(valveHeatSink.y, geothermalFieldControllerHeat.valveOpening1)
    annotation (Line(points={{-30,-45.6},{-30,-21.2},{-83.04,-21.2}},
                   color={0,0,127}));
  connect(geothermalFieldControllerHeat.valveOpening2, valveHeatStorage.y)
    annotation (Line(points={{-83.04,-30.8},{-56,-30.8},{-56,-63},{-26.4,-63}},
        color={0,0,127}));
  connect(integrator.u, PeakLoadDevice.chemicalEnergyFlowRate) annotation (Line(
        points={{-62,-86.8},{-62,-78},{-26,-78},{-26,-116},{74,-116},{74,-76},{
          90.77,-76},{90.77,-56.54}}, color={0,0,127}));
  connect(traj, fromKelvin.Kelvin)
    annotation (Line(points={{-160,-80},{-145.2,-80}}, color={0,0,127}));
  connect(hPControllerOnOff.heatPumpControlBus, heatPumpControlBus) annotation (
     Line(
      points={{-58.05,72.05},{-44,72.05},{-44,79},{-0.5,79}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(getTStorageUpper.y, hPControllerOnOff.T_meas) annotation (Line(points=
         {{-139,74},{-108.5,74},{-108.5,76},{-78,76}}, color={0,0,127}));
  connect(coldConsumerFlow.ports[1], vol1.ports[3]) annotation (Line(points={{94,
          -20},{90,-20},{90,30},{86,30}}, color={0,127,255}));
  connect(heatConsumerReturn.ports[1], vol2.ports[3]) annotation (Line(points={{
          112,-106},{110,-106},{110,-54},{106,-54}}, color={0,127,255}));
  connect(geothermalFieldControllerCold.valveOpening2, valve.y) annotation (
      Line(points={{-87.04,43.2},{-86,43.2},{-86,-3.6}}, color={0,0,127}));
  connect(geothermalFieldControllerCold.valveOpening1, valveColdStorage.y)
    annotation (Line(points={{-87.04,52.8},{-52,52.8},{-52,46.4}}, color={0,0,127}));
  connect(geothermalFieldControllerCold.valveOpening1, valve1.y) annotation (
      Line(points={{-87.04,52.8},{-78,52.8},{-78,32.4}}, color={0,0,127}));
  connect(const2.y, add1.u1) annotation (Line(points={{-147.5,29},{-135,29},{-135,
          24}}, color={0,0,127}));
  connect(add1.y, geothermalFieldControllerHeat.Setpoint) annotation (Line(
        points={{-123.5,21},{-120,21},{-120,-20.4},{-100,-20.4}}, color={0,0,127}));
  connect(T_set_HeatStorage, hPControllerOnOff.T_set)
    annotation (Line(points={{-160,14},{-160,68},{-78,68}}, color={0,0,127}));
  connect(T_set_HeatStorage, add1.u2) annotation (Line(points={{-160,14},{-150,
          14},{-150,18},{-135,18}}, color={0,0,127}));
  connect(T_set_ColdStorage.y, geothermalFieldControllerCold.Setpoint)
    annotation (Line(points={{-147.5,45},{-128,45},{-128,53.6},{-104,53.6}},
        color={0,0,127}));
  annotation (experiment(StopTime=86400, Interval=10), Documentation(revisions="<html>
<ul>
<li>
May 19, 2017, by Marc Baranski:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Simple stand-alone model of a combined heat and cold supply system.
The geothermal heat pump can either transport heat </p>
<ul>
<li>
from the cold to the heat storage
</li>
<li>
from the cold storage to the geothermal field (heat storage disconnected)
</li>
<li>
from the geothermal field to the heat storage
</li>
</ul>
<p>In the flow line of the heating circuit a boiler is connected as a peak load device.
Consumers are modeled as sinks are sources with a constant temperature.</p>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-120},{200,80}})),
    Icon(coordinateSystem(extent={{-160,-120},{200,80}})));
end GeothermalHeatPumpSystem;
