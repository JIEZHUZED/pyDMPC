within ModelicaModels;
package DataBase "Contians records for the various case studies"
  package Geo

    record GeoRecord

      parameter Modelica.SIunits.MassFlowRate m_flow_tot = 16.0
       "The total mass flow rate circulating through field and
   building";

      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end GeoRecord;

    record borFieDat "Example definition of a borefield data record"
      extends AixLib.Fluid.Geothermal.Borefields.Data.Borefield.Template(
          filDat=ModelicaModels.DataBase.Geo.filDat(),
          soiDat=ModelicaModels.DataBase.Geo.soiDat(),
          conDat=ModelicaModels.DataBase.Geo.conDat());
      annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="borFieDat",
    Documentation(
    info="<html>
<p>This record presents an example on how to define borefield records
using the template in
<a href=\"modelica://AixLib.Fluid.Geothermal.Borefields.Data.Borefield.Template\">
AixLib.Fluid.Geothermal.Borefields.Data.Borefield.Template</a>.</p>
</html>",
    revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
    end borFieDat;

    record conDat "Example definition of a configuration data record"
      extends AixLib.Fluid.Geothermal.Borefields.Data.Configuration.Template(
                  borCon=AixLib.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
            mBor_flow_nominal=0.4,
            mBorFie_flow_nominal=16,
            dp_nominal=50000,
            hBor=100,
            rBor=0.076,
            dBor=100,
            cooBor=[6.02,49.93; 15.08,51.43; 24.14,49.93; 33.2,49.93; 42.26,49.93; 51.25,
                49.93; 60.32,49.93; 22.98,41.07; 10.65,35.27; 22.91,32; 6.08,27.5; 15.15,
                27.5; 22.98,14; 35.58,6.77; 44.65,6.77; 53.64,6.77; 62.63,6.77; 71.69,
                6.77; 80.75,6.77; 89.75,6.77; 98.81,6.77; 107.8,6.77; 115.5,11.48; 106.58,
                16.32; 91.04,16.32; 98.81,20.82; 114.41,20.82; 106.64,25.32; 91.04,25.39;
                98.81,29.96; 114.41,29.82; 106.64,34.45; 98.81,38.95; 114.41,38.89;
                91.04,43.52; 106.58,43.52; 98.81,48.02; 114.41,47.95; 78.3,49.93; 69.31,
                49.93],
            rTub=0.016,
            kTub=0.38,
            eTub=0.0029,
            xC=0.048);
      annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="conDat",
        Documentation(
    info="<html>
<p>
This record presents an example for how to define configuration data records
using the template in
<a href=\"modelica://AixLib.Fluid.Geothermal.Borefields.Data.Configuration.Template\">
AixLib.Fluid.Geothermal.Borefields.Data.Configuration.Template</a>.
</p>
</html>",
    revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
    end conDat;

    record filDat
      "Filling data record of Bentonite heat transfer properties"
      extends AixLib.Fluid.Geothermal.Borefields.Data.Filling.Template(
          kFil=2,
          dFil=1600,
          cFil=800);
      annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="filDat",
    Documentation(
    info="<html>
<p>
This filling data record contains the heat transfer properties of bentonite.
</p>
</html>",
    revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
    end filDat;

    record soiDat
      "Soil data record of sandstone heat transfer properties"
      extends AixLib.Fluid.Geothermal.Borefields.Data.Soil.Template(
        kSoi=3.85,
        dSoi=540,
        cSoi=18);
      annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="soiDat",
    Documentation(
    info="<html>
<p>
This soil data record contains the heat transfer properties of sandstone.
</p>
</html>",
    revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
    end soiDat;
  end Geo;
end DataBase;
