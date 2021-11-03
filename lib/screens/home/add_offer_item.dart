import 'dart:io';
import 'dart:convert' show json;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/custom/fdottedline.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/helpers/mime_type.dart';

import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/model/file_model.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/notifiers/product_notifier.dart';
import 'package:vendor_app/screens/home/ad_manager.dart';
import 'package:vendor_app/screens/home/dashboard.dart';
import 'package:vendor_app/screens/home/home.dart';
import 'package:intl/intl.dart';

class OfferAdd extends StatefulWidget {
  OfferAdd({this.slNumber=1});
  int slNumber=1;
  @override
  _OfferAddState createState() => _OfferAddState(slNumber: slNumber);
}
class _OfferAddState extends State<OfferAdd> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  int slNumber=1;
  _OfferAddState({this.slNumber});
  final List<FileModel> _images = List();
  Future<bool> _onBackPressed(BuildContext context,Widget widget) {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: Row(
          children: [
            new Text('Are you sure'),SizedBox(width: 5,),Text('?',style: TextStyle(color: Colors.red),),
          ],
        ),
        content: new Text('Upload Your Banner Here'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Ok"),
          ),

        ],
      ),
    ) ??
        false;
  }

  ImageAddedNotifier _imageAddedNotifier;
  AddProductLoadingNotifier _loadingNotifier;

  File imageFile;

  @override
  void initState() {
    super.initState();
    _images.add(null);
    _imageAddedNotifier =
        Provider.of<ImageAddedNotifier>(context, listen: false);
    _loadingNotifier =
        Provider.of<AddProductLoadingNotifier>(context, listen: false);
  }
  String aboutOffer="";
  String startDate="";
  String endDate="";
  DateTime selectedStartDate=DateTime.now();
  TextEditingController _startDateController = TextEditingController();
  Future<Null> _selectStartDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedStartDate = picked;
        String year=picked.year.toString();
        int _month=picked.month;
        String month=_month<10?"0"+_month.toString():_month.toString();
        int _day=picked.day;
        String day=_day<10?"0"+_day.toString():_day.toString();
        String date=year+"-"+month+"-"+day;
        _startDateController.text = date.toString();
      });
  }
  DateTime selectedEndDate=DateTime.now();
  TextEditingController _endDateController = TextEditingController();
  Future<Null> _selectEndDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: selectedStartDate,
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedEndDate = picked;
        String year=picked.year.toString();
        int _month=picked.month;
        String month=_month<10?"0"+_month.toString():_month.toString();
        int _day=picked.day;
        String day=_day<10?"0"+_day.toString():_day.toString();
        String date=year+"-"+month+"-"+day;
        _endDateController.text = date.toString();
      });
  }
  TimeOfDay startTime=TimeOfDay.now();
  TextEditingController _startTimeController = TextEditingController();
  Future<Null> _selectStartTime() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null)
      setState(() {
        startTime = picked;
       int  _hour = startTime.hour;
        int _minute = startTime.minute;
        String hour=_hour<10?"0"+_hour.toString():_hour.toString();
        String minute=_minute<10?"0"+_minute.toString():_minute.toString();
        String _time = hour + ':' + minute+":"+"00";
        _startTimeController.text = _time;
      });
  }
  TextEditingController _endTimeController = TextEditingController();
  TimeOfDay endTime=TimeOfDay.now();
  Future<Null> _selectEndTime() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null)
      setState(() {
        endTime = picked;
        int  _hour = endTime.hour;
        int _minute = endTime.minute;
        String hour=_hour<10?"0"+_hour.toString():_hour.toString();
        String minute=_minute<10?"0"+_minute.toString():_minute.toString();
        String _time = hour + ':' + minute+":"+"00";
        _endTimeController.text = _time;
      });
  }
  Widget  aboutOfferField()
  {
    return TextFormField(
      obscureText: false,
      // controller: emailController,
      onSaved: (value) {
        aboutOffer = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      maxLength: 60,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Say something about the offer",
        // prefixText: '+974 ',
        prefixStyle: TextStyle(color: Colors.grey),
        enabledBorder:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)),
        border:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)) ,
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color:colorPrimary,width:1)),
      ),
    );
  }

  Widget  startDateField()
  {

    return TextFormField(
      obscureText: false,
      // controller: emailController,
      onSaved: (value) {
        startDate = value;
      },
      style: style,
      readOnly: true,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      onTap: (){
        _selectStartDate();
      },
      controller: _startDateController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Offer starts from",
        // prefixText: '+974 ',
        prefixStyle: TextStyle(color: Colors.grey),
        suffixIconConstraints: BoxConstraints(
            minHeight: 20,
            minWidth: 20
        ),
        suffixIcon: InkWell(
          onTap: (){
            _selectStartDate();
          },
          child: new Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.only(right: 10),
            child: Image(
              image: AssetImage(
                  "assets/icons/date.png"
              ),
              height: 20,
              width: 20,
            ),
          ),
        ),
        enabledBorder:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)),
        border:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)) ,
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color:colorPrimary,width:1)),
      ),
    );
  }
  String _startTime,_endTime;
  Widget  startTimeField()
  {
    return TextFormField(
      obscureText: false,
      // controller: emailController,
      onSaved: (value) {
        _startTime = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      onTap: (){
        _selectStartTime();
      },
      controller: _startTimeController,
      readOnly: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Offer starts on",
        // prefixText: '+974 ',
        suffixIconConstraints: BoxConstraints(
            minHeight: 20,
            minWidth: 20
        ),
        suffixIcon: new Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.only(right: 10),
          child: Image(
            image: AssetImage(
                "assets/icons/time.png"
            ),
            height: 20,
            width: 20,
          ),
        ),
        prefixStyle: TextStyle(color: Colors.grey),
        enabledBorder:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)),
        border:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)) ,
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color:colorPrimary,width:1)),
      ),
    );
  }
  Widget  endDateField()
  {
    return TextFormField(
      obscureText: false,
      // controller: emailController,
      onSaved: (value) {
        endDate = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      onTap: (){
        _selectEndDate();
      },
      controller: _endDateController,
      readOnly: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Offer ends on",
        // prefixText: '+974 ',
        suffixIconConstraints: BoxConstraints(
            minHeight: 20,
            minWidth: 20
        ),
        suffixIcon: new Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.only(right: 10),
          child: Image(
            image: AssetImage(
                "assets/icons/date.png"
            ),
            height: 20,
            width: 20,
          ),
        ),
        prefixStyle: TextStyle(color: Colors.grey),
        enabledBorder:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)),
        border:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)) ,
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color:colorPrimary,width:1)),
      ),
    );
  }
  Widget  endTimeField()
  {
    return TextFormField(
      obscureText: false,
      // controller: emailController,
      onSaved: (value) {
        _endTime = value;
      },
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      onTap: (){
        _selectEndTime();
      },
      controller: _endTimeController,
      readOnly: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Offer ends on",
        // prefixText: '+974 ',
          suffixIconConstraints: BoxConstraints(
              minHeight: 20,
              minWidth: 20
          ),
          suffixIcon: new Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.only(right: 10),
            child: Image(
              image: AssetImage(
                  "assets/icons/time.png"
              ),
              height: 20,
              width: 20,
            ),
          ),
        prefixStyle: TextStyle(color: Colors.grey),
        enabledBorder:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)),
        border:OutlineInputBorder(
            borderSide: new BorderSide(color:Colors.grey,width: 1)) ,
        focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color:colorPrimary,width:1)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final submitButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: colorPrimary,
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 10.0),
        onPressed: () async {
          // Navigator.of(context).pushReplacementNamed('/home');

          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            var request = ApiCall().getMultipartRequest('vendor/offerbanners/add');

            _images.forEach((element) {
              if (element != null) {
                request.files.add(http.MultipartFile.fromBytes(
                    'image',
                    // File(element.imageStr).readAsBytesSync(),
                    element.imageU8L,
                    filename: element.name ?? 'image.jpg',
                    contentType: MimeTypes.getContentType(element)));
              }
              String timeStart=startDate+" "+_startTime;
              String timeEnd=endDate+" "+_endTime;
              request.fields["description"]=aboutOffer;
              request.fields["start_time"]=timeStart;
              request.fields["end_time"]=timeEnd;
            });

            // _loadingNotifier.isLoading = true;
            ApiCall()
                .execute(
                'vendor/offerbanners/add', null,
                multipartRequest: request)
                .then((value) {

            //  _loadingNotifier.isLoading = false;
              ApiCall().showToast("Successfully updated");
              Navigator.pop(context);
            });
          }
        },
        child: Text("Save",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
    List<Widget> specifications = [];
    return  Scaffold(
      appBar: AppBar(
    title: Text( 'Add Offers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
       automaticallyImplyLeading: false,
    backgroundColor: colorPrimary,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },

        );
      },
    ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text( 'Offer serial number :', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 14),),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                                child: Text( slNumber.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 12),)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        aboutOfferField(),
                        SizedBox(height: 10,),
                        Text(
                          "Promotion Banners",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ]..addAll(specifications)..addAll([
                        Consumer<ImageAddedNotifier>(
                          builder: (context, value, child) =>
                              GridView.count(
                                crossAxisCount: 1,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(2.0),
                                primary: false,
                                childAspectRatio: 0.95,
                                children: _gridTile(),
                                mainAxisSpacing: 1.0,
                                crossAxisSpacing: 5.0,
                              ),
                        ),
                        Text(
                          'Image resolution 320x320',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 10,),
                        Text( 'Offer Starts From', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 14),),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width:(MediaQuery.of(context).size.width-60)/2,
                                child: startDateField()),
                            Container(
                                width:(MediaQuery.of(context).size.width-60)/2,
                                child: startTimeField()),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text( 'Offer Ends On', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 14),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width:(MediaQuery.of(context).size.width-60)/2,
                                child: endDateField()),
                            Container(
                                width:(MediaQuery.of(context).size.width-60)/2,
                                child: endTimeField()),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        submitButon,
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
              Consumer<AddProductLoadingNotifier>(
                builder: (context, value, child) {
                  return value.isLoading ? progressBar : SizedBox();
                },
              )
            ],
          )

      // }),
    );
  }

  List<GridTile> _gridTile() {
    return _images
        .asMap()
        .map((key, element) =>
        MapEntry(key, GridTile(child: addImage(key, element))))
        .values
        .cast<GridTile>()
        .toList();
  }

  Widget addImage(int index, FileModel imageModel) =>
      FDottedLine(
        color: colorPrimary,
        strokeWidth: 2.0,
        dottedLength: 4.0,
        space: 3.0,
        corner: FDottedLineCorner.all(3.0),
        child: InkWell(
          onTap: () {
            _showAlertDialog(context, index, imageModel);
          },
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width-40,
              height: MediaQuery.of(context).size.width-40,
              alignment: Alignment.center,
              child: getGridChild(index, imageModel)),
        ),
      );

  Widget getGridChild(int index, FileModel imageModel) {
    if (imageModel == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 30,
            color: primaryTextColor,
          ),
          Text(
            'Upload Image',
            style: TextStyle(fontSize: 12, color: primaryTextColor),
          ),
        ],
      );
    } else if (imageModel.imageU8L != null && imageModel.imageU8L.length > 0) {
      return Image.memory(imageModel.imageU8L);
    } else if (imageModel.imageStr != null &&
        imageModel.imageStr
            .trim()
            .isNotEmpty &&
        imageModel.isNetwork) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/images/no_image.png',
        image: imageModel.imageStr,
      );
    } else {
      return Image.file(File(imageModel.imageStr));
    }
  }




// replace this function with the examples above
  _showAlertDialog(BuildContext context, int index, FileModel imageModel) {
    // set up the list options
    Widget optionOne = SimpleDialogOption(
      child: const Text('Take image with camera'),
      onPressed: () {
        _getFromCamera(); // ImagePicker()


        Navigator.of(context).pop();
      },
    );

    Widget optionTwo = SimpleDialogOption(
      child: const Text('Upload image from gallery'),
      onPressed: () {
        _getFromGallery();


        Navigator.of(context).pop();
      },
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Upload Image'),
          children: <Widget>[
            optionOne,
            optionTwo,
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _loadingNotifier.reset();
    super.dispose();
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
      aspectRatio:CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
      ]
          : [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop offer Image',
          toolbarColor: colorPrimary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          statusBarColor: colorPrimary,
          activeControlsWidgetColor: colorPrimary,
          backgroundColor:Colors.white ,
          lockAspectRatio: true),
    );
    if (croppedImage != null) {
      imageFile = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();

      // _images.insert(0,
      //     FileModel(imageU8L: bytes, fileName: filePath));
      _images[0]=FileModel(imageU8L: bytes, fileName: filePath);
      _imageAddedNotifier.imageAdded();
      setState(() {
        // debugPrint('MJM ImagePicker gallery $value');
        // _images.add(
        //    FileModel(imageU8L: bytes, fileName: filePath));
        // _imageAddedNotifier.imageAdded();
      });

      // });
    }
  }

  void _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
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
      aspectRatio:CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
      ]
          : [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop offer Image',
          toolbarColor: colorPrimary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          statusBarColor: colorPrimary,
          activeControlsWidgetColor: colorPrimary,
          backgroundColor:Colors.white ,
          lockAspectRatio: true),
    );
    if (croppedImage != null) {
      imageFile = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();
      _images[0]=FileModel(imageU8L: bytes, fileName: filePath);
      // _images.insert(
      //     0, FileModel(imageU8L: bytes, fileName: filePath));
      _imageAddedNotifier.imageAdded();
      setState(() {
        // debugPrint('MJM ImagePicker gallery $value');

      });

      // });
    }
  }
}

class _DropdownModel {
  final String id, title;
  _DropdownModel(this.id, this.title);
}

class _DropdownField extends StatelessWidget {
  _DropdownModel value;
  List<_DropdownModel> list;
  ValueChanged<_DropdownModel> onChanged;
  String hintText;
  String labelText;
  bool isMandatory = true;

  _DropdownField(
      {this.value,
        this.list,
        this.onChanged,
        this.hintText,
        this.labelText,
        this.isMandatory = true}) {
    if (list == null) {
      list = List();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value?.id,
      isExpanded: true,
      isDense: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: hintText,
        labelText: labelText,
      ),
      onChanged: (String newValue) {
        if ((value == null || newValue != value.id) && onChanged != null) {
          onChanged(list.firstWhere((element) => element.id == newValue));
        }
      },
      validator: (value) {
        if (isMandatory && value == null) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      items: list.map((_DropdownModel value) {
        return DropdownMenuItem<String>(
          value: value.id,
          child: Text(value.title),
        );
      }).toList(),
    );
  }
}
Future<void> showDialogueBox(BuildContext context,Widget widget)
{
  return showDialog(context: context,
      builder: (ctx) => AlertDialog(
        title: Text("ALERT !!",style: TextStyle(color: Colors.red),),
        content: Text("Add your Banner here"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Ok"),
          ),

        ],
      ));
}
