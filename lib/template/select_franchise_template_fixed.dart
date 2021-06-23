import 'package:flutter/material.dart';
import 'package:mahathir_academy_app/template/select_view_template_fixed.dart';

class SelectFranchiseTemplateFixed extends StatefulWidget {
  FloatingActionButton franchiseFab;
  FutureBuilder franchiseItemBuilder;
  String franchiseContentTitle;

  SelectFranchiseTemplateFixed(
      {this.franchiseFab,
      this.franchiseContentTitle,
      this.franchiseItemBuilder});

  static const String id = '/selectFranchiseTemplateFixed';
  List<String> franchises = ['Franchise1', 'Franchise2', 'Franchise3'];

  @override
  _SelectFranchiseTemplateFixedState createState() =>
      _SelectFranchiseTemplateFixedState();
}

class _SelectFranchiseTemplateFixedState
    extends State<SelectFranchiseTemplateFixed> {
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
