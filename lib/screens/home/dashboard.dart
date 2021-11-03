import 'dart:io';

import 'package:blinking_text/blinking_text.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/dashboard_response.dart';
import 'package:vendor_app/notifiers/home_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/home/profile.dart';
import 'package:vendor_app/screens/products/CategoryScreen.dart';
import 'package:vendor_app/screens/products/add_new_product.dart';
import 'package:vendor_app/screens/products/pendingproducts.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vendor_app/screens/products/successStoreCreation.dart';


import '../../main.dart';
import 'home.dart';



class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  BuildContext mContext;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  final keyOne = GlobalKey();

int tbPos=0;

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.of(mContext).pushReplacementNamed('home');
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();




  }
  @override initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) =>ShowCaseWidget.of(context).startShowCase([keyOne]));
      }

  @override
  Widget build(BuildContext context) {
    mContext=context;
    ApiCall().context=context;

    return  Scaffold(
    appBar: AppBar(
      title: Image.asset(
        'assets/logos/logo_main_small.png',
        height: 30,
      ),

      centerTitle: true,
      backgroundColor: Colors.white,
      actions: [
         Container(
           margin: EdgeInsets.only(right: 0),
           padding: EdgeInsets.all(2),
           width: 125,
           child: Center(child: Row(
             children: [
               Icon(Icons.person_rounded,color:colorPrimary,size: 15,),
               SizedBox(width: 5),
               InkWell(
                 onTap: (){
                    // showNotifications();
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (BuildContext context) => Profile()));

                 },
                 child: Container(

                      child:FutureBuilder<DashboardResponse>(
                        future: ApiCall().execute<DashboardResponse, Null>('dashboard', null),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            mStoreSlug=snapshot.data.dashboardData.storeslug;
                            return _getStorename(snapshot.data.dashboardData);
                          } else if (snapshot.hasError) {
                            return
                              enableData();
                              // errorScreen('Error: ${snapshot.error}');
                          } else {
                            return SizedBox();
                          }
                        },

                      )),
               ),
             ],
           )),
         ),


              // Text('',style:TextStyle(color: colorPrimary),))),

      ],
    ),
    body: FutureBuilder<DashboardResponse>(
      future: ApiCall().execute<DashboardResponse, Null>('dashboard', null),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          mStoreSlug=snapshot.data.dashboardData.storeslug;
          return _getView(context, snapshot.data.dashboardData);
        } else if (snapshot.hasError) {
          return
            // enableData();
            errorScreen('Error: ${snapshot.error}');
        } else {
          return progressBar;
        }
      },

    ),
    );
  }

Widget _getStorename(DashboardData dashboardData){
    return Showcase(
      key: keyOne,
      showcaseBackgroundColor: colorPrimary,
      descTextStyle:TextStyle(color:Colors.white,fontSize: 15),
      overlayColor: Colors.grey,
      overlayOpacity: 0.4,
      description: 'Click here to update your profile',
      child: Container(
        width: 100,
        child: Text(dashboardData.storename.toUpperCase(),style:TextStyle(color: colorPrimary))
      ),
    );
}

  Widget _getView(BuildContext context, DashboardData dashboardData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _itemsListGradient(
                context,
                [
                  const Color(0xFF8bfcfe),
                  const Color(0xFF64a1ff),
                ],
                'New Orders',
                dashboardData.newOrderCount,
                '${dashboardData.symbolleft} ${dashboardData.newOrderTotal}',
                'assets/icons/new_orders.png',
                tabPosition: 1),
            _itemsListGradientP(
                context,
                [
                  const Color(0xFF82f4bb),
                  const Color(0xFF94c9e0),
                ],
                'Total Products',
                dashboardData.productsCount,

                'Pending: ${dashboardData.pending}',
                'assets/icons/total_products.png',
                dashboardData.storeslug,
                navigation: 'products',),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: _itemsListGradient(
                      context,
                      [
                        const Color(0xFFf6d166),
                        const Color(0xFFfda781),
                      ],
                      'Delivered',
                      dashboardData.deliveredCount,
                      '${dashboardData.symbolleft} ${dashboardData.deliveredTotal}',
                      'assets/icons/delivered.png',tabPosition: 1,parameter: 'del'),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _itemsListGradient(
                      context,
                      [
                        const Color(0xFFfcc88b),
                        const Color(0xFFd67fe9),
                      ],
                      'Cancelled',
                      dashboardData.rejectedCount,
                      '${dashboardData.symbolleft} ${dashboardData.rejectedTotal}',
                      'assets/icons/rejected.png',tabPosition: 1,parameter: 'rej'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: _itemsListGradient(
                      context,
                      [
                        const Color(0xFFd1fa7a),
                        const Color(0xFF9be89d),
                      ],
                      'Returned',
                      (int.parse(dashboardData.returnedCount ?? '0') +
                              int.parse(dashboardData.cancelledCount ?? '0'))
                          .toString(),
                      '${dashboardData.symbolleft} ${(double.parse(dashboardData.cancelledTotal ?? '0') + double.parse(dashboardData.returnedTotal ?? '0'))}',
                      'assets/icons/return.png',tabPosition: 1,parameter:'ret'),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _itemListGradientOffers(
                      context,
                      [
                        const Color(0xFF8dd9ea),
                        const Color(0xFF78BEF8),
                      ],
                      'OFFERS'),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: _itemsListGradient(
                      context,
                      [
                        const Color(0xFF8dd9ea),
                        const Color(0xFF84f9b1),
                      ],
                      'Followers',
                      dashboardData.followers,
                      '',
                      'assets/icons/new_orders.png'),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 5,right: 5),
              child: Text(
                'Monthly Sales Chart For The Year',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.only(left: 5,right: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                height: 300,
                child: charts.BarChart([
                  charts.Series<SalesChartData, String>(
                      id: "Subscribers",
                      data: dashboardData.salesChart,
                      domainFn: (SalesChartData series, _) => series.month,
                      measureFn: (SalesChartData series, _) =>
                          double.parse(series.amount ?? '0'),
                      colorFn: (SalesChartData series, _) =>
                          charts.ColorUtil.fromDartColor(colorPrimary))
                ], animate: true),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // _itemsList(context, 'Pending Products to Approve', 'assets/icons/pending.png',navigation:'pending_p',store: dashboardData.storeslug),
            _itemsList(context, 'Pending Ads to Approve',
              'assets/icons/pending.png',
              tabPosition: 0),
            _itemsList(context, 'Contact Customer Care',
                'assets/icons/whatsappl.png',navigation:'contact_customer_care'),
            // _itemsList(context, 'Low Stock Products', 'assets/icons/low-atock.png',navigation:'lowstock_p'),

          ],
        ),
      ),
    );
  }
  Widget _itemListGradientOffers(BuildContext context, final List<Color>  colors,
      final String title)
  {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 15,left: 5,right: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 125,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
            tileMode: TileMode.clamp,
          ),
        ),
        // padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("offer");
          },
          child: Center( child:Text(
            title,
            style: TextStyle(
                color: Color(0xFFFF96D5),
                fontWeight: FontWeight.bold,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 4.0,
                    color: Color.fromARGB(255, 200, 76, 190),
                  ),
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 4.0,
                    color: Color.fromARGB(255, 173, 115, 210),
                  ),
                ],
                fontSize: 32),
          ),),
        ),
      ),
    );
  }
  Widget _itemsListGradient(
      BuildContext context,
      final List<Color>  colors,
      final String title,
      final String count,
      final String subTitle,
      final String icon,
      {final String navigation,
      final int tabPosition = -1,
      final String parameter}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 15,left: 5,right: 5,),
      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(10),
      ),

      child: Container(

        height: 125,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
            tileMode: TileMode.clamp,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: InkWell(
          onTap: () {
            if (tabPosition >= 0) {
              Provider.of<HomeTabNotifier>(context, listen: false).currentIndex =
                  tabPosition;
              if(parameter!=null&&parameter!="")
                {
                  switch(parameter)
                  {
                    case 'del':
                        tbPosition=6;
                        break;
                    case 'rej':
                      tbPosition=4;
                      break;
                    case 'ret':
                      tbPosition=5;
                      break;
                    default:
                      tbPosition=0;
                      break;
                  }
                }

              else
                tbPosition=0;
            } else if (navigation != null && navigation.isNotEmpty) {
              Navigator.of(context).pushNamed(navigation);
            }
          },
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Text(
                          count,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  ImageIcon(
                    AssetImage(icon),
                    size: 40,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  subTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemsListGradientP(
      BuildContext context,
      final List<Color>  colors,
      final String title,
      final String count,
      final String subTitle,
      final String icon,
      final String store,
      {final String navigation,
        final int tabPosition = -1,
        final String parameter}) {
    return Card(
      margin: const EdgeInsets.only(top: 15,left: 5,right: 5,bottom: 5),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(

        height: 125,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
            tileMode: TileMode.clamp,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: InkWell(
          onTap: () {
            if (tabPosition >= 0) {
              Provider.of<HomeTabNotifier>(context, listen: false).currentIndex =
                  tabPosition;
              if(parameter!=null&&parameter!="")
              {
                switch(parameter)
                {
                  case 'del':
                    tbPosition=5;
                    break;
                  case 'rej':
                    tbPosition=3;
                    break;
                  case 'ret':
                    tbPosition=4;
                    break;
                  default:
                    tbPosition=0;
                    break;
                }
              }

              else
                tbPosition=0;
            }
            else if (navigation != null && navigation.isNotEmpty) {
              if(navigation=="add_product")
                {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => AddNewProduct()));
                }
              else
                Navigator.of(context).pushNamed(navigation);
            }
          },
          child: Column(


            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Text(
                          count,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(height: 5),
                        BlinkText(
                            'Add / Edit Products',
                            style: TextStyle(fontSize: 16.0,fontWeight:FontWeight.bold,color: Colors.deepPurple),
                            beginColor: Colors.deepPurple,
                            endColor: Colors.orange,
                            times: 10,
                            duration: Duration(seconds: 2)
                        ),
                        // Text(
                        //   'Add / Edit Products',style:TextStyle(color:Colors.deepPurple,fontSize: 21, fontWeight: FontWeight.bold),),

                      ],
                    ),
                  ),

                  ImageIcon(
                    AssetImage(icon),
                    size: 40,
                  ),
                ],
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  subTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNotifications() {
    setState(() {

    });
    flutterLocalNotificationsPlugin.show(0,
        "title",
        "body",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          importance: Importance.high,
          color:Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
          sound: RawResourceAndroidNotificationSound('alarm')
        )
      )



    );
  }
  Widget _itemsList(BuildContext context, String title, String image,
      {String navigation, int tabPosition = -1, String store}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 5),

      color: Colors.white,
      elevation: 5,
      child: Container(
        height: 50,
        child: InkWell(
          onTap: () {
            if (tabPosition >= 0) {
              Provider.of<HomeTabNotifier>(context, listen: false).currentIndex =
                  tabPosition;
            }
            else if (navigation != null && navigation.isNotEmpty) {
              if(navigation=='pending_p')
                {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) => PendingProductsScreen(store,)));
                }

              else if(navigation=='lowstock_p')
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => StoreSuccess()));
              }
              else if(navigation=='contact_customer_care')
              {
                String phone ='${'wa.me/+97470920545/?text'}=${Uri.parse('Hi')}';
                if (phone != null && phone.trim().isNotEmpty) {
                  phone = 'https:$phone';
                  if ( canLaunch(phone) != null) {
                    launch(phone);
                  }
                }

              }

              }
              else
                Navigator.of(context).pushNamed(navigation);
            },
          // },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 7, 15, 7),
            child: Row(
              children: [
                ImageIcon(
                  AssetImage(image),
                  color: colorPrimary,
                  size: 22,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: colorPrimary,
                ),

              ],

            ),

          ),
        ),
      ),
    );
  }

  _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Not supported");
    }
  }
}

