import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {

  static const String id = '/leaderboard';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard'),
        )
    );
  }
}
