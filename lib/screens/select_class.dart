import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/screens/coach/coach.dart';
import 'award_exp.dart';


class SelectClass extends StatefulWidget {

  static const String id = '/selectClass';
  List<String> classes = ['Class1', 'Class2', 'Class3'];

  @override
  _SelectClassState createState() => _SelectClassState();
}

class _SelectClassState extends State<SelectClass> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        title: Text('Select Class')),
        backgroundColor: Color(0xFFDB5D38),
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // wrap the icon in a circle avatar
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.list,
                  size: 30.0,
                  color: Color(0xFF8A1501),),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Please select the class you want to award EXP to: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0
                ),
              ),
            ],
          ),
        ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              // container must have a child to get shown up on screen
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)
                  )
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.classes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Center(
                      child: ListTile(
                        title: Text(widget.classes[index]),
                        onTap:() {
                          Navigator.pushNamed(context, AwardExp.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}