import 'package:flutter/material.dart';

class UpdateNotifier extends ChangeNotifier {
  bool _isProgressShown=false;
  bool get isProgressShown => _isProgressShown;
  set isProgressShown(bool duty)
  {
    _isProgressShown=duty;
    notifyListeners();
  }
  void  update()
  {
    notifyListeners();
  }
  void reset() {
    _isProgressShown=false;
  }
}