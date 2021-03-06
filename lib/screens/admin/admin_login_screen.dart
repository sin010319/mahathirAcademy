import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'HQAdmin_navigation.dart';
import 'franchiseAdmin_navigation.dart';
import 'package:mahathir_academy_app/screens/login_screen.dart';
import 'package:sizer/sizer.dart';

class AdminLoginScreen extends StatefulWidget {
  static const String id = '/admin_login';

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  // create an authentication instance
  // use this auth object to use the associated methods with sign in
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  double _height, _width;
  String _email = '', _password = '';
  bool _showPassword = true;
  bool showSpinner = false; // to figure out when should our spinner spins
  String hqAdmin = "@gmail.com", franchiseAdmin = "@admin.com";

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  child: Text('Admin Login',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                      )),
                )
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            height: _height,
            width: _width,
            padding: EdgeInsets.only(bottom: 3.h),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  image(),
                  welcomeText(),
                  loginText(),
                  Container(
                      margin: EdgeInsets.only(
                          left: _width / 12.0,
                          right: _width / 12.0,
                          top: _height / 15.0),
                      child: Column(children: <Widget>[
                        emailBox(),
                        SizedBox(height: _height / 40.0),
                        passwordBox(),
                      ])),
                  SizedBox(height: _height / 12),
                  Column(
                    children: [
                      Text('Sign in as:'),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HQAdminButton(),
                          SizedBox(width: 5.w),
                          franchiseAdminButton(),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 9.sp),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'I am not an admin. ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: 'Click here.',
                              style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.redAccent,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushNamed(
                                    context, LoginScreen.id))
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget image() {
    return Container(
        margin: EdgeInsets.only(top: _height / 25.0),
        height: 16.0.h,
        width: 16.0.h,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Image.asset('assets/images/login.png'));
  }

  Widget welcomeText() {
    return Container(
      padding: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Welcome, Admin",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginText() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Sign in to your admin account",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailBox() {
    return Material(
      borderRadius: BorderRadius.circular(30.0.sp),
      elevation: 10,
      child: TextField(
        onChanged: (input) => _email = input,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.redAccent,
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: Colors.red[900], size: 15.sp),
          hintText: "User ID",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0.sp),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget passwordBox() {
    return Material(
      borderRadius: BorderRadius.circular(30.0.sp),
      elevation: 10,
      child: TextField(
        onChanged: (input) => _password = input,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.redAccent,
        obscureText: _showPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.red[900], size: 15.sp),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: this._showPassword ? Colors.grey : Colors.red[900],
            ),
            onPressed: () {
              setState(() => this._showPassword = !this._showPassword);
            },
          ),
          hintText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0.sp),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget franchiseAdminButton() {
    String name;
    return RaisedButton(
      elevation: 0,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0.sp)),
      onPressed: () {
        RegExp regExp = new RegExp(
            r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
        if (_email == null || _email.isEmpty) {
          showAlertDialog(context);
        } else if (_password == null || _password.length < 6) {
          showAlertDialog(context);
        } else {
          setState(() {
            showSpinner = true;
          });
          franchiseAdminSignIn();
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0.h),
      child: Container(
        alignment: Alignment.center,
        width: _width / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0.sp)),
          gradient: LinearGradient(
            colors: <Color>[Colors.red[900], Colors.yellow[900]],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('FRANCHISE ADMIN', style: TextStyle(fontSize: 9.sp)),
      ),
    );
  }

  Widget HQAdminButton() {
    String name;
    return RaisedButton(
      elevation: 0,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0.sp)),
      onPressed: () {
        RegExp regExp = new RegExp(
            r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
        if (_email == null || _email.isEmpty) {
          showAlertDialog(context);
        } else if (_password == null || _password.length < 6) {
          showAlertDialog(context);
        } else {
          setState(() {
            showSpinner = true;
          });
          HQAdminSignIn();
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0.h),
      child: Container(
        alignment: Alignment.center,
        width: _width / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0.sp)),
          gradient: LinearGradient(
            colors: <Color>[Colors.red[900], Colors.yellow[900]],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('HQ ADMIN', style: TextStyle(fontSize: 9.sp)),
      ),
    );
  }

  Future<void> franchiseAdminSignIn() async {
    _email = _email + franchiseAdmin;
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (user != null) {
        Navigator.pushNamed(context, franchiseAdminNavigation.id);
        setState(() {
          showSpinner = false;
        });
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      showAlertDialog(context);
      print(e.message);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> HQAdminSignIn() async {
    // _email = _email + hqAdmin;
    _email = _email + hqAdmin;
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);

      if (user != null) {
        Navigator.pushNamed(context, HQAdminNavigation.id);
        setState(() {
          showSpinner = false;
        });
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      showAlertDialog(context);
      print(e.message);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  showAlertDialog(BuildContext c) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushNamed(context, AdminLoginScreen.id);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Login Error"),
      content: Text("Please use correct email and password."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
