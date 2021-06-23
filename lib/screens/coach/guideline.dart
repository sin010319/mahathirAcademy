import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Guideline extends StatelessWidget {
  static const String id = '/guideline';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Row(
            children: [
              Image.asset("assets/images/brand_logo.png",
                  fit: BoxFit.contain, height: 5.5.h),
              SizedBox(
                width: 1.5.w,
              ),
              Flexible(
                child: Text('Guidelines',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                    )),
              )
            ],
          ),
        ),
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
