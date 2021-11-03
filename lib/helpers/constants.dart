import 'dart:ui';

import 'package:flutter/material.dart';

const SUCCESS_MESSAGE = "You will be contacted by us very soon.";
const APP_TAG = "DRIVER_APP";


// Api related
// const String BASE_URL = "https://xshop.qa/";
// const String BASE_URL = "https://xshop.qa/";
// const String BASE_URL = "https://xshop.qa/";
// const String BASE_URL = "https://xshop.qa/";
const String BASE_URL = "https://xshop.qa/";
const Color colorPrimary = Color(0xFF008872);
const Color gradientEnd = Color(0xFF008872);
const Color primaryTextColor = Color(0xFF008872);
const Color primaryIconColor = Color(0xFF008872);
const Color gradientStartColor = Color(0xFF7fefba);
const Color gradientEndColor = Color(0xFF92cddf);
const double register_icon_size=16.0;
const double field_text_size=10.0;
const Color textColor = Color(0xFF616161);
const Color textColorSecondary = Color(0xFF999999);
const APIKeys = "AIzaSyC6FXxQ6oMlmp8e-uQz2sIth9wJz0c2Od8";

const String productThumbUrl = '${BASE_URL}images/product/thumbnail/';
const String offerThumbUrl='${BASE_URL}images/store/offer/banner/';
const padding = 10.0;
const contryCode = 91;
String deviceToken = "";
String currency = "";

// public static final String PRODUCT_URL = MAIN_URL + "images/product/";
// public static final String BANNER_URL = MAIN_URL + "images/banner/";

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
Widget enableData(){
  return
    Container(
    child: Center(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
    IconButton(icon: new Image.asset('assets/icons/nosignal.png'),iconSize: 50,
    ),
        Text("Check Internet Connectivity",style: TextStyle(color: colorPrimary,fontSize: 20),),
        // Padding(
        //   padding: const EdgeInsets.only(top: 5),
        //   child: Text("Swipe Down to Refresh the Screen",style: TextStyle(color:Colors.grey[500],fontSize: 10),),
        // ),
      ],
    )),
  );
}
Widget getAppBar(String title,assetImage,BuildContext context){
  return AppBar(
      backgroundColor: colorPrimary,
      title: Text(title,style: TextStyle(color: Colors.white)),
      // automaticallyImplyLeading: true,
      elevation: 0,
      leading: InkWell(
        onTap: (){
          Navigator.pop(context,true);
        },
        child: Container(
          padding: EdgeInsets.all(15),

          child: Icon(Icons.arrow_back)),
      ),
      // automaticallyImplyLeading: true,
      // actions:[
      //   InkWell(
      //     onTap: (){
      //       if(assetImage=="assets/images/search2.png")
      //         NextPage(context, SearchProductScreen());
      //     },
      //     child: assetImage!=""?Container(
      //       margin: EdgeInsets.only(right: right),
      //       child: ImageIcon(
      //         AssetImage(assetImage),
      //         color: white,
      //         size: 20,
      //       ),
      //     ):Container(),
      //   ),
      // ]
  );
}


Widget getEmptyProductContainer()
{
  return Text("Your Xshop Product List is empty");
}

Widget getEmptyContainerWithTitleAndImage(BuildContext context,String title,String image)
{
  double imageWidth=160;
  double imageHeight=(imageWidth*587)/641;
  double buttonHeight=65;
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration:getContentBox,
    margin: EdgeInsets.only(top:15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: imageWidth,
            height:imageHeight ,
            margin: EdgeInsets.only(bottom: 20),
            child: Image(image:AssetImage(image),
              width: imageWidth,
              height:imageHeight ,
              fit: BoxFit.fitWidth,
            )
        ),
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Center(child: Text(title,style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: 'opensans_bold',letterSpacing: 0.5),)),
        ),
        Container(
          height:buttonHeight ,
          color: Colors.white,
          padding: EdgeInsets.only(bottom: 10,right: 10,left: 10),
          child: InkWell(
            onTap: (){
              // NextPage(context, DashBoard(initialIndex: 2,));
            },
            child: Container(
              padding: EdgeInsets.only(top: 13,bottom: 13),
              margin: EdgeInsets.only(left:20,right: 20,top:10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red
              ),
              child: Center(child: Text('CONTINUE SHOPPING ',style: TextStyle(color: Colors.white,fontSize: 14,fontFamily: 'opensans_bold',letterSpacing: 0.5),)),
            ),
          ),
        )
      ],
    ),
  );
}

BoxDecoration getContentBox = BoxDecoration(
    color: Colors.white);

Widget errorScreen(String errorTitle) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(errorTitle),
          )
        ],
      ),
    );
Widget progressBar = InkWell(
  child: SafeArea(
    child: Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
    ),
  ),
);
String getMonth(String num)
{
  switch(num)
  {

    case "1":
      return "January";
      break;
    case "2":
      return "February";
      break;
    case "3":
      return "March";
      break;
    case "4":
      return "April";
      break;
    case "5":
      return "May";
      break;
    case "6":
      return "June";
      break;
    case "7":
      return "July";
      break;
    case "8":
      return "August";
      break;
    case "9":
      return "September";
      break;
    case "10":
      return "October";
      break;
    case "11":
      return "November";
      break;
    case "12":
      return "December";
      break;
    default:
      return "January";
      break;
  }
}
String getConvertedDateAndTime(String data)
{
  String eventDate="1";
  String month="January";
  String year="0000";
  String time="00.00 AM";
  try{
    DateTime date = DateTime.parse(data);
    eventDate=date.day.toString();
    month=getMonth(date.month.toString());
    year=date.year==-1?"0000":date.year.toString();
    int _minute=date.minute;
    int _hour=date.hour;
    time=_hour.toString()+": "+_minute.toString();
  }
  catch(Exception)
  {

  }
  return eventDate+"-"+month+"-"+year+"\n"+time;
}
String getConvertedDate(String data)
{
  String eventDate="1";
  String month="January";
  String year="0000";
  try{
    DateTime date = DateTime.parse(data);
    eventDate=date.day.toString();
    month=getMonth(date.month.toString());
    year=date.year==-1?"0000":date.year.toString();
  }
  catch(Exception)
  {

  }
  return eventDate+" "+month+" "+year;
}