class Facilitator{

  String _facilitatorName;
  String _facilitatorId;
  List<dynamic> _classIds;
  String _franchiseName;
  List<dynamic> _classNames;

  Facilitator(this._facilitatorName, this._classIds, this._franchiseName, this._classNames);
  Facilitator.fromFacilitator(this._facilitatorName, this._facilitatorId);

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

  String get facilitatorId => _facilitatorId;

  set facilitatorId(String value) {
    _facilitatorId = value;
  }

  String get facilitatorName => _facilitatorName;

  set facilitatorName(String value) {
    _facilitatorName = value;
  }
}