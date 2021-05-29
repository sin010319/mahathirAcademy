import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/screens/leaderboard.dart';
import 'level_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category extends StatefulWidget {


  static const String id = '/categoryTemplate';
  List<String> classes = ['🔴 Elite', '🟠 Diamond', '🟡 Ruby', '🟢 Platinum', '🟣 Gold', '🔵 Silver', '🟤 Bronze', '🏆 Overall'];

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text('Select Class Speaker Category')),
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
                radius: 30.0,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.list,
                  size: 30.0,
                  color: Color(0xFF8A1501),),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Please select which class speaker you want to view: ',
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.classes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Center(
                      child: ListTile(
                        title: Text(
                          widget.classes[index],
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap:() {
                          switch (index){
                            case 0:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LevelTemplate(
                                        titleForDisplay: "Elite Speaker",
                                        streamList: _firestore
                                            .collection('students')
                                            .orderBy('exp', descending: true)
                                            .where('exp', isGreaterThanOrEqualTo: 4000)
                                            .snapshots(),
                                        imageLocation: 'elite'),

                                  ));
                              break;
                            case 1:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LevelTemplate(
                                          titleForDisplay: "Diamond Speaker",
                                          streamList: _firestore
                                              .collection('students')
                                              .orderBy('exp', descending: true)
                                              .where('exp', isGreaterThanOrEqualTo: 3000, isLessThan: 4000)
                                              .snapshots(),
                                          imageLocation: 'diamond')
                                  ));
                              break;
                            case 2:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LevelTemplate(
                                          titleForDisplay: "Ruby Speaker",
                                          streamList: _firestore
                                              .collection('students')
                                              .orderBy('exp', descending: true)
                                              .where('exp', isGreaterThanOrEqualTo: 2000, isLessThan: 3000)
                                              .snapshots(),
                                          imageLocation: 'ruby')
                                  ));
                              break;
                            case 3:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LevelTemplate(
                                        titleForDisplay: "Platinum Speaker",
                                        streamList: _firestore
                                            .collection('students')
                                            .orderBy('exp', descending: true)
                                            .where('exp', isGreaterThanOrEqualTo: 1500, isLessThan: 2000)
                                            .snapshots(),
                                        imageLocation: 'platinum'),
                                  ));
                              break;
                            case 4:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LevelTemplate(
                                          titleForDisplay: "Gold Speaker",
                                          streamList: _firestore
                                              .collection('students')
                                              .orderBy('exp', descending: true)
                                              .where('exp', isGreaterThanOrEqualTo: 1000, isLessThan: 1500)
                                              .snapshots(),
                                          imageLocation: 'gold')
                                  ));
                              break;
                            case 5:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LevelTemplate(
                                          titleForDisplay: "Silver Speaker",
                                          streamList: _firestore
                                              .collection('students')
                                              .orderBy('exp', descending: true)
                                              .where('exp', isGreaterThanOrEqualTo: 500, isLessThan: 1000)
                                              .snapshots(),
                                          imageLocation: 'silver')
                                  ));
                              break;
                            case 6:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LevelTemplate(
                                          titleForDisplay: "Bronze Speaker",
                                          streamList: _firestore
                                              .collection('students')
                                              .orderBy('exp', descending: true)
                                              .where('exp', isLessThan: 500)
                                              .snapshots(),
                                          imageLocation: 'bronze')
                                  ));
                              break;
                            case 7:
                              Navigator.pushNamed(context, Leaderboard.id);
                              break;
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}