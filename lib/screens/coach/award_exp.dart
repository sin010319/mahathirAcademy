import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mahathir_academy_app/models/StringExtension.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'award_exp_bottomSheet.dart';
import 'guideline.dart';
import 'package:sizer/sizer.dart';

double _width;

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
List<bool> state = [];
bool isChanged = false;

List<Student> tickedStudents = [];

class AwardExp extends StatefulWidget {
  static bool clear;

  static const String id = '/award_exp';
  String contentTitle;

  AwardExp({this.contentTitle});
  AwardExp.fromAwardExp();

  @override
  _AwardExpState createState() => _AwardExpState();

  Future retrievedStudents;
}

class _AwardExpState extends State<AwardExp> {
  List<TextEditingController> _controllers = new List();
  bool isChecked = false;

  String alertMessage =
      'Please select minimum of one student before awarding EXP.';
  String acknowledgementMessage =
      'Are you sure you want to acknowledge the selected student?';

  @override
  void initState() {
    tickedStudents = [];
    widget.retrievedStudents = callStuFunc();
    isChanged = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.retrievedStudents = callStuFunc();
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          animatedIconTheme: IconThemeData(size: 18.sp, color: Colors.white),
          backgroundColor: Color(0xFF8A1501),
          visible: true,
          curve: Curves.bounceIn,
          children: [
            // FAB 1
            SpeedDialChild(
                child: Icon(FontAwesomeIcons.question, color: Colors.white),
                backgroundColor: Color(0xFFC61F00),
                onTap: () {
                  setState(() {
                    Navigator.pushNamed(context, Guideline.id);
                  });
                },
                label: 'Award EXP Guidelines',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 11.0.sp),
                labelBackgroundColor: Color(0xFFFF3700)),
            // FAB 2
            SpeedDialChild(
                child: Icon(FontAwesomeIcons.award, color: Colors.white),
                backgroundColor: Color(0xFFC61F00),
                onTap: () {
                  if (tickedStudents.length != 0) {
                    showModal();
                  } else {
                    PopUpAlertClass.popUpAlert(alertMessage, context);
                  }
                },
                label: 'Award EXP',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 11.0.sp),
                labelBackgroundColor: Color(0xFFFF3700)),
            // FAB 3
          ],
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            child: Row(
              children: [
                Image.asset("assets/images/brand_logo.png",
                    fit: BoxFit.contain, height: 5.5.h),
                SizedBox(
                  width: 1.5.w,
                ),
                Flexible(
                  child: Text('Award EXP',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                      )),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xFFDB5D38),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // wrap the icon in a circle avatar
                    CircleAvatar(
                      radius: 25.0.sp,
                      backgroundColor: Colors.white,
                      child: Icon(
                        FontAwesomeIcons.award,
                        size: 25.0.sp,
                        color: Color(0xFF8A1501),
                      ),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    FutureBuilder(
                        future: widget.retrievedStudents,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                                  ConnectionState.done ||
                              snapshot.hasError) {
                            print('error3');
                            return Container();
                          }
                          return Text(
                            '${widget.contentTitle}\n${snapshot.data.length} Students',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5.sp),
                          );
                        }),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                    // container must have a child to get shown up on screen
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0.sp),
                            topRight: Radius.circular(20.0.sp))),
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 1.0.h,
                        ),
                        returnFutureBuilder()
                        // future: widget.retrievedStudents),
                      ]),
                    )),
              )
            ]));
  }

  Future<List<Student>> studentData() async {
    var selectedClassId;
    List<Student> studentList = [];

    await _firestore
        .collection('classes')
        .where('className', isEqualTo: widget.contentTitle)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        selectedClassId = doc['classId'];
      });
    });
    print(selectedClassId);

    await _firestore
        .collection('students')
        .where('classIds', arrayContains: selectedClassId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String name = doc['studentName'];
        String studentId = doc['studentId'];
        int exp = doc['exp'];
        String timestamp =
            DateTime.parse(doc['timestamp'].toDate().toString()).toString();
        var student = Student.withTimestamp(name, studentId, exp, timestamp);
        studentList.add(student);
      });
    });
    print(studentList);
    state = List.filled(studentList.length, false);
    return studentList;
  }

  Future callStuFunc() async {
    return await studentData();
  }

  void showModal() {
    AwardExp.clear = true;
    Future<void> future = showModalBottomSheet(
        context: context,
        // builder here needs a method to return widget
        builder: awardExpBottomSheet,
        isScrollControlled: true // enable the modal take up the full screen
        );
    future.then((void value) => closeModal(value));
  }

  FutureBuilder<dynamic> closeModal(void value) {
    AwardExp.clear = false;
    print('modal closed');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  FutureBuilder<dynamic> returnFutureBuilder() {
    return FutureBuilder(
      future: widget.retrievedStudents,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.hasError) {
          print('error3');
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            // When this checkboxState value changes, it is going to trigger this callback and pass in the latest state of checkbox
                            activeColor: Colors.orangeAccent,
                            // color of tick
                            value: state[index],
                            // if true, checked; else unchecked
                            // once the user clicks on the checkbox, swap the state
                            onChanged: (bool newValue) {
                              setState(() {
                                state[index] = !state[index];
                                Student studentObj = snapshot.data[index];
                                if (state[index] &&
                                    !tickedStudents.contains(studentObj)) {
                                  tickedStudents.add(studentObj);
                                } else if (!state[index]) {
                                  tickedStudents.remove(studentObj);
                                }
                              });
                            },
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              height: 10.0.h,
                              child: Card(
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      snapshot.data[index].studentName,
                                      style: kListItemsTextStyle,
                                    ),
                                    subtitle: Text(
                                      'Last Updated: ${StringExtension.displayTimeAgoFromTimestamp(snapshot.data[index].timestamp)}',
                                      style: kTimestampSubtitleTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Card(
                              child: TextFormField(
                                initialValue:
                                    snapshot.data[index].exp.toString(),
                                style: kExpTextStyle,
                                enabled: false,
                                //Not clickable and not editable
                                readOnly: true,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ),
        );
      },
    );
  }

  Widget awardExpBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
        child: AwardExpBottomSheet(tickedStudents: tickedStudents),
      ),
    );
  }
}
