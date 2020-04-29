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

  //void init(String project, number, client, highway, county, projection, north, east, lat, long, location, elevationDatum, tubeHeight, boreholeID, 
  //startDate, endDate, surfaceElevation, contractor, equipment, method, loggedBy, checkedBy){
  void init(LogInfo i){
    this.project = i.project ?? "";
    this.number = i.number ?? "";
    this.client = i.client ?? "";
    this.highway = i.highway ?? "";
    this.county = i.county ?? "";
    this.projection = i.projection ?? "";
    this.north = i.north ?? "";
    this.east = i.east ?? "";
    this.lat = i.lat ?? "";
    this.long = i.long ?? "";
    this.location = i.location ?? "";
    this.elevationDatum = i.elevationDatum ?? "";
    this.tubeHeight = i.tubeHeight ?? "";
    this.boreholeID = i.boreholeID ?? "";
    this.startDate = i.startDate ?? "";
    this.endDate = i.endDate ?? "";
    this.surfaceElevation = i.surfaceElevation ?? "";
    this.contractor = i.contractor ?? "";
    this.equipment = i.equipment ?? "";
    this.method = i.method ?? "";
    this.loggedBy = i.loggedBy ?? "";
    this.checkedBy = i.checkedBy ?? "";
  }
}
