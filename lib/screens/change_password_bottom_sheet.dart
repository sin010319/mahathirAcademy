import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/components/password_box.dart';
import 'package:mahathir_academy_app/components/pop_up_alert.dart';
import 'package:mahathir_academy_app/components/pop_up_dialog.dart';
import 'package:mahathir_academy_app/components/round_button.dart';
import 'package:mahathir_academy_app/template/add_amend_bottomSheet_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

// for storing data into cloud firebase
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class ChangePasswordBottomSheet extends StatefulWidget {
  static const String id = '/change_password';

  String identifier;
  String userId;

  ChangePasswordBottomSheet({this.identifier, this.userId});

  @override
  _ChangePasswordBottomSheetState createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  String newPassword = "";
  String confirmPassword = "";

  Color displayTextColor = Colors.redAccent;
  String textToDisplay = "";
  bool viewVisible = false;

  void shortPassword() {
    setState(() {
      viewVisible = true;
      textToDisplay = "Password too short";
      displayTextColor = Color(0xFF8A1501);
    });
  }

  void passwordNotMatch() {
    setState(() {
      viewVisible = true;
      textToDisplay = "Passwords do not match";
      displayTextColor = Color(0xFF8A1501);
    });
  }

  void passwordMatch() {
    setState(() {
      viewVisible = true;
      textToDisplay = "Passwords match";
      displayTextColor = Colors.green;
    });
  }

  void hideText() {
    setState(() {
      viewVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void changePassword(String password) async {
      //Create an instance of the current user.
      User user = await _auth.currentUser;

      //Pass in the password to updatePassword.
      user.updatePassword(password).then((_) {
        print("Successfully changed password");
      }).catchError((error) {
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    }

    Future<void> callFunc(String password) async {
      await changePassword(password);
      String message = 'You have successfully updated your password.';
      PopUpAlertClass.popUpAlert(message, context);
    }

    List<Widget> retContent = [
      SizedBox(height: 4.0.h),
      PasswordBox(
          hintText: "New Password",
          function: (input) {
            setState(() {
              this.newPassword = input;
              if (this.newPassword.length < 6) {
                shortPassword();
              } else {
                hideText();
              }
            });
          }),
      SizedBox(height: 3.0.h),
      PasswordBox(
          hintText: "Confirm Password",
          function: (input) {
            setState(() {
              this.confirmPassword = input;
              if (this.confirmPassword != this.newPassword) {
                passwordNotMatch();
              } else {
                passwordMatch();
              }
            });
          }),
      SizedBox(
        height: 1.0.h,
      ),
      Align(
        alignment: Alignment.center,
        child: Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: viewVisible,
            child: Text(textToDisplay,
                style: TextStyle(
                    color: displayTextColor,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.bold))),
      ),
      SizedBox(
        height: 4.0.h,
      ),
      RoundButton(
          label: 'Save Changes',
          function: () async {
            if (this.newPassword.isEmpty || this.confirmPassword.isEmpty) {
              String message =
                  'Kindly fill up all the required field(s) before changing password.';
              PopUpAlertClass.popUpAlert(message, context);
            } else {
              if (this.newPassword.length < 6) {
                String message =
                    "Please provide a password with at least 6 characters.";
                PopUpAlertClass.popUpAlert(message, context);
              } else {
                if (this.newPassword == this.confirmPassword) {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  String message =
                      'Are you sure you want to change your password?';
                  PopUpDialogClass.popUpDialog(message, context, () {
                    Navigator.of(context, rootNavigator: true).pop();
                    callFunc(this.newPassword);
                  }, () {
                    Navigator.of(context, rootNavigator: true).pop();
                  });
                } else {
                  String message =
                      "Your new and confirm passwords do not match.";
                  PopUpAlertClass.popUpAlert(message, context);
                }
              }
            }
          }),
    ];

    return AddAmendTemplate(identifier: widget.identifier, content: retContent);
  }
}
