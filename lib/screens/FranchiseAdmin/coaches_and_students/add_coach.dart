// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mahathir_academy_app/components/pop_up_alert.dart';
// import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
// import 'package:mahathir_academy_app/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mahathir_academy_app/models/coach.dart';
// import 'package:mahathir_academy_app/screens/FranchiseAdmin/coaches_and_students/edit_coach_bottomSheet.dart';
// import 'package:mahathir_academy_app/screens/coach/coach_profile_specific.dart';
// import 'package:mahathir_academy_app/template/select_coach_template.dart';
//
// import 'assign_coach_add_students_bottomSheet.dart';
//
// // for storing data into cloud firebase
// final _firestore = FirebaseFirestore.instance;
// final _auth = FirebaseAuth.instance;
// String targetAdminId;
//
// class AddCoachScreen extends StatefulWidget {
//   static const String id = '/addFranchise';
//   List<String> franchises = ['Franchise1', 'Franchise2', 'Franchise3'];
//
//   @override
//   _AddCoachScreenState createState() => _AddCoachScreenState();
//
//   Future retrievedCoaches;
// }
//
// class _AddCoachScreenState extends State<AddCoachScreen> {
//   @override
//   void initState() {
//     targetAdminId = _auth.currentUser.uid;
//     widget.retrievedCoaches = callFunc();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Future<void> removeCoach(String CoachIdForDelete) async {
//       CollectionReference coaches =
//           FirebaseFirestore.instance.collection('coaches');
//
//       return coaches
//           .doc(CoachIdForDelete)
//           .delete()
//           .then((value) => print("Franchise Removed"))
//           .catchError((error) => print("Failed to remove franchise: $error"));
//     }
//
//     Future<void> removeData(String coachIdForDelete) async {
//       CollectionReference franchiseAdmins =
//           FirebaseFirestore.instance.collection('franchiseAdmins');
//       CollectionReference students =
//           FirebaseFirestore.instance.collection('students');
//       CollectionReference classes =
//           FirebaseFirestore.instance.collection('classes');
//       CollectionReference coaches =
//           FirebaseFirestore.instance.collection('coaches');
//
//       dynamic classIdsForDelete = [];
//
//       await franchiseAdmins
//           .where('franchiseId', isEqualTo: coachIdForDelete)
//           .get()
//           .then((querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//           classIdsForDelete = doc['classIds'];
//         });
//       });
//
//       for (dynamic classId in classIdsForDelete) {
//         await classes
//             .where('classId', isEqualTo: classId)
//             .get()
//             .then((querySnapshot) {
//           querySnapshot.docs.forEach((doc) {
//             doc.reference.delete();
//           });
//         });
//       }
//
//       await franchiseAdmins
//           .where('franchiseId', isEqualTo: coachIdForDelete)
//           .get()
//           .then((querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//           doc.reference.delete();
//         });
//       });
//
//       await students
//           .where('franchiseId', isEqualTo: coachIdForDelete)
//           .get()
//           .then((querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//           doc.reference.delete();
//         });
//       });
//
//       await coaches
//           .where('franchiseId', isEqualTo: coachIdForDelete)
//           .get()
//           .then((querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//           doc.reference.delete();
//         });
//       });
//     }
//
//     Future<void> callDeleteFunc(String franchiseIdForDelete) async {
//       await removeCoach(franchiseIdForDelete);
//       await removeData(franchiseIdForDelete);
//       String franchiseDeletedMsg =
//           'You have successfully removed a franchise. Please close this page to view the newly updated franchises.';
//       await PopUpAlertClass.popUpAlert(franchiseDeletedMsg, context);
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (BuildContext context) => super.widget));
//     }
//
//     return SelectCoachTemplate(
//         myFab: FloatingActionButton(
//           onPressed: () {
//             showModal();
//           },
//           backgroundColor: Color(0xFF8A1501),
//           child: Icon(Icons.add),
//         ),
//         coachContentTitleBuilder: FutureBuilder(
//             future: widget.retrievedCoaches,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState != ConnectionState.done ||
//                   snapshot.hasError) {
//                 print('error3');
//                 return Container();
//               }
//               return Text(
//                 '${snapshot.data[0]} \n${snapshot.data[1].length} coaches',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18.0),
//               );
//             }),
//         myFutureBuilder: FutureBuilder(
//             future: widget.retrievedCoaches,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState != ConnectionState.done ||
//                   snapshot.hasError) {
//                 print('error3');
//                 return Center(child: CircularProgressIndicator());
//               }
//               return Expanded(
//                 child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         child: Center(
//                             child: ListTile(
//                                 title: Text(snapshot.data[index].coachName),
//                                 trailing: Wrap(
//                                   spacing: 8,
//                                   children: [
//                                     GestureDetector(
//                                       child: Icon(
//                                         Icons.edit,
//                                         color: Color(0xFF8A1501),
//                                       ),
//                                       onTap: () {
//                                         showModalBottomSheet(
//                                             context: context,
//                                             // builder here needs a method to return widget
//                                             builder: editCoachBuildBottomSheet,
//                                             isScrollControlled:
//                                                 true // enable the modal take up the full screen
//                                             );
//                                       },
//                                     ),
//                                     GestureDetector(
//                                       child: Icon(
//                                         Icons.delete,
//                                         color: Color(0xFF8A1501),
//                                       ),
//                                       onTap: () {
//                                         String message =
//                                             'Are you sure you want to remove ${snapshot.data[index].coachName}? Note that when you remove this coach, all the coach information will be wiped away.';
//                                         PopUpDialogClass.popUpDialog(
//                                             message, context, () {
//                                           Navigator.of(context,
//                                                   rootNavigator: true)
//                                               .pop();
//                                           callDeleteFunc(
//                                               snapshot.data[index].coachId);
//                                         }, () {
//                                           Navigator.of(context,
//                                                   rootNavigator: true)
//                                               .pop();
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             SpecificCoachProfile(
//                                           franchiseInfo: snapshot.data[index],
//                                         ),
//                                       ));
//                                 })),
//                       );
//                     }),
//               );
//             }));
//   }
//
//   void showModal() {
//     Future<void> future = showModalBottomSheet(
//         context: context,
//         // builder here needs a method to return widget
//         builder: coachBuildBottomSheet,
//         isScrollControlled: true // enable the modal take up the full screen
//         );
//     future.then((void value) => closeModal(value));
//   }
//
//   FutureBuilder<dynamic> closeModal(void value) {
//     print('modal closed');
//     Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (BuildContext context) => super.widget));
//   }
//
//   Future<List<Coach>> coachData() async {
//     String coachId;
//     String coachName;
//     List<Coach> coachList = [];
//
//     await _firestore
//         .collection('coaches')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         coachName = doc["coachName"];
//         coachId = doc["coachId"];
//         Coach newCoach = Coach.fromCoach(coachName, coachId);
//         coachList.add(newCoach);
//       });
//     });
//
//     return coachList;
//   }
//
//   Future callFunc() async {
//     return await coachData();
//   }
// }
//
// Widget coachBuildBottomSheet(BuildContext context) {
//   String identifier = 'Coach';
//
//   return SingleChildScrollView(
//     child: Container(
//       padding:
//           EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//       // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
//       child: AddCoachStudentBottomSheet(
//         identifier: identifier,
//         franchiseId: franchiseId,
//         title1: franchiseName,
//         title2: franchiseLocation,
//       ),
//     ),
//   );
// }
//
// Widget editCoachBuildBottomSheet(BuildContext context) {
//   String identifier = 'Amend Franchise';
//
//   return SingleChildScrollView(
//     child: Container(
//       padding:
//           EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//       // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
//       child: EditCoachBottomSheet(identifier: identifier),
//     ),
//   );
// }
