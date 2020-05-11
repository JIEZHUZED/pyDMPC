within ModelicaModels.Subsystems.BaseClasses;
model HallBaseClass "Simplified model of hall 1"
  replaceable package MediumAir = AixLib.Media.Air;
  replaceable package MediumWater = AixLib.Media.Water;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)=8000*1.2/3600
  "Nominal mass flow rate"
  annotation(Dialog(group = "Nominal condition"));

  AixLib.Fluid.MixingVolumes.MixingVolume
                                      volume(
  redeclare package Medium = MediumAir,
    m_flow_nominal=m_flow_nominal,
    nPorts=1,
    V=36*10*10,
    T_start=295.15)
               annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  AixLib.Fluid.FixedResistances.PressureDrop res(redeclare package Medium = MediumAir,
  m_flow_nominal=m_flow_nominal,
      dp_nominal=200)
    annotation (Placement(transformation(extent={{132,-120},{152,-100}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor outdoorAirConductor(G=400)
              "Conducts heat from/to outdoor air"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature outdoorAir
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{58,-50},{78,-30}})));
  Modelica.Blocks.Math.Gain SolarShare(k=100)
    "Share of the total radiation that is actually transported into the hall"
    annotation (Placement(transformation(extent={{34,-46},{46,-34}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor
                                  CCAConductor(G=5000)
    "Conducts heat from water to concrete"
    annotation (Placement(transformation(extent={{30,-160},{50,-140}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor concreteFloor(C=100000000,
      T(fixed=true, start=295.15))
    annotation (Placement(transformation(extent={{60,-144},{80,-124}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor FloorConductor(G=10000)
    "Conducts heat from floor to air"
    annotation (Placement(transformation(extent={{88,-158},{108,-138}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature SupplyWater
    "Supply water to concrete core activiation"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin waterTemperature
    annotation (Placement(transformation(extent={{-28,-106},{-16,-94}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,158},{-80,178}})));
equation
  connect(volume.ports[1], res.port_a) annotation (Line(points={{100,-90},{120,-90},
          {120,-110},{132,-110}},
                             color={0,127,255}));
  connect(outdoorAirConductor.port_b, volume.heatPort)
    annotation (Line(points={{50,-80},{90,-80}},
                                               color={191,0,0}));
  connect(outdoorAirConductor.port_a, outdoorAir.port)
    annotation (Line(points={{30,-80},{20,-80}},
                                               color={191,0,0}));
  connect(prescribedHeatFlow.port, volume.heatPort) annotation (Line(points={{78,-40},
          {80,-40},{80,-80},{90,-80}},   color={191,0,0}));
  connect(prescribedHeatFlow.Q_flow, SolarShare.y)
    annotation (Line(points={{58,-40},{46.6,-40}}, color={0,0,127}));
  connect(CCAConductor.port_b, concreteFloor.port)
    annotation (Line(points={{50,-150},{70,-150},{70,-144}}, color={191,0,0}));
  connect(SupplyWater.port, CCAConductor.port_a)
    annotation (Line(points={{20,-150},{30,-150}}, color={191,0,0}));
  connect(concreteFloor.port, FloorConductor.port_a)
    annotation (Line(points={{70,-144},{70,-148},{88,-148}}, color={191,0,0}));
  connect(FloorConductor.port_b, volume.heatPort) annotation (Line(points={{108,
          -148},{120,-148},{120,-132},{92,-132},{92,-96},{78,-96},{78,-80},{90,-80}},
                                                                          color=
         {191,0,0}));
  connect(waterTemperature.Kelvin, SupplyWater.T) annotation (Line(points={{-15.4,
          -100},{-14,-100},{-14,-150},{-2,-150}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}})),
    experiment(StopTime=3841200, Interval=10),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end HallBaseClass;
