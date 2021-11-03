import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/product_list_response.dart';
import 'package:vendor_app/network/response/vendor_product_response.dart';
import 'package:vendor_app/screens/products/CategoryScreen.dart';
import 'package:vendor_app/screens/products/edit_product.dart';
import 'package:vendor_app/screens/products/edit_product_image.dart';
import 'package:vendor_app/screens/search/searchproduct.dart';

import 'add_new_product.dart';



class ProductCategoryScreen extends StatefulWidget {
 String slug;
 Data product;
  @override
  _ProductCategoryScreenState createState() =>_ProductCategoryScreenState(slug: this.slug);
 ProductCategoryScreen({this.slug});

}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  ProductCategoryResponse pro;
  ProductListResponse proList;
  final double _paddingTop = 8;
  final double _paddingStart = 20;
  String slug;

_ProductCategoryScreenState({this.slug});
  @override
  Widget build(BuildContext context) {
    Map body = {
    'category': slug
  };
    return Scaffold(
        appBar:AppBar(
          title: Text('Products Categories'),
          backgroundColor: colorPrimary,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryScreen()));
              }),
          elevation: 0,
          bottom:PreferredSize(
            child: getSearch(),
            preferredSize: Size.fromHeight(60.0),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 30,
          ),
          backgroundColor: colorPrimary,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    // PendingProductsScreen(mStoreSlug)
                    AddNewProduct()));
          },
        ),
      body:WillPopScope(
        onWillPop: ()=>Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    CategoryScreen()))
        ,
        child: FutureBuilder<ProductCategoryResponse>(
          future: ApiCall()
              .execute<ProductCategoryResponse, Null>('v2/vendor/products', body),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              pro = snapshot.data;
              return Container(decoration:BoxDecoration(
                  gradient:     LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,

                    colors: [
                      Colors.white70.withOpacity(0.3),
                      Colors.white24.withOpacity(0.3),

                    ],
                    tileMode: TileMode.clamp,
                  )
              ) ,margin:EdgeInsets.only(bottom: 20),child: _listview(pro.products.data));
            } else if (snapshot.hasError) {
              return
                // getEmptyCntainer();
                errorScreen(snapshot.error);
            } else {
              return progressBar;
            }
          },
        ),
      )



    );


  }
Widget getSearch() {
  return
    InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchProductScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
        height: 40,
        padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 2),
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
              hintText: "Search Products",
              suffixIcon: new Container(
                  height: 15,
                  width: 15,
                  margin: EdgeInsets.only(right: 20),
                  child: Icon(Icons.search_rounded)),
              hintStyle: TextStyle(fontSize: 12),
              fillColor: Color(0xFFEEEEF0),
              contentPadding:
              EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              filled: true,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: colorPrimary, width: 1.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: colorPrimary, width: 1.0),
                borderRadius: BorderRadius.circular(25.0),
              )),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          // onChanged: (text) {
          //   searchContent=text;
          // },
          // onEditingComplete: (){
          //   SearchProduct(searchContent);
          // },
          // onSubmitted: (text)
          // {
          //   SearchProduct(text);
          // },
        ),
      ),
    );
}
  Widget _listview(List<Data> data) => ListView.builder(
      padding: EdgeInsets.only(bottom: 70),
      itemBuilder: (context, index) => _itemsBuilder(
          pro.products.data[index],
          pro.products.data[index].productImages,

      ),
      // separatorBuilder: (context, index) => Divider(
      //       color: Colors.grey,
      //       height: 1,
      //     ),
      itemCount: pro.products.data.length);

  Widget _itemsBuilder(Data data,List<ProductImages> productImages,
      ) {
    String status = "Inactive";

    if (data.productActive == '1') status = "Active";
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5,top: 5),
      child: Container(
        // margin: const EdgeInsets.only(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors.white,
          gradient:     LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Colors.white70.withOpacity(0.3),
              Colors.grey.withOpacity(0.3),

            ],
            tileMode: TileMode.clamp,
          )
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
              padding: EdgeInsets.fromLTRB(
                  _paddingStart, _paddingTop, 0, _paddingTop),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/no_image.png',
                    image: '$productThumbUrl${data.image}',
                    width: 65,
                    height: 65,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.name,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              '${data.symbolLeft}${data.symbolRight} ${data.currentPrice}',
                              style: TextStyle(
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold),
                            ),
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
                                builder: (BuildContext context) =>
                                    EditProduct(data,productImages,slug)
                            ));
                      }),
                  Container(
                    margin: EdgeInsets.only(top: 2, right: 10),
                    width: 25,
                    padding: EdgeInsets.all(2),
                    child: InkWell(
                        onTap: () async {
                          showAlertDeleteProduct(data.productId);
                        },
                        child: Image.asset('assets/icons/trash.png',
                            color: Colors.red, fit: BoxFit.fitWidth)),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  _paddingStart, _paddingTop, 0, _paddingTop),
              child: Container(
                height: 30,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditProductImage(data, productImages)));
                        },
                        child: Container(
                          child: Text(
                            'Manage Products Images',
                            style: TextStyle(color: colorPrimary, fontSize: 14,fontWeight: FontWeight.bold),
                          ),
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
                                  fontSize: 14,fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: Container(
                                  height: 25,
                                  child: Switch(
                                    activeColor: colorPrimary,
                                    inactiveThumbColor: Colors.red,
                                    inactiveTrackColor: Colors.redAccent,
                                    value: status == "Active" ? true : false,
                                    onChanged: (value) {
                                      // DefaultTabController.of(context).animateTo(1);
                                      if (status == "Active")
                                        ApiCall()
                                            .execute(
                                            data.productinactivation,
                                            null,
                                            multipartRequest: null)
                                            .then((value) {
                                          setState(() {});
                                          // ApiCall().showToast(
                                          // 'Profile Information Updated successfully');
                                        });
                                      else {
                                        ApiCall()
                                            .execute(
                                            data.productactivation, null,
                                            multipartRequest: null)
                                            .then((value) {
                                          setState(() {});
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

                    SizedBox(
                      height: 12.0,
                    ),
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

  void showAlertDeleteProduct(String productId) {
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
                child: Text(
                  "CANCEL",
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                ),
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
                    setState(() {});
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => PendingProductsScreen(mStoreSlug)),
                    // );
                  });
                },
                child: Text(
                  "DELETE",
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}