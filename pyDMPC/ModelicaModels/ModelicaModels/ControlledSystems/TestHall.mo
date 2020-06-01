within ModelicaModels.ControlledSystems;
model TestHall
  Subsystems.Hall hall
    annotation (Placement(transformation(extent={{-10,-10},{14,10}})));
  Subsystems.Office office
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Modelica.Blocks.Interfaces.RealInput T_in1 "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}})));
  Modelica.Blocks.Interfaces.RealInput T_CCA1 "Input signal connector"
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}})));
  Modelica.Blocks.Interfaces.RealOutput thermostat1
    annotation (Placement(transformation(extent={{90,82},{110,102}})));
  Modelica.Blocks.Interfaces.RealOutput T_room1
    annotation (Placement(transformation(extent={{90,64},{110,84}})));
  Modelica.Blocks.Interfaces.RealOutput V_flow
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput T_hall
    annotation (Placement(transformation(extent={{90,-28},{110,-8}})));
  Modelica.Blocks.Interfaces.RealOutput T_CCA_act "Value of Real output"
    annotation (Placement(transformation(extent={{90,-68},{110,-48}})));
  Modelica.Blocks.Interfaces.RealOutput T_AHU
    annotation (Placement(transformation(extent={{90,-44},{110,-24}})));
  Modelica.Blocks.Sources.RealExpression timer(y=time)
    annotation (Placement(transformation(extent={{-14,-78},{8,-60}})));
  Modelica.Blocks.Interfaces.RealOutput simTime "Value of Real output"
    annotation (Placement(transformation(extent={{90,-80},{110,-60}})));
  Modelica.Blocks.Interfaces.RealInput Tset "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,30},{-80,70}})));
  Subsystems.BaseClasses.IdealHeater idealHeater
    annotation (Placement(transformation(extent={{-48,6},{-28,26}})));
  Modelica.Blocks.Interfaces.RealOutput energy "Value of Real output"
    annotation (Placement(transformation(extent={{90,-108},{110,-88}})));
  Modelica.Blocks.Sources.RealExpression energyMeter(y=integrator.y + office.energy
         + office2.energy + idealHeater.energy + hall.CCA_energy)
    annotation (Placement(transformation(extent={{-14,-106},{8,-88}})));
  Modelica.Blocks.Sources.RealExpression AHU_energy(y=1.2*16000/3600*1000*(
        T_in1 - 10)*0.3)
    annotation (Placement(transformation(extent={{-100,-90},{-78,-72}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/3600000)
    annotation (Placement(transformation(extent={{-68,-86},{-58,-76}})));
  Subsystems.Hall hall_ref
    annotation (Placement(transformation(extent={{-12,-50},{12,-30}})));
  Modelica.Blocks.Sources.Constant T_AHU_ref(k=23)
    "Air volume flow rate, could be an initial value"
    annotation (Placement(transformation(extent={{-100,-46},{-90,-36}})));
  Subsystems.BaseClasses.IdealHeater idealHeater_ref
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Blocks.Sources.Constant T_outside_ref(k=281.51 - 273.15)
    "Air volume flow rate, could be an initial value"
    annotation (Placement(transformation(extent={{-100,-64},{-90,-54}})));
  Modelica.Blocks.Sources.RealExpression AHU_energy_ref(y=1.2*16000/3600*1000*(
        T_AHU_ref.k - 10)*0.3)
    annotation (Placement(transformation(extent={{-100,-106},{-78,-88}})));
  Modelica.Blocks.Continuous.Integrator integrator_ref(k=1/3600000)
    annotation (Placement(transformation(extent={{-68,-102},{-58,-92}})));
  Modelica.Blocks.Sources.RealExpression energyMeter_ref(y=integrator_ref.y +
        office.energy_ref + office2.energy_ref + idealHeater_ref.energy +
        hall_ref.CCA_energy)
    annotation (Placement(transformation(extent={{-14,-92},{8,-74}})));
  Modelica.Blocks.Interfaces.RealOutput energy_ref "Value of Real output"
    annotation (Placement(transformation(extent={{90,-94},{110,-74}})));
  Subsystems.Office office2(startTime=-7200)
    annotation (Placement(transformation(extent={{-10,52},{10,72}})));
  Modelica.Blocks.Interfaces.RealOutput thermostat2
    annotation (Placement(transformation(extent={{90,46},{110,66}})));
  Modelica.Blocks.Interfaces.RealOutput T_room2
    annotation (Placement(transformation(extent={{90,28},{110,48}})));
  Modelica.Blocks.Interfaces.RealInput Tset2
                                            "Prescribed fluid temperature"
    annotation (Placement(transformation(extent={{-120,62},{-80,102}})));
equation
  connect(hall.T_in, T_in1) annotation (Line(points={{-10,1.8},{-56,1.8},{-56,
          10},{-100,10}}, color={0,0,127}));
  connect(hall.T_CCA, T_CCA1) annotation (Line(points={{-10,-8},{-56,-8},{-56,
          -20},{-100,-20}}, color={0,0,127}));
  connect(office.thermostat, thermostat1)
    annotation (Line(points={{10,92},{100,92}}, color={0,0,127}));
  connect(office.T_room, T_room1) annotation (Line(points={{10,88},{54,88},{54,
          74},{100,74}}, color={0,0,127}));
  connect(hall.V_flow, V_flow)
    annotation (Line(points={{14,9},{56,9},{56,0},{100,0}}, color={0,0,127}));
  connect(hall.T_hall, T_hall) annotation (Line(points={{14,2.6},{44,2.6},{44,
          -18},{100,-18}}, color={0,0,127}));
  connect(hall.T_CCA_act, T_CCA_act) annotation (Line(points={{13.8,-6.4},{13.8,
          -6},{34,-6},{34,-58},{100,-58}}, color={0,0,127}));
  connect(hall.T_AHU, T_AHU) annotation (Line(points={{14,0.2},{38,0.2},{38,-34},
          {100,-34}}, color={0,0,127}));
  connect(timer.y, simTime) annotation (Line(points={{9.1,-69},{49.55,-69},{
          49.55,-70},{100,-70}}, color={0,0,127}));
  connect(Tset, office.T_set) annotation (Line(points={{-100,50},{-66,50},{-66,
          91},{-10,91}}, color={0,0,127}));
  connect(T_in1, office.T_in) annotation (Line(points={{-100,10},{-56,10},{-56,
          97},{-10,97}}, color={0,0,127}));
  connect(idealHeater.port1, hall.heatPort1) annotation (Line(points={{-28.6,16},
          {-24,16},{-24,-10},{-10,-10}},       color={191,0,0}));
  connect(hall.T_hall, idealHeater.T) annotation (Line(points={{14,2.6},{34,2.6},
          {34,34},{-52,34},{-52,18},{-48,18},{-48,18.6}},
                                                       color={0,0,127}));
  connect(energyMeter.y, energy) annotation (Line(points={{9.1,-97},{51.55,-97},
          {51.55,-98},{100,-98}}, color={0,0,127}));
  connect(hall_ref.heatPort1, idealHeater_ref.port1) annotation (Line(points={{
          -12,-50},{-22,-50},{-22,-40},{-30.6,-40}}, color={191,0,0}));
  connect(hall_ref.T_in, T_AHU_ref.y) annotation (Line(points={{-12,-38.2},{-16,
          -38.2},{-16,-24},{-68,-24},{-68,-41},{-89.5,-41}}, color={0,0,127}));
  connect(hall_ref.T_hall, idealHeater_ref.T) annotation (Line(points={{12,
          -37.4},{18,-37.4},{18,-22},{-58,-22},{-58,-37.4},{-50,-37.4}}, color=
          {0,0,127}));
  connect(T_outside_ref.y, hall_ref.T_CCA) annotation (Line(points={{-89.5,-59},
          {-26,-59},{-26,-48},{-12,-48}}, color={0,0,127}));
  connect(AHU_energy.y, integrator.u)
    annotation (Line(points={{-76.9,-81},{-69,-81}}, color={0,0,127}));
  connect(AHU_energy_ref.y, integrator_ref.u)
    annotation (Line(points={{-76.9,-97},{-69,-97}}, color={0,0,127}));
  connect(energyMeter_ref.y, energy_ref) annotation (Line(points={{9.1,-83},{
          51.55,-83},{51.55,-84},{100,-84}}, color={0,0,127}));
  connect(T_AHU_ref.y, office.T_in_ref) annotation (Line(points={{-89.5,-41},{
          -68,-41},{-68,46},{-40,46},{-40,85},{-10,85}}, color={0,0,127}));
  connect(office2.thermostat, thermostat2) annotation (Line(points={{10,64},{52,
          64},{52,56},{100,56}}, color={0,0,127}));
  connect(office2.T_room, T_room2) annotation (Line(points={{10,60},{46,60},{46,
          38},{100,38}}, color={0,0,127}));
  connect(Tset2, office2.T_set) annotation (Line(points={{-100,82},{-26,82},{
          -26,63},{-10,63}}, color={0,0,127}));
  connect(T_in1, office2.T_in) annotation (Line(points={{-100,10},{-56,10},{-56,
          69},{-10,69}}, color={0,0,127}));
  connect(T_AHU_ref.y, office2.T_in_ref) annotation (Line(points={{-89.5,-41},{
          -68,-41},{-68,46},{-26,46},{-26,57},{-10,57}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=10));
end TestHall;
