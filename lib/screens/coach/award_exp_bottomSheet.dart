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

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;

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
  String alertMethodMessage =
      'Please select a method first before awarding exp to students.';

  @override
  Widget build(BuildContext context) {
    // platform specific UI
    // method to produce ANDROID Material dropdown button: androidDropdown()
    DropdownButton<String> methodDropdownList() {
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

      // create and return a new dropdown list for user selection
      // specify data type of items in dropdown list which is String in this case
      return DropdownButton<String>(
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
      );
    }

    return Container(
        color: Colors.red,
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: Column(children: <Widget>[
            Text(
              'Award EXP', // task name
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Color(0xFF8A1501),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'The following are the students that you wish to award exp to:',
                style: kSubtitleTextStyle,
              ),
            ),
            SizedBox(
              height: 5.0,
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
                                  height: 70.0,
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Card(
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
                                    )
                                  ],
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
              height: 30.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Method of awarding EXP ',
                style: kSubtitleTextStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: methodDropdownList(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'EXP',
                style: kSubtitleTextStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownMenuList(),
            ),
            SizedBox(
              height: 30.0,
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
          batch.update(doc.reference, {"exp": doc.data()["exp"] + awardedExp});
          print('can update exp');
        });
      });
    }
    String expAwardedMessage =
        'You have successfully award EXP to the student(s). Please close this page to view the newly updated student EXP.';
    PopUpAlertClass.popUpAlert(expAwardedMessage, context);
    return batch.commit();
  }

  callAwardExpFunc(int awardedExp) async {
    return await update(awardedExp);
  }
}
