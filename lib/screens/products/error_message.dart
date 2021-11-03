import 'package:flutter/material.dart';
import 'package:vendor_app/helpers/constants.dart';

class ErrorMessage extends StatelessWidget {
  final String title;
  final  String message;
  final String buttonTitle;
  final Function onButtonPressed;

  ErrorMessage({
    this.title,
    this.message,
    this.buttonTitle,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$title',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.w700,
            height: 1.444,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          '$message',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w300,
            height: 1.25,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        onButtonPressed != null
            ? FlatButton(
            onPressed: onButtonPressed as void Function(),
            child: Text(
              '$buttonTitle',
              style: TextStyle(
                fontSize: 18,
                color: colorPrimary,
              ),
            ))
            : Container(),
      ],
    );
  }
}
