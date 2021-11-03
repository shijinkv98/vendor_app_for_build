import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/screens/home/profile.dart';

/// This is the main method of app, from here execution starts.


/// App widget class.
class WelcomeTipsScreen extends StatefulWidget {

  // Making list of pages needed to pass in IntroViewsFlutter constructor.
  @override
  _WelcomeTipsScreenState createState() => _WelcomeTipsScreenState();
}

class _WelcomeTipsScreenState extends State<WelcomeTipsScreen> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'IntroViews Flutter',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: ThemeData(
        primaryColor: colorPrimary
      ),
      home: WelcomeTipsScreenPAGE()

    );
    
  }
}
class WelcomeTipsScreenPAGE extends StatefulWidget {
  WelcomeTipsScreenPAGE({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WelcomeTipsScreenPAGE> {
  final pages = [
    PageViewModel(
      // pageColor: const Color(0xFF03A9F4),
      // iconImageAssetPath: 'assets/air-hostess.png',
      bubble: Image.asset('assets/icons/appicon.ico'),
      pageBackground: Image.asset('assets/icons/socialmediainfo.jpg'),
      // body: const Text(
      //   'Hassle-free  booking  of  flight  tickets  with  full  refund  on  cancellation',
      // ),
      // title: const Text(
      //   'Flights',
      // ),
      // titleTextStyle:
      // const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      // bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      // mainImage: Image.asset(
      //   'assets/airplane.png',
      //   height: 285.0,
      //   width: 285.0,
      //   alignment: Alignment.center,
      // ),
    ),
    PageViewModel(
      // pageColor: const Color(0xFF8BC34A),
      // iconImageAssetPath: 'assets/waiter.png',
      bubble: Image.asset('assets/icons/appicon.ico'),
      pageBackground: Image.asset('assets/icons/deliveryinfo.jpg'),
      //   body: const Text(
      //     'We  work  for  the  comfort ,  enjoy  your  stay  at  our  beautiful  hotels',
      //   ),
      //   title: const Text('Hotels'),
      //   mainImage: Image.asset(
      //     'assets/hotel.png',
      //     height: 285.0,
      //     width: 285.0,
      //     alignment: Alignment.center,
      //   ),
      //   titleTextStyle:
      //   const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      //   bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    /*PageViewModel(
      pageBackground: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: [
              Colors.orange,
              Colors.pinkAccent,
            ],
          ),
        ),
      ),
      iconImageAssetPath: 'assets/taxi-driver.png',
      body: const Text(
        'Easy  cab  booking  at  your  doorstep  with  cashless  payment  system',
      ),
      title: const Text('Cabs'),
      mainImage: Image.asset(
        'assets/taxi.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle:
      const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),*/
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logos/logo_main_small.png',
          height: 30,
        ),

        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Builder(
        builder: (context) =>
            IntroViewsFlutter(
              pages,
              showNextButton: true,
              showBackButton: true,
              onTapDoneButton: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Profile()),
                );
              },
              pageButtonTextStyles: const TextStyle(
                color: colorPrimary,
                fontSize: 15.0,
              ),
            ),
      ),
    );
  }
}