class Coach {
  String _coachName;
  String _coachId;
  List<dynamic> _classIds;
  String _franchiseName;
  List<dynamic> _classNames;
  String _username;
  String _contactNum;

  Coach(this._coachName, this._classIds, this._franchiseName, this._classNames);
  Coach.completeInfo(this._coachName, this._username, this._classIds,
      this._franchiseName, this._classNames, this._contactNum);

  Coach.fromCoach(this._coachName, this._coachId);

  Coach.viewCoach(this._coachName, this._coachId, this._franchiseName);

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  List<dynamic> get classNames => _classNames;

  set classNames(List<dynamic> value) {
    _classNames = value;
  }

  String get franchiseName => _franchiseName;

  set franchiseName(String value) {
    _franchiseName = value;
  }

  List<dynamic> get classIds => _classIds;

  set classIds(List<dynamic> value) {
    _classIds = value;
  }

  String get coachId => _coachId;

  set coachId(String value) {
    _coachId = value;
  }

  String get coachName => _coachName;

  set coachName(String value) {
    _coachName = value;
  }

  String get contactNum => _contactNum;

  set contactNum(String value) {
    _contactNum = value;
  }
}
