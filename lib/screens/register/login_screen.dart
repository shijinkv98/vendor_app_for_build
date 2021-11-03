// import 'dart:convert';
import 'dart:convert' show jsonEncode;
import 'dart:io' show Platform;

import 'package:connectivity/connectivity.dart';
import 'package:device_id/device_id.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/SingupResponse.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendor_app/notifiers/loading_notifiers.dart';
import 'package:vendor_app/screens/CountryListRespose.dart';
import 'package:vendor_app/screens/home/time.dart';
import 'package:vendor_app/screens/register/add_address.dart';
import 'forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  PickResult selectedPlace;

}

class _LoginScreenState extends State<LoginScreen> {
  Countries _chosenValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  bool _isObscure = true;
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;
  BuildContext mContext;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  // String deviceId = await _getId();
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    //Navigator.of(mContext).pushReplacementNamed('home');
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Not supported");
    }
  }
  ProgressLoadNotifier _updatedNotifier;
  @override
  Future<void> initState()  {
    _updatedNotifier =
        Provider.of<ProgressLoadNotifier>(context, listen: false);
    _updatedNotifier.isLoading =false;

    super.initState();
  }
  @override
  void dispose() {
    _updatedNotifier.reset();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    // TextEditingController emailController = new TextEditingController();
    String email;
    final emailField = TextFormField(
      obscureText: false,
      // controller: emailController,
      onSaved: (value) {
        email = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
          // } else if (!RegExp(
          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          //     .hasMatch(value)) {
          //   return 'Invalid email';
          // } else if (value.trim().length != 10) {
          //   return 'Invalid Mobile number';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Phone Number",
        labelText: 'Phone Number',
        // prefixText: '+974 ',
        prefixStyle: TextStyle(color: Colors.grey),
        suffixIcon: InkWell(
          onTap: (){

          },

          child: Icon(
            Icons.local_phone_outlined,
            color: primaryIconColor,
          ),
        ),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );



    String password;
    final passwordField = TextFormField(
      obscureText: _isObscure,
      // controller: passwordController,
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        password = value;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Password",
        labelText: "Password",
        suffixIcon:
        InkWell(
          onTap: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          child: IconButton(
            icon:Image.asset(
              _isObscure ?
              'assets/icons/private.png':'assets/icons/eye.png',
              width: 20,
              height: 297446451830,
              color: colorPrimary,
            ),
            onPressed: null,
            color: colorPrimary,
          ),
          // border:

          // Icon(
          //   _isObscure ? Icons.lock_outline : Icons.lock_open_outlined,
          //   color: primaryIconColor,
          // ),
        ),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: colorPrimary,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () async {
          // Navigator.of(context).pushReplacementNamed('/home');
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            if(_chosenValue == null)
              ApiCall().showToast("Please Select Country");
              //ApiCall().showToast(countryId);

              debugPrint("params: " + _chosenValue.id);
              String deviceId = await DeviceId.getID;
             // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

            Map<String, dynamic> deviceData = <String, dynamic>{};
            if (Platform.isAndroid) {
              deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
            } else if (Platform.isIOS) {
              deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
            }
            String devicetoken = await FirebaseMessaging.instance.getToken();
              Map body = {
                // email_phone,password
                'email_phone': email.trim(),
                'password': password.trim(),
                'device_token': devicetoken,
                'device_id': deviceId,
                'country': countryId,
                'device_platform': Platform.isIOS ? '2' : '1',
              };

              FocusScope.of(context).requestFocus(FocusNode());
              _updatedNotifier.isLoading = true;
              SignupResponse value = await ApiCall()
                  .execute<SignupResponse, Null>(
                  "vendorlogin", body, loadingNotifier: _updatedNotifier);

              if (value != null &&
                  value.vendorData != null &&
                  value.vendorData.token != null) {
                _updatedNotifier.isLoading = false;
                await ApiCall().saveUser(jsonEncode(value.vendorData.toJson()));
                Navigator.of(context).pushReplacementNamed('home');
              }


              // if(value.success != 1){
              //   _updatedNotifier.isLoading=false;
              // }

            }
          },

        child: Text("Sign in",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

Widget getContent(){
  return Container(
    height: MediaQuery.of(context).size.height,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    color: colorPrimary,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 80),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(65.0),
                            topRight: Radius.circular(65.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sign in to your Account",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: 80,
                                    child: getCountry()
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width - 160,
                                    child: emailField),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          passwordField,
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ForgotPasswordScreen('')));
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          loginButon,
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Don\'t have an account?',
                                  style: TextStyle(color: Colors.black, fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' Create new store',
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context).pushNamed('signup');
                                          },
                                        style:
                                        TextStyle(color: colorPrimary, fontSize: 15))
                                  ])),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          String phone ='${'wa.me/+97470920545/?text'}=${Uri.parse('Hi')}';
                          if (phone != null && phone.trim().isNotEmpty) {
                            phone = 'https:$phone';
                            if ( canLaunch(phone) != null) {
                              launch(phone);
                            }
                          }
                          // FlutterOpenWhatsapp.sendSingleMessage("+97470920545", "Hello");
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 30,right:30),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.white,
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  height:50,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF25d366),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Image(
                                      image: AssetImage('assets/icons/whatsappl.png'),
                                      width: 30,height: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF25d366),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'SELLER SUPPORT CENTRE',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                letterSpacing: 1),
                                          ),
                                          Text(
                                            '+974 7092 0545',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Align(alignment: Alignment.bottomCenter,
          child: Consumer<ProgressLoadNotifier>(
            builder: (context, value, child) {
              return value.isLoading ? progressBar : SizedBox();
            },
          ),)
      ],
    ),
  );

}
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign in',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body:
      FutureBuilder<CountryList>(
        future: ApiCall().execute<CountryList, Null>('countries/en', null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            countries=snapshot.data.countries;
            // if(countries!=null)
            // {
            //   _chosenValue = countries[0];
            //   countryId = _chosenValue.id.toString();
            // }
            return getContent();
          } else if (snapshot.hasError) {
            return errorScreen('Error: ${snapshot.error}');
          } else {
            return progressBar;
          }
        },
      )
    );
  }
  List<Countries> countries;
  String name = "";
  String countryId = " ";
  Countries getValue()
  {
    for(int i=0;i<countries.length;i++)
    {

      if(countries[i].id==countryId)
        return countries[i];
    }
    return countries[0];
  }

  Widget getCountry(){
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {

          return DropdownButton<Countries>(
            isExpanded: true,
            dropdownColor: Colors.white,
            focusColor:Colors.black,
            value: getValue(),
            isDense: true,
            underline: Container(color: Colors.transparent),
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor:colorPrimary,
            items: countries.map<DropdownMenuItem<Countries>>((Countries value) {
              return DropdownMenuItem<Countries>(
                value: value,
                child: Text(value.name,style:TextStyle(color:colorPrimary),overflow: TextOverflow.visible),
              );
            }).toList(),
            hint:Text(name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            onChanged: (Countries value) {
              //_chosenValue = value;

              setState(() {
                name=value.name;

                countryId = value.id.toString();
                _chosenValue = value;
                // updateOrderstatus(widget.orderItems.item.id,value.statusId.toString());

              });

            },

          );

        }
    );
  }
}
