import 'package:flutter/material.dart';

class Guideline extends StatelessWidget {
  static const String id = '/guideline';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guidelines"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
              // Create a grid with 2 columns in portrait mode, or 3 columns in
              // landscape mode.
              crossAxisCount: orientation == Orientation.portrait ? 1 : 1,
              // Generate 100 widgets that display their index in the List.
              children: [
                GestureDetector(
                  child: Container(
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          height: constraints.biggest.height,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              image:
                                  Image.asset('assets/images/guidelineMark.png')
                                      .image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]);
        },
      ),
    );
  }
}
