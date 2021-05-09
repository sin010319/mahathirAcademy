class Coach{

  String _coachName;
  String _coachId;
  List<dynamic> _classIds;
  String _franchiseName;
  List<dynamic> _classNames;

  Coach(this._coachName, this._classIds, this._franchiseName, this._classNames);

  Coach.fromCoach(this._coachName, this._coachId);


  List<dynamic> get classNames => _classNames;

  set classNames(List<dynamic> value) {
    _classNames = value;
  }

  String get franchiseName => _franchiseName;

  set franchiseId(String value) {
    _franchiseName = value;
  }

  List<dynamic> get classIds => _classIds;

  set classIds(List<dynamic> value) {
    _classIds = value;
  }

  String get coachName => _coachName;

  set coachName(String value) {
    _coachName = value;
  }

  String get coachId => _coachId;

  set coachId(String value) {
    _coachId = value;
  }
}