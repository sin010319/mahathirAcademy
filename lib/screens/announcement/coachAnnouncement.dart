import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/admin.dart';
import 'package:mahathir_academy_app/models/student.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
final _auth = FirebaseAuth.instance;
String targetCoachId="";
String targetStudentName;
String targetAdminName;
String targetAdminId="";
String targetFranchiseId;
String targetCoachFranchise;

class CoachAnnouncement extends StatelessWidget {
  final messageTextController = TextEditingController();

  String messageText;

  static const String id = '/coachAnnouncement';


  @override
  Widget build(BuildContext context) {
    targetCoachId = _auth.currentUser.uid;
    getCoach();
    print(targetCoachFranchise);
    print(targetCoachId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessagesStream(),
          ],

        ),

      ),
    );
  }

  Future<Student> getCoach() async {
    await _firestore.collection('coaches')
        .doc(targetCoachId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      targetCoachFranchise = data['franchiseAdmin'];
      print(targetStudentName);
      print("hahahhah");




    });
  }


}
class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('announcements').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['message'];
          final messageSender = message.data()['sender'];
          final messageTarget = message.data()['target'];
          print(messageSender);
          print(targetCoachFranchise);

          if ((messageSender == targetCoachFranchise && messageTarget == 'franchiseStudent')  || messageSender == "hqAdmin") {
            final messageBubble = MessageBubble(sender: messageSender??'default value', text: messageText??'default value');
            messageBubbles.add(messageBubble);

          }






        };
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );

      },

    );

  }

}


class MessageBubble extends StatelessWidget {

  MessageBubble({this.sender, this.text, this.target});

  final String sender;
  final String text;
  final String target;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom:5.0),
            child: Text(sender,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,

              ),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: Colors.red[900],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),

          )],
      ),
    );
  }

}

