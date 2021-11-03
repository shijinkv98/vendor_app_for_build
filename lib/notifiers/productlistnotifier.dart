import 'package:flutter/cupertino.dart';
import 'package:vendor_app/network/response/product_list_response.dart';

class ProductListNotifier extends ChangeNotifier {
  ProductListResponse _productListResponse;
  ProductListResponse get productListResponse=>_productListResponse;
  set productListResponse(ProductListResponse response)
  {
    _productListResponse=response;
    notifyListeners();
  }
  void update()
  {
    notifyListeners();
  }
  void reset()
  {
    _productListResponse=null;
  }
}