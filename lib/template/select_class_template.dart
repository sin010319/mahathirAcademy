import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/coach/coach_navigation.dart';


class SelectClassTemplate extends StatefulWidget {

  static const String id = '/selectClassTemplate';
  List<String> classes = ['Class1', 'Class2', 'Class3'];

  String textForDisplay;
  Function function;


  SelectClassTemplate({this.textForDisplay, this.function});

  @override
  _SelectClassTemplateState createState() => _SelectClassTemplateState();
}

class _SelectClassTemplateState extends State<SelectClassTemplate> {

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
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/icons/classroom.png"),
                radius: 30.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.textForDisplay,
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
                        title: Text(widget.classes[index],
                          style: kListItemsTextStyle,),
                        onTap: widget.function,
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