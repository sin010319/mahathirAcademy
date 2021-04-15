import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/view_coaches_students.dart';
import 'package:mahathir_academy_app/screens/leaderboard.dart';
import 'edit_class_bottomSheet.dart';
import 'add_class_bottomSheet.dart';

class ViewClassScreen extends StatefulWidget {
  static const String id = '/addClass';
  List<String> classes = ['Class1', 'Class2', 'Class3'];

  @override
  _ViewClassScreenState createState() => _ViewClassScreenState();
}

class _ViewClassScreenState extends State<ViewClassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                // builder here needs a method to return widget
                builder: addClassBuildBottomSheet,
                isScrollControlled:
                    true // enable the modal take up the full screen
                );
          },
          backgroundColor: Color(0xFF8A1501),
          child: Icon(Icons.add),
        ),
        appBar: AppBar(title: Text('Classes')),
        backgroundColor: Color(0xFFDB5D38),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // wrap the icon in a circle avatar
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/icons/classroom.png"),
                      radius: 30.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Franchise1 ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${widget.classes.length} Classes: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      // container must have a child to get shown up on screen
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: Column(children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.classes.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Center(
                                    child: ListTile(
                                        title: Text(widget.classes[index]),
                                        trailing: Wrap(
                                          spacing: 8,
                                          children: [
                                            GestureDetector(
                                              child: Icon(
                                                Icons.edit,
                                                color: Color(0xFF8A1501),
                                              ),
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    // builder here needs a method to return widget
                                                    builder:
                                                        editClassBuildBottomSheet,
                                                    isScrollControlled:
                                                        true // enable the modal take up the full screen
                                                    );
                                              },
                                            ),
                                            GestureDetector(
                                              child: Icon(
                                                Icons.delete,
                                                color: Color(0xFF8A1501),
                                              ),
                                              onTap: () {
                                                deleteDialog(context,
                                                    widget.classes[index]);
                                              },
                                            ),
                                          ],
                                        ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, ViewCoachStudent.id);
                                      })),
                              );
                            })
                      ])))
            ]));
  }
}

deleteDialog(BuildContext context, String itemRemoved) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Icon(Icons.close)),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Are you sure you want to remove $itemRemoved?',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        button('Yes', context),
                        button('No', context),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

Widget button(String text, BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;

  return RaisedButton(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    onPressed: () {
      if (text == 'Yes') {
        // do something
      } else if (text == 'No') {
        Navigator.of(context, rootNavigator: true).pop();
      }
    },
    textColor: Colors.white,
    padding: EdgeInsets.all(0.0),
    child: Container(
      alignment: Alignment.center,
      width: _width / 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        gradient: LinearGradient(
          colors: <Color>[Colors.orange[200], Colors.pinkAccent],
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Text(text, style: TextStyle(fontSize: 15)),
    ),
  );
}

Widget editClassBuildBottomSheet(BuildContext context) {
  String identifier = 'Amend Class';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: EditClassBottomSheet(identifier: identifier),
    ),
  );
}

Widget addClassBuildBottomSheet(BuildContext context) {
  String identifier = 'Class';

  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AddClassBottomSheet(identifier: identifier),
    ),
  );
}
