import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/order_list_response.dart'
    show Order, OrderDetailsResponse, OrderItems, Timeline;
import 'package:vendor_app/network/response/orderlistresponse.dart';
import 'package:vendor_app/network/response/orderupdateresponse.dart';
import 'package:vendor_app/notifiers/order_details_notifier.dart';

import 'home/home.dart';
import 'home/orders.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderItems orderItems;
  String orderId = "0";
  OrderDetailsScreen({Key key, @required this.orderItems}) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();

}

TextStyle _titleStyle = TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.bold);

class _OrderDetailsState extends State<OrderDetailsScreen> {
  final double _paddingTop = 10;
  final double _paddingStart = 10;
  final double _paddingTableRow = 7;
  OrderStatusList _chosenValue;


  final BoxDecoration _boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 5.0,
      ),
    ],
  );
  OrderTimelineNotifier _timelineNotifier;
  OrderDetailsLoadingNotifier _loadingNotifier;
  List<Timeline> _timeline;
  OrderDetailsResponse _detailsResponse;
  List<OrderStatusList> orderStatusList;
  Widget getFullView()
  {
    return FutureBuilder<OrderStatusListResponse>(
      future: ApiCall().execute<OrderStatusListResponse, Null>('order/status-all', null),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          orderStatusList=snapshot.data.orderStatusList;
          return getView();
        } else if (snapshot.hasError) {
          return errorScreen('Error: ${snapshot.error}');
        } else {
          return progressBar;
          return progressBar;
        }
      },
    );
  }

  void updateOrderstatus(String orderId,String statusId)
  {
    Map body={
      "status_id":statusId
    };

    String orderUpdateUrl="order/changestatus/"+orderId;
    ApiCall()
        .execute<OrderUpdateResponse, Null>(orderUpdateUrl, body).then((result) {
      ApiCall().showToast(result.message);
      // setState(() {
      //
      // });
      Navigator.of(context).pop(false);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen()));
      // Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (BuildContext context) => super.widget));
    }
      // setState(() {
      // });
      // }
    );
  }
  @override
  void initState() {
    super.initState();
    statusText=widget.orderItems.orderData.orderStatus;
    _timelineNotifier =
        Provider.of<OrderTimelineNotifier>(context, listen: false);
    _loadingNotifier =
        Provider.of<OrderDetailsLoadingNotifier>(context, listen: false);
    _loadingNotifier.setLoading(true);
    // /vendor/order-details/<order_id>	id,token, item_id
    ApiCall().execute<OrderDetailsResponse, Null>(
        'vendor/order-details/${widget.orderItems.orderData.id}',
        {'item_id': widget.orderItems.item.id}).then((value) {
      _loadingNotifier.isLoading = false;
      _detailsResponse=value;
      _timeline = value?.timeline;

      _timelineNotifier.responseReceived();
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
          backgroundColor: colorPrimary,
        ),
        body: getFullView()
    );


  }
  String statusText="";
  Widget getView()
  {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  // margin: const EdgeInsets.only(top: 8),
                  padding: EdgeInsets.fromLTRB(
                      _paddingStart, _paddingTop, _paddingStart, _paddingTop),
                  // decoration: _boxDecoration,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Order Id : '),
                                Text(widget.orderItems.item.orderId,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Order Item Status :'),
                                Card(
                                  elevation: 3,
                                  color: colorPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),

                                  child: Container(
                                    height: 30,
                                    margin: EdgeInsets.only(left: 5),
                                    padding:
                                    EdgeInsets.fromLTRB(10.0, 2, 10.0, 2),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(2.0),
                                        color: Theme.of(context).primaryColor),
                                    child: Center(
                                      child: Text(
                                          widget.orderItems.item.statusText,
                                          style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2,),
                            Row(
                              children: [
                                Text('Ordered on :'),
                                Text(widget.orderItems.orderData.createdAt,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),

                          ],
                        ),
                      ),
                      // Column(
                      //   children: [
                      //     SizedBox(
                      //       height: 27.0,
                      //       child: widget.orderItems.orderData.orderStatus!="Confirmed"?RaisedButton(
                      //         padding: EdgeInsets.all(0),
                      //         onPressed: ()
                      //         async {
                      //           Map body = {
                      //             'id': widget.orderItems.orderData.id,
                      //           };
                      //
                      //           ApiCall()
                      //               .qpprove_reject(
                      //             'activateorder',
                      //             body,
                      //           )
                      //               .then((value) {
                      //             String message = value['message'];
                      //             ApiCall().showToast(message);
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => Orders()),
                      //             );
                      //           });
                      //         },
                      //         child: Text(
                      //           'Accept ',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         color: Colors.green,
                      //       ):Container(),
                      //     ),
                      //     SizedBox(
                      //       height: 5,
                      //     ),
                      //     SizedBox(
                      //       height: 27.0,
                      //       child: widget.orderItems.orderData.orderStatus!="Cancelled"?RaisedButton(
                      //         padding: EdgeInsets.all(0),
                      //
                      //         onPressed: () async {
                      //           Map body = {
                      //             'id': widget.orderItems.orderData.id,
                      //           };
                      //
                      //           ApiCall()
                      //               .qpprove_reject(
                      //             'deactivateorder',
                      //             body,
                      //           )
                      //               .then((value) {
                      //             String message = value['message'];
                      //             ApiCall().showToast(message);
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => Orders()),
                      //             );
                      //           });
                      //         },
                      //         child: Text(
                      //           'Reject',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         color: Colors.red,
                      //       ):Container(),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 8),
                    padding: EdgeInsets.fromLTRB(_paddingStart, _paddingTop,
                        _paddingStart, _paddingTop),
                    // decoration: _boxDecoration,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width - 100 ,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width:80 ,
                                      child: Text('Item Name : ')),
                                  Container(
                                      width:MediaQuery.of(context).size.width - 180 ,
                                      padding: EdgeInsets.only(right: 5),
                                      child:
                                      // Text('Item Name : Item Name :Item Name :Item Name :')),

                                      Text(widget.orderItems.item.productName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))),
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Text('Quantity : '),
                                  Text(widget.orderItems.item.quantity,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),

                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width:60,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/no_image.png',
                            image:
                            '$productThumbUrl${widget.orderItems.item.image}',
                            width: 60,
                            height: 60,
                          ),
                        ),

                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Text(
                  'Change Order Status',
                  style: TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                    margin: const EdgeInsets.only(top: 5,left: 5,right: 5),
                    padding:
                    EdgeInsets.fromLTRB(0, 0, 0, _paddingTop),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.white,
                    ),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Change Status : ',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal),),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          width: 150,
                          // height: 35,
                          child: getOrderStatus(),
                        ),
                      ],
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Text(
                  'Payment Summery',
                  style: TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding:
                  EdgeInsets.fromLTRB(0, 0, 0, _paddingTop),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: _paddingStart, right: _paddingStart),
                        // child: Text(
                        //   'Payment Summery',
                        //   style: _titleStyle,
                        // ),
                      ),
                      Table(
                        columnWidths: {
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                        },
                        children: getTableData(),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: _paddingStart, right: _paddingStart),
                        child: Column(
                          children: [
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Expanded(child: Text('Sub Total')),
                                Text(
                                    '$currency ${widget.orderItems.orderData.orderTotalAmount}'),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Divider(),
                            Row(
                              children: [
                                Expanded(child: Text('Delivery charges')),
                                Text(
                                    '$currency ${widget.orderItems.orderData.orderShippingCharge}'),
                                // Text('0.0'),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Divider(),
                            Row(
                              children: [
                                Expanded(child: Text('Grand Total',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                                Text(
                                    '$currency ${widget.orderItems.orderData.orderNetTotalAmount}',style: TextStyle(color:colorPrimary,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: EdgeInsets.fromLTRB(_paddingStart, _paddingTop,
                        _paddingStart, _paddingTop),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Text(widget.orderItems.orderData.shippingName,
                                    style: TextStyle(color: Colors.black)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  widget.orderItems.orderData
                                      .getShippingAddress(),
                                  style: TextStyle(
                                      color: Colors.black54, height: 1.3),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 50,
                        ),
                        RaisedButton.icon(
                            onPressed: () async {
                              String phone =
                                  widget.orderItems.orderData.shippingPhone;
                              if (phone != null && phone.trim().isNotEmpty) {
                                phone = 'tel:$phone';
                                if (await canLaunch(phone)) {
                                  await launch(phone);
                                }
                              }
                            },
                            color: primaryTextColor,
                            icon: Icon(
                              Icons.headset_mic_sharp,
                              size: 18,
                            ),
                            // padding: EdgeInsets.only(left: 5, right: 5),
                            textColor: Colors.white,
                            label: Text(
                              'Call Customer',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ))
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Text(
                  'Order Timeline',
                  style: TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Consumer<OrderTimelineNotifier>(
                builder: (context, value, child) {
                  List<Widget> chidrens = [
                    SizedBox(
                      height: _paddingTop,
                    ),
                  ];
                  if (_timeline != null && _timeline.isNotEmpty) {
                    _timeline.forEach((element) {
                      chidrens.add(
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  element.statusHistory?.statusText ?? ''),
                            ),
                            Text(element.createdAt,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      );
                      chidrens.add(
                        SizedBox(
                          height: 3,
                        ),
                      );
                    });
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          padding: EdgeInsets.fromLTRB(_paddingStart,
                              _paddingTop, _paddingStart, _paddingTop),
                          // decoration: _boxDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: chidrens,
                          )),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              Container(height: 20)
            ],
          ),
        ),
        Consumer<OrderDetailsLoadingNotifier>(
          builder: (context, value, child) {
            return value.isLoading ? progressBar : SizedBox();
          },
        )
      ],
    );
  }
  OrderStatusList getValue()
  {
    for(int i=0;i<orderStatusList.length;i++)
    {
      if(orderStatusList[i].statusText==statusText)
        return orderStatusList[i];
    }
    return orderStatusList[0];
  }
  Widget getOrderStatus(){
    var currentSelectedValue;
    return Card(
      color: colorPrimary,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Container(
        height: 30,
        margin: EdgeInsets.only(left: 10,top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),

        child:
        DropdownButton<OrderStatusList>(
          isExpanded: true,
          dropdownColor:colorPrimary,
          focusColor:Colors.black,
          hint:Text(widget.orderItems.item.statusText,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          value: currentSelectedValue,
          isDense: true,
          //elevation: 5,
          style: TextStyle(color: Colors.white),
          iconEnabledColor:Colors.white,

          onChanged: (OrderStatusList newValue) {
            setState(() {
              // _chosenValue = value;
              // statusText=value.statusText;
              currentSelectedValue = newValue;
              updateOrderstatus(widget.orderItems.item.id,newValue.statusId.toString());

            });

          },
            items: orderStatusList.map<DropdownMenuItem<OrderStatusList>>((OrderStatusList value) {
              return DropdownMenuItem<OrderStatusList>(
                value: value,
                child: Text(value.statusText,style:TextStyle(color:Colors.white),),
              );
            }).toList()
        ),
      ),
    );
  }
  List<TableRow> getTableData() {
    List<TableRow> rows = [
      TableRow(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(40)),
          children: [
            TableCell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      _paddingStart, _paddingTableRow, 0, _paddingTableRow),
                  child: Text('Item'),
                )),
            TableCell(
              child: Text('Qty'),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
            // TableCell(
            //   child: Text('Price'),
            //   verticalAlignment:
            //       TableCellVerticalAlignment.middle,
            // ),
            TableCell(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: _paddingStart),
                child: Text('Amount'),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
          ]),
    ];
    rows.addAll(
        widget.orderItems.orderData.itemsNew.map((item) => TableRow(children: [
          TableCell(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    _paddingStart, _paddingTableRow, 0, _paddingTableRow),
                child: Text(item.productName),
              )),
          TableCell(
            child: Text(item.quantity),
            verticalAlignment: TableCellVerticalAlignment.middle,
          ),
          // TableCell(
          //   child: Text(item.amount),
          //   verticalAlignment:
          //       TableCellVerticalAlignment.middle,
          // ),
          TableCell(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: _paddingStart),
              child: Text(item.amount),
            ),
            verticalAlignment: TableCellVerticalAlignment.middle,
          ),
        ])));

    return rows;
  }


}