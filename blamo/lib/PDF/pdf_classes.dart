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
    String descriptor;
    void setDepth(){
      this.beginDepth = this.beginDepth ?? this.unit.depthUB;
      this.endDepth = this.endDepth ?? this.unit.depthLB;
    }
    double scaledRenderHeight;
    String notToScale = "";
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

  //void init(String project, number, client, highway, county, projection, north, east, lat, long, location, elevationDatum, tubeHeight, boreholeID, 
  //startDate, endDate, surfaceElevation, contractor, equipment, method, loggedBy, checkedBy){
  void init(LogInfo i){
    this.project = i.project == "null" || i.project == "" ? "n/a" : i.project;
    this.number = i.number == "null" || i.number == "" ? "n/a" : i.number;
    this.client = i.client == "null" || i.client == "" ? "n/a" : i.client;
    this.highway = i.highway == "null" || i.highway == "" ? "n/a" : i.highway;
    this.county = i.county == "null" || i.county == "" ? "n/a" : i.county;
    this.projection = i.projection == "null" || i.projection == "" ? "n/a" : i.projection;
    this.north = i.north == "null" || i.north == "" ? "n/a" : i.north;
    this.east = i.east == "null" || i.east == "" ? "n/a" : i.east;
    this.lat = i.lat == "null" || i.lat == "" ? "n/a" : i.lat;
    this.long = i.long  == "null" || i.long == "" ? "n/a" : i.long;
    this.location = i.location == "null" || i.location == "" ? "n/a" : i.location;
    this.elevationDatum = i.elevationDatum == "null" || i.elevationDatum == "" ? "n/a" : i.elevationDatum;
    this.tubeHeight = i.tubeHeight == "null" || i.tubeHeight == "" ? "n/a" : i.tubeHeight;
    this.boreholeID = i.boreholeID == "null" || i.boreholeID == "" ? "n/a" : i.boreholeID;
    this.startDate = i.startDate == "null" || i.startDate == "" ? "n/a" : i.startDate;
    this.endDate = i.endDate == "null" || i.endDate == "" ? "n/a" : i.endDate;
    this.surfaceElevation = i.surfaceElevation == "null" || i.surfaceElevation == "" ? "n/a" : i.surfaceElevation;
    this.contractor = i.contractor == "null" || i.contractor == "" ? "n/a" : i.contractor;
    this.equipment = i.equipment == "null" || i.equipment == "" ? "n/a" : i.equipment;
    this.method = i.method == "null" || i.method == "" ? "n/a" : i.method;
    this.loggedBy = i.loggedBy == "null" || i.loggedBy == "" ? "n/a" : i.loggedBy;
    this.checkedBy = i.checkedBy == "null" || i.checkedBy == "" ? "n/a" : i.checkedBy;
  }
}
