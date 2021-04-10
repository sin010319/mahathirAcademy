

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class AwardExp extends StatefulWidget {
  static const String id = '/award_exp';
  List<String> students = ['Student1', 'Student2', 'Student3'];

  @override
  _AwardExpState createState() => _AwardExpState();
}

class _AwardExpState extends State<AwardExp> {
  List<TextEditingController> _controllers = new List();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // add a new container that slides up for us to add new task
          // modal bottom sheet
          EXPDialog(context);
        },
        backgroundColor: Color(0xFF8A1501),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('Award EXP')),
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
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      FontAwesomeIcons.award,
                      size: 30.0,
                      color: Color(0xFF8A1501),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Class ?',
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
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.students.length,
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Checkbox(
                              // When this checkboxState value changes, it is going to trigger this callback and pass in the latest state of checkbox
                              activeColor: Colors.lightBlueAccent,  // color of tick
                              value: isChecked, // if true, checked; else unchecked
                              // once the user clicks on the checkbox, swap the state
                              onChanged: (bool newValue) {
                                setState(() {
                                  isChecked = newValue;
                                });
                                },
                            ),
                          ),
                          Expanded(
                            flex: 7, child:
                          Card(
                          child: Center(
                          child: ListTile(
                          title: Text(widget.students[index]),
                          ),
                          ),
                          ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget> [Card(
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 25.0
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                              )
                      ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ]),
    );
  }
}

EXPDialog(BuildContext context){
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
                      'Are you sure you want to add the EXP?'
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
