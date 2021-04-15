import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_profile.dart';
import 'package:mahathir_academy_app/screens/student/student_profile.dart';

String identifier;

class ViewStudents extends StatefulWidget {

  static const String id = '/viewStudents';
  String coach = 'Coach1';
  List<String> students = ['Student1', 'Student2', 'Student3'];
  List<int> exp = [230, 40, 100];

  @override
  _ViewStudentsState createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text('View Students')),
      backgroundColor: Color(0xFFDB5D38),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // wrap the icon in a circle avatar
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/icons/students.png"),
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
                      fontSize: 18.0
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Class1',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0
                  ),
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
                          topRight: Radius.circular(20.0)
                      )
                  ),
                  child: Column(
                      children: [
                        SizedBox(height: 10.0,),
                        Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.students.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Center(
                                    child: ListTile(
                                      title: Text(widget.students[index],
                                          style: kListItemsTextStyle),
                                      trailing:
                                      Wrap(
                                        spacing: 8,
                                        children: [
                                          Container(
                                              child: Text(widget.exp[index].toString(),
                                                  style: kExpTextStyle)
                                          ),
                                        ],
                                      ),
                                      onTap:() {
                                        Navigator.pushNamed(context, StudentProfile.id);
                                      },
                                    ),
                                  ),
                                );
                              }
                          ),
                        ),
                      ]
                  ),
                )
            )
          ]
      ),
    );
  }
}

deleteDialog(BuildContext context, String itemRemoved){
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
                          onTap: (){
                            Navigator. of(context, rootNavigator: true). pop();
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
    onPressed: (){
      if(text == 'Yes'){
        // do something
      }else if(text == 'No'){
        Navigator. of(context, rootNavigator: true). pop();
      }
    },
    textColor: Colors.white,
    padding: EdgeInsets.all(0.0),
    child: Container(
      alignment: Alignment.center,
      width: _width/5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        gradient: LinearGradient(
          colors: <Color>[Colors.orange[200], Colors.pinkAccent],
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Text(text ,style: TextStyle(fontSize: 15)),
    ),
  );
}
