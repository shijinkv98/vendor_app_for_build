import 'dart:io';

import 'package:showcaseview/showcaseview.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/notifiers/home_notifiers.dart';
import 'package:vendor_app/screens/home/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/products/CategoryScreen.dart';

import 'ad_manager.dart';
import 'dashboard.dart';
import 'report.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
int tbPosition=1;
String adMangerId="0";
TextStyle _optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

List<Widget> _widgetOptions = <Widget>[

  AdManager(),
  Orders(),
  ShowCaseWidget(
      builder: Builder(builder: (_) =>Dashboard()),
    autoPlay: true,
    autoPlayDelay: Duration(seconds: 3),

  ),
  Report(),
  CategoryScreen(),
  // Profile(),
  // IntroScreen(),
  Text(
    'Others',
    style: _optionStyle,
  ),
  Text(
    'Others2',
    style: _optionStyle,
  ),
];

class _HomeState extends State<HomeScreen> {
  HomeTabNotifier _homeTabNotifier;
  @override
  Widget build(BuildContext context) {
    debugPrint('MJM HomeScreen build()');
    _homeTabNotifier = Provider.of<HomeTabNotifier>(context, listen: false);
    return Consumer<HomeTabNotifier>(
      builder: (context, value, child) {
        return WillPopScope(
            onWillPop: () async => showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(title: Text('Are you sure you want to quit?'), actions: <Widget>[
                  RaisedButton(
                      child: Text('Ok'),
                      onPressed: () => exit(0)),
                  RaisedButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false)),
                ])),
        child:
          Scaffold(
          body: Center(
            child: _widgetOptions[value.currentIndex],
          ),

          bottomNavigationBar:new  BottomNavigationBar(

            type: BottomNavigationBarType.fixed,
              items:  [
                new BottomNavigationBarItem(
                  icon: new ImageIcon(AssetImage("assets/icons/services_grey.png")),label: 'Ad Manager'),
              BottomNavigationBarItem(icon: new ImageIcon(AssetImage("assets/icons/order_grey.png")), label: 'Order'),
              BottomNavigationBarItem(
                  icon: new ImageIcon(AssetImage("assets/icons/dashboard_grey.png")), label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: new ImageIcon(AssetImage("assets/icons/report_grey.png")), label: 'Report'),
              BottomNavigationBarItem(
                  icon: new ImageIcon(AssetImage("assets/icons/productsicon.png")), label: 'Products'),
            ],
            iconSize: 30,
            selectedFontSize: 12,
            backgroundColor: colorPrimary,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedFontSize: 12,
            currentIndex: _homeTabNotifier.currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            onTap: (value) {
              _homeTabNotifier.currentIndex = value;
            },
          ),
          )
        );
      },
    );
  }
}
