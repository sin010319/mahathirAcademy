import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/admin.dart';
import 'package:mahathir_academy_app/screens/admin/hqviewStudentsRank.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
final _auth = FirebaseAuth.instance;
String targetAdminId="";
String targetFranchiseAdminName;

class FranchiseAnnouncement extends StatelessWidget {
  final messageTextController = TextEditingController();

  String messageText;

  static const String id = '/franchiseAnnouncement';


  @override
  Widget build(BuildContext context) {
    targetAdminId = _auth.currentUser.uid;
    getFranchiseAdmin();
    print(targetFranchiseAdminName);
    print(targetAdminId);
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
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        print(messageText);
                        print("lamo");
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('announcements').add(
                          {'message' : messageText,
                            'sender' : targetFranchiseAdminName,
                            'timestamp': new DateTime.now(),
                            'target': 'franchiseStudent'

                          });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),

          ],

        ),

      ),
    );
  }

  Future<Admin> getFranchiseAdmin() async {
    await _firestore.collection('franchiseAdmins')
        .doc(targetAdminId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      targetFranchiseAdminName = data['franchiseAdminName'];
      targetFranchiseId = data['franchiseId'];
      print(targetFranchiseAdminName);
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

          if (messageSender == 'hqAdmin' || (messageSender == targetFranchiseAdminName && messageTarget == 'franchiseStudent')) {
            final messageBubble = MessageBubble(sender: messageSender, text: messageText, target: messageTarget);
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

