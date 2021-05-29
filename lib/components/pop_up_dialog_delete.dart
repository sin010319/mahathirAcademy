import 'package:flutter/material.dart';

class DeletePopUpDialogClass extends StatelessWidget {
  DeletePopUpDialogClass(
      {this.message,
      this.onChangedFunction,
      this.btn1Text,
      this.btn2Text,
      this.function1,
      this.function2});

  final String message;
  String btn1Text;
  String btn2Text;
  Function function1;
  Function function2;
  Function onChangedFunction;

  static popUpDialog(
      String message,
      Function onChangedFunction,
      BuildContext context,
      String btn1Text,
      String btn2Text,
      Function function1,
      Function function2) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeletePopUpDialogClass(
            message: message,
            onChangedFunction: onChangedFunction,
            btn1Text: btn1Text,
            btn2Text: btn2Text,
            function1: function1,
            function2: function2,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        content: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -40.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Icon(Icons.close)),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(message),
                TextField(
                  onChanged: onChangedFunction,
                  decoration:
                      InputDecoration(hintText: "user password for delete"),
                ),
                SizedBox(
                  height: 15.0,
                ),
                button(btn1Text, function1, context),
                button(btn2Text, function2, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget button(String text, Function function, BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: function,
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(text, style: TextStyle(fontSize: 15)),
      ),
    );
  }
}
