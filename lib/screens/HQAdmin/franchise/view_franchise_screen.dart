import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/template/SelectFranchiseTemplate.dart';

class ViewFranchiseScreen extends StatefulWidget {

  static const String id = '/addFranchise';
  List<String> franchises = ['Franchise1', 'Franchise2', 'Franchise3'];

  @override
  _ViewFranchiseScreenState createState() => _ViewFranchiseScreenState();
}

class _ViewFranchiseScreenState extends State<ViewFranchiseScreen> {

  @override
  Widget build(BuildContext context) {
    return SelectFranchiseTemplate(
      fab: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              // builder here needs a method to return widget
              builder: addFranchiseBuildBottomSheet,
              isScrollControlled: true // enable the modal take up the full screen
          );
        },
        backgroundColor: Color(0xFF8A1501),
        child: Icon(Icons.add),
      ),
      myItemBuilder: (context, index) {
        return Card(
          child: Center(
              child: ListTile(
                  title: Text(
                      widget.franchises[index]),
                  trailing:
                  Wrap(
                    spacing: 8,
                    children: [
                      GestureDetector(
                        child: Icon(Icons.edit,
                          color: Color(0xFF8A1501),),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              // builder here needs a method to return widget
                              builder: editFranchiseBuildBottomSheet,
                              isScrollControlled: true // enable the modal take up the full screen
                          );
                        },),
                      GestureDetector(
                        child: Icon(Icons.delete,
                          color: Color(0xFF8A1501),),
                        onTap: () {
                          deleteDialog(context, widget
                              .franchises[index]);
                        },),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                        context, ViewAdminScreen.id);
                  }
              )
          ),
        );
      }
    );
  }
}


deleteDialog(BuildContext context, String itemRemoved){
  showDialog(
      context: context,
      builder: (BuildContext context) {
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
                          onTap: (){
                            Navigator. of(context, rootNavigator: true). pop();
                          },
                          child: Icon(Icons.close)),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Are you sure you want to remove $itemRemoved?',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        button('Yes', context),
                        button('No', context),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

Widget button(String text, BuildContext context) {

  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;

  return RaisedButton(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    onPressed: (){
      if(text == 'Yes'){
        // do something
      }else if(text == 'No'){
        Navigator. of(context, rootNavigator: true). pop();
      }
    },
    textColor: Colors.white,
    padding: EdgeInsets.all(0.0),
    child: Container(
      alignment: Alignment.center,
      width: _width/5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        gradient: LinearGradient(
          colors: <Color>[Colors.orange[200], Colors.pinkAccent],
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Text(text ,style: TextStyle(fontSize: 15)),
    ),
  );
}


Widget editFranchiseBuildBottomSheet(BuildContext context){

  String identifier = 'Amend Franchise';

  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: EditFranchiseBottomSheet(identifier: identifier),
    ),
  );
}

Widget addFranchiseBuildBottomSheet(BuildContext context){

  String identifier = 'Franchise';

  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      // make AddTaskScreen class to take a callback to pass the new added task to TaskScreen class
      child: AddFranchiseBottomSheet(identifier: identifier),
    ),
  );
}
