import 'package:blamo/ObjectHandler.dart';

class UnitPDF { // TODO - touch up inits? Maybe?
    double beginUnitDepth;
    double endUnitDepth;
    String unitDescription;
    String unitMethods;

    void init(String beginUnitDepth, endUnitDepth, unitDescription, unitMethods){
      this.beginUnitDepth = double.parse(beginUnitDepth);
      this.endUnitDepth = double.parse(endUnitDepth);
      this.unitDescription = unitDescription;
      this.unitMethods = unitMethods;
    }
}

class TestPDF {
    double beginTestDepth;
    double endTestDepth;
    String soilType;
    String description;
    String moistureContent;
    String dryDensity;
    String liquidLimit;
    String plasticLimit;
    String fines;
    String blows1;
    String blows2;
    String blows3;
    String blowCount;

    void init(String beginTestDepth, endTestDepth, soilType, description, moistureContent, dryDensity, liquidLimit, plasticLimit, fines, blows1, blows2, blows3, blowCount){
      this.beginTestDepth = double.parse(beginTestDepth);
      this.endTestDepth = double.parse(endTestDepth);
      this.soilType = soilType;
      this.description = description;
      this.moistureContent = moistureContent;
      this.dryDensity = dryDensity;
      this.liquidLimit = liquidLimit;
      this.plasticLimit = plasticLimit;
      this.fines = fines;
      this.blows1 = blows1;
      this.blows2 = blows2;
      this.blows3 = blows3;
      this.blowCount = blowCount;
    }
}

class Level { //class for holding units and associated tests.
    //UnitPDF unit;
    //List<TestPDF> tests = [];
    Unit unit;
    List<Test> tests = [];
    double beginDepth; // GOES BY ELEVATION. begindepth is higher elevation, or technically a "lower" bound. i.e. 0.
    double endDepth; //                      enddepth is lower elevation, or technically a "higher" bound. i.e. -2.5.
    void setDepth(){
      this.beginDepth = this.beginDepth ?? this.unit.depthUB;
      this.endDepth = this.endDepth ?? this.unit.depthLB;
    }
}

class LogInfoPDF {
    String objectID;
    String testType;
    String project;
    String number;
    String client;
    String lat;
    String long;
    String location;
    String elevationDatum;
    String boreholeID;
    String startDate;
    String endDate;
    String surfaceElevation;
    String contractor;
    String method;
    String loggedBy;
    String checkedBy;
    String fakedata;

  void init(String objectID, testType, project, number, client, lat, long, location, elevationDatum, boreholeID, startDate, endDate, surfaceElevation, contractor, method, loggedBy, checkedBy){
    this.objectID = objectID;
    this.testType = testType;
    this.project = project;
    this.number = number;
    this.client = client;
    this.lat = lat;
    this.long = long;
    this.location = location;
    this.elevationDatum = elevationDatum;
    this.boreholeID = boreholeID;
    this.startDate = startDate;
    this.endDate = endDate;
    this.surfaceElevation = surfaceElevation;
    this.contractor = contractor;
    this.method = method;
    this.loggedBy = loggedBy;
    this.checkedBy = checkedBy;
  }
}
