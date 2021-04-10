import 'package:flutter/material.dart';


class Announcement extends StatelessWidget {

  static const String id = '/announcement';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Announcement'),
        )
    );
  }
}

