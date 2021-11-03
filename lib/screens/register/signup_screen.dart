// import 'dart:io';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/SingupResponse.dart';
import 'package:vendor_app/notifiers/register_notifier.dart'
    show CheckBoxNotifier;
import 'package:vendor_app/screens/CountryListRespose.dart';
import 'package:vendor_app/screens/register/termsandprivacypolicy.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  Countries _chosenValue;
  CheckBoxNotifier _checkBoxNotifier;
  bool _isObscure = true;
  String _qatar;
  _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Not supported");
    }
  }
  @override
  Widget build(BuildContext context) {
    String shopName;
    _checkBoxNotifier = Provider.of<CheckBoxNotifier>(context, listen: false);
    final shopNameField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        shopName = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          hintText: "Shop name",
          labelText: 'Shop name',
          suffixIcon: Icon(
            Icons.person_outline,
            color: primaryIconColor,
          )
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
          ),
    );
    var _countryArray = ['Qatar'];
    final _countryField = DropdownButtonFormField(
      value: _qatar,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(8, 0.0, 0, 0.0),
        hintStyle: TextStyle(fontSize: 14),
        labelStyle: TextStyle(fontSize: 14),
        hintText: 'Country',
        labelText: 'Country',

      ),
      isExpanded: true,
      isDense: true,

      onChanged: (String newValue) {
        // setState(() {
        _qatar = newValue;
        // state.didChange(newValue);
        // });
      },
      items: _countryArray.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
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
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Invalid email';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          hintText: "Email",
          labelText: 'Email',
          suffixIcon: Icon(
            Icons.alternate_email,
            color: primaryIconColor,
          )
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
          ),
    );


    String phoneNo;
    final phoneField = TextFormField(
      obscureText: false,
      onSaved: (value) {
        phoneNo = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          hintText: "Phone Number",
          labelText: 'Phone Number',
          // prefixText: '+974 ',prefixStyle:TextStyle(color: Colors.grey),
          suffixIcon: Icon(
            Icons.local_phone_outlined,
            color: primaryIconColor,
          )
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
          ),
    );

    // final TextEditingController passwordController =
    //     new TextEditingController();
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
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            if(_chosenValue == null)
              ApiCall().showToast("Please Select Country");
            if (!_checkBoxNotifier.isChecked) {
              ApiCall()
                  .showToast('Please Accept Terms of Use and Privacy Policy');
            } else {
              Map body = {
                // name,email,phone_number,password
                'name': shopName.trim(),
                'email': email.trim(),
                'password': password.trim(),
                'phone_number': phoneNo,
                'phone_country_code':countryId,
                'country':countryId,
                // 'device_token': deviceToken,
                // 'device_id': deviceId,
                // 'device_platform': Platform.isIOS ? '2' : '1',
              };

              FocusScope.of(context).requestFocus(FocusNode());
              var response = await ApiCall()
                  .execute<SignupResponse, Null>("vendorregistration", body);

              if (response?.vendorData != null) {
                // Navigator.of(context)
                //     .pushReplacementNamed('vendorDetails', arguments: '');
                Navigator.of(context)
                    .pushNamed('otp', arguments: response.vendorData);
              }
            }
          }
        },
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
    Widget getFullView(){
      return SingleChildScrollView(

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
                        "Create your Account",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    shopNameField,
                    SizedBox(
                      height: 10,
                    ),
                    emailField,

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
                              child: phoneField),
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
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Consumer<CheckBoxNotifier>(
                            builder: (context, value, child) {
                              return Checkbox(
                                value: value.isChecked,
                                activeColor: colorPrimary,
                                checkColor: Colors.white,
                                materialTapTargetSize: null,
                                onChanged: (bool value2) {
                                  value.isChecked = value2;
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "I Accept All The",
                              style:
                              TextStyle(color: Colors.black, fontSize: 12),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Terms of Use',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF265c7e),
                                    ),
                                  recognizer: new TapGestureRecognizer()..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => TermsAndPrivacyPolicyscreen(terms:true))),
                                ),
                                TextSpan(
                                  text: ' and',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                                TextSpan(
                                    text: ' Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF265c7e),
                                    ),
                                  recognizer: new TapGestureRecognizer()..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => TermsAndPrivacyPolicyscreen(terms:false))),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    loginButon,
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Already have an account?',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Sign in',
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => LoginScreen()));

                                    },
                                  style:
                                  TextStyle(color: colorPrimary, fontSize: 15))
                            ]))
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
                              borderRadius: BorderRadius.circular(10),
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
      );

    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,

      body:WillPopScope(
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
        child: FutureBuilder<CountryList>(
          future: ApiCall().execute<CountryList, Null>('countries/en', null),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              countries=snapshot.data.countries;
              // if(_chosenValue!=null)
              //   {
              //     _chosenValue = countries[0];
              //     countryId = _chosenValue.id.toString();
              //   }

              return getFullView();
            } else if (snapshot.hasError) {
              return errorScreen('Error: ${snapshot.error}');
            } else {
              return progressBar;
            }
          },
        ),
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
            underline: Container(color: Colors.transparent),
            isDense: true,
            // elevation: 5,
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
                  fontWeight: FontWeight.w500),
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