import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/models/class.dart';
import 'package:mahathir_academy_app/screens/coach/award_exp.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

String newClassIdForTransfer = '';

class ClassDropdownMenuList extends StatefulWidget {
  static List<DropdownMenuItem<String>> dropdownItems = [];
  bool first = false;
  static bool assessmentScore = false;
  static List<Class> classes = [];

  static void classDropdownList(String value) async {
    List<dynamic> classIds = [];

    await _firestore
        .collection('franchises')
        .where('franchiseId', isEqualTo: value)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        classIds = doc['classIds'];
      });
    });

    String className;
    String classId;
    Class newClass;

    for (var eachClassId in classIds) {
      await _firestore
          .collection('classes')
          .where('classId', isEqualTo: eachClassId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          className = doc['className'];
          classId = doc['classId'];
          newClass = Class(className, classId);
          classes.add(newClass);
        });
      });
    }

    await _firestore.collection('classes').doc('9999').get().then((value) {
      Map<String, dynamic> data = value.data();
      className = data['className'];
      classId = data['classId'];
      newClass = Class(className, classId);
      classes.add(newClass);
    });

    // extract a list of DropdownMenuItems from the currenciesList
    if (classes.length > 0) {
      for (int i = 0; i < classes.length; i++) {
        // create a DropdownMenuItem and save into a variable
        var newItem = DropdownMenuItem(
          // dropdown menu item has a child of text widget
          child: Text(classes[i].className),
          value: classes[i]
              .classId, // pass in the currency value when onCHanged() is triggered
        );
        // add the item created to a list
        dropdownItems.add(newItem);
      }
    }
    print(dropdownItems.toString());
  }

  @override
  _ClassDropdownMenuListState createState() => _ClassDropdownMenuListState();
}

class _ClassDropdownMenuListState extends State<ClassDropdownMenuList> {
  String selectedClass = ClassDropdownMenuList.classes[0].classId;

  @override
  Widget build(BuildContext context) {
    bool isTrue = true;

    for (var eachClass in ClassDropdownMenuList.classes) {
      if (eachClass.classId == selectedClass) {
        isTrue = true;
        break;
      } else {
        isTrue = false;
      }
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
          itemHeight: 50.0,
          style: kExpTextStyle,
          value:
              isTrue ? selectedClass : ClassDropdownMenuList.classes[0].classId,
          // start out with the default value
          // items expect a list of DropdownMenuItem widget
          items: ClassDropdownMenuList.dropdownItems,
          hint: Text('Select an EXP to award'),
          // onChanged will get triggered when the user selects a new item from that dropdown
          onChanged: (value) {
            setState(() {
              selectedClass = value;
              newClassIdForTransfer = value;
            });
          },
        ),
      ),
    );
  }
}
