import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Leaderboard extends StatefulWidget {
  static const String id = '/leaderboard';
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final _firestore = FirebaseFirestore.instance;

  int i = 0;
  Color my = Colors.brown, CheckMyColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    var r = TextStyle(color: Colors.yellow, fontSize: 34);
    return Stack(
      children: <Widget>[
        Scaffold(
            backgroundColor: Color(0xFFDB5D38),
            appBar: AppBar(title: Text('LeaderBoard')),
            body: Container(
              color: Colors.red,
              padding: EdgeInsets.only(top:100),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('points')
                                .orderBy('point', descending: true)
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
                                            .data()['point'] ==
                                            snapshot.data.docs[index - 1]
                                                .data()['point']) {
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
                                                                    .data()['name'],
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
                                                                  .data()['point']
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
            )),
      ],
    );
  }

}
