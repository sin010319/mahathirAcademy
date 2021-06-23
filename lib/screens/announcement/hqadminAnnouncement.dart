import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/models/admin.dart';
import 'package:sizer/sizer.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
final _auth = FirebaseAuth.instance;
String targetAdminId = "";
String targetAdminName;

class HQAdminAnnouncement extends StatelessWidget {
  final messageTextController = TextEditingController();

  String messageText;

  static const String id = '/hqAminAnnouncement';

  @override
  Widget build(BuildContext context) {
    targetAdminId = _auth.currentUser.uid;
    getAdmin();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Row(
            children: [
              Image.asset("assets/images/brand_logo.png",
                  fit: BoxFit.contain, height: 5.5.h),
              SizedBox(
                width: 1.5.w,
              ),
              Flexible(
                child: Text('Announcement',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                    )),
              )
            ],
          ),
        ),
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
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('announcements').add({
                        'message': messageText,
                        'sender': targetAdminName,
                        'timestamp': new DateTime.now()
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

  Future<Admin> getAdmin() async {
    await _firestore
        .collection('hqAdmin')
        .doc(targetAdminId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      targetAdminName = data['username'];
      print(targetAdminName);
    });
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('announcements')
          .orderBy('timestamp')
          .snapshots(),
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

          final messageBubble = MessageBubble(
              sender: messageSender ?? 'default value',
              text: messageText ?? 'default value');
          messageBubbles.add(messageBubble);
        }
        ;
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text});

  final String sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5.0.sp),
            child: Text(
              sender,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.sp),
                bottomLeft: Radius.circular(30.sp),
                bottomRight: Radius.circular(30.sp)),
            elevation: 5.0,
            color: Colors.red[900],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
              child: Text(
                '$text',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
