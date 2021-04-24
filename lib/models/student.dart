class Student{

  String _studentName;
  int _exp;

  Student(this._studentName, this._exp);

  int get exp => _exp;

  set exp(int value) {
    _exp = value;
  }

  String get studentName => _studentName;

  set studentName(String value) {
    _studentName = value;
  }
}