import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/screens/register/resetpassword.dart';
import 'package:vendor_app/screens/register/resetpasswordresponse.dart';

import '../CountryListRespose.dart';


class ForgotPasswordScreen extends StatefulWidget {
  String title;

  ForgotPasswordScreen(String title)
  {
    this.title=title;
  }
  @override
  _ForgotPasswordScreenState createState() => new _ForgotPasswordScreenState(title: title);
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String title;
  Countries _chosenValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _ForgotPasswordScreenState({ this.title}) ;

  Widget getForms_forgot(){
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 5,left: 25,right: 25,bottom: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 35),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: 65,
                            child: getCountry()
                        ),
                        Container(

                            width: MediaQuery.of(context).size.width - 120,
                            child: emailField),
                      ],
                    ),
                  )
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
  Widget getButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
      child: Container(
        width: double.infinity,
        height: 40,
        child: RaisedButton(
            color: colorPrimary,
            elevation: 0,
            child: Text('Submit',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

              }


              Map body={
                "email":email,
                "country":countryId.toString()
              };
              FocusScope.of(context).requestFocus(FocusNode());

              var response = await ApiCall()
                  .execute<ResetPasswordResponse, Null>("vendor-send-reset-password-code", body);

              if (response!= null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ResetPasswordScreen(email:email,)));
              }
            }

        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        centerTitle: false,
        automaticallyImplyLeading: true,
        title:  Text('Forgot Password',style:TextStyle(fontSize:15,color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body:FutureBuilder<CountryList>(
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
Widget getContent(){
    return Container(
      child: Column(
          children: [
            getPersonalInfo(),
            getButton(context)
          ],
      ),
    );
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
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor:colorPrimary,
            items: countries.map<DropdownMenuItem<Countries>>((Countries value) {
              return DropdownMenuItem<Countries>(
                value: value,
                child: Text(value.name,style:TextStyle(color:colorPrimary),),
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
  Container getPersonalInfo()
  {
    return Container(
      child: Container(width: double.infinity,
        child: Column(

          children: [
            getForms_forgot(),


          ],
        ),

      ),
    );
    //return Container(child: Column(children: [Container(child:_listview(products,context,widget))],),);

  }

}
String email;
bool isLoading = false;
final emailField = TextFormField(
  cursorColor: colorPrimary,
  obscureText: false,
  // inputFormatters: [
  //   new WhitelistingTextInputFormatter(
  //       new RegExp(r'^[0-9]*$')),
  //   new LengthLimitingTextInputFormatter(10)
  // ],
  onChanged: (value) {
    email = value;
  },
  // style: style,
  validator: (value) {
    if (value.trim().isEmpty) {
      return 'This field is required';
    } else {
      return value.length < 6 ? 'Enter a valid Mobile Number ' : null;
    }
  },
  keyboardType: TextInputType.number,
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(padding, 0.0, padding, 0.0),
    hintText: "Enter Registered Mobile Number", hintStyle: TextStyle(color: textColorSecondary),
    labelText: 'Mobile Number',
    // prefixText: "+974",
    labelStyle: TextStyle(fontSize: field_text_size, color: textColor),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[200]),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorPrimary),
    ),


    suffixIcon:  Icon(
      Icons.local_phone_outlined,
      color: primaryIconColor,
    ),

  ),

);

