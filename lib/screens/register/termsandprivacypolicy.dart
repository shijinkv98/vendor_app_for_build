import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

const Color white = const Color(0xFFFFFFFF);
const String SEMI_BOLD_FONT="semi_bold_font";
final TextStyle appBarTitle = TextStyle(fontWeight: FontWeight.w500,fontFamily: SEMI_BOLD_FONT,fontSize: 18,letterSpacing: 0.8,color: white);

class TermsAndPrivacyPolicyscreen extends StatefulWidget{
 bool terms;
  @override
  _TermsAndPrivacyPolicyscreenState createState() => new _TermsAndPrivacyPolicyscreenState(terms:this.terms);
 TermsAndPrivacyPolicyscreen({this.terms});
}

class _TermsAndPrivacyPolicyscreenState extends State<TermsAndPrivacyPolicyscreen> {

  bool terms;

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  WebViewController _webViewController;

  _TermsAndPrivacyPolicyscreenState({this.terms});

  @override
  void initState() {
    super.initState();
    // WebView.platform = SurfaceAndroidWebView();

  }
  @override
  Widget build(BuildContext context){
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return terms?getAppBar(context, "TERMS AND CONDITIONS",getBody()):getAppBar(context, "PRIVACY POLICY",getBody());
  }

  Widget getBody(){

    return WebView(
      initialUrl: terms?'${BASE_URL}en/seller-terms':'${BASE_URL}en/privacy-policy',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
        _controller.complete(webViewController);
      },
      onProgress: (int progress) {
        print("WebView is loading (progress : $progress%)");
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');

        // Removes header and footer from page
        _webViewController
            .evaluateJavascript("javascript:(function() { " +
            "var head = document.getElementsByTagName('header')[0];" +
            "head.parentNode.removeChild(head);" +
            "var footer = document.getElementsByTagName('footer')[0];" +
            "footer.parentNode.removeChild(footer);" +
            "})()")
            .then((value) => debugPrint('Page finished loading Javascript'))
            .catchError((onError) => debugPrint('$onError'));
      },
    );

  }

  Widget getAppBar(BuildContext context,String title,Widget body){
    return Scaffold(

      appBar: new PreferredSize(
        child:new Container(

          padding: new EdgeInsets.only(
              top: MediaQuery.of(context).padding.top
          ),
          color: colorPrimary,
          // decoration: new BoxDecoration(
          //   color: colorPrimary,
          //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60),bottomRight:Radius.circular(60) ),
          //   image: DecorationImage(
          //       image: AssetImage('assets/images/rectangle_33.png'),
          //       fit: BoxFit.cover),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap:(){
                  Navigator.pop(context);

                }         ,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Image.asset('assets/images/back_ios.png',width: 14,height: 23,),
                ),
              )      ,
              Center(child: Text(title,style: appBarTitle,)),
              Container(padding: EdgeInsets.only(right: 30),)
            ],
          ),
        ),

        preferredSize: new Size(
            MediaQuery.of(context).size.width,
            80.0
        ),
      ),
      body: body,

      backgroundColor: white,
    );
  }


}