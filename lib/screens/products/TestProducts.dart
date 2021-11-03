// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vendor_app/helpers/constants.dart';
// import 'package:vendor_app/network/ApiCall.dart';
// import 'package:vendor_app/network/response/product_list_response.dart';
// import 'package:vendor_app/notifiers/productlistnotifier.dart';
// import 'package:vendor_app/screens/search/searchproduct.dart';
//
// import 'add_new_product.dart';
// import 'edit_product.dart';
// import 'edit_product_image.dart';
//
// class TestProducts extends StatefulWidget {
//   @override
//   _tabsState createState() => _tabsState();
// }
//
// class _tabsState extends State<TestProducts> with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     _updateNotifier = Provider.of<ProductListNotifier>(context, listen: false);
//
//   }
//   final double _paddingTop = 8;
//   final double _paddingStart = 20;
//   ProductListNotifier _updateNotifier;
//   ProductListResponse _productListResponse;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(
//         title: Text('Products'),
//         backgroundColor: colorPrimary,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back_outlined),
//             color: Colors.white,
//             onPressed: () {
//               Navigator.of(context).pushReplacementNamed("home");
//             }),
//         elevation: 0,
//         bottom:PreferredSize(
//           child: getSearch(),
//           preferredSize: Size.fromHeight(60.0),
//         ),
//       ),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(
//             Icons.add,
//             size: 30,
//           ),
//           backgroundColor: colorPrimary,
//           onPressed: () {
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                     // PendingProductsScreen(mStoreSlug)
//                     AddNewProduct()));
//           },
//         ),
//
//       body:
//       FutureBuilder<ProductListResponse>(
//         future: ApiCall()
//             .execute<ProductListResponse, Null>('all-products/en', null),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             _productListResponse = snapshot.data;
//             // debugPrint('products size: ${snapshot.data?.products?.length}');
//             return Container(margin:EdgeInsets.only(bottom: 20),child: getFullView());
//             // _getView(snapshot.data?.products
//             //     ?.where((element) =>
//             // element.products?.data != null &&
//             //     element.products.data.isNotEmpty)
//             //     ?.toList());
//           } else if (snapshot.hasError) {
//             return
//               // getEmptyCntainer();
//             errorScreen(snapshot.error);
//           } else {
//             return progressBar;
//           }
//         },
//       ),
//
//     );
//   }
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
//   Widget getViewProducts(ProductListResponse response){
//     return _getCatList(response?.products
//         ?.where((element) =>
//     element.products?.data != null &&
//         element.products.data.isNotEmpty)
//         ?.toList());
//   }
//   Widget getSearch() {
//     return
//       InkWell(
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
//               EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
//   Widget _getCatList(List<ProductsWithCat> productsWithCat) {
//     return ListView.builder(
//         itemCount:productsWithCat.length,
//         itemBuilder: (BuildContext context, int index) {
//           return _listCat(productsWithCat[index].products,_productListResponse.products[index].category);
//         });
//   }
//   Widget _listCat(PaginationData paginationProduct, Category category,){
//     Product pro =
//     paginationProduct.data != null && paginationProduct.data.length > 0
//         ?paginationProduct.data[0]
//         : null;
//     return Card(elevation:5,
//         margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
//         child:
//       ExpansionTile( leading: Icon(Icons.category,color: colorPrimary,),title: Text(category.slug,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//       children: [
//         Container(margin: EdgeInsets.only(left: 0),width: double.infinity,child:
//         ListView.builder(
//           shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount:paginationProduct.data.length,
//             itemBuilder: (BuildContext context, int index) {
//               return _listSubCat(paginationProduct.data[index],paginationProduct.data[index].images);
//             }))
//       ],
//
//     ),
//
//
// );
//   }
//   Widget _listSubCat(Product data, List<Images> images){
//     String status = "Inactive";
//
//     if (data.product_active == '1') status = "Active";
//     return Container(
//       height: 165,
//       child:
//       Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//         child: Container(
//           // margin: const EdgeInsets.only(),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//             // boxShadow: [
//             //   BoxShadow(
//             //     color: Colors.grey,
//             //     blurRadius: 3.0,
//             //   ),
//             // ],
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.fromLTRB(
//                     _paddingStart, _paddingTop, 0, _paddingTop),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FadeInImage.assetNetwork(
//                       placeholder: 'assets/images/no_image.png',
//                       image: '$productThumbUrl${data.image}',
//                       width: 65,
//                       height: 65,
//                     ),
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             data.name,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),overflow: TextOverflow.ellipsis,maxLines: 2,
//                             // style: TextStyle(
//                             //     color: Colors.black, fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 '${data.symbolLeft}${data.symbolRight} ${data.currentPrice}',
//                                  style: TextStyle(
//                                     color: colorPrimary,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               // Container(
//                               //     decoration: BoxDecoration(
//                               //         color: primaryTextColor,
//                               //         borderRadius: BorderRadius.circular(4)),
//                               //     padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
//                               //     child: Text(
//                               //       'data',
//                               //       style: TextStyle(
//                               //         color: Colors.white,
//                               //         fontSize: 12,
//                               //       ),
//                               //     ))
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                         icon: Icon(Icons.edit_outlined,color: colorPrimary,),
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (BuildContext context) =>
//                                       EditProduct(data, images)));
//                         }),
//                     Container(
//                       margin: EdgeInsets.only(top: 2, right: 10),
//                       width: 25,
//                       padding: EdgeInsets.all(2),
//                       child: InkWell(
//                           onTap: () async {
//                             showAlertDeleteProduct(data.productId.toString());
//                           },
//                           child: Image.asset('assets/icons/trash.png',
//                               color: Colors.red, fit: BoxFit.fitWidth)),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               Divider(
//                 height: 2,
//                 color: Colors.grey,
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(
//                     _paddingStart, _paddingTop, 0, _paddingTop),
//                 child: Container(
//                   height: 30,
//                   child: Stack(
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (BuildContext context) =>
//                                         EditProductImage(data, images)));
//                           },
//                           child: Container(
//                             child: Text(
//                               'Manage Products Images',
//                               style: TextStyle(color: colorPrimary, fontSize: 14),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         right: 0.0,
//                         child: Align(
//                           alignment: Alignment.centerRight,
//                           child: Container(
//                             margin: EdgeInsets.only(right: 10),
//                             child: Row(
//                               children: [
//                                 Text(status, style: TextStyle(
//                                     color: status=="Active"?colorPrimary:Colors.redAccent,
//                                     fontSize: 14.0)),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 0),
//                                   child: Container(
//                                     height: 25,
//                                     child: Switch(
//                                       activeColor: colorPrimary,
//                                       inactiveThumbColor: Colors.red,
//                                       inactiveTrackColor: Colors.redAccent,
//                                       value: status == "Active" ? true : false,
//                                       onChanged: (value) {
//                                         // DefaultTabController.of(context).animateTo(1);
//                                         if (status == "Active")
//                                           ApiCall()
//                                               .execute(
//                                               data.productinactivation,
//                                               null,
//                                               multipartRequest: null)
//                                               .then((value) {
//                                             setState(() {});
//                                             // ApiCall().showToast(
//                                             // 'Profile Information Updated successfully');
//                                           });
//                                         else {
//                                           ApiCall()
//                                               .execute(
//                                               data.productactivation, null,
//                                               multipartRequest: null)
//                                               .then((value) {
//                                             setState(() {});
//                                           });
//                                         }
//                                         //print("VALUE : $value");
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(
//                         height: 12.0,
//                       ),
//                       // Text('Active : $status', style: TextStyle(
//                       //     color: Colors.black,
//                       //     fontSize: 20.0
//                       // ),)
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//
//     );
//   }
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
//
//
//
// }
