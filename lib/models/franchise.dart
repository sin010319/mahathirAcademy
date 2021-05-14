class Franchise {
  String _franchiseName;
  String _franchiseLocation;
  String _franchiseId;
  String _franchiseAdminId;

  Franchise(this._franchiseName, this._franchiseLocation, this._franchiseId);

  Franchise.forDropdown(this._franchiseName, this._franchiseId);

  Franchise.fromFranchise(this._franchiseName, this._franchiseLocation,
      this._franchiseId, this._franchiseAdminId);

  String get franchiseAdminId => _franchiseAdminId;

  set franchiseAdminId(String value) {
    _franchiseAdminId = value;
  }

  String get franchiseId => _franchiseId;

  set franchiseId(String value) {
    _franchiseId = value;
  }

  String get franchiseLocation => _franchiseLocation;

  set franchiseLocation(String value) {
    _franchiseLocation = value;
  }

  String get franchiseName => _franchiseName;

  set franchiseName(String value) {
    _franchiseName = value;
  }
}
