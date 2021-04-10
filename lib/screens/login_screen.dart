import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahathir_academy_app/screens/navigation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

//
// class LoginPage extends StatelessWidget {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LoginScreen(),
//     );
//   }
// }


class LoginScreen extends StatefulWidget {

  static const String id = '/';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
        title: Text('Login'),
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
                welcomeText(),
                loginText(),
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
                button(),
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
      child: new Image.asset('images/login.png'));
  }

  Widget welcomeText(){
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Welcome",
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

  Widget loginText() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Sign in to your account",
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

  // Widget form() {
  //   return Container(
  //     margin: EdgeInsets.only(
  //         left: _width / 12.0,
  //         right: _width / 12.0,
  //         top: _height / 15.0),
  //     child: Form(
  //       key: _key,
  //       child: Column(
  //         children: <Widget>[
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: (){
        RegExp regExp = new RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
        if(_email == null || _email.isEmpty){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Email Cannot be empty')));
        }else if(_password == null || _password.length < 6){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Password needs to be at least six characters')));
        }else if(!regExp.hasMatch(_email)){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter a Valid Email')));
        }else{
          setState((){showSpinner = true;});
          signIn();
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _width/2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.red[900], Colors.yellow[900]],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',style: TextStyle(fontSize: 15)),
      ),
    );
  }

  Future<void> signIn() async {
    try{
      final user = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      if (user != null){
        Navigator.pushNamed(context, Navigation.id);
        setState((){showSpinner = false;});
      }
    }catch(e){
      setState((){showSpinner = false;});
      print(e.message);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

}