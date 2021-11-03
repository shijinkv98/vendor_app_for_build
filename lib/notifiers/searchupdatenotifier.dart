import 'package:flutter/material.dart';
import 'package:vendor_app/network/response/product_list_response.dart';
import 'package:vendor_app/network/response/product_search_response.dart';

class SearchUpdateNotifier extends ChangeNotifier {
  bool _isProgressShown=false;
  ProductSearchResponseNew productSearchResponseNew;
  bool get isProgressShown => _isProgressShown;
  ProductSearchResponseNew get productSearchResponses=>productSearchResponseNew;
  set productSearchResponse(ProductSearchResponseNew duty)
  {
    productSearchResponseNew=duty;
    _isProgressShown=false;
    notifyListeners();
  }
  void update()
  {
    notifyListeners();
  }
  set isProgressShown(bool duty)
  {
    _isProgressShown=duty;
    notifyListeners();
  }

  void reset() {
    productSearchResponseNew=null;
    _isProgressShown=false;
  }

}