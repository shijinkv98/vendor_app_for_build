import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/screens/home/profile.dart';
import 'package:vendor_app/screens/register/signup_screen.dart';

class StoreSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SignUpScreen()));

        },
        child: const Text("OK"),
        backgroundColor: colorPrimary,
      ),

      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/bg_sucess.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 70,
                height: 70,
                child: Image.asset('assets/icons/sucess_ico.png')),
            Container(
              margin: EdgeInsets.only(top: 10,left: 15,right: 15),
              child: Text('Valued Seller, We have successfully received Your Request',style: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),

            ) ,
            Container(
              margin: EdgeInsets.only(top: 10,left: 15,right: 15),
              child: Text('Xshop Customer Care team will contact you soon, once your Seller Account is Activated.',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),textAlign: TextAlign.center,),

            ),
          ],
        )
      )
    );
  }
}