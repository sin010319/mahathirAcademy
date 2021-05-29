class Student {
  String _studentName;
  String _studentId;
  int _exp;
  String _franchiseLocation;
  List<dynamic> _classNames;
  String _rank;
  String _username;
  String _contactNum;
  String _timestamp;

  Student(this._studentName, this._studentId, this._exp);

  Student.withTimestamp(
      this._studentName, this._studentId, this._exp, this._timestamp);

  Student.completeStudentInfo(this._studentName, this._username, this._exp,
      this._franchiseLocation, this._classNames, this._rank, this._contactNum);

  Student.viewStudent(this._studentName, this._studentId, this._classNames);

  Student.viewRankStudent(this._studentName, this._studentId, this._rank);

  Student.fromStudent(this._studentName, this._exp, this._studentId,
      this._classNames, this._rank);

  Student.simpleStudent(this._studentName, this._studentId);

  List<dynamic> get classNames => _classNames;

  set classNames(List<dynamic> value) {
    _classNames = value;
  }

  String get franchiseLocation => _franchiseLocation;

  set franchiseLocation(String value) {
    _franchiseLocation = value;
  }

  int get exp => _exp;

  set exp(int value) {
    _exp = value;
  }

  String get studentName => _studentName;

  set studentName(String value) {
    _studentName = value;
  }

  String get rank => _rank;

  set rank(String value) {
    _rank = value;
  }

  String get studentId => _studentId;

  set studentId(String value) {
    _studentId = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get contactNum => _contactNum;

  set contactNum(String value) {
    _contactNum = value;
  }

  String get timestamp => _timestamp;

  set timestamp(String value) {
    _timestamp = value;
  }
}
