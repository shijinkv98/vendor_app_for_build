import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter

import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/model/file_model.dart';
import 'package:vendor_app/model/user.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/network/response/profileresponse.dart';
import 'package:vendor_app/network/response/store_open_close_response.dart';
import 'package:vendor_app/notifiers/product_notifier.dart';
import 'package:vendor_app/notifiers/updatenotifier.dart';
import 'package:vendor_app/screens/CountryListRespose.dart';
import 'package:vendor_app/screens/home/ad_manager.dart';
import 'package:vendor_app/screens/home/popup.dart';
import 'package:vendor_app/screens/home/popup_content.dart';
import 'package:vendor_app/screens/register/signup_screen.dart';
import '../../helpers/constants.dart';

// const String uploadURL = "https://xshop.qa/api//update-logo";

class Profile extends StatefulWidget {
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UpdateNotifier _updateNotifier;
  Countries _chosenValue;
  String dialcode='';
  ProfileResponse profileResponse;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  bool circular = true;
  PickResult selectedPlace;
  File _image;
  File _image2;
  BuildContext mContext;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isEnabled = true;
  FocusNode focusNode = FocusNode();
  bool status = false;
  enableButton() {
    setState(() {
      isEnabled = true;
    });
  } // /NetworkHandler  networkHandler = NetworkHandler();

  TextEditingController _textController100;
  PickedFile _imageFile;
  PickedFile _imageFile2;
  final String uploadUrl = 'https://xshop.qa/api/update-logo';
  final String uploadUrl2 = 'https://xshop.qa/api/update-banner';
  final String uploadUrl3 = 'https://xshop.qa/api/update-profile ';
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey5 = GlobalKey<FormState>();
  String whatsapp = "";
  String facebook = "";
  String instagram = "";
  String youtube = "";
  String website = "";
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.of(mContext).pushReplacementNamed('home');
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  ImageAddedNotifier _imageAddedNotifier;

  Future<String> uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('logo', filepath));
    ApiCall().showToast('Logo Updated Successfully');
    request.fields['id'] = userId;
    request.fields['token'] = userToken;
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<String> uploadImage2(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('banner', filepath));
    ApiCall().showToast('Banner Updated Successfully');
    request.fields['id'] = userId;
    request.fields['token'] = userToken;
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
        uploadImage(_image.path, uploadUrl);
      });
    } else {
      print('Retrieve error ' + response.exception.code);
    }
  }

  Future<void> retriveLostData2() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile2 = response.file;
        uploadImage2(_image2.path, uploadUrl);
      });
    } else {
      print('Retrieve error ' + response.exception.code);
    }
  }

  void _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile.path);
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _image = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();

      setState(() {
        uploadImage(_image.path, uploadUrl);
      });
    }
  }

  void _getFromCamera2() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage2(pickedFile.path);
  }

  _cropImage2(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _image2 = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();

      setState(() {
        uploadImage2(_image2.path, uploadUrl2);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.grey,
                    ),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPicker2(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getFromGallery2();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.grey,
                    ),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera2();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage3(pickedFile.path);
  }

  _cropImage3(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _image = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();

      setState(() {
        uploadImage(_image.path, uploadUrl);
      });
    }
  }

  void _getFromGallery2() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage4(pickedFile.path);
  }

  _cropImage4(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      _image2 = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();

      setState(() {
        uploadImage2(_image2.path, uploadUrl2);
      });
    }

    // _imgFromGallery() async {
    //   // ignore: deprecated_member_use_from_same_package
    //   File image = await ImagePicker.pickImage(
    //       source: ImageSource.gallery, imageQuality: 50);
    //
    //   setState(() {
    //     _image = image;
    //     uploadImage(_image.path, uploadUrl);
    //   });
    // }
    //
    // _imgFromGallery2() async {
    //   // ignore: deprecated_member_use_from_same_package
    //   File image2 = await ImagePicker.pickImage(
    //       source: ImageSource.gallery, imageQuality: 50);
    //
    //   setState(() {
    //     _image2 = image2;
    //     uploadImage2(_image2.path, uploadUrl2);
    //   });
    // }
  }

  @override
  void initState() {
    _updateNotifier =
        Provider.of<UpdateNotifier>(context, listen: false);
    ApiCall().getUser().then((UserData userData) {
      userId = userData.id.toString();
      userToken = userData.token.toString();
    });
    // Provider.of<GenerateMaps>(context,listen: false).getCurrentLocation();
    super.initState();
    _textController100 = new TextEditingController();

    ApiCall().execute<CountryList, Null>(
        'countries/en',
        null).then((value) {
      countries=value.countries;
      dialcode=profileResponse.whatsapp_prefix;
      _updateNotifier.update();
    });
  }

  @override
  void dispose() {
    _updateNotifier.reset();
    super.dispose();
  }

  void fetchData() async {}
  final double _paddingTop = 10;

  final double _paddingStart = 10;

  final BoxDecoration _boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 3.0,
      ),
    ],
  );

  void _handleMoreOptionClick(String value) {
    switch (value) {
      case 'vendorlogout':
        {
          ApiCall().saveUser('').whenComplete(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SignUpScreen())));
        }
        break;
      case 'logo':
        {
          _image;
        }
        break;
      default:
        {}
        break;
    }
  }

  String presetText;
  String userId = "", userToken = "";
  String whatsapp_num = "";
  TextEditingController _textController;
  TextEditingController _textController1;
  TextEditingController _textController2;
  TextEditingController _textController3;
  TextEditingController _textController4;
  TextEditingController _textController5;
  TextEditingController _textController6;
  TextEditingController _textController7;
  TextEditingController _textController8;
  TextEditingController _textController9;
  TextEditingController _textController10;
  TextEditingController _textController11;
  @override
  Widget build(BuildContext context) {
    mContext = context;

    // UserData userData=getUser() as UserData;
    final _padding = EdgeInsets.fromLTRB(
        _paddingStart, _paddingTop, _paddingStart, _paddingTop);

    _textController = new TextEditingController();
    _textController1 = new TextEditingController();
    _textController2 = new TextEditingController();
    _textController3 = new TextEditingController();
    _textController4 = new TextEditingController();
    _textController5 = new TextEditingController();
    _textController6 = new TextEditingController();
    _textController7 = new TextEditingController();
    _textController8 = new TextEditingController();
    _textController9 = new TextEditingController();
    _textController10 = new TextEditingController();
    _textController11 = new TextEditingController();
    bool _enabled = false;

    String whatsapp = "";

    final whatsappField = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: _textController,
      obscureText: false,
      onSaved: (value) {
        whatsapp = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Colors.white,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 0.5),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "with country code",
        labelText: "Whatsapp Number",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/whatsapp.png',
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
    String facebook;
    final facebookField =
    TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller:_textController1,
      obscureText: false,
      onSaved: (value) {
        facebook = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 0.5),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Facebook URL",
        labelText: "Facebook URL",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/facebook.png',
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
    String instagram;
    final instagramField = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: _textController2,
      obscureText: false,
      onSaved: (value) {
        instagram = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Instagram URL",
        labelText: "Instagram URL",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/instagram.png',
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
    String youtube;
    final youtubeFiled = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller:_textController3,
      obscureText: false,
      onSaved: (value) {
        youtube = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Youtube URL",
        labelText: "Youtube URL",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/youtube.png',
            width: 5,
            height: 5,
          ),
        ),
      ),
    );
    String website;
    final websiteField = TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller:_textController4,
      obscureText: false,
      onSaved: (value) {
        website = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Add Website URL",
        labelText: "Website URL",
        prefixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: Image.asset(
            'assets/icons/globe.png',
            width: 5,
            height: 5,
          ),
        ),
      ),
    );

    String deliveryRadius;
    final deliveryRadiusField = TextFormField(
      controller: _textController5,
      obscureText: false,
      onSaved: (value) {
        deliveryRadius = value;
        // _guaranteePeriod = value;
      },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onTap: () {},
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colorPrimary, width: 1.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Maximum 200 KM",
        labelText: "Delivery Radius in KM",
      ),
    );

    String deliveryCharge;
    final deliveryChargeField = TextFormField(
      controller: _textController6,
      obscureText: false,
      onSaved: (value) {
        deliveryCharge = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colorPrimary, width: 1.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Min Delivery charge",
        labelText: "Min Delivery charge",
      ),
    );
    String deliveryAmount;
    final deliveryAmountField = TextFormField(
      controller: _textController7,
      obscureText: false,
      onSaved: (value) {
        deliveryAmount = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colorPrimary, width: 1.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Free Delivery Amount",
        labelText: "Free Delivery Amount",
      ),
    );
    String storeTime;
    final storeTImeField = TextFormField(
      controller: _textController8,
      obscureText: false,
      enabled: false,
      onSaved: (value) {
        storeTime = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      textInputAction: TextInputAction.send,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Color(0xFFebebeb),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colorPrimary, width: 1.0),
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Store Time",
        labelText: "Store Time",
      ),
    );

    String phoneNumber;

    final phoneNumberField = TextFormField(
      enabled: false,
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.left,
      initialValue: presetText,
      controller: _textController9,
      obscureText: false,
      onSaved: (value) {
        phoneNumber = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
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
        border: InputBorder.none,
        hintText: "Phone Number",
      ),
    );

    String email;

    final emailField = TextFormField(
      enabled: false,
      // enabled: isEnabled,
      textAlignVertical: TextAlignVertical.top,
      textAlign: TextAlign.left,
      initialValue: presetText,
      controller: _textController10,
      obscureText: false,

      onSaved: (value) {
        email = value;
        // _guaranteePeriod = value;
      },
      // initialValue: _guaranteePeriod,
      // style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon:
            ImageIcon(AssetImage('assets/icons/edit.png'), color: colorPrimary),
        hintText: "Email",
      ),
    );
    String location;
    final _locationField = TextFormField(
      controller: _textController100,
      obscureText: false,
      enabled: false,
      onSaved: (value) {
        location = value;
      },
      style: style,
      // validator: (value) {
      //   if (value.trim().isEmpty) {
      //     return 'This field is required';
      //   } else {
      //     return null;
      //   }
      // },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.my_location,
            color: colorPrimary,
          ),
        ),
        hintText: "Enter Store Location",
        focusColor: Colors.black,
        labelText: "Store Location",
      ),
    );
    // String location;
    // final locationField = TextFormField(
    //   enabled: false,
    //   textAlignVertical: TextAlignVertical.top,
    //   textAlign: TextAlign.left,
    //   // initialValue: presetText,
    //   controller: _textController11,
    //   obscureText: false,
    //   onSaved: (value) {
    //     location = value;
    //     // _guaranteePeriod = value;
    //   },
    //   // initialValue: _guaranteePeriod,
    //   // style: style,
    //   validator: (value) {
    //     if (value.trim().isEmpty) {
    //       return 'This field is required';
    //     } else {
    //       return null;
    //     }
    //   },
    //   keyboardType: TextInputType.name,
    //   textInputAction: TextInputAction.next,
    //   decoration: InputDecoration(
    //     border: InputBorder.none,
    //     // hintText: finalAddress
    //   ),
    // );
    Widget getTime() {
      return InkWell();
    }

    Widget getContent() {
      if (profileResponse.is_closed == '0') status = true;

      final halfMediaWidth = MediaQuery.of(context).size.width / 2;
      _textController9.text = profileResponse.phoneNumber;
      _textController10.text = profileResponse.email;
      _textController100.text = profileResponse.location;
      _textController.text = profileResponse.whatsapp;
      _textController1.text = profileResponse.facebook;
      _textController2.text = profileResponse.instagram;
      _textController3.text = profileResponse.youtube;
      _textController4.text = profileResponse.websiteUrl;
      _textController5.text = profileResponse.freeDeliveryRadius;
      _textController6.text = profileResponse.minDeliveryCharge;
      _textController7.text = profileResponse.freeDeliveryAmount;
      _textController8.text = profileResponse.storeTime;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker2(context);
                    },
                    child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${BANNER_URL}${profileResponse.banner}'),
                              fit: BoxFit.cover),
                        ),
                        child: _image2 != null
                            ? ClipRRect(
                                // borderRadius:
                                // BorderRadius.circular(55),
                                child: Image.file(
                                  _image2,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(0)),
                                width: 115,
                                height: 115,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: colorPrimary,
                                ),
                              )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 25, 5, 0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 35,
                      ),
                      Expanded(
                          child: Text(
                        '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                      // PopupMenuButton<String>(
                      //   onSelected: (String value) {
                      //     _handleMoreOptionClick(value);
                      //   },
                      //   icon: Icon(
                      //     Icons.more_vert,
                      //     color: colorPrimary,
                      //   ),
                      //   itemBuilder: (BuildContext context) {
                      //     var list = List<PopupMenuEntry<String>>();
                      //     list.add(
                      //       PopupMenuItem<String>(
                      //         height: 15,
                      //         child: Text(
                      //           "Logout",
                      //           // style: TextStyle(color: TEXT_BLACK),
                      //         ),
                      //         value: 'logout',
                      //       ),
                      //     );
                      //     return list;
                      //   },
                      // ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 160,
                      ),
                      Column(
                        children: <Widget>[
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: NetworkImage(
                                    '${LOGO_URL}${profileResponse.logo}'),
                                child: _image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(55),
                                        child: Image.file(
                                          _image,
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        width: 115,
                                        height: 115,
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: colorPrimary,
                                        ),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // ClipOval(
                      //   child: FadeInImage.assetNetwork(
                      //     ,placeholder: 'assets/images/no_image.png'
                      //     image: "",
                      //     width: 80,
                      //     fit: BoxFit.cover,
                      //     height: 80,
                      //   ),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(profileResponse.storename)
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),            
            Card(
              elevation: 3,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Joined',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(profileResponse.joined),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: Color(0xFFebebeb),
                  ),
                  Expanded(
                    child: Container(
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Orders',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(profileResponse.orders),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: Color(0xFFebebeb),
                  ),
                  Expanded(
                    child: Container(
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Shop Status',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Container(
                            child: CustomSwitch(
                              value: status,
                              activeColor: colorPrimary,
                              activeTextColor: Colors.white,
                              inactiveColor: Colors.red,
                              inactiveTextColor: Colors.white,
                              onChanged: (value) {
                                status != true ? storeOpen() : storeClose();
                                setState(() {
                                  status = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Container(
            //   height: 1,
            //   width: double.maxFinite,
            //   color: Color(0xFFebebeb),
            // ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Profile Information',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      // if (_formKey4.currentState.validate()) {
                      //   _formKey4.currentState.save();
                      // _formKey3.currentState.save();
                      // } else {
                      Map body = {
                        // 'email': _textController10.text,
                        // 'phone_number':  _textController9.text,
                        'location': _textController100.text.toString(),
                        'latitude':
                            selectedPlace.geometry.location.lat.toString(),
                        'longitude':
                            selectedPlace.geometry.location.lng.toString(),

                        // 'id': userId,
                        // 'token': userToken
                      };
                      FocusScope.of(context).requestFocus(FocusNode());
                      ApiCall()
                          .execute("update-location", body,
                              multipartRequest: null)
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "Location Updated successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: colorPrimary,
                            textColor: Colors.white,
                            fontSize: 15.0);

                        // ApiCall().showToast(
                        // 'Profile Information Updated successfully');
                        setState(() {});
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.only(bottom: 5),
                      height: 35,
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.system_update_tv,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Text('Update',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                        ],
                        // FocusScope.of(context)
                        //     .requestFocus(FocusNode());
                        // var response = await ApiCall().execute<EditProfile, Null>("update-profile", body);
                        // ApiCall().showToast('Profile Information Updated successfully');
                        // setState(() {});
                        //
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 2, left: 5, right: 5),
              padding: EdgeInsets.all(0),
              // decoration: _boxDecoration,
              child: new Form(
                  key: _formKey3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Card(
                        elevation: 3,
                        child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10),
                                  width: halfMediaWidth,
                                  child: phoneNumberField,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Text(
                                          profileResponse.mobileVerified,
                                          style: TextStyle(
                                              color: primaryTextColor))),
                                )
                              ],
                            )),
                      ),
                    ],
                  )),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 1, left: 5, right: 5),
              // decoration: _boxDecoration,
              child: new Form(
                  key: _formKey4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Card(
                        elevation: 3,
                        child: Container(
                            alignment: Alignment.center,
                            child: Container(
                              // alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 10),
                              // width: MediaQuery.of(context).size.width /1.5,
                              child: InkWell(
                                  onTap: () {
                                    Fluttertoast.showToast(
                                        msg: "Not Available",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: colorPrimary,
                                        textColor: Colors.white,
                                        fontSize: 15.0);
                                  },
                                  // {
                                  //   showPopup(
                                  //       context, _popupBody(), 'Edit Email Id');
                                  // },
                                  child: emailField),
                            )),
                      ),
                    ],
                  )),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 1, left: 5, right: 5),
                padding: EdgeInsets.all(0),
                // decoration: _boxDecoration,
                child: new Form(
                    key: _formKey5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Card(
                          elevation: 3,
                          child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    // margin: const EdgeInsets.only(left: 10),
                                    // width: halfMediaWidth,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return PlacePicker(
                                                  apiKey:
                                                      'AIzaSyAIjaTpHNWTYXsHI-aW1kNxGQVXc3_epGA',
                                                  initialPosition:
                                                      Profile.kInitialPosition,
                                                  useCurrentLocation: true,
                                                  selectInitialPosition: true,
                                                  //usePlaceDetailSearch: true,
                                                  onPlacePicked: (result) {
                                                    selectedPlace = result;
                                                    Navigator.of(context).pop();
                                                    _textController100
                                                        .text = selectedPlace ==
                                                            null
                                                        ? ""
                                                        : selectedPlace
                                                                .formattedAddress ??
                                                            "";
                                                    // setState(() {
                                                    //
                                                    //
                                                    // });
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: _locationField),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    )),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      _paddingStart, _paddingTop, _paddingStart, _paddingTop),
                  // decoration: _boxDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Store verified status'),
                      Expanded(
                          child: SizedBox(
                        height: 20,
                      )),
                      Text(
                        profileResponse.storeVerifiedStatus,
                        style: TextStyle(color: primaryTextColor),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Padding(
                    padding: _padding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Social Media',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              // } else {

                              if (whatsapp.trim() == ''){
                                Map body = {
                                  // name,email,phone_number,password
                                  'whatsapp_prefix' : dialcode,
                                  'whatsapp': whatsapp.trim(),
                                  'facebook': facebook.trim(),
                                  'instagram': instagram.trim(),
                                  'youtube': youtube.trim(),
                                  'website_url': website.trim(),
                                  'id': userId,
                                  'token': userToken
                                };

                                FocusScope.of(context).requestFocus(FocusNode());
                                // ApiCall()
                                //     .execute("update-social-media", body,
                                //     multipartRequest: null)
                                //     .then((value)
                                ApiCall()
                                    .execute("v2/vendor/update-social-media", body,
                                    multipartRequest: null)
                                    .then((value)
                                {
                                  Fluttertoast.showToast(
                                      msg: "Social Media Updated successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: colorPrimary,
                                      textColor: Colors.white,
                                      fontSize: 15.0);
                                  // ApiCall().showToast(
                                  //     'Social Media Updated successfully');
                                  setState(() {});
                                });
                              }else{

                                if(dialcode == '0' || dialcode == ''){
                                  ApiCall().showToast("Please Select Country");
                                }else{
                                  if(whatsapp.trim().contains('+')){
                                    ApiCall().showToast("Please Remove Country Code from your number");
                                  }else{
                                    if(dialcode.contains('+')){
                                    }else{
                                      dialcode = '+' + dialcode;
                                    }
                                    Map body = {
                                      // name,email,phone_number,password
                                      'whatsapp_prefix' : dialcode,
                                      'whatsapp': whatsapp.trim(),
                                      'facebook': facebook.trim(),
                                      'instagram': instagram.trim(),
                                      'youtube': youtube.trim(),
                                      'website_url': website.trim(),
                                      'id': userId,
                                      'token': userToken
                                    };

                                    FocusScope.of(context).requestFocus(FocusNode());
                                    // ApiCall()
                                    //     .execute("update-social-media", body,
                                    //     multipartRequest: null)
                                    //     .then((value)
                                        ApiCall()
                                        .execute("v2/vendor/update-social-media", body,
                                        multipartRequest: null)
                                        .then((value)
                                    {
                                      Fluttertoast.showToast(
                                          msg: "Social Media Updated successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: colorPrimary,
                                          textColor: Colors.white,
                                          fontSize: 15.0);
                                      // ApiCall().showToast(
                                      //     'Social Media Updated successfully');
                                      setState(() {});
                                    });
                                  }
                                }
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: EdgeInsets.only(bottom: 5),
                            height: 35,
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.system_update_tv,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                Text('Update',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10,bottom: 5),
                            alignment: Alignment.topCenter,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 50,
                                  width: 100,
                                  padding: EdgeInsets.only(top: 8,left: 8,right: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)
                                  ),
                                  child: getCountry(),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width-145,
                                  child: whatsappField,
                                ),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              alignment: Alignment.topCenter,
                              child:
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    width: halfMediaWidth,
                                    child: instagramField,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topCenter,
                                    width: halfMediaWidth,
                                    child: facebookField,
                                  ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topCenter,
                                    width: halfMediaWidth,
                                    child: youtubeFiled,
                                  ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: websiteField,
                          )
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.only(left:10,right: 10),
              child: Column(
                children: [
                  Padding(
                    padding: _padding,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Delivery Information',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return (InkWell(
                              onTap: () async {
                                if (_formKey2.currentState.validate()) {
                                  _formKey2.currentState.save();
                                  // } else {
                                  Map body = {
                                    // name,email,phone_number,password
                                    'free_delivery_radius':
                                        deliveryRadius.trim(),
                                    'min_delivery_charge':
                                        deliveryCharge.trim(),
                                    'free_delivery_amount':
                                        deliveryAmount.trim(),
                                    'store_time': storeTime.trim(),
                                    'id': userId,
                                    'token': userToken
                                  };

                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  ApiCall()
                                      .execute("update-delivery-info", body)
                                      .then((value) {
                                    setState(() {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Delivery Information Updated successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: colorPrimary,
                                          textColor: Colors.white,
                                          fontSize: 15.0);
                                    });
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: EdgeInsets.only(bottom: 5),
                                height: 35,
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.system_update_tv,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    Text('Update',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ));
                          })
                        ]),
                  ),
                  new Form(
                      key: _formKey2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    width: halfMediaWidth,
                                    child: deliveryRadiusField,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topCenter,
                                    width: halfMediaWidth,
                                    child: deliveryChargeField,
                                  ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    width: halfMediaWidth,
                                    child: deliveryAmountField,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.topCenter,
                                    width: halfMediaWidth,
                                    child: InkWell(
                                        onTap: () {
                                          TimeRangePicker.show(
                                            context: context,
                                            onSubmitted:
                                                (TimeRangeValue value) {
                                              print(
                                                  "${value.startTime} - ${value.endTime}");
                                              // _textController8 = ("${value.startTime} - ${value.endTime}") as TextEditingController;
                                              _textController8.text =
                                                  "${value.startTime.format(context)} - ${value.endTime.format(context)}";
                                            },
                                          );
                                        },
                                        child: storeTImeField),
                                  ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ))
                ],
              ),
            ),

            SizedBox(
              height: 30,
            ),
         
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              _handleMoreOptionClick(value);
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              var list = List<PopupMenuEntry<String>>();
              list.add(
                PopupMenuItem<String>(
                  height: 15,
                  child: Text(
                    "Logout",
                    // style: TextStyle(color: TEXT_BLACK),
                  ),
                  value: 'vendorlogout',
                ),
              );
              return list;
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: colorPrimary,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        child: FutureBuilder<ProfileResponse>(
          future: ApiCall().execute<ProfileResponse, Null>('profile', null),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              profileResponse = snapshot.data;
              return getContent();
            } else if (snapshot.hasError) {
              return
                  // enableData();
                  errorScreen('Error: ${snapshot.error}');
            } else {
              return progressBar;
            }
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
      ),
    );
  }

  Future<void> storeClose() async {
    Map body = {
      'is_closed': "1",
      // LATITUDE:_location.latitude,
      // LONGITUDE:_location.longitude
    };
    ApiCall()
        .execute<StoreOpenCloseResponse, Null>('store-open-close', body)
        .then((StoreOpenCloseResponse result) {
      // _updateNotifier.isProgressShown = true;
      if (result.success == null) {
        if (result.message != null) ApiCall().showToast(result.message);
      }
      ApiCall().showToast(result.message != null ? result.message : "");
      if (result.success == "1") {
        ApiCall().showToast(result.message);
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Profile()));
    });
  }

  Future<void> storeOpen() async {
    Map body = {
      'is_closed': "0",
      // LATITUDE:_location.latitude,
      // LONGITUDE:_location.longitude
    };
    ApiCall()
        .execute<StoreOpenCloseResponse, Null>('store-open-close', body)
        .then((StoreOpenCloseResponse result) {
      // _updateNotifier.isProgressShown = true;
      if (result.success == null) {
        if (result.message != null) ApiCall().showToast(result.message);
      }
      ApiCall().showToast(result.message != null ? result.message : "");
      if (result.success == "1") {
        ApiCall().showToast(result.message);
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Profile()));
    });
  }

  Widget _timePickerTheme(BuildContext context, Widget child) => Theme(
      data: Theme.of(context).copyWith(
        timePickerTheme: TimePickerTheme.of(context).copyWith(
          helpTextStyle: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      child: child);

  _showDialog(
      {ValueChanged<String> onValueChanged,
      String hint,
      RegExp regExp,
      TextInputType textInputType = TextInputType.emailAddress}) async {
    final myController = TextEditingController();
    await showDialog<String>(
      builder: (context) => _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(hint),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  controller: myController,
                  keyboardType: textInputType,
                  decoration:
                      new InputDecoration(labelText: hint, hintText: hint),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CLOSE'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('SUBMIT'),
                onPressed: () {
                  String value = myController.text?.trim() ?? '';
                  if (value.isEmpty ||
                      (regExp != null && !regExp.hasMatch(value))) {
                    ApiCall().showToast('Please enter a valid $hint');
                  } else {
                    onValueChanged(value);
                    Navigator.pop(context);
                  }
                })
          ],
        ),
      ),
      context: context,
    );
  }

  Widget _popupBody() {
    return Container(
        child: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                TextFormField(
                  enabled: true,
                  // enabled: isEnabled,
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.left,
                  initialValue: presetText,
                  controller: _textController10,
                  obscureText: false,

                  // onSaved: (value) {
                  //   email = value;
                  //   // _guaranteePeriod = value;
                  // },
                  // initialValue: _guaranteePeriod,
                  // style: style,
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'This field is required';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.alternate_email,
                      color: primaryIconColor,
                    ),
                    hintText: "Email",
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 40,
                      width: 70,
                      color: colorPrimary,
                      child: Center(
                          child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: MediaQuery.of(context).size.height * 0.4,
        left: 30,
        right: 30,
        bottom: MediaQuery.of(context).size.height * 0.38,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomInset: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  List<Countries> countries;
  String name = "Select Country";
  String countryId = " ";

  Countries dropdownValueCountries;
  // Countries getValue()
  // {
  //   for(int i=0;i<countries.length;i++)
  //   {
  //
  //     if(countries[i].id==countryId)
  //       return countries[i];
  //   }
  //   return countries[0];
  // }
  Widget getCountryData(){
    return profileResponse.whatsapp_prefix=="+91"?Text('India',
      style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold),
    ):Text('Qatar',
      style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold),
    );
  }
  Widget getCountry(){
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {

          return DropdownButton<Countries>(
            isExpanded: true,
            dropdownColor: Colors.white,
            focusColor:Colors.black,
            value:dropdownValueCountries,
            isDense: true,
            underline: Container(color: Colors.transparent),
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor:colorPrimary,
            items: countries.map<DropdownMenuItem<Countries>>((Countries value) {
              return DropdownMenuItem<Countries>(
                value: value,
                child: Text(value.name.toString(),style:TextStyle(color:colorPrimary),overflow: TextOverflow.visible),
              );
            }).toList(),

            hint:profileResponse.whatsapp_prefix=="null"?Text("Select Country",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),overflow: TextOverflow.visible,
            ):getCountryData(),
            onChanged: (Countries data) {
              //_chosenValue = value;

              setState(() {
                // name=value.name;
                dropdownValueCountries = data;
                name=data.dialCode.toString();
                dialcode=data.dialCode.toString();
                countryId = data.id.toString();
                // _chosenValue = data;
                // updateOrderstatus(widget.orderItems.item.id,value.statusId.toString());

              });

            },

          );

        }
    );
  }

}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

Future<UserData> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user') == null ? "" : prefs.getString('user');
  if (user == null || user.trim().isEmpty) {
    return null;
  }
  return UserData.fromJson(json.decode(user == null ? "" : user));
}

class Data {
  UserData user;

  Data(this.user);
}

class ProfileData {
  GetUsers user;

  ProfileData(this.user);
}

final String WHATSAPP = "Whatsapp";
final String FACEBOOK = "Facebook";
final String INSTAGRAM = "Instagram";
final String YOUTUBE = "Youtube";
final String WEBSITE = "Website URL";
final String DELIVERYRADIUS = "free_delivery_radius";
final String DELIVERYCHARGE = "min_delivery_charge";
final String DELIVERYAMOUNT = "free_delivery_amount";
final String STORETIME = "store_time";
final String LOGO_URL =
    "https://xshop.qa/images/store/thumbnail/";
// final String LOGO_URL = "https://xshop.qa/images/registration/logo/thumbnail/";
final String BANNER_URL =
    "https://xshop.qa/images/store/banner/thumbnail/";

class VenderSocailMedia {
  String name;
  String link;
  VenderSocailMedia({this.name, this.link});
}

class VenderDeliveryInfo {
  String key;
  String value;
  VenderDeliveryInfo({this.key, this.value});
}

class GetUsers {
  String success;
  String joined;
  String storename;
  String orders;
  String message;
  String phone_number;
  String mobile_verified;
  String email;
  String email_verified;
  String latitude;
  String longtitude;
  String country;
  String location;
  String store_verified_status;
  List<VenderSocailMedia> venderSocailMedias = new List();
  List<VenderDeliveryInfo> venderDeliveryInfos = new List();
  String image = "";
  String banner = "";
  GetUsers({
    this.success,
    this.storename,
    this.joined,
    this.orders,
    this.message,
    this.phone_number,
    this.mobile_verified,
    this.email,
    this.email_verified,
    this.latitude,
    this.longtitude,
    this.country,
    this.location,
    this.store_verified_status,
  });
  void setVenderSocialMedia(var vendersocial) {
    String venderName = vendersocial['name'];
    String venderLink = vendersocial['link'];
    VenderSocailMedia vender =
        new VenderSocailMedia(name: venderName, link: venderLink);
    venderSocailMedias.add(vender);
  }

  void setImage(String image) {
    this.image = image;
  }

  String getImage() {
    return LOGO_URL + image;
  }

  void setBanner(String banner) {
    this.banner = banner;
  }

  String getBanner() {
    return BANNER_URL + banner;
  }

  void setVederDeliveryInfo(var venderdelivery) {
    String venderKey = venderdelivery['key'];
    String venderValue = venderdelivery['value'];
    VenderDeliveryInfo vender2 =
        new VenderDeliveryInfo(key: venderKey, value: venderValue);
    venderDeliveryInfos.add(vender2);
  }

  String getLink(String name_) {
    String link = "";
    for (int i = 0; i < venderSocailMedias.length; i++) {
      VenderSocailMedia media = venderSocailMedias[i];
      if (media.name == name_) {
        return media.link;
      }
    }
    return link;
  }

  String getValue(String key_) {
    String value = "";
    for (int i = 0; i < venderDeliveryInfos.length; i++) {
      VenderDeliveryInfo media = venderDeliveryInfos[i];
      if (media.key == key_) {
        return media.value;
      }
    }
    return value;
  }

  factory GetUsers.fromJson(Map<String, dynamic> json) {
    return GetUsers(
      success: json['success'],
      joined: json['joined'],
      storename: json['storename'],
      orders: json['orders'],
      message: json['message'],
      phone_number: json['phone_number'],
      mobile_verified: json['mobile_verified'],
      email: json['email'],
      email_verified: json['email_verified'],
      latitude: json['latitude'],
      longtitude: json['longtitude'],
      country: json['country'],
      location: json['location'],
      store_verified_status: json['store_verified_status'],
    );
  }
}

class MyImagePicker extends StatefulWidget {
  MyImagePicker({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

Future<Social> createAlbum(String title) async {
  final http.Response response = await http.post(
    // Uri.parse('https://xshop.qa/update-social-media'),
    Uri.parse('https://xshop.qa/v2/vendor/update-social-media'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'whatsapp': " ",
      'facebook': " ",
      'instagram': " ",
      'youtube': " ",
      'website_url': " ",
      'id': userId,
      'token': userToken
    }),
  );

  if (response.statusCode == 200) {
    return Social.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Social {
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String youtube;
  final String website_url;

  Social(
      {this.facebook,
      this.whatsapp,
      this.instagram,
      this.website_url,
      this.youtube});

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      facebook: json['facebook'],
      whatsapp: json['whatsapp'],
      instagram: json['instagram'],
      website_url: json['website_url'],
      youtube: json['youtube'],
    );
  }
}

Future<Delivery> createDelivery(String title) async {
  final http.Response response = await http.post(
    Uri.parse('https://xshop.qa/update-delivery-info'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'free_delivery_radius': " ",
      'min_delivery_charge': " ",
      'free_delivery_amount': " ",
      'store_time': " ",
      'id': userId,
      'token': userToken
    }),
  );

  if (response.statusCode == 200) {
    return Delivery.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Delivery {
  final String free_delivery_radius;
  final String min_delivery_charge;
  final String free_delivery_amount;
  final String store_time;

  Delivery({
    this.min_delivery_charge,
    this.free_delivery_radius,
    this.free_delivery_amount,
    this.store_time,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      min_delivery_charge: json['min_delivery_charge'],
      free_delivery_radius: json['free_delivery_radius'],
      free_delivery_amount: json['free_delivery_amount'],
      store_time: json['store_time'],
    );
  }
}

Future<EditProfile> createEditProfile(String title) async {
  final http.Response response = await http.post(
    Uri.parse('https://xshop.qa/api/update-profile '),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': " ",
      'phone_number': " ",
      'country': " ",
      'id': userId,
      'token': userToken
    }),
  );

  if (response.statusCode == 200) {
    return EditProfile.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class EditProfile {
  int success;
  String message;
  // List<Reasons> reasons;
  EditProfile.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
  }
}