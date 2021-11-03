
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/screens/products/CategoryScreen.dart';
import 'package:vendor_app/screens/products/TestProducts.dart';
import 'package:vendor_app/screens/products/add_new_product.dart';
import 'package:vendor_app/screens/products/products.dart';

class ProductConfirmation extends StatefulWidget {

  @override
  _ProductConfirmationState createState() =>
      new _ProductConfirmationState();

}

class _ProductConfirmationState extends State<ProductConfirmation> {



  _ProductConfirmationState();

  @override
  void initState() {
    super.initState();
  }

  final myController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    debugPrint('$APP_TAG ReturnToStoreScreen build()');

    return Scaffold(
      // use Scaffold also in order to provide material app widgets
      backgroundColor: Colors.white,
      // appBar: appBar(context),
      body: getContent(),
    );
  }

  Widget getContent() {
    return Center(
      child: Card(
        margin: EdgeInsets.only(left: 15, right: 15),
        elevation: 10,
        child: Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _reason(),
          ],
        )),
      ),
    );
  }

  Widget _reason() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: colorPrimary,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                      child: Text(
                    'Product Created Successfully',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              'Add more Products ?',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ))),
                    SizedBox(height: 10),

                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                // PendingProductsScreen(mStoreSlug)
                                CategoryScreen()),
                              );
                            },
                            child: Container(
                              height: 35,
                              margin: EdgeInsets.only(right: 10, bottom: 20),
                              decoration: BoxDecoration(
                                color: colorPrimary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Container(
                                  margin: EdgeInsets.only(left: 30, right: 30),
                                  child: Center(
                                      child: Text(
                                    "NO",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ))),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                // PendingProductsScreen(mStoreSlug)
                                AddNewProduct()),
                              );
                            },
                            child: Container(
                              height: 35,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Container(
                                  margin: EdgeInsets.only(left: 30, right: 30),
                                  child: Center(
                                      child: Text(
                                    "YES",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ))),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



