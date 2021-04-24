import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard extends StatefulWidget {

  static const String id = '/view_exp';
  List<String> students = ['Student1', 'Student2', 'Student3'];

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final _firestore = FirebaseFirestore.instance;
  int i = 0;
  List<TextEditingController> _controllers = new List();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    var r = TextStyle(color: Colors.yellow, fontSize: 34);

    return Scaffold(
      appBar: AppBar(title: Text('Student Ranking')),
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
                    backgroundImage: AssetImage("assets/icons/overall.png"),
                    radius: 30.0,
                  ),
                  SizedBox(
                    height: 10.0,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('students')
                                .orderBy('exp', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      print(index);
                                      if (index >= 1) {
                                        print('Greater than 1');
                                        if (snapshot.data.docs[index]
                                            .data()['exp'] ==
                                            snapshot.data.docs[index - 1]
                                                .data()['exp']) {
                                          print('Same');
                                        } else {
                                          i++;
                                        }
                                      }


                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 5.0),
                                        child: InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: i == 0
                                                        ? Colors.amber
                                                        : i == 1
                                                        ? Colors.grey
                                                        : i == 2
                                                        ? Colors.brown
                                                        : Colors.red[100],
                                                    width: 3.0,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                BorderRadius.circular(5.0)),
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 20.0, top: 10.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                snapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .data()['studentName'],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    fontSize: 15
                                                                ),
                                                                maxLines: 6,
                                                              )),
                                                          SizedBox(height: 5,),
                                                          Text("Points: " +
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .data()['exp']
                                                                  .toString()),
                                                          SizedBox(height: 5,),
                                                        ],
                                                      ),
                                                    ),
                                                    Flexible(child: Container()),
                                                    i == 0
                                                        ? Text("🥇", style: r)
                                                        : i == 1
                                                        ? Text(
                                                      "🥈",
                                                      style: r,
                                                    )
                                                        : i == 2
                                                        ? Text(
                                                      "🥉",
                                                      style: r,
                                                    )
                                                        : Text(''),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20.0,
                                                          top: 13.0,
                                                          right: 20.0),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                            }))
                  ],
                ),
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



