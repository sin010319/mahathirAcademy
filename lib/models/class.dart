import 'package:mahathir_academy_app/models/coach.dart';
import 'package:mahathir_academy_app/models/facilitator.dart';
import 'package:mahathir_academy_app/models/student.dart';

class Class{

  String _classId;
  String _className;
  Coach _coach;
  Facilitator _facilitator;
  List<Student> _studentList;

  Class(this._className, this._classId);

  Class.main(this._className, this._classId, this._coach, this._facilitator, this._studentList);

  String get classId => _classId;

  set classId(String value) {
    _classId = value;
  }

  String get className => _className;

  set className(String value) {
    _className = value;
  }

  List<Student> get studentList => _studentList;

  set studentList(List<Student> value) {
    _studentList = value;
  }

  Facilitator get facilitator => _facilitator;

  set facilitator(Facilitator value) {
    _facilitator = value;
  }

  Coach get coach => _coach;

  set coach(Coach value) {
    _coach = value;
  }
}