import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/components/round_button.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mahathir_academy_app/screens/admin/HQAdmin_navigation.dart';
import 'package:mahathir_academy_app/screens/admin/franchiseAdmin_navigation.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';
import 'package:mahathir_academy_app/screens/student/student_navigation.dart';
import 'package:mahathir_academy_app/screens/login_screen.dart';


class LoginScreenTemplate extends StatefulWidget {

  static const String id = '/login_template';
  String appBarTitle;
  String welcomeTextIdentifier;
  String loginTextIdentifier;
  RichText bottomText;
  Widget button1;
  Widget button2;
  final scaffoldKey;

  LoginScreenTemplate({
      this.appBarTitle,
      this.welcomeTextIdentifier,
      this.loginTextIdentifier,
    this.bottomText,
  this.button1,
  this.button2,
  this.scaffoldKey});

  @override
  _LoginScreenTemplateState createState() => _LoginScreenTemplateState();
}

class _LoginScreenTemplateState extends State<LoginScreenTemplate> {

  // create an authentication instance
  // use this auth object to use the associated methods with sign in
  final _auth = FirebaseAuth.instance;

  double _height, _width;
  String _email = '', _password = '';
  bool _showPassword = true;
  bool showSpinner = false; // to figure out when should our spinner spins

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                image(),
                welcomeText(widget.welcomeTextIdentifier),
                loginText(widget.loginTextIdentifier),
                Container(
                    margin: EdgeInsets.only(
                        left: _width / 12.0,
                        right: _width / 12.0,
                        top: _height / 15.0),
                    child: Column(children: <Widget> [
                      emailBox(),
                      SizedBox(height: _height / 40.0),
                      passwordBox(),])
                ),
                SizedBox(height: _height / 12),
                Column(
                  children: [
                    Text('Sign in as an:'),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.button1,
                        SizedBox(width: 20),
            widget.button2,
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 10),
                widget.bottomText
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget image(){
    return Container(
        margin: EdgeInsets.only(top: _height / 15.0),
        height: 100.0,
        width: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Image.asset('assets/images/login.png'));
  }

  Widget welcomeText(String welcomeTextIdentifier){
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              welcomeTextIdentifier,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginText(String loginTextIdentifier) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              loginTextIdentifier,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailBox(){
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: 10,
      child:TextField(
        onChanged: (input) => _email = input,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.redAccent,
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: Colors.red[900], size: 20),
          hintText: "Email ID",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget passwordBox(){
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: 10,
      child:TextField(
        onChanged: (input) => _password = input,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.redAccent,
        obscureText: _showPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.red[900], size: 20),
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
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }


}