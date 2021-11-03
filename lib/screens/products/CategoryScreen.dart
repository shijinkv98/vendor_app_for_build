import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/vendor_category_response.dart';
import 'package:vendor_app/screens/home/dashboard.dart';
import 'package:vendor_app/screens/home/home.dart';
import 'package:vendor_app/screens/search/searchproduct.dart';

import 'ProductCategoryScreen.dart';
import 'add_new_product.dart';


class CategoryScreen extends StatefulWidget {

  @override
  _CategoryScreenState createState()
  {
    return _CategoryScreenState();
  }
}

class _CategoryScreenState extends State<CategoryScreen> {
  VendorCategoryResponse catResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
          backgroundColor: colorPrimary,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }),
          elevation: 0,

          bottom: PreferredSize(
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
        body: WillPopScope(
          onWillPop: () =>
              Navigator.pushReplacement(
                  context, MaterialPageRoute(
                  builder: (BuildContext context) =>
                      HomeScreen())),
          child: FutureBuilder<VendorCategoryResponse>(
            future: ApiCall()
                .execute<VendorCategoryResponse, Null>(
                'v2/vendor/categories', null),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                catResponse = snapshot.data;
                return Container(margin: EdgeInsets.only(bottom: 20),
                    child: getContent(catResponse.categories));
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


    Widget getContent(List<Categories> categories) {
      double width = MediaQuery
          .of(context)
          .size
          .width - 15;
      double height = 240;
      double aspect = (width / 2) / height;
      return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child:
        GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: 0.89,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5),
            semanticChildCount: 2,
            itemCount: categories.length,
            itemBuilder: (BuildContext ctx, index) {
              return _itemsBuilder(categories[index], index);
            }),
      );
    }
    Widget _itemsBuilder(Categories cat, int index) {
      LinearGradient bg1 =
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,

        colors: [
          Color(0xffFA89AE).withOpacity(0.3),
          Color(0xffF9E48D).withOpacity(0.3),

        ],
        tileMode: TileMode.clamp,
      );
      LinearGradient bg2 = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xff9BC1F8).withOpacity(0.3),
          Color(0xffD8A1F9).withOpacity(0.3),
        ],
        tileMode: TileMode.clamp,
      );
      LinearGradient bg3 = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xff64C3FF).withOpacity(0.3),
          Color(0xff87F8FA).withOpacity(0.3),
        ],
        tileMode: TileMode.clamp,
      );
      LinearGradient bg4 = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.deepPurple.withOpacity(0.3),
          Colors.orange.withOpacity(0.3),
        ],
        tileMode: TileMode.clamp,
      );
      LinearGradient bg5 = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.orange.withOpacity(0.3),
          Colors.red.withOpacity(0.3),
        ],
        tileMode: TileMode.clamp,
      );
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ProductCategoryScreen(slug: cat.slug,)));
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              // gradient: index%3==0?bg1:index%3==1?bg2:index%3==2?bg3:index%3==3?bg4:bg1,),

              image:
              DecorationImage(
                  image: NetworkImage(cat.image),
                  // AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius
                                    .circular(10),
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5),
                                  child: Text(cat.name, style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5),
                                  child: Text(
                                    '${'( '}${cat.products_count}${' )'}',
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,),
                                ),

                              ],
                            )),
                      ],
                    )),
              ],
            ),
            // child: Column(
            //   children: [
            //     Container(
            //       margin: EdgeInsets.only(top: 5),
            //       child:
            //       FadeInImage.assetNetwork(
            //         placeholder: 'assets/images/no_image.png',
            //         // image: '${BASE_URL}${'images/product/thumbnail/'}${cat.image}',
            //         image: cat.image,
            //         fit: BoxFit.contain,
            //         height:80 ,
            //         width:100,
            //       ),
            //     ),
            //      ],
            // ),
          ),
        ),
      );
    }
  }
