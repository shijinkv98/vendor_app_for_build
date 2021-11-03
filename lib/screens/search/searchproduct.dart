
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/product_search_response.dart';
import 'package:vendor_app/notifiers/searchupdatenotifier.dart';
import 'package:vendor_app/screens/products/edit_product_image_search.dart';
import 'package:vendor_app/screens/products/edit_product_search.dart';


class SearchProductScreen extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProductScreen> {
  SearchUpdateNotifier _updateNotifier;
  ProductSearchResponseNew _productSearchResponse;
  final double _paddingTop = 8;
  final double _paddingStart = 20;

  @override
  void initState() {
    _updateNotifier =
        Provider.of<SearchUpdateNotifier>(context, listen: false);
    super.initState();
  }
  @override
  void dispose() {
    _updateNotifier.reset();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      appBar: getAppBar('Search Products','',context),
      body:  getContent(),
      // bottomNavigationBar: getBottomNav(context,_updateNotifier),
    );
  }
  String query="";
  double searchViewSize=70;
  Widget getContent() {
    return  Container(
      height: MediaQuery.of(context).size.height,
      decoration:getContentBox,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: searchViewSize,
                child: searchView()

            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child:Container(
                margin: EdgeInsets.only(left: 0,right: 0,top: searchViewSize),
                child: Consumer<SearchUpdateNotifier>(
                  builder: (context, value, child) {
                    return value.productSearchResponses!=null ? getproductViews(value.productSearchResponses) : Center(child: SizedBox(child: Text('No result found',style: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold,fontSize: 15))));
                  },
                ),
              )

          ),
          Align(alignment: Alignment.center,
            child: Consumer<SearchUpdateNotifier>(
              builder: (context, value, child) {
                return value.isProgressShown ? progressBar : SizedBox();
              },
            ),)
        ],
      ),
    );

    // height: MediaQuery.of(context).size.height,
  }
  Widget textFormSearch() {
    return  Container(
      margin: EdgeInsets.only(top:17,right:10,left:10,bottom: 10),
      height: 30,
      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 2),
      child: Container(
        height: 30,
        // padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),

        ),
        child: TextFormField(
          obscureText: false,
          autofocus: false,
          onChanged: (value) {
            query = value;
            searchProduct();
          },

          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            filled: true,
              hintText:"Search products",
            hintStyle: TextStyle(fontSize: 12),
            border:OutlineInputBorder(
              borderSide: const BorderSide(color: colorPrimary, width: 1.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
              focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: colorPrimary, width: 1.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            fillColor: Color(0xFFEEEEF0),
            contentPadding: EdgeInsets.only(top:5,bottom: 5,left:10,right: 10),
              suffixIconConstraints: BoxConstraints(
                  minHeight: 20,
                  minWidth: 20
              ),
              suffixIcon: new Container(
                height: 15,
                width: 15,
                margin: EdgeInsets.only(right: 20),
                child: Icon(Icons.search_rounded)
              ),

          ),

        ),
      ),
    );
  }
  Widget  searchView() {
    return textFormSearch();
  }
  void searchProduct()
  {
    _updateNotifier.isProgressShown=true;
    if(query=="")
    {
      _updateNotifier.productSearchResponse=null;
      return;
    }
    Map body = {
      "search": query,
    };
    ApiCall()
        .execute<ProductSearchResponseNew, Null>('product-search/en', body).then((ProductSearchResponseNew result){
      _updateNotifier.productSearchResponse=result;

    });
  }
  Widget getproductViews(ProductSearchResponseNew productSearchResponse)
  {
    _productSearchResponse=productSearchResponse;

    return Container(
        margin: EdgeInsets.only(top: 15),
        child: SingleChildScrollView(
           child: Container(
             height: MediaQuery.of(context).size.height,
             child: Column(
               children: [
                 getMainHeading(query),
                 productSearchResponse.success != 0 ?
                 Container(
                     height: MediaQuery.of(context).size.height-210,
                     margin: EdgeInsets.only(bottom: 0),
                     child:_getSearchList()):getEmptyProductContainer(),
                 Divider(height: 2,color: Colors.white,)

               ],
             ),
           ),
    ));
        // CustomScrollView(
        //   slivers: [
        //     SliverToBoxAdapter(child:getMainHeading(query)),
        //     SliverPadding(padding: EdgeInsets.only(left: 0,right: 0,top: 20,bottom: 10),sliver: productSearchResponse.products==null||productSearchResponse.products.length==0?
        //     SliverToBoxAdapter(child: getEmptyProductContainer(context)):Container(child:_getView(productSearchResponse?.products
        //         ?.where((element) =>
        //     element.products?.data != null &&
        //         element.products.data.isNotEmpty)
        //         ?.toList()))),
        //   ],
        // ));
  }
  Widget getMainHeading(String title){
    double width=MediaQuery.of(context).size.width-(20)-30;
    double containerWidth=130;
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10,top: 0),
      child: Center(
        child:  Row(
          children: [
            Container(
              width:containerWidth ,
              child: Text("Search result for -",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,  fontSize: 14,letterSpacing: 0.5)),
            ),
            Container(
              width:width-containerWidth ,
              child: Text(title,
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,  fontSize: 14,letterSpacing: 0.5)),
            ),
          ],
        ),
      ),
    );

  }

  Widget _getSearchList() {
    return ListView.builder(
        itemCount: _productSearchResponse.products.length,
        itemBuilder: (BuildContext context, int index) {
          return _listview(_productSearchResponse.products[index],_productSearchResponse.products[index].images);
        });
  }
  Widget _listview(Products product,List<Images> images) {


    String  status = "Inactive";

    if(product.productActive=='1')
      status="Active";
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(left: 10,right: 10,bottom:10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     blurRadius: 3.0,
          //   ),
          // ],
        ),
        child: Column(
          children: [
            Padding(
              padding:
              EdgeInsets.fromLTRB(_paddingStart, _paddingTop, 0, _paddingTop),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/no_image.png',
                    image: '$productThumbUrl${product.image}',
                    width: 65,
                    height: 65,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text('${product.symbolLeft}${product.symbolRight} ${product.currentPrice}',style: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),),
                            SizedBox(
                              width: 10,
                            ),
                            // Container(
                            //     decoration: BoxDecoration(
                            //         color: primaryTextColor,
                            //         borderRadius: BorderRadius.circular(4)),
                            //     padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                            //     child: Text(
                            //       'data',
                            //       style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 12,
                            //       ),
                            //     ))
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.edit_outlined,color: Colors.blue,),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => EditProductSearch(product,images)));
                      }),
                  Container(
                    margin: EdgeInsets.only(top: 2,right: 10),
                    width: 25,
                    padding: EdgeInsets.all(2),
                    child:
                    InkWell(
                        onTap: ()
                        async {
                          showAlertDeleteProduct( product.productId.toString());


                        },
                        child: Image.asset('assets/icons/trash.png',color: Colors.red,fit: BoxFit.fitWidth)),

                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            Padding(
              padding:
              EdgeInsets.fromLTRB(_paddingStart, _paddingTop, 0, _paddingTop),
              child: Container(
                height: 30,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => EditProductImageSearch(product, images)));
                        },
                        child: Container(
                          child: Text('Manage Products Images',style: TextStyle(color:colorPrimary,fontSize: 14 ),),

                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              Text(status, style: TextStyle(
                                  color: status=="Active"?colorPrimary:Colors.redAccent,
                                  fontSize: 14.0)),
                              Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: Container(
                                  height: 25,

                                  child:

                                  Switch(
                                    activeColor: colorPrimary,
                                    value: status=="Active"?true:false,
                                    onChanged: (value) {
                                      if(status=="Active")
                                        ApiCall()
                                            .execute(product.productinactivation, null, multipartRequest: null)
                                            .then((value) {
                                          String message=value['message'];
                                          ApiCall().showToast(message);
                                          setState(() {});
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (BuildContext context) => super.widget));

                                          // Navigator.push(context,MaterialPageRoute(builder: (context) => ProductsScreen()),);

                                          //ApiCall().showToast(message);

                                        });
                                      else{
                                        ApiCall()
                                            .execute(product.productactivation, null, multipartRequest: null)
                                            .then((value) {
                                          String message=value['message'];
                                          ApiCall().showToast(message);
                                          setState(() {});
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (BuildContext context) => super.widget));

                                          // Navigator.push(context,MaterialPageRoute(builder: (context) => ProductsScreen()),);

                                          //ApiCall().showToast(message);

                                        });
                                      }
                                      //print("VALUE : $value");

                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 12.0,),
                    // Text('Active : $status', style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 20.0
                    // ),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showAlertDeleteProduct(String productId){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Are you sure you want to delete?"),
        // content: Text("See products pending for approval"),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("CANCEL",style: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),),
              ),
              FlatButton(
                onPressed: () {
                  Map body = {
                    'product_id': productId,
                  };

                  ApiCall()
                      .qpprove_reject(
                    '${"deleteproduct/"}${productId}',
                    null,
                  )
                      .then((value) {

                    String message = value['message'];
                    Navigator.of(context).pop();
                    setState(() {

                    });
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => super.widget),
                    // );
                  });
                },
                child: Text("DELETE",style: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold)),
              ),

            ],
          ),
        ],
      ),
    );
  }

  // Widget _listview(PaginationData productsPagination) =>SizedBox(height: 500 ,child: ListView.builder(
  //     padding: EdgeInsets.only(bottom: 70),
  //     // shrinkWrap: true,
  //     itemBuilder: (context, index) =>
  //         _itemsBuilder(productsPagination.data[index],productsPagination.data[index].images),
  //     // separatorBuilder: (context, index) => Divider(
  //     //       color: Colors.grey,
  //     //       height: 1,
  //     //     ),
  //     itemCount:productsPagination.data.length));
  // Widget getCategoryGrid(Product products) {
  //   double width = MediaQuery.of(context).size.width-30;
  //   double containerWidth = (width)/2;
  //   double height = 240;
  //
  //   return SliverGrid(
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         childAspectRatio: containerWidth/height,
  //         mainAxisSpacing: 10.0,
  //         crossAxisSpacing: 2.0),
  //     delegate: SliverChildBuilderDelegate(
  //           (context, index) {
  //         return _itemsBuilder(height,products);
  //       },
  //       childCount:products.name.length,
  //     ),
  //   );
  // }

  // Widget _itemsBuilder( double d, Product product) {
  //   double width=MediaQuery.of(context).size.width/2;
  //   return InkWell(
  //       onTap: (){
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => ProductsScreen()));
  //       },
  //       child:  Card(
  //           elevation: 5,
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(3),
  //             child:Container(
  //               height: 240,
  //               width: width,
  //               child: Stack(
  //                 children: [
  //                   Align(alignment: Alignment.topCenter,
  //                     child: Container(
  //                       height: 240,
  //                       width: width,
  //                       child: Column(
  //                         children: [
  //                           Container(
  //                               height: 44,
  //                               width: width,
  //                               child: FadeInImage.assetNetwork(
  //                                 imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace)=>Image(
  //                                   image: AssetImage("assets/images/logo.png"),
  //                                   fit: BoxFit.cover,
  //                                   height: 44,
  //                                 ),
  //                                 placeholder: "assets/images/logo.png",
  //                                 image:product.image,
  //                                 fit: BoxFit.cover,
  //                                 height: 44,
  //                                 width: MediaQuery.of(context).size.width,
  //                               )
  //                           ),
  //                           Container(
  //                             width: width,
  //                             height: 20,
  //                             margin: EdgeInsets.only(left: 10,right: 10),
  //                             padding: EdgeInsets.only(top: 10),
  //                             child: Text(product.name,
  //                               style:  TextStyle(color: Colors.black, fontFamily: 'opensans_bold', fontSize: 13,letterSpacing: 0.5),overflow: TextOverflow.ellipsis,maxLines: 1,),
  //                           ),
  //
  //
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Align(alignment: Alignment.bottomCenter,
  //                     child: Container(
  //                       width: width,
  //                       height: 40,
  //                       margin: EdgeInsets.only(bottom: 10),
  //                       child: Column(
  //                         children: [
  //                           Divider(thickness: 1,),
  //                           Container(
  //                             width: width,
  //
  //                             margin: EdgeInsets.only(left: 10,right: 10,),
  //                             child: Text('${'₹ '}${product.currentPrice!=null?product.currentPrice:""}',
  //                               style:  TextStyle(color: Colors.green, fontFamily: 'opensans_bold', fontSize: 13,letterSpacing: 0.5),overflow: TextOverflow.ellipsis,maxLines: 1,),
  //                           ),
  //                         ],
  //                       ),
  //                     ),),
  //
  //                   // Align(alignment: Alignment.bottomRight,
  //                   //     child:Container(
  //                   //       margin: EdgeInsets.only(bottom: priceHeight-(cartIconSize/2),right: 5),
  //                   //       child: InkWell(
  //                   //         onTap: (){
  //                   //           addToCart(product.productId);
  //                   //         },
  //                   //         child: Container(
  //                   //           child: Image(image:
  //                   //           AssetImage('assets/images/add_cart_blue.png'),width: cartIconSize,
  //                   //             height: cartIconSize,
  //                   //             fit: BoxFit.cover,
  //                   //             // size: 30,
  //                   //           ),
  //                   //         ),
  //                   //       ),
  //                   //     )),
  //                   // Align(alignment: Alignment.topRight,
  //                   //     child:Container(
  //                   //       margin: EdgeInsets.only(top:10,right: 10),
  //                   //       child: InkWell(
  //                   //         onTap: (){
  //                   //
  //                   //           if(product.isFavourite) {
  //                   //             product.isFavourite=false;
  //                   //             _updateNotifier.update();
  //                   //             if(product.wishid!=null)
  //                   //               removeFromWishlist(product.wishid);
  //                   //           }
  //                   //           else {
  //                   //             product.isFavourite=true;
  //                   //             _updateNotifier.update();
  //                   //             addToWishList(product);
  //                   //           }
  //                   //         },
  //                   //         child: Container(
  //                   //           child: Image(image:
  //                   //           AssetImage(product.isFavourite?'assets/images/wishlist.png':"assets/images/favorite.png"),width: wishListIconsize,
  //                   //             height: wishListIconsize,
  //                   //             fit: BoxFit.cover,
  //                   //           ),
  //                   //         ),
  //                   //       ),
  //                   //     ))
  //
  //                 ],
  //               ),
  //             ),
  //           ))
  //
  //   );
  //
  //
  // }
  // void removeFromWishlist(String wishId)
  // {
  //   Map body = {
  //     // name,email,phone_number,password
  //     "whish_id": wishId,
  //   };
  //   _updateNotifier.isProgressShown = true;
  //   ApiCall()
  //       .execute<UpdateResponse, Null>(REMOVE_FROMWISHLIST_URL, body).then((UpdateResponse result){
  //     _updateNotifier.isProgressShown = false;
  //     ApiCall().showToast(result.message);
  //     searchProduct();
  //     getWishListResponse(_updateNotifier);
  //   });
  // }
  // void addToWishList(Products product)
  // {
  //
  //   _updateNotifier.isProgressShown = true;
  //
  //   Map body = {
  //     PRODUCT_ID: product.productId,
  //   };
  //   ApiCall()
  //       .execute<UpdateResponse, Null>(ADD_TO_WISHLIST_URL, body).then((UpdateResponse result){
  //     _updateNotifier.isProgressShown = false;
  //     ApiCall().showToast(result.message);
  //     searchProduct();
  //     getWishListResponse(_updateNotifier);
  //   });
  // }
  // void addToCart(String productId)
  // {
  //   _updateNotifier.isProgressShown = true;
  //
  //   Map body = {
  //     PRODUCT_ID: productId,
  //     QTY: "1",
  //   };
  //   ApiCall()
  //       .execute<UpdateResponse, Null>(ADD_TO_CART_URL, body).then((UpdateResponse result){
  //     _updateNotifier.isProgressShown = false;
  //     ApiCall().showToast(result.message);
  //     getCartResponse(_updateNotifier);
  //   });
  // }

}
