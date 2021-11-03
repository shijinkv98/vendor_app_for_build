import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/model/user.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/notifiers/home_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/notifiers/searchupdatenotifier.dart';
import 'package:vendor_app/notifiers/updatenotifier.dart';
import 'package:vendor_app/screens/home/Maps.dart';
import 'package:vendor_app/screens/home/offer_manager.dart';
import 'package:vendor_app/screens/products/TestProducts.dart';
import 'package:vendor_app/screens/products/CategoryScreen.dart';

import 'helpers/constants.dart';
import 'map/map_places.dart';
import 'notifiers/loading_notifiers.dart';
import 'notifiers/order_details_notifier.dart';
import 'notifiers/product_notifier.dart';
import 'notifiers/productlistnotifier.dart';
import 'notifiers/register_notifier.dart';
import 'notifiers/report_notifier.dart';
import 'screens/category/category_list.dart';
import 'screens/register/login_screen.dart';
import 'screens/home/home.dart';
import 'screens/products/add_new_product.dart';
import 'screens/register/otp.dart';
import 'screens/register/vendor_datails.dart';
import 'screens/splash.dart';
import 'screens/register/signup_screen.dart';
import 'screens/order_details.dart';
import 'screens/subscribe_ad.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
    enableLights: true,
    sound:RawResourceAndroidNotificationSound('alarm'),
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}
String userResponse="";
void SaveUser()
async {
  var pref = await SharedPreferences.getInstance() ;
  Data data=Data(pref);
  userResponse= data.preferences.getString('user') == null ? "" : data.preferences.getString('user');

}
// Future<void> main()  {
//   // ignore: invalid_use_of_visible_for_testing_member
//
//   //setupPreferences("user","");
//   runApp(MyApp());
//   // const MethodChannel('plugins.flutter.io/shared_preferences')
//   //     .setMockMethodCallHandler((MethodCall methodCall) async {
//   //   if (methodCall.method == 'getAll') {
//   //     return <String, dynamic>{}; // set initial values here if desired
//   //   }
//   //   return null;
//   // });
//
// }
Future setupPreferences(String key, String value) async {
  SharedPreferences.setMockInitialValues(<String, dynamic>{'flutter.' + key: value});
  final preferences = await SharedPreferences.getInstance();
  await preferences.setString(key, value);
}
class Data {
  SharedPreferences preferences;
  Data(this.preferences);
}
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState(){
    super.initState();
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: android?.smallIcon,
                  sound:RawResourceAndroidNotificationSound('alarm'),
                  enableVibration: true,
                  playSound: true
              ),
            ));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    ApiCall().context = context;
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (context) => HomeTabNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => CheckBoxNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchUpdateNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OTPNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageAddedNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => DocsAddedNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => PhysicalStoreClickNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => DateChangeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => DashboardLoadNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportLoadingNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProgressLoadNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderDetailsLoadingNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderTimelineNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategorySelectedNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductListNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddProductLoadingNotifier(),
        ),
        ChangeNotifierProvider.value(value: GenerateMaps(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginLoadingNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => UpdateNotifier(),
        ),

        // ChangeNotifierProvider(
        //   create: (context) => DocsAddedNotifier(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => DocsAddedNotifier(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => DocsAddedNotifier(),
        // ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'splash':
              return MaterialPageRoute(builder: (_) => SplashScreen());
              break;
            case 'login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
              break;
            case 'offer':
              return MaterialPageRoute(builder: (_) => OfferManger());
              break;
            case 'signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
              break;
            case 'home':
              return MaterialPageRoute(builder: (_) => HomeScreen());
              break;
            case 'orderDetails':
              return MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(
                    orderItems: settings.arguments,
                  ));
              break;
            case 'categories':
              return MaterialPageRoute(builder: (_) => CategoryListScreen());
              break;
            case 'products':
              return MaterialPageRoute(builder: (_) => CategoryScreen());
              break;
          // case 'subscribeAds':
          //   return MaterialPageRoute(builder: (_) => SubscribeAds());
          //   break;
            case 'addProduct':
              return MaterialPageRoute(builder: (_) => AddNewProduct());
              break;
            case 'vendorDetails':
              return MaterialPageRoute(
                  builder: (_) => VendorDetailScreen(
                    userData: settings.arguments,
                  ));
              break;
            case 'otp':
              return MaterialPageRoute(
                  builder: (_) => OtpScreen(
                    userData: settings.arguments,
                  ));
              break;
            case 'mapPlacePicker':
              return MaterialPageRoute(builder: (_) => MapPlacePicker());
              break;
          // case 'prod':
          //   return MaterialPageRoute(builder: (_) => SearchProduct());
          //   break;
          // case 'prod':
          //   return MaterialPageRoute(builder: (_) => SearchProduct());
          //   break;
          // case 'prod':
          //   return MaterialPageRoute(builder: (_) => SearchProduct());
          //   break;
            default:
              return MaterialPageRoute(builder: (_) => SplashScreen());
              break;
          }
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: colorPrimary,
          fontFamily: 'Roboto',
          // primarySwatch: colorPrimary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
