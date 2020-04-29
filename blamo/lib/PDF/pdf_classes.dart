import 'package:blamo/ObjectHandler.dart';

class UnitPDF { // TODO - touch up inits? Maybe?
    double beginUnitDepth;
    double endUnitDepth;
    String unitDescription;
    String unitMethods;
    String notes;

    void init(String beginUnitDepth, endUnitDepth, unitDescription, unitMethods, notes){
      this.beginUnitDepth = double.parse(beginUnitDepth);
      this.endUnitDepth = double.parse(endUnitDepth);
      this.unitDescription = unitDescription;
      this.unitMethods = unitMethods;
      this.notes = notes;
    }
}

class TestPDF {
    String testType; //
    double beginTestDepth;
    double endTestDepth;
    double percentRecovery; //
    String soilDrivingResistance; //
    String rockDiscontinuityData; //
    String rockQualityDesignation; //
    // String soilType;
    // String description;
    String moistureContent;
    String dryDensity;
    String liquidLimit;
    String plasticLimit;
    String fines;
    String blows1;
    String blows2;
    String blows3;
    String blowCount;
    String tags;

    void init(String testType, beginTestDepth, endTestDepth, percentRecovery, soilDrivingResistance, rockDicontinuityData, rockQualityDesignation, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount){
    //void init(String beginTestDepth, endTestDepth, soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount){
      this.testType = testType;
      this.beginTestDepth = double.parse(beginTestDepth);
      this.endTestDepth = double.parse(endTestDepth);
      this.soilDrivingResistance = soilDrivingResistance; //
      this.rockDiscontinuityData = rockDiscontinuityData; //
      this.rockQualityDesignation = rockQualityDesignation; //
      //this.soilType = soilType;
      //this.description = description;
      this.moistureContent = moistureContent;
      this.dryDensity = dryDensity;
      this.liquidLimit = liquidLimit;
      this.plasticLimit = plasticLimit;
      this.fines = fines;
      this.blows1 = blows1;
      this.blows2 = blows2;
      this.blows3 = blows3;
      this.blowCount = blowCount;
      this.tags = tags; //
    }
}

class Level { //class for holding units and associated tests.
    //UnitPDF unit;
    //List<TestPDF> tests = [];
    Unit unit;
    List<Test> tests = [];
    double beginDepth; // GOES BY ELEVATION. begindepth is higher elevation, or technically a "lower" bound. i.e. 0.
    double endDepth; //                      enddepth is lower elevation, or technically a "higher" bound. i.e. -2.5.
    String tags;
    void setDepth(){
      this.beginDepth = this.beginDepth ?? this.unit.depthUB;
      this.endDepth = this.endDepth ?? this.unit.depthLB;
    }
    double scaledRenderHeight;
}

class LogInfoPDF {
    //String objectID;
    
    String project;
    String number;
    String client;
    String highway;
    String county;
    String projection;
    String north;
    String east;
    String lat;
    String long;
    String location;
    String elevationDatum;
    String tubeHeight;
    String boreholeID;
    String startDate;
    String endDate;
    String surfaceElevation;
    String contractor;
    String equipment;
    String method;
    String loggedBy;
    String checkedBy;
    //String fakedata;
    //String testType;

  void init(String project, number, client, highway, county, projection, north, east, lat, long, location, elevationDatum, tubeHeight, boreholeID, 
  startDate, endDate, surfaceElevation, contractor, equipment, method, loggedBy, checkedBy){
  //void init(String objectID, testType, project, number, client, lat, long, location, elevationDatum, boreholeID, startDate, endDate, surfaceElevation, contractor, method, loggedBy, checkedBy){
   
    this.project = project;
    this.number = number;
    this.client = client;
    this.highway = highway;
    this.county = county;
    this.projection = projection;
    this.north = north;
    this.east = east;
    this.lat = lat;
    this.long = long;
    this.location = location;
    this.elevationDatum = elevationDatum;
    this.tubeHeight = tubeHeight;
    this.boreholeID = boreholeID;
    this.startDate = startDate;
    this.endDate = endDate;
    this.surfaceElevation = surfaceElevation;
    this.contractor = contractor;
    this.equipment = equipment;
    this.method = method;
    this.loggedBy = loggedBy;
    this.checkedBy = checkedBy;
  }
}
