import 'package:flutter/material.dart';

// TaskTile
// variables in stateful obj are not as final as state can change and can use setState() method
class classTile extends StatelessWidget{

  final bool isChecked;
  final String taskTitle;
  final Function checkboxCallback;
  final Function longPressCallback;

  classTile({this.isChecked, this.taskTitle, this.checkboxCallback, this.longPressCallback});

  // rebuild a list tile whenever we update either the isChecked property or the task title property
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onLongPress: longPressCallback,  // trigger a callback method when user pres on the particular listtile for a long time
        title: Text(
          taskTitle,
          style: TextStyle(
            // once a checkbox is checked, there wil be a line thru the task
              decoration: isChecked? TextDecoration.lineThrough: null
          ),
        ),
        trailing: Checkbox(
          // When this checkboxState value changes, it is going to trigger this callback and pass in the latest
          // state of checkbox
          activeColor: Colors.lightBlueAccent,  // color of tick
          value: isChecked, // if true, checked; else unchecked
          // once the user clicks on the checkbox, swap the state
          onChanged: checkboxCallback, // callback gets triggered when user change the checkbox field by tapping it to tick or untick it
        )
    );
  }
}
