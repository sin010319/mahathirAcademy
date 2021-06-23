import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';

import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:mahathir_academy_app/screens/coach/award_exp.dart';
import 'update_exp_data.dart';
import 'dropdownMenuList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
bool rankUp = false;

class AwardExpBottomSheet extends StatefulWidget {
  String selectedMethod; // start out with the default value

  List<Student> tickedStudents;
  Future retrievedStudents;
  Future<dynamic> function;

  AwardExpBottomSheet({this.tickedStudents});

  @override
  _AwardExpBottomSheetState createState() => _AwardExpBottomSheetState();
}

class _AwardExpBottomSheetState extends State<AwardExpBottomSheet> {
  int markBefore;
  int markAfter;
  String rankBefore = "";
  String rankAfter = "";
  String targetFranchiseAdminName;
  String targetStudentId;
  String alertMethodMessage =
      'Please select a method first before awarding exp to students.';

  @override
  Widget build(BuildContext context) {
    // platform specific UI
    // method to produce ANDROID Material dropdown button: androidDropdown()
    Widget methodDropdownList() {
      List<DropdownMenuItem<String>> dropdownItems = [];
      // extract a list of DropdownMenuItems from the currenciesList
      for (int i = 0; i < methods.length; i++) {
        // create a DropdownMenuItem and save into a variable
        var newItem = DropdownMenuItem(
          // dropdown menu item has a child of text widget
          child: Text(methods[i]),
          value: methods[
              i], // pass in the currency value when onChanged() is triggered
        );
        // add the item created to a list
        dropdownItems.add(newItem);
      }

      return Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            color: Colors.white),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          isExpanded: true,
          itemHeight: 40.0.sp,
          style: kMethodDropdownTextStyle,
          hint: Text('Select a method to award EXP'),
          value: widget.selectedMethod,
          // start out with the default value
          // items expect a list of DropdownMenuItem widget
          items: dropdownItems,
          // onChanged will get triggered when the user selects a new item from that dropdown
          onChanged: (String newValue) {
            setState(() {
              DropdownMenuList.dropdownItems.clear();
              widget.selectedMethod = newValue;
              DropdownMenuList.expDropdownList(newValue);
            });
          },
        )),
      );
    }

    return Container(
        color: Colors.red,
        child: Container(
          padding: EdgeInsets.all(10.0.sp),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0.sp),
                  topRight: Radius.circular(20.0.sp))),
          child: Column(children: <Widget>[
            Text(
              'Award EXP', // task name
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0.sp,
                color: Color(0xFF8A1501),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 2.0.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'The following are the students that you wish to award exp to:',
                style: kSubtitleTextStyle,
              ),
            ),
            SizedBox(
              height: 3.0.h,
            ),
            Column(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.tickedStudents.length,
                      itemBuilder: (context, index) {
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Container(
                                  height: 10.0.h,
                                  child: Card(
                                    child: Center(
                                      child: ListTile(
                                        title: Text(
                                          widget.tickedStudents[index]
                                              .studentName,
                                          style: kListItemsTextStyle,
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
                                    initialValue: widget
                                        .tickedStudents[index].exp
                                        .toString(),
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
                      }),
                )
              ],
            ),
            SizedBox(
              height: 3.0.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Method of awarding EXP ',
                style: kSubtitleTextStyle,
              ),
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: methodDropdownList(),
            ),
            SizedBox(
              height: 2.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'EXP',
                style: kSubtitleTextStyle,
              ),
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownMenuList(),
            ),
            SizedBox(
              height: 4.0.h,
            ),
            RoundButton(
                label: 'Award EXP',
                function: () {
                  if (widget.selectedMethod == null ||
                      widget.selectedMethod == '') {
                    PopUpAlertClass.popUpAlert(alertMethodMessage, context);
                  } else {
                    String message =
                        'Are you sure you want to award the allocated EXP to the student(s)?';
                    PopUpDialogClass.popUpDialog(message, context, () {
                      update(awardedExp);
                      Navigator.of(context, rootNavigator: true).pop();
                    }, () {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  }
                }),
          ]),
        ));
  }

  Future update(int awardedExp) async {
    WriteBatch batch = _firestore.batch();

    for (int i = 0; i < tickedStudents.length; i++) {
      await _firestore
          .collection("students")
          .where('studentName', isEqualTo: tickedStudents[i].studentName)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          markBefore = doc.data()["exp"];
          rankBefore = decideRank(markBefore);

          batch.update(doc.reference, {
            "exp": doc.data()["exp"] + awardedExp,
            "timestamp": new DateTime.now()
          });
          markAfter = doc.data()["exp"] + awardedExp;
          rankAfter = decideRank(markAfter);
          targetFranchiseAdminName = doc.data()['franchiseAdminName'];
          targetStudentId = doc.data()['studentId'];
          print(rankBefore);
          print("------------");
          print(rankAfter);
          print(tickedStudents[i].studentName);

          print('can update exp');
        });
      });
    }

    if (rankBefore != rankAfter) {
      String studentRankUp =
          "Student has leveled up from $rankBefore to $rankAfter!";
      PopUpAlertClass.popUpAlert(studentRankUp, context);
      _firestore.collection('announcements').add({
        'message': "Congratulation! You have ranked up!",
        'sender': targetFranchiseAdminName,
        'timestamp': new DateTime.now(),
        'target': targetStudentId
      });
    }

    String expAwardedMessage =
        'You have successfully award EXP to the student(s). Please close this page to view the newly updated student EXP.';
    PopUpAlertClass.popUpAlert(expAwardedMessage, context);
    return batch.commit();
  }

  String decideRank(int exp) {
    String retRank = "";
    if (exp >= 0 && exp < 500) {
      retRank = "Bronze Speaker";
    } else if (exp >= 500 && exp < 1000) {
      retRank = "Silver Speaker";
    } else if (exp >= 1000 && exp < 1500) {
      retRank = "Gold Speaker";
    } else if (exp >= 1500 && exp < 2000) {
      retRank = "Platinum Speaker";
    } else if (exp >= 2000 && exp < 3000) {
      retRank = "Ruby Speaker";
    } else if (exp >= 3000 && exp < 4000) {
      retRank = "Diamond Speaker";
    } else if (exp >= 4000) {
      retRank = "Elite Speaker";
    }
    return retRank;
  }

  callAwardExpFunc(int awardedExp) async {
    return await update(awardedExp);
  }
}
