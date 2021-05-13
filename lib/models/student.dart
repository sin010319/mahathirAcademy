class Student {
  String _studentName;
  String _studentId;
  int _exp;
  String _franchiseLocation;
  String _className;
  String _rank;
  String _username;
  String _coachName;
  String _facilitatorName;

  Student(this._studentName, this._studentId, this._exp);

  Student.completeStudentInfo(
      this._studentName,
      this._username,
      this._exp,
      this._franchiseLocation,
      this._className,
      this._rank,
      this._coachName,
      this._facilitatorName);

  Student.viewStudent(this._studentName, this._studentId, this._className);

  Student.viewRankStudent(this._studentName, this._studentId, this._rank);

  String get className => _className;

  set className(String value) {
    _className = value;
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

  String get facilitatorName => _facilitatorName;

  set facilitatorName(String value) {
    _facilitatorName = value;
  }

  String get coachName => _coachName;

  set coachName(String value) {
    _coachName = value;
  }
}
