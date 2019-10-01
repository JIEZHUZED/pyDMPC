within ModelicaModels.SubsystemModels.DetailedModels.Geo;
model GeothermalHeatPump "Example of a geothermal heat pump systemreplaceable package Water = AixLib.Media.Water;"
  extends Modelica.Icons.Example;
  extends
    ModelicaModels.Subsystems.Geo.BaseClasses.GeothermalHeatPumpControlledBase(
    redeclare
      AixLib.Fluid.Examples.GeothermalHeatPump.Components.BoilerStandAlone
      PeakLoadDevice(redeclare package Medium = Water),
    vol1(V=0.5),
    vol2(V=0.5),
    resistanceGeothermalSource(m_flow_nominal=16),
    pumpGeothermalSource(m_flow_nominal=8),
    boundary,
    variation(table=[0,285]),
    decisionVariables(table=[0.0,273.15 + 35]),
    geothField_sink1(T=T_start_cold[1]),
    pumpCondenser(m_flow_nominal=8),
    pumpHeatConsumer(m_flow_nominal=8),
    heatPumpTab(tablePower=[0,266.15,275.15,280.15,283.15,293.15; 308.15,1650,
          1700,1750,1850,1900; 323.15,2250,2200,2300,2500,2550],
        tableHeatFlowCondenser=[0,266.16,275.15,280.15,283.15,293.15; 308.15,
          4850,5800,6500,7400,8150; 323.15,5000,5600,6450,8350,8750]));

  AixLib.Fluid.Sources.Boundary_pT coldConsumerFlow(redeclare package Medium =
        Water, nPorts=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={94,-20})));
  AixLib.Fluid.Sources.Boundary_pT heatConsumerReturn(
    redeclare package Medium = Water,
    nPorts=1,
    T=303.15) "Source representing heat consumer" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={112,-106})));
  Modelica.Blocks.Sources.Constant pressureDifference(k=20000)
    "Pressure difference used for all pumps"                   annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={72,6})));
  Modelica.Blocks.Sources.Constant const(k=0)
    "Pressure difference used for all pumps" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={150,-10})));
  Modelica.Blocks.Math.Gain negate1(k=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={116,-18})));
  Modelica.Blocks.Math.Gain negate2(k=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=180,
        origin={116,2})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    "Pressure difference used for all pumps" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={134,2})));
  Modelica.Blocks.Sources.Constant const2(k=4)
    "Infiltration rate"
    annotation (Placement(transformation(extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-153,29})));
  Modelica.Blocks.Sources.Constant T_set_ColdStorage(k=279.15)
    "Infiltration rate" annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-153,45})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{-140,16},{-130,26}})));
  Subsystems.Geo.BaseClasses.geothermalFieldController                       geothermalFieldControllerCold(bandwidth=
       275.15)
    "Controls the heat exchange with the geothermal field and the cold storage"
    annotation (Placement(transformation(extent={{-104,38},{-88,54}})));
  AixLib.Controls.HeatPump.HPControllerOnOff hPControllerOnOff(bandwidth=5)
    "Controls the temperature in the heat storage by switching the heat pump on or off"
    annotation (Placement(transformation(extent={{-78,62},{-58,82}})));
  Subsystems.Geo.BaseClasses.geothermalFieldController                       geothermalFieldControllerHeat(bandwidth=
       275.15)
    "Controls the heat exchange with the geothermal field and the heat storage"
    annotation (Placement(transformation(extent={{-96,-34},{-80,-18}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature cellarTemperature(T=284.15)
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={194,-76})));
equation
  connect(resistanceColdConsumerFlow.port_b,coldConsumerFlow. ports[1])
    annotation (Line(points={{80,-20},{88,-20}},            color={0,127,255}));
  connect(pressureDifference.y, pumpColdConsumer.dp_in) annotation (Line(points={{65.4,6},
          {55,6},{55,-11.6}},                        color={0,0,127}));
  connect(pressureDifference.y, pumpHeatConsumer.dp_in) annotation (Line(points={{65.4,6},
          {62,6},{62,-36},{55,-36},{55,-41.6}},                        color={0,
          0,127}));
  connect(resistanceHeatConsumerReturn.port_a,heatConsumerReturn. ports[1])
    annotation (Line(points={{100,-106},{106,-106}},          color={0,127,255}));
  connect(pressureDifference.y, pumpEvaporator.dp_in) annotation (Line(points={{65.4,6},
          {56,6},{56,54},{7,54},{7,44.4}},                        color={0,0,
          127}));
  connect(pressureDifference.y, pumpCondenser.dp_in) annotation (Line(points={{65.4,6},
          {62,6},{62,-36},{-1,-36},{-1,-89.6}},               color={0,0,127}));
  connect(pumpGeothermalSource.dp_in,pressureDifference. y) annotation (Line(
        points={{-89,-45.6},{-89,-36},{62,-36},{62,6},{65.4,6}},       color={0,
          0,127}));
  connect(integrator.u, PeakLoadDevice.chemicalEnergyFlowRate) annotation (Line(
        points={{-62,-86.8},{-62,-78},{-26,-78},{-26,-116},{74,-116},{74,-76},{
          90.77,-76},{90.77,-56.54}}, color={0,0,127}));
  connect(const.y, negate1.u) annotation (Line(points={{143.4,-10},{116,-10},{
          116,-13.2}}, color={0,0,127}));
  connect(prescribedHeatFlow.Q_flow, negate1.y)
    annotation (Line(points={{116,-28},{116,-22.4}}, color={0,0,127}));
  connect(prescribedHeatFlow1.Q_flow, negate2.y)
    annotation (Line(points={{96,2},{111.6,2}}, color={0,0,127}));
  connect(negate2.u, const1.y)
    annotation (Line(points={{120.8,2},{127.4,2}}, color={0,0,127}));
  connect(T_set_ColdStorage.y, geothermalFieldControllerCold.Setpoint)
    annotation (Line(points={{-147.5,45},{-128,45},{-128,51.6},{-104,51.6}},
        color={0,0,127}));
  connect(const2.y,add1. u1) annotation (Line(points={{-147.5,29},{-141,29},{
          -141,24}},
                color={0,0,127}));
  connect(add1.y,geothermalFieldControllerHeat. Setpoint) annotation (Line(
        points={{-129.5,21},{-126,21},{-126,-20.4},{-96,-20.4}},  color={0,0,127}));
  connect(geothermalFieldControllerCold.valveOpening1, valve1.y) annotation (
      Line(points={{-87.04,50.8},{-78,50.8},{-78,30.4}}, color={0,0,127}));
  connect(geothermalFieldControllerCold.valveOpening1, valveColdStorage.y)
    annotation (Line(points={{-87.04,50.8},{-52,50.8},{-52,46.4}}, color={0,0,127}));
  connect(geothermalFieldControllerCold.valveOpening2, valve.y) annotation (
      Line(points={{-87.04,41.2},{-86,41.2},{-86,-3.6}}, color={0,0,127}));
  connect(geothermalFieldControllerCold.valveOpening2, valveHeatSource.y)
    annotation (Line(points={{-87.04,41.2},{-86,41.2},{-86,1},{-68.4,1}}, color=
         {0,0,127}));
  connect(valveHeatSink.y,geothermalFieldControllerHeat. valveOpening1)
    annotation (Line(points={{-32,-41.6},{-32,-21.2},{-79.04,-21.2}},
                   color={0,0,127}));
  connect(geothermalFieldControllerHeat.valveOpening2, valveHeatStorage.y)
    annotation (Line(points={{-79.04,-30.8},{-56,-30.8},{-56,-63},{-26.4,-63}},
        color={0,0,127}));
  connect(getTStorageUpper.y, heatStorageTemperature) annotation (Line(points={
          {-139,74},{-122,74},{-122,60},{60,60},{60,80}}, color={0,0,127}));
  connect(getTStorageLower.y, coldStorageTemperature)
    annotation (Line(points={{-139,58},{78,58},{78,80}}, color={0,0,127}));
  connect(decisionVariables.y[1], add1.u2) annotation (Line(points={{-145.3,7},
          {-145.3,18},{-141,18}}, color={0,0,127}));
  connect(getTStorageUpper.y, hPControllerOnOff.T_meas)
    annotation (Line(points={{-139,74},{-78,74},{-78,76}}, color={0,0,127}));
  connect(getTStorageLower.y, geothermalFieldControllerCold.temperature)
    annotation (Line(points={{-139,58},{-108,58},{-108,46},{-104,46}}, color={0,
          0,127}));
  connect(getTStorageUpper.y, geothermalFieldControllerHeat.temperature)
    annotation (Line(points={{-139,74},{-122,74},{-122,-26},{-96,-26}}, color={
          0,0,127}));
  connect(decisionVariables.y[1], hPControllerOnOff.T_set) annotation (Line(
        points={{-145.3,7},{-145.3,22},{-146,22},{-146,36},{-112,36},{-112,68},
          {-78,68}}, color={0,0,127}));
  connect(cellarTemperature.port, heatStorage.heatPort)
    annotation (Line(points={{188,-76},{49.2,-76}},         color={191,0,0}));
  connect(cellarTemperature.port, coldStorage.heatPort)
    annotation (Line(points={{188,-76},{50,-76},{50,6},{49.2,6}},
                                                        color={191,0,0}));
  connect(hPControllerOnOff.heatPumpControlBus, heatPumpControlBus) annotation (
     Line(
      points={{-58.05,72.05},{-32.025,72.05},{-32.025,79},{-0.5,79}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
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
end GeothermalHeatPump;
