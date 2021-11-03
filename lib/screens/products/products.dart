// import 'package:custom_switch/custom_switch.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:vendor_app/custom/custom_tabview.dart';
// import 'package:vendor_app/helpers/constants.dart';
// import 'package:vendor_app/network/ApiCall.dart';
// import 'package:vendor_app/network/response/product_list_response.dart';
// import 'package:vendor_app/notifiers/productlistnotifier.dart';
// import 'package:vendor_app/screens/home/ad_manager.dart';
// import 'package:vendor_app/screens/home/orders.dart';
// import 'package:vendor_app/screens/products/edit_product.dart';
// import 'package:vendor_app/screens/products/search.dart';
// import 'package:vendor_app/screens/products/searchnew.dart';
// import 'package:vendor_app/screens/search/searchproduct.dart';
//
// import 'add_new_product.dart';
// import 'edit_product_image.dart';
//
// class ProductsScreen extends StatefulWidget {
//   @override
//   _ProductsState createState() => _ProductsState();
// }
//
// class _ProductsState extends State<ProductsScreen>
//     with TickerProviderStateMixin {
//   final double _paddingTop = 8;
//   final double _paddingStart = 20;
//   final int tabPosition = 0;
//   @override
//   void initState() {
//     super.initState();
//     _updateNotifier = Provider.of<ProductListNotifier>(context, listen: false);
//     // ApiCall().execute<ProductListResponse, Null>('all-products/en', null);
//   }
//
//   ProductListNotifier _updateNotifier;
//   ProductListResponse _productListResponse;
//
//   @override
//   void dispose() {
//     _updateNotifier.reset();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Map body = {'by': 'category'};
//
//     return Scaffold(
//       appBar:
//       AppBar(
//         title: Text('Products'),
//         backgroundColor: colorPrimary,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back_outlined),
//             color: Colors.white,
//             onPressed: () {
//               Navigator.of(context).pushReplacementNamed("home");
//             }),
//         // actions: [
//         //   IconButton(
//         //       icon: Icon(Icons.search),
//         //       onPressed: () {
//         //         Navigator.pushReplacement(
//         //             context, MaterialPageRoute(builder: (BuildContext context) => ProductsScreenSearch()));
//         //
//         //         //       showSearch<String>(
//         //   //         context: context,
//         //   //         delegate: CustomDelegate(),
//         //   //       );
//         //   //       // Navigator.of(context).pushNamed('searchProduct');
//         //       })
//         // ],
//         elevation: 0,
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(
//           Icons.add,
//           size: 30,
//         ),
//         backgroundColor: colorPrimary,
//         onPressed: () {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       // PendingProductsScreen(mStoreSlug)
//                       AddNewProduct()));
//         },
//       ),
//       body:
//       FutureBuilder<ProductListResponse>(
//         future: ApiCall()
//             .execute<ProductListResponse, Null>('all-products/en', body),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             _productListResponse = snapshot.data;
//             // debugPrint('products size: ${snapshot.data?.products?.length}');
//             return getFullView();
//             // _getView(snapshot.data?.products
//             //     ?.where((element) =>
//             // element.products?.data != null &&
//             //     element.products.data.isNotEmpty)
//             //     ?.toList());
//           } else if (snapshot.hasError) {
//             return getEmptyCntainer();
//             // errorScreen(snapshot.error);
//           } else {
//             return progressBar;
//           }
//         },
//       ),
//     );
//   }
//
//   String searchContent = "";
//   Widget getSearch() {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => SearchProductScreen()),
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
//         height: 40,
//         padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 2),
//         child: TextField(
//           enabled: false,
//           decoration: InputDecoration(
//               hintText: "Search Products",
//               suffixIcon: new Container(
//                   height: 15,
//                   width: 15,
//                   margin: EdgeInsets.only(right: 20),
//                   child: Icon(Icons.search_rounded)),
//               hintStyle: TextStyle(fontSize: 12),
//               fillColor: Color(0xFFEEEEF0),
//               contentPadding:
//                   EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
//               filled: true,
//               border: OutlineInputBorder(
//                 borderSide: const BorderSide(color: colorPrimary, width: 1.0),
//                 borderRadius: BorderRadius.circular(25.0),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: colorPrimary, width: 1.0),
//                 borderRadius: BorderRadius.circular(25.0),
//               )),
//           keyboardType: TextInputType.text,
//           textInputAction: TextInputAction.search,
//           // onChanged: (text) {
//           //   searchContent=text;
//           // },
//           // onEditingComplete: (){
//           //   SearchProduct(searchContent);
//           // },
//           // onSubmitted: (text)
//           // {
//           //   SearchProduct(text);
//           // },
//         ),
//       ),
//     );
//   }
//
//   Widget getFullView() {
//     _updateNotifier.productListResponse = _productListResponse;
//     return Consumer<ProductListNotifier>(
//       builder: (context, value, child) {
//         return _updateNotifier.productListResponse != null
//             ? getViewProducts(_updateNotifier.productListResponse)
//             : SizedBox();
//       },
//     );
//   }
//
//   Widget getViewProducts(ProductListResponse response) {
//     return Container(
//       margin: EdgeInsets.only(top: 0),
//       child: Column(
//         children: [
//           getSearch(),
//           Expanded(
//             child: _getView(response?.products
//                 ?.where((element) =>
//                     element.products?.data != null &&
//                     element.products.data.isNotEmpty)
//                 ?.toList()),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void SearchProduct(String text) {
//     Map body = {"search": text, 'by': 'category'};
//     FocusScope.of(context).requestFocus(FocusNode());
//     ApiCall()
//         .execute<ProductListResponse, Null>('all-products/en', body)
//         .then((result) {
//       // ApiCall().showToast(result.);
//       _updateNotifier.productListResponse = result;
//     });
//     // setState(() {
//     //
//     // });
//   }
//
//   Widget _getView(List<ProductsWithCat> productsWithCat) => CustomTabView(
//         initPosition: tabPosition,
//         itemCount: productsWithCat.length,
//         tabBuilder: (context, index) => Tab(text: productsWithCat[index].name),
//         pageBuilder: (context, index) =>
//             _listview(productsWithCat[index].products),
//         onPositionChange: (index) {
//           print('current position: $index');
//           // initPosition = index;
//         },
//         onScroll: (position) => print('$position'),
//       );
//
//   Widget _listview(PaginationData productsPagination) => ListView.builder(
//       padding: EdgeInsets.only(bottom: 70),
//       itemBuilder: (context, index) => _itemsBuilder(
//           productsPagination.data[index],
//           productsPagination.data[index].images),
//       // separatorBuilder: (context, index) => Divider(
//       //       color: Colors.grey,
//       //       height: 1,
//       //     ),
//       itemCount: productsPagination.data.length);
//   Widget getEmptyCntainer() {
//     return Container(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Center(
//           child: Text(
//             'Add Your First Product',
//             style: TextStyle(fontSize: 20, color: primaryTextColor),
//           ),
//         ),
//       ],
//     ));
//   }
//
//   Widget _itemsBuilder(Product product, List<ImagesNew> images) {
//     String status = "Inactive";
//
//     if (product.product_active == '1') status = "Active";
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//       child: Container(
//         // margin: const EdgeInsets.only(),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.grey,
//           //     blurRadius: 3.0,
//           //   ),
//           // ],
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(
//                   _paddingStart, _paddingTop, 0, _paddingTop),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   FadeInImage.assetNetwork(
//                     placeholder: 'assets/images/no_image.png',
//                     image: '$productThumbUrl${product.image}',
//                     width: 65,
//                     height: 65,
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           product.name,
//                           style: TextStyle(
//                               color: Colors.black, fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               '${product.symbolLeft}${product.symbolRight} ${product.currentPrice}',
//                               style: TextStyle(
//                                   color: colorPrimary,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             // Container(
//                             //     decoration: BoxDecoration(
//                             //         color: primaryTextColor,
//                             //         borderRadius: BorderRadius.circular(4)),
//                             //     padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
//                             //     child: Text(
//                             //       'data',
//                             //       style: TextStyle(
//                             //         color: Colors.white,
//                             //         fontSize: 12,
//                             //       ),
//                             //     ))
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                       icon: Icon(Icons.edit_outlined),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (BuildContext context) =>
//                                     EditProduct(product, images)));
//                       }),
//                   Container(
//                     margin: EdgeInsets.only(top: 2, right: 10),
//                     width: 25,
//                     padding: EdgeInsets.all(2),
//                     child: InkWell(
//                         onTap: () async {
//                           showAlertDeleteProduct(product.productId.toString());
//                         },
//                         child: Image.asset('assets/icons/trash.png',
//                             color: Colors.black, fit: BoxFit.fitWidth)),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Divider(
//               height: 2,
//               color: Colors.grey,
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(
//                   _paddingStart, _paddingTop, 0, _paddingTop),
//               child: Container(
//                 height: 30,
//                 child: Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (BuildContext context) =>
//                                       EditProductImage(product, images)));
//                         },
//                         child: Container(
//                           child: Text(
//                             'Manage Products Images',
//                             style: TextStyle(color: colorPrimary, fontSize: 14),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       right: 0.0,
//                       child: Align(
//                         alignment: Alignment.centerRight,
//                         child: Container(
//                           margin: EdgeInsets.only(right: 10),
//                           child: Row(
//                             children: [
//                               // Text(status, style: TextStyle(
//                               //     color: status=="Active"?colorPrimary:Colors.redAccent,
//                               //     fontSize: 14.0)),
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 0),
//                                 child: Container(
//                                   height: 25,
//                                   child: Switch(
//                                     activeColor: Colors.grey,
//                                     value: status == "Active" ? true : false,
//                                     onChanged: (value) {
//                                       // DefaultTabController.of(context).animateTo(1);
//                                       if (status == "Active")
//                                         ApiCall()
//                                             .execute(
//                                                 product.productinactivation,
//                                                 null,
//                                                 multipartRequest: null)
//                                             .then((value) {
//                                           setState(() {});
//                                           // ApiCall().showToast(
//                                           // 'Profile Information Updated successfully');
//                                         });
//                                       else {
//                                         ApiCall()
//                                             .execute(
//                                                 product.productactivation, null,
//                                                 multipartRequest: null)
//                                             .then((value) {
//                                           setState(() {});
//                                         });
//                                       }
//                                       //print("VALUE : $value");
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(
//                       height: 12.0,
//                     ),
//                     // Text('Active : $status', style: TextStyle(
//                     //     color: Colors.black,
//                     //     fontSize: 20.0
//                     // ),)
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> productActive(Product product) async {
//     Map body = {
//       // DUTY_ON:"1",
//       // LATITUDE:_location.latitude,
//       // LONGITUDE:_location.longitude
//     };
//     ApiCall()
//         .execute(product.productactivation, null, multipartRequest: null)
//         .then((value) {
//       String message = value['message'];
//       ApiCall().showToast(message);
//       // setState(() {});
//       // Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (BuildContext context) => super.widget));
//
//       // Navigator.push(context,MaterialPageRoute(builder: (context) => ProductsScreen()),);
//
//       //ApiCall().showToast(message);
//     });
//   }
//
//   Future<void> productInActive(Product product) async {
//     Map body = {};
//     ApiCall()
//         .execute(product.productinactivation, null, multipartRequest: null)
//         .then((value) {
//       String message = value['message'];
//       ApiCall().showToast(message);
//       // setState(() {});
//       // Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (BuildContext context) => super.widget));
//
//       // Navigator.push(context,MaterialPageRoute(builder: (context) => ProductsScreen()),);
//
//       //ApiCall().showToast(message);
//     });
//   }
//
//   void showAlertDeleteProduct(String productId) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text("Are you sure you want to delete?"),
//         // content: Text("See products pending for approval"),
//         actions: <Widget>[
//           Row(
//             children: [
//               FlatButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text(
//                   "CANCEL",
//                   style: TextStyle(
//                       color: colorPrimary, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               FlatButton(
//                 onPressed: () {
//                   Map body = {
//                     'product_id': productId,
//                   };
//
//                   ApiCall()
//                       .qpprove_reject(
//                     '${"deleteproduct/"}${productId}',
//                     null,
//                   )
//                       .then((value) {
//                     String message = value['message'];
//                     Navigator.of(context).pop();
//                     setState(() {});
//                     // Navigator.pushReplacement(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //       builder: (context) => PendingProductsScreen(mStoreSlug)),
//                     // );
//                   });
//                 },
//                 child: Text(
//                   "DELETE",
//                   style: TextStyle(
//                       color: colorPrimary, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
