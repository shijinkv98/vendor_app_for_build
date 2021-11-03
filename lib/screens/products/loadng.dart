import 'package:flutter/material.dart';
import 'package:vendor_app/helpers/constants.dart';

class LoaderAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height:MediaQuery.of(context).size.height-250,child: Center(child: CircularProgressIndicator(valueColor:
    AlwaysStoppedAnimation<Color>(colorPrimary))));
  }
}
