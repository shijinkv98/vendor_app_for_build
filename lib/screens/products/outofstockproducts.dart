// import 'package:flutter/material.dart';
// import 'package:vendor_app/custom/custom_tabview.dart';
// import 'package:vendor_app/helpers/constants.dart';
// import 'package:vendor_app/network/ApiCall.dart';
// import 'package:vendor_app/network/response/outof_stock_product_list_response.dart';
// import 'package:vendor_app/network/response/product_list_response.dart';
// import 'package:vendor_app/screens/home/home.dart';
// import 'package:vendor_app/screens/products/edit_product.dart';
// import 'package:vendor_app/screens/products/search.dart';
//
// class OutofStockProductsScreen extends StatefulWidget {
//   String store;
//   @override
//   _OutofStockProductsScreenState createState() => _OutofStockProductsScreenState(store: this.store);
//   OutofStockProductsScreen(String response)
//   {
//     this.store=response;
//   }
// }
//
// class _OutofStockProductsScreenState extends State<OutofStockProductsScreen>
//     with TickerProviderStateMixin {
//   final double _paddingTop = 8;
//   final double _paddingStart = 20;
//   String store="";
//   _OutofStockProductsScreenState({ this.store}) ;
//   @override
//   void initState() {
//     super.initState();
//
//    // ApiCall().execute<ProductListResponse, Null>('pendingproducts', null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Map body = {
//
//       // 'store': store,
//     };
//
//     return WillPopScope(
//         onWillPop: () async => showDialog(
//         context: context,
//         builder: (context) =>
//             AlertDialog(title: Text('Are you sure you want to quit?'), actions: <Widget>[
//               RaisedButton(
//                   child: Text('Ok'),
//                   onPressed: () => Navigator.of(context).pop(true)),
//               RaisedButton(
//                   child: Text('Cancel'),
//                   onPressed: () => Navigator.of(context).pop(false)),
//             ])),
//     child:
//       Scaffold(
//       appBar: AppBar(
//
//         title: Text('Out of Stock Products'),
//         leading:IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () =>Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => HomeScreen())
//              )),
//
//         backgroundColor: colorPrimary,
//
//         actions: [
//           IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 showSearch<String>(
//                   context: context,
//                   delegate: CustomDelegate(),
//                 );
//                 // Navigator.of(context).pushNamed('searchProduct');
//               })
//         ],
//         elevation: 0,
//       ),
//
//       body: FutureBuilder<OutofStockProductsResponse>(
//         future: ApiCall()
//             .execute<OutofStockProductsResponse, Null>('outofstock', body),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             debugPrint('products size: ${snapshot.data?.product?.length}');
//             return _listview(snapshot.data?.product
//                 ?.where((element) =>
//                     element!= null)
//                 ?.toList());
//           } else if (snapshot.hasError) {
//             return errorScreen('Error: ${snapshot.error}');
//           } else {
//             return progressBar;
//           }
//         },
//       ),
//     ));
//   }
//
//
//   Widget _listview(List<Product> productsPagination) => ListView.builder(
//       padding: EdgeInsets.only(bottom: 70),
//       itemBuilder: (context, index) =>
//           _itemsBuilder(productsPagination[index]),
//       // separatorBuilder: (context, index) => Divider(
//       //       color: Colors.grey,
//       //       height: 1,
//       //     ),
//       itemCount: productsPagination.length);
//
//   Widget _itemsBuilder(Product product) {
//     bool status = false;
//     if(product.status==1)
//       status=true;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(0),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey,
//             blurRadius: 3.0,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding:
//                 EdgeInsets.fromLTRB(_paddingStart, 15, 0, _paddingTop),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 FadeInImage.assetNetwork(
//                   placeholder: 'assets/images/no_image.png',
//                   image: '$productThumbUrl${product.images}',
//                   width: 65,
//                   height: 65,
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         product.name,
//                         style: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(product.currentPrice),
//                           // !=null?'${product.currentPrice}${" "} ${product.currentPrice}':""),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       RichText(
//                           text: TextSpan(
//                               text:'Available Stock :',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black,
//                               ),
//                               children: <TextSpan>[
//                                 TextSpan(
//                                     text: ' ${product.stock}',
//                                     style: TextStyle(
//                                         color: Colors.redAccent,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w400))
//                               ])),
//                       SizedBox(
//                         width: 10,
//                       ),
//                     ],
//
//                   ),
//                 ),
//                 IconButton(
//                     icon: Icon(Icons.edit_outlined),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (BuildContext context) => EditProduct(product,product.images)));
//                     })
//
//
//               ],
//             ),
//           ),
//
//
//         ],
//       ),
//     );
//   }
// }
