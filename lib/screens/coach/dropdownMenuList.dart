import 'package:flutter/material.dart';
import 'update_exp_data.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:sizer/sizer.dart';

int awardedExp = 0;

class DropdownMenuList extends StatefulWidget {
  static List<int> expList = method1ExpValues;
  static List<DropdownMenuItem<String>> dropdownItems = [];
  bool first = false;
  static bool assessmentScore = false;

  static void expDropdownList(String value) {
    int index = methods.indexOf(value);
    int methodId = methodIds[index];

    switch (methodId) {
      case 1:
        expList = method1ExpValues;
        break;
      case 2:
        expList = method2ExpValues;
        break;
      case 3:
        expList = method3ExpValues;
        break;
      case 4:
        expList = method4ExpValues;
        break;
      case 5:
        expList = method5ExpValues;
        break;
    }

    // extract a list of DropdownMenuItems from the currenciesList
    if (expList.length > 0 && !assessmentScore) {
      for (int i = 0; i < expList.length; i++) {
        // create a DropdownMenuItem and save into a variable
        var newItem = DropdownMenuItem(
          // dropdown menu item has a child of text widget
          child: Text(expList[i].toString()),
          value: expList[i]
              .toString(), // pass in the currency value when onCHanged() is triggered
        );
        // add the item created to a list
        dropdownItems.add(newItem);
      }
    }
    print(dropdownItems.toString());
  }

  @override
  _DropdownMenuListState createState() => _DropdownMenuListState();
}

class _DropdownMenuListState extends State<DropdownMenuList> {
  String selectedExpValue = DropdownMenuList.expList[0].toString();

  @override
  Widget build(BuildContext context) {
    bool isTrue = true;

    if (DropdownMenuList.expList.contains(int.parse(selectedExpValue))) {
      isTrue = true;
    } else {
      isTrue = false;
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
          style: kExpTextStyle,
          value: isTrue
              ? selectedExpValue
              : DropdownMenuList.expList[0].toString(),
          // start out with the default value
          // items expect a list of DropdownMenuItem widget
          items: DropdownMenuList.dropdownItems,
          hint: Text('Select an EXP to award'),
          // onChanged will get triggered when the user selects a new item from that dropdown
          onChanged: (value) {
            setState(() {
              selectedExpValue = value;
              awardedExp = int.parse(value);
            });
          },
        ),
      ),
    );
  }
}
