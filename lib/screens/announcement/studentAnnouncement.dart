import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahathir_academy_app/models/student.dart';
import 'package:sizer/sizer.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
final _auth = FirebaseAuth.instance;
String targetStudentId = "";
String targetStudentName;
String targetAdminName;
String targetAdminId = "";
String targetFranchiseId;
String targetStudentFranchise;

class StudentAnnouncement extends StatelessWidget {
  final messageTextController = TextEditingController();

  String messageText;

  static const String id = '/studentAnnouncement';

  @override
  Widget build(BuildContext context) {
    targetStudentId = _auth.currentUser.uid;
    getStudent();
    print(targetStudentFranchise);
    print(targetStudentId);
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
          ],
        ),
      ),
    );
  }

  Future<Student> getStudent() async {
    await _firestore
        .collection('students')
        .doc(targetStudentId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data();
      targetStudentFranchise = data['franchiseAdminName'];
      print(targetStudentName);
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
          final messageTarget = message.data()['target'];
          print(messageSender);
          print(targetStudentFranchise);

          if ((messageSender == targetStudentFranchise &&
                  messageTarget == "franchiseStudent") ||
              messageSender == "hqAdmin" ||
              (messageSender == targetStudentFranchise &&
                  messageTarget == targetStudentId)) {
            final messageBubble = MessageBubble(
                sender: messageSender ?? 'default value',
                text: messageText ?? 'default value',
                target: messageTarget ?? 'default value');
            messageBubbles.add(messageBubble);
          }
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
  MessageBubble({this.sender, this.text, this.target});

  final String sender;
  final String target;
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
