import 'package:mahathir_academy_app/models/franchise.dart';

class Admin{

  String _adminName;
  String _adminEmail;
  String _contactNum;

  Admin(this._adminName, this._adminEmail, this._contactNum);

  String get adminName => _adminName;

  set adminName(String value) {
    _adminName = value;
  }

  String get contactNum => _contactNum;

  set contactNum(String value) {
    _contactNum = value;
  }

  String get adminEmail => _adminEmail;

  set adminEmail(String value) {
    _adminEmail = value;
  }
}