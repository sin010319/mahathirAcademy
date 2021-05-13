import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahathir_academy_app/constants.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise_admin/view_admin_screen.dart';
import 'package:mahathir_academy_app/screens/FranchiseAdmin/class/view_class_screen.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/add_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/screens/HQAdmin/franchise/edit_franchise_bottomSheet.dart';
import 'package:mahathir_academy_app/template/select_view_template.dart';
import 'package:mahathir_academy_app/template/select_view_template_fixed.dart';

class SelectCoachTemplate extends StatefulWidget {
  FloatingActionButton franchiseFab;
  FutureBuilder franchiseItemBuilder;
  String franchiseContentTitle;

  SelectCoachTemplate(
      {this.franchiseFab,
      this.franchiseContentTitle,
      this.franchiseItemBuilder});

  static const String id = '/selectFranchiseTemplateFixed';
  List<String> franchises = ['Franchise1', 'Franchise2', 'Franchise3'];

  @override
  _SelectCoachTemplateState createState() => _SelectCoachTemplateState();
}

class _SelectCoachTemplateState extends State<SelectCoachTemplate> {
  @override
  Widget build(BuildContext context) {
    String franchiseAppBarTitle = 'Select Franchise';
    String franchiseImageIconLocation = 'assets/icons/franchise.png';

    return SelectViewTemplateFixed(
      fab: widget.franchiseFab,
      appBarTitle: franchiseAppBarTitle,
      imageIconLocation: franchiseImageIconLocation,
      contentTitle: widget.franchiseContentTitle,
      myFutureBuilder: widget.franchiseItemBuilder,
    );
  }
}
