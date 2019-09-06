within ModelicaModels.ControlledSystems;
model GeothermalHeatPumpAggregated
  "Class necessary to be able to FMU-export the actual model"
  GeothermalHeatPumpSystem geothermalHeatPumpSystem
    annotation (Placement(transformation(extent={{-30,-20},{36,16}})));
  Modelica.Blocks.Interfaces.RealInput traj "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-120,-42},{-80,-2}})));
  Modelica.Blocks.Interfaces.RealInput T_set_storage
    "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-120,24},{-80,64}})));
equation
  connect(geothermalHeatPumpSystem.traj, traj) annotation (Line(points={{-30,
          -12.8},{-80,-12.8},{-80,-22},{-100,-22}}, color={0,0,127}));
  connect(geothermalHeatPumpSystem.T_set_storage, T_set_storage) annotation (
      Line(points={{-18.2667,13.84},{-57.1334,13.84},{-57.1334,44},{-100,44}},
        color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=600));
end GeothermalHeatPumpAggregated;
