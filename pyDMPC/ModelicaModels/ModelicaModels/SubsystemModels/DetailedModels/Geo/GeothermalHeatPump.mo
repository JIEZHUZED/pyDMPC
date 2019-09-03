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
    pumpGeothermalSource(m_flow_nominal=16),
    boundary,
    tableInternalGains(fileName=
          "C:/mst/pyDMPC/pyDMPC/ModelicaModels/ModelicaModels/Subsystems/Geo/BaseClasses/TEASER_BuildingSets/InternalGains_ERC.mat"),
    tableTSet(fileName=
          "C:/mst/pyDMPC/pyDMPC/ModelicaModels/ModelicaModels/Subsystems/Geo/BaseClasses/TEASER_BuildingSets/Tset_ERC.mat"),
    tableAHU(fileName=
          "C:/mst/pyDMPC/pyDMPC/ModelicaModels/ModelicaModels/Subsystems/Geo/BaseClasses/TEASER_BuildingSets/AHU_ERC.mat"),
    weaDat(filNam=
          "C:/mst/pyDMPC/pyDMPC/ModelicaModels/ModelicaModels/Subsystems/Geo/BaseClasses/TEASER_BuildingSets/DEU_BW_Mannheim_107290_TRY2010_12_Jahr_BBSR.mos"),
    variation(table=[0,285]),
    const(k=293.15),
    decisionVariables(table=[0.0,273.15 + 35]),
    geothField_sink1(T=T_start_cold[1]),
    integrator1(k=3600),
    integrator(k=3600));

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
  AixLib.Controls.HeatPump.HPControllerOnOff hPControllerOnOff(bandwidth=5)
    "Controls the temperature in the heat storage by switching the heat pump on or off"
    annotation (Placement(transformation(extent={{-78,62},{-58,82}})));
  AixLib.Fluid.Examples.GeothermalHeatPump.Control.geothermalFieldController geothermalFieldControllerCold(
      temperature_low=273.15 + 6, temperature_high=273.15 + 8)
    "Controls the heat exchange with the geothermal field and the cold storage"
    annotation (Placement(transformation(extent={{-100,28},{-84,44}})));
  AixLib.Fluid.Examples.GeothermalHeatPump.Control.geothermalFieldController geothermalFieldControllerHeat
    "Controls the heat exchange with the geothermal field and the heat storage"
    annotation (Placement(transformation(extent={{-100,-34},{-84,-18}})));
  Modelica.Blocks.Math.Gain negate(k=-1)
    annotation (Placement(transformation(extent={{110,-2},{102,6}})));
  Modelica.Blocks.Math.Gain negate1(k=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={116,-22})));
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
  connect(hPControllerOnOff.heatPumpControlBus, heatPumpControlBus) annotation (
     Line(
      points={{-58.05,72.05},{-44,72.05},{-44,79},{-0.5,79}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(getTStorageLower.y,geothermalFieldControllerCold. temperature)
    annotation (Line(points={{-139,58},{-122,58},{-108,58},{-108,36},{-100,36}},
        color={0,0,127}));
  connect(geothermalFieldControllerCold.valveOpening1, valveColdStorage.y)
    annotation (Line(points={{-83.04,40.8},{-82,40.8},{-82,40},{-82,52},{-82,54},
          {-52,54},{-52,46.4}}, color={0,0,127}));
  connect(geothermalFieldControllerCold.valveOpening2, valveHeatSource.y)
    annotation (Line(points={{-83.04,31.2},{-82,31.2},{-82,1},{-68.4,1}}, color=
         {0,0,127}));
  connect(getTStorageUpper.y,geothermalFieldControllerHeat. temperature)
    annotation (Line(points={{-139,74},{-122,74},{-122,-26},{-100,-26}}, color=
          {0,0,127}));
  connect(valveHeatSink.y, geothermalFieldControllerHeat.valveOpening1)
    annotation (Line(points={{-30,-45.6},{-30,-45.6},{-30,-32},{-30,-21.2},{-83.04,
          -21.2}}, color={0,0,127}));
  connect(geothermalFieldControllerHeat.valveOpening2, valveHeatStorage.y)
    annotation (Line(points={{-83.04,-30.8},{-56,-30.8},{-56,-63},{-26.4,-63}},
        color={0,0,127}));
  connect(getTStorageUpper.y, hPControllerOnOff.T_meas) annotation (Line(points=
         {{-139,74},{-108,74},{-108,76},{-78,76}}, color={0,0,127}));
  connect(prescribedHeatFlow1.Q_flow, negate.y)
    annotation (Line(points={{96,2},{101.6,2}}, color={0,0,127}));
  connect(prescribedHeatFlow.Q_flow, negate1.y)
    annotation (Line(points={{116,-28},{116,-26.4}}, color={0,0,127}));
  connect(integrator.u, PeakLoadDevice.chemicalEnergyFlowRate) annotation (Line(
        points={{-62,-86.8},{-62,-78},{-26,-78},{-26,-116},{74,-116},{74,-76},{
          90.77,-76},{90.77,-56.54}}, color={0,0,127}));
  connect(negate1.u, sum1.y) annotation (Line(points={{116,-17.2},{116.5,-17.2},
          {116.5,-16.4},{132,-16.4}}, color={0,0,127}));
  connect(negate.u, sum2.y)
    annotation (Line(points={{110.8,2},{111.6,2}}, color={0,0,127}));
  connect(multizone.PCooler[1], sum2.u[1]) annotation (Line(points={{145,
          0.166667},{122,0.166667},{122,2.4},{120.8,2.4}}, color={0,0,127}));
  connect(multizone.PHeater[1], sum1.u[1]) annotation (Line(points={{145,
          2.16667},{131.6,2.16667},{131.6,-7.2}}, color={0,0,127}));
  connect(multizone.PCoolAHU, sum2.u[2]) annotation (Line(points={{145,5},{122,
          5},{122,1.6},{120.8,1.6}}, color={0,0,127}));
  connect(multizone.PHeatAHU, sum1.u[2]) annotation (Line(points={{145,7},{132.4,
          7},{132.4,-7.2}},       color={0,0,127}));
  connect(decisionVariables.y[1], hPControllerOnOff.T_set) annotation (Line(
        points={{-145.3,7},{-126,7},{-126,68},{-78,68}}, color={0,0,127}));
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
