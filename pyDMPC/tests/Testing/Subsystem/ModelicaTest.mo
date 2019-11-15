within Testing.Subsystem;
model ModelicaTest
  Modelica.Blocks.Sources.Constant Test(k=20)
    annotation (Placement(transformation(extent={{-32,-42},{42,32}})));
  Modelica.Blocks.Sources.CombiTimeTable variation(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    columns=2:3,
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Testing/Subsystem/variation.txt"))
                                    "Table with control input"
                                                            annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-82,74})));
  Modelica.Blocks.Sources.CombiTimeTable decisionVariables(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    tableName="tab1",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2},
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Testing/Subsystem/decisionVariables.txt"))
    "Table with decision variables"              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,74})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=3600,
      Interval=10,
      Tolerance=0.001));
end ModelicaTest;
