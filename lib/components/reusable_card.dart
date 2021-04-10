import 'package:flutter/material.dart';

// extract repeated widget out here as a stateless widget class
class ReusableCard extends StatelessWidget {
  // Key is a class that will keep track of the state of widgets
  // Key is especially useful when the widgets change its position in the widget tree
  // const ReusableCard({
  //   Key key,
  // }) : super(key: key);

  // We dont need constructor above so we can comment out it
  // We can customize our very own constructor

  // instance variable
  // we have to put this instance variable final, meaning making it constant
  // becuz this is inside a stateless widget, it means that its property is immutable
  // use final, cannot use const
  final Color colour;
  final Widget cardChild;
  final Function onPress;   // this variable onPress is of type Function, as it is stored as a function

  // Difference between const, final:
  // final can only be assigned once
  // while myConst is compile time constant, so meaning its value is constant even at compile time
  // for exp
  // const int time = DateTime.now() (GOT ERROR)
  // final int time = DateTime.now() (NO ERROR)
  // this is becuz DateTime.now() is always changing the seconds value
  // for a const variable tha needs to be constant even at compile time, so that DateTime.now() canot be assigned to it

  // @required here means that this parameter is a must for this ReusableCard constructor
  ReusableCard({@required this.colour, this.cardChild, this.onPress});

  // will return this container wrapped with GestureDetector when we call the constructor ReusableCard({@required this.colour, this.cardChild, this.onPress});
  @override
  Widget build(BuildContext context) {
    // wrap our ReusableCard class with GestureDetector widget so that it will react to certain gesture
    return GestureDetector(
      // this onTap callback will get triggered when we clicks/tap on the card
      // onPress here is a variable which stores a function
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(10.0),   // set margin for all sides
        // to make our boxes to have rounded corner, we use BoxDecoration
        decoration: BoxDecoration(
          // need to specify the color of the container inside this BoxDecoration if we have one and not inside the container nia
          color: colour,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}


// EXTRA NOTE
// specify theme for this particular FAB by wrapping it in a Theme widget
// floatingActionButton: Theme(
//   data: ThemeData(accentColor: Colors.purple),
//   child: FloatingActionButton(
//     child: Icon(Icons.add),
//   ),
// )