import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/model/user.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:vendor_app/network/response/offerbannersresponse.dart';
import 'package:vendor_app/network/response/updateresponse.dart';
import 'package:vendor_app/notifiers/updatenotifier.dart';

import '../UploadImageDemo2.dart';
import 'add_offer_item.dart';
import 'home.dart';

class OfferManger extends StatefulWidget {
  @override
  _OfferMangerState createState() => _OfferMangerState();
}

int index_selected = 0;

class _OfferMangerState extends State<OfferManger>
    with TickerProviderStateMixin {
  final double _paddingTop = 8;
  final double _paddingStart = 20;
  OfferBannersResponse _offerBannersResponse;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    setState(() {});
    _updateNotifier = Provider.of<UpdateNotifier>(context, listen: false);
    // });
    // this.fetchUser();
  }

  UpdateNotifier _updateNotifier;

  TabController _tabController;
  TextStyle _tabTextStyle = TextStyle(
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Offer Manger')),
          backgroundColor: colorPrimary,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<OfferBannersResponse>(
          future: ApiCall()
              .execute<OfferBannersResponse, Null>("vendor/offerbanners", null),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _offerBannersResponse = snapshot.data;
              return getViews();
            } else if (snapshot.hasError) {
              return Container();
            } else {
              return progressBar;
            }
          },
        ));
  }

  Widget getViews() {
    return Consumer<UpdateNotifier>(
      builder: (context, value, child) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(children: [
                Container(
                    height: 40,
                    color: Colors.white,
                    child: TabBar(
                        controller: _tabController,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: primaryTextColor,
                        labelColor: primaryTextColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 1.0,
                        indicatorPadding: EdgeInsets.all(5),
                        tabs: [
                          Tab(
                            text: 'All offers',
                          ),
                          Tab(
                            text: 'Ongoing',
                          ),
                          Tab(
                            text: 'History',
                          ),
                        ])),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      allOfferList(_offerBannersResponse.data.allAds),
                      ongoingList(_offerBannersResponse.data.onGoing),
                      historyList(_offerBannersResponse.data.history),
                    ],
                  ),
                )
              ]),
            ),
            Align(
              alignment: Alignment.center,
              child: _updateNotifier.isProgressShown ? progressBar : SizedBox(),
            )
          ],
        );
      },
    );
  }

  void getOfferBannerResponse() {
    Map body = {};
    // name,email,phone_number,password
    _updateNotifier.isProgressShown = true;
    ApiCall()
        .execute<OfferBannersResponse, Null>("vendor/offerbanners", body)
        .then((OfferBannersResponse result) {
      _offerBannersResponse = result;
      _updateNotifier.isProgressShown = false;
    });
  }

  void deleteItem(String id) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
        title: Center(
            child:
            Column(
              children: [
                Text('ALERT!',
                    style: TextStyle(color: Colors.red, fontSize: 20)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            Container(
                                child: Text(
                                  'Delete Offer',
                                  style: TextStyle(color: Colors.black, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text('Are you sure you want delete offer?',
                                    style:
                                    TextStyle(color: Colors.grey[500], fontSize: 15)))
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            width: 80,
                            height: 40,
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 2, bottom: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: colorPrimary),
                            child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _updateNotifier.isProgressShown = true;
                            String link = "vendor/offerbanners/delete/" + id;
                            Map body = {};
                            ApiCall()
                                .execute<UpdateResponse, Null>(link, body)
                                .then((UpdateResponse result) {
                              _updateNotifier.isProgressShown = false;
                              ApiCall().showToast(result.message);
                              getOfferBannerResponse();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 15, bottom: 20),
                            width: 80,
                            height: 40,
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 2, bottom: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: colorPrimary),
                            child: Center(
                                child: Text(
                                  'YES',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )),
        // content: Text("See products pending for approval"),
        // actions: <Widget>[
        //
        // ],
      ),
    );
  }

  Widget allOfferList(List<Ads> allAds) {
    return Container(
      height: MediaQuery.of(context).size.height - 40,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Card(
                margin: const EdgeInsets.only(top: 5, bottom: 5.0),
                elevation: 3,
                color: const Color(0xFFFFFFFF),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Create new offer",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.play_circle_outline,
                            size: 30,
                            color: colorPrimary,
                          ),
                          onPressed: () {}),
                      SizedBox(width: 8),
                      SizedBox(
                        height: 25,
                        child: RaisedButton(
                            color: colorPrimary,
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            textColor: Colors.white,
                            child: Row(
                              children: const [
                                const Text(
                                  'Add ',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                const Icon(
                                  Icons.add,
                                  size: 15,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OfferAdd()),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
            Container(
              margin: const EdgeInsets.only(
                  top: 5, right: 10, left: 10, bottom: 5.0),
              child: ListView.builder(
                  itemCount: allAds.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return allProductItem(allAds[index]);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget allProductItem(Ads onGoing) {
    double imageWidth = 100, iconWidth = 32, activeWidth = 80;
    double width1 =
        MediaQuery.of(context).size.width - activeWidth - imageWidth - 70;
    double width2 =
        MediaQuery.of(context).size.width - iconWidth - imageWidth - 70;
    double width = width2 / 2;

    return Container(
      margin: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Color(0xFF9EC1CF)),
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/no_image.png',
            image: '$offerThumbUrl${onGoing.image}',
            width: 100,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width1,
                      child: Text(
                        onGoing.description,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Container(
                      width: activeWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: onGoing.status == "Completed"
                              ? Color(0xFF76C2FA)
                              : Colors.green),
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          onGoing.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: onGoing.status == "Completed"
                                ? Color(0XFF0D8973)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 2,
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width - imageWidth - 70,
                  margin: EdgeInsets.only(top: 10),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: width,
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              child: Text("Start",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              width: width,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                  getConvertedDateAndTime(onGoing.startTime),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              child: Text("End",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              width: width,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                getConvertedDateAndTime(onGoing.endTime),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteItem(onGoing.id.toString());
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Color(0xFF416B7C)),
                            width: iconWidth,
                            padding: EdgeInsets.all(5),
                            child: Image(
                              image: AssetImage('assets/icons/delete.png'),
                              width: iconWidth,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget ongoingItem(Ads onGoing) {
    double imageWidth = 100, iconWidth = 32, activeWidth = 80;
    double width1 =
        MediaQuery.of(context).size.width - activeWidth - imageWidth - 70;
    double width2 =
        MediaQuery.of(context).size.width - iconWidth - imageWidth - 70;
    double width = width2 / 2;

    return Container(
      margin: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Color(0xFF9EC1CF)),
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/no_image.png',
            image: '$offerThumbUrl${onGoing.image}',
            width: 100,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width1,
                      child: Text(
                        onGoing.description,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Container(
                      width: activeWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: onGoing.status == "Completed"
                              ? Color(0xFF76C2FA)
                              : Colors.green),
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          onGoing.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: onGoing.status == "Completed"
                                ? Color(0XFF0D8973)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 2,
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width - imageWidth - 70,
                  margin: EdgeInsets.only(top: 10),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: width,
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              child: Text("Start",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              width: width,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                  getConvertedDateAndTime(onGoing.startTime),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              child: Text("End",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              width: width,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                getConvertedDateAndTime(onGoing.endTime),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteItem(onGoing.id.toString());
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Color(0xFF416B7C)),
                            width: iconWidth,
                            padding: EdgeInsets.all(5),
                            child: Image(
                              image: AssetImage('assets/icons/delete.png'),
                              width: iconWidth,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget historyItem(Ads onGoing) {
    double imageWidth = 100, iconWidth = 32, activeWidth = 80;
    double width1 =
        MediaQuery.of(context).size.width - activeWidth - imageWidth - 70;
    double width2 =
        MediaQuery.of(context).size.width - iconWidth - imageWidth - 70;
    double width = width2 / 2;

    return Container(
      margin: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Color(0xFF9EC1CF)),
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/no_image.png',
            image: '$offerThumbUrl${onGoing.image}',
            width: 100,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width1,
                      child: Text(
                        onGoing.description,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Container(
                      width: activeWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xFF76C2FA)),
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Center(
                        child: Text(
                          onGoing.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF0D8973),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 2,
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width - imageWidth - 70,
                  margin: EdgeInsets.only(top: 10),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: width,
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              child: Text("Start",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              width: width,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                  getConvertedDateAndTime(onGoing.startTime),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              child: Text("End",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                              width: width,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                getConvertedDateAndTime(onGoing.endTime),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteItem(onGoing.id.toString());
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Color(0xFF416B7C)),
                            width: iconWidth,
                            padding: EdgeInsets.all(5),
                            child: Image(
                              image: AssetImage('assets/icons/delete.png'),
                              width: iconWidth,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget ongoingList(List<Ads> onGoing) {
    return Container(
      height: MediaQuery.of(context).size.height - 40,
      margin: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5.0),
      child: ListView.builder(
          itemCount: onGoing.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return ongoingItem(onGoing[index]);
          }),
    );
  }

  Widget historyList(List<Ads> history) {
    return Container(
      height: MediaQuery.of(context).size.height - 40,
      margin: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5.0),
      child: ListView.builder(
          itemCount: history.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return historyItem(history[index]);
          }),
    );
  }
}
