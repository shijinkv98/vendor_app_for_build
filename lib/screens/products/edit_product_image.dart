import 'dart:io';
import 'dart:convert' show json;
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vendor_app/custom/fdottedline.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/helpers/mime_type.dart';

import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/model/file_model.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/category_response.dart';
import 'package:vendor_app/network/response/vendor_product_response.dart';
import 'package:vendor_app/notifiers/product_notifier.dart';
import 'package:vendor_app/screens/products/CategoryScreen.dart';
import 'package:vendor_app/screens/products/products.dart';

import 'edit_product_image_search.dart';

class EditProductImage extends StatefulWidget {
  Data product;
  String slug;
  List<ProductImages> images;
  @override
  _EditProductState createState() => _EditProductState(item: this.product,images:this.images,slug: this.slug);
  EditProductImage(Data response,this.images)
  {
    this.product=response;
    this.images=images;
    this.slug=slug;
  }
}


class _EditProductState extends State<EditProductImage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Data item;
  String slug;

  List<ProductImages> images;
  _EditProductState({ this.item, this.images,this.slug}) ;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  File imageFile;
  final List<FileModel> _images = List();

  ImageAddedNotifier _imageAddedNotifier;
  AddProductLoadingNotifier _loadingNotifier;
  CategorySelectedNotifier _categorySelectedNotifier;
  Data product;

  @override
  void initState() {
    super.initState();
    _images.add(null);
    _imageAddedNotifier =
        Provider.of<ImageAddedNotifier>(context, listen: false);
    _loadingNotifier =
        Provider.of<AddProductLoadingNotifier>(context, listen: false);
    _categorySelectedNotifier =
        Provider.of<CategorySelectedNotifier>(context, listen: false);
    for(int i=0;i<item.productImages.length;i++) {
      _images.insert(i,
          FileModel(imageU8L: null,
              fileName: item.productImages[i].image,
              imageStr: '$productThumbUrl${item.productImages[i].image}',
              isNetwork: true));
      _imageAddedNotifier.imageAdded();
    }
    if(item.productImages.length==0)
    {
      _images.insert(0,
          FileModel(imageU8L: null,
              fileName: item.image,
              imageStr: '$productThumbUrl${item.image}',
              isNetwork: true));
      _imageAddedNotifier.imageAdded();
    }
    // ApiCall().execute<CategoryResponse, Null>('getcategories', null);
  }

  _DropdownModel _mainCategory;
  _DropdownModel _subCategory;
  _DropdownModel _manufacturers;
  Map<String, _DropdownModel> _specifications = new Map();
  List<_DropdownModel> _subCategories;
  String _productName, _desscription, _mrp, _sellingPrice, _stock;
  String _minimumQty, _searchTag, _return, _returnDays, _orderNo;

  @override
  Widget build(BuildContext context) {
    final productNameField = TextFormField(
      obscureText: false,
      autofocus: true,
      onChanged: (value) {
        _productName = value;
      },
      initialValue: item.name,
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
          // } else if (!RegExp(
          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          //     .hasMatch(value)) {
          //   return 'Invalid email';
        } else {
          return null;
        }
      },
      maxLines: 8,
      minLines: 1,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Product name",
        labelText: 'Product name',
      ),
    );
    String getText(String html)
    {

      String s1= html.replaceAll("<p>", "");
      String s2= s1.replaceAll('</p>', "");
      return s2;
    }
    final _desscriptionField = TextFormField(
      obscureText: false,
      autofocus: true,
      onChanged: (value) {
        _desscription = value;
      },
      initialValue: getText(item.description),
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
          // } else if (!RegExp(
          //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          //     .hasMatch(value)) {
          //   return 'Invalid email';
        } else {
          return null;
        }
      },
      maxLines: 8,
      minLines: 1,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Description",
        labelText: 'Description',
      ),
    );

    final _mrpField = TextFormField(
      obscureText: false,
      autofocus: true,
      onChanged: (value) {
        _mrp = value;
      },
      initialValue: item.defaultPrice,
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType:
      TextInputType.numberWithOptions(decimal: true, signed: false),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "MRP",
        labelText: 'MRP',
      ),
    );

    final _sellingPriceField = TextFormField(
      obscureText: false,
      autofocus: true,
      onChanged: (value) {
        _sellingPrice = value;
      },
      initialValue: item.currentPrice,
      style: style,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
      keyboardType:
      TextInputType.numberWithOptions(decimal: true, signed: false),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        hintText: "Selling price",
        labelText: 'Selling price',
      ),
    );

    final _stockField = TextFormField(
      obscureText: false,
      autofocus: true,
      onChanged: (value) {
        _stock = value;
      },
      initialValue: item.stock,
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
        hintText: "Stock",
        labelText: 'Stock',
      ),
    );

    final _minimumQtyField = TextFormField(
      obscureText: false,
      autofocus: true,
      onChanged: (value) {
        _minimumQty = value;
      },
      initialValue: item.minQuantity,
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
        hintText: "Minimum purchase quantity",
        labelText: 'Minimum purchase quantity',
      ),
    );

    final _searchTagField = TextFormField(
      obscureText: false,
      autofocus: true,
      onChanged: (value) {
        _searchTag = value;
      },
      initialValue: item.tags,
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
        hintText: "Search tag",
        labelText: 'Search tag',
      ),
    );


    var _returnsArray = ['Return', 'Replace'];
    final _returnField = DropdownButtonFormField(
      value: _return,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(8, 0.0, 5, 0.0),
        hintStyle: TextStyle(fontSize: 14),
        labelStyle: TextStyle(fontSize: 14),
        hintText: 'Return',
        labelText: 'Return',
      ),
      isExpanded: true,
      isDense: true,
      onChanged: (String newValue) {
        // setState(() {

        _return = newValue;
        // state.didChange(newValue);
        // });
      },
      items: _returnsArray.map((String value) {
        return DropdownMenuItem<String>(
          value: value,

          child: Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );



    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Manage Product Images',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorPrimary,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.only(left: 10,right: 10,top: 20),
            child: Consumer<ImageAddedNotifier>(
            builder: (context, value, child) =>
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: const EdgeInsets.all(2.0),
                primary: false,
                childAspectRatio: 0.8,
                children: _gridTile(),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 6.0,
              ),

    ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            margin: EdgeInsets.only(left: 10,right: 10,top: 20),
            elevation: 3,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(5.0),
              color: colorPrimary,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 10.0),
                onPressed: () async {
                  // Navigator.of(context).pushReplacementNamed('/home');
                  List<Map> specList = [];
                  if(_specifications!=null) {
                    _specifications.forEach((key, value) {
                      specList.add({'specification_id': key, 'value_id': value.id});
                    });
                  }
                  // debugPrint(' selected specifications ${json.encode(specList)}');
// category,name,description,stock,default_price,current_price,tags,min_quantity,stock_alert_quantity,imageFile,manufacturer_id,specifications

                  var request = ApiCall().getMultipartRequest('${"updateproduct/"}${item.productId}');
                  if(_mainCategory != null)
                  {
                    request.fields['category'] =
                        _subCategory?.id ?? _mainCategory.id ?? '';
                  }
                  if(_productName != null){
                    request.fields['name'] = _productName;
                  }
                  if(_desscription != null){
                    request.fields['description'] = _desscription;
                  }
                  // if(_stock != null){
                  //   request.fields['stock'] = _stock;
                  // }
                  // if(_mrp != null){
                  //   request.fields['default_price'] = _mrp;
                  // }
                  if(_sellingPrice != null) {
                    request.fields['current_price'] = _sellingPrice;
                  }
                  if(_searchTag != null) {
                    request.fields['tags'] = _searchTag;
                  }
                  // if(_minimumQty != null) {
                  //   request.fields['min_quantity'] = _minimumQty;
                  // }
                  if(_orderNo != null) {
                    request.fields['order_number'] = _orderNo;
                  }
                  // if(_stock != null) {
                  //   request.fields['stock_alert_quantity'] = '1';
                  // }
                  if(_manufacturers != null) {
                    request.fields['manufacturer_id'] = _manufacturers.id;
                  }
                  if(_returnDays != null) {
                    request.fields['return_period'] = _returnDays ?? '0';
                  }
                  // request.fields['sortorder_in_vendorapp'] = _orderNo;
                  if(_specifications != null) {
                    request.fields['specifications'] = json.encode(specList);
                  }
                  _images.forEach((element) {
                    if (element != null) {
                      if(element.imageU8L!=null) {
                        request.files.add(http.MultipartFile.fromBytes(
                            'imageFile[]',
                            // File(element.imageStr).readAsBytesSync(),
                            element.imageU8L,
                            filename: element.name ?? 'ProductImag.jpg',
                            contentType: MimeTypes.getContentType(element)));
                      }
                    }
                  });
                  _loadingNotifier.isLoading = true;

                  ApiCall().executeNew('addproduct', null,multipartRequest: request)
                      .then((value) {
                    _loadingNotifier.isLoading = false;
                    // ApiCall().showToast("Successfully updated");
                    setState(() {

                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>CategoryScreen()),
                    );
                    Fluttertoast.showToast(
                        msg: "Successfully Updated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: colorPrimary,
                        textColor: Colors.white,
                        fontSize: 15.0);
                    setState(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryScreen()),
                      );

                    });


                  });
                },
                child: Text("Save",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],

      ),



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

    // return [
    //   GridTile(
    //     child: addImage,
    //   ),
    // ].toList();
  }

  Widget addImage(int index, FileModel imageModel) => FDottedLine(
    color: colorPrimary,
    strokeWidth: 2.0,
    dottedLength: 4.0,
    space: 3.0,
    corner: FDottedLineCorner.all(3.0),
    child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 130,
        alignment: Alignment.center,
        child: getGridChild(index, imageModel)),
  );

  // setState(());
  Widget getGridChild(int index, FileModel imageModel) {
    if (imageModel == null) {
      return InkWell(
        onTap: () {
          _showAlertDialog(context, index, imageModel);
        },
        child: Container(
          height: 125,
          child: Column(
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
          ),
        ),
      );
    } else if (imageModel.imageU8L != null && imageModel.imageU8L.length > 0) {
      return Image.memory(imageModel.imageU8L);
    } else if (imageModel.imageStr != null &&
        imageModel.imageStr.trim().isNotEmpty &&
        imageModel.isNetwork) {
      return Container(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                showAlertDeleteProduct(index);

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.highlight_remove_outlined,color: Colors.red,
                  ),
                ],
              ),

            ),
            Expanded(
              child:
              Container(
                height: 100,
                margin: EdgeInsets.only(top: 0),
                child: Align(
                  alignment: Alignment.center,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/no_image.png',
                    image: imageModel.imageStr,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Image.file(File(imageModel.imageStr));
    }
  }
  void showAlertDeleteProduct(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Are you sure you want to delete?"),
        // content: Text("See products pending for approval"),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "CANCEL",
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Map body = {
                'image': item.productImages[index].image,
                'product_id': item.productId
              };

                  // FocusScope.of(context).requestFocus(FocusNode());
                  ApiCall()
                      .execute("deleteproductimage", body,multipartRequest: null).then((value) {
                    // ApiCall().showToast('Image Removed Successfully');
                        Fluttertoast.showToast(
                        msg: "Image Removed Successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: colorPrimary,
                        textColor: Colors.white,
                        fontSize: 15.0);
                        setState(() {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => CategoryScreen()),
                          );

                        });

                  } );
                },
                child: Text(
                  "DELETE",
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget getContent(){
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [


                      SizedBox(
                        height: 10,
                      ),
                    ]

                      ..addAll([
                        Consumer<ImageAddedNotifier>(
                          builder: (context, value, child) =>
                              GridView.count(
                                crossAxisCount: 3,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(2.0),
                                primary: false,
                                childAspectRatio: 0.8,
                                children: _gridTile(),
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 6.0,
                              ),

                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(5.0),
                          color: colorPrimary,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 10.0),
                            onPressed: () async {
                              // Navigator.of(context).pushReplacementNamed('/home');
                              List<Map> specList = [];
                              if(_specifications!=null) {
                                _specifications.forEach((key, value) {
                                  specList.add({'specification_id': key, 'value_id': value.id});
                                });
                              }
                              // debugPrint(' selected specifications ${json.encode(specList)}');
// category,name,description,stock,default_price,current_price,tags,min_quantity,stock_alert_quantity,imageFile,manufacturer_id,specifications

                              var request = ApiCall().getMultipartRequest('${"updateproduct/"}${item.productId}');
                              if(_mainCategory != null)
                              {
                                request.fields['category'] =
                                    _subCategory?.id ?? _mainCategory.id ?? '';
                              }
                              if(_productName != null){
                                request.fields['name'] = _productName;
                              }
                              if(_desscription != null){
                                request.fields['description'] = _desscription;
                              }
                              // if(_stock != null){
                              //   request.fields['stock'] = _stock;
                              // }
                              // if(_mrp != null){
                              //   request.fields['default_price'] = _mrp;
                              // }
                              if(_sellingPrice != null) {
                                request.fields['current_price'] = _sellingPrice;
                              }
                              if(_searchTag != null) {
                                request.fields['tags'] = _searchTag;
                              }
                              // if(_minimumQty != null) {
                              //   request.fields['min_quantity'] = _minimumQty;
                              // }
                              if(_orderNo != null) {
                                request.fields['order_number'] = _orderNo;
                              }
                              // if(_stock != null) {
                              //   request.fields['stock_alert_quantity'] = '1';
                              // }
                              if(_manufacturers != null) {
                                request.fields['manufacturer_id'] = _manufacturers.id;
                              }
                              if(_returnDays != null) {
                                request.fields['return_period'] = _returnDays ?? '0';
                              }
                              // request.fields['sortorder_in_vendorapp'] = _orderNo;
                              if(_specifications != null) {
                                request.fields['specifications'] = json.encode(specList);
                              }
                              _images.forEach((element) {
                                if (element != null) {
                                  if(element.imageU8L!=null) {
                                    request.files.add(http.MultipartFile.fromBytes(
                                        'imageFile[]',
                                        // File(element.imageStr).readAsBytesSync(),
                                        element.imageU8L,
                                        filename: element.name ?? 'ProductImag.jpg',
                                        contentType: MimeTypes.getContentType(element)));
                                  }
                                }
                              });
                              _loadingNotifier.isLoading = true;

                              ApiCall().executeNew('addproduct', null,
                                  multipartRequest: request)
                                  .then((value) {
                                _loadingNotifier.isLoading = false;
                                // ApiCall().showToast("Successfully updated");
                                // setState(() {
                                //
                                // });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                                );
                                Fluttertoast.showToast(
                                    msg: "Successfully updated",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: colorPrimary,
                                    textColor: Colors.white,
                                    fontSize: 15.0);


                              });
                            },
                            child: Text("Save",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        Consumer<AddProductLoadingNotifier>(
          builder: (context, value, child) {
            return value.isLoading ? progressBar : SizedBox();
          },
        )
      ],
    );
  }

// replace this function with the examples above
  _showAlertDialog(BuildContext context, int index, FileModel imageModel) {
    // set up the list options
    Widget optionOne = SimpleDialogOption(
      child: const Text('Take image with camera'),
      onPressed: () {
        _getFromCamera();
        // ImagePicker()
        //     .getImage(source: ImageSource.camera, imageQuality: 70)
        //     .then((value) => {
        //   value.readAsBytes().then((imageU8L) {
        //     _images.insert(index,
        //         FileModel(imageU8L: imageU8L, fileName: value.path));
        //     _imageAddedNotifier.imageAdded();
        //   })
        // });
        // Navigator.of(context).pop();
      },
    );
    Widget optionTwo = SimpleDialogOption(
      child: const Text('Upload image from gallery'),
      onPressed: () {
        _getFromGallery();
        // ImagePicker()
        //     .getImage(source: ImageSource.gallery, imageQuality: 70)
        //     .then((value) {
        //   // debugPrint('MJM ImagePicker gallery $value');
        //   value.readAsBytes().then((imageU8L) {
        //     _images.insert(
        //         index, FileModel(imageU8L: imageU8L, fileName: value.path));
        //     _imageAddedNotifier.imageAdded();
        //   });
        // });
        // // FilePicker.platform
        // //     .pickFiles(type: FileType.image, allowMultiple: true)
        // //     .then((value) {
        // //   _images.insertAll(
        // //       index,
        // //       value.files.map((e) => FileModel(
        // //           fileName: e.name, imageStr: e.path, imageU8L: e.bytes)));
        // //   _imageAddedNotifier.imageAdded();
        // // });
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
      imageFile = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();
      _images.insert(0, FileModel(imageU8L: bytes, fileName: filePath));
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
    );
    if (croppedImage != null) {
      imageFile = croppedImage;
      Uint8List bytes = croppedImage.readAsBytesSync();
      _images.insert(0, FileModel(imageU8L: bytes, fileName: filePath));
      _imageAddedNotifier.imageAdded();
      setState(() {
        // debugPrint('MJM ImagePicker gallery $value');
      });

      // });
    }
  }
  // Widget _dropdownField(
  //     {_DropdownModel value,
  //     List<_DropdownModel> list,
  //     ValueChanged<_DropdownModel> onChanged,
  //     String hintText,
  //     String labelText,
  //     bool isMandatory = true}) {
  //   if (list == null) {
  //     list = List();
  //   }
  //   return DropdownButtonFormField<_DropdownModel>(
  //     value: value,
  //     isExpanded: true,
  //     isDense: true,
  //     decoration: InputDecoration(
  //       contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
  //       hintText: hintText,
  //       labelText: labelText,
  //     ),
  //     onChanged: (_DropdownModel newValue) {
  //       if (newValue != value && onChanged != null) {
  //         onChanged(newValue);
  //       }
  //     },
  //     validator: (value) {
  //       if (isMandatory && value == null) {
  //         return 'This field is required';
  //       } else {
  //         return null;
  //       }
  //     },
  //     items: list.map((_DropdownModel value) {
  //       return DropdownMenuItem<_DropdownModel>(
  //         value: value,
  //         child: Text(value.title),
  //       );
  //     }).toList(),
  //   );
  // }

  @override
  void dispose() {
    _loadingNotifier.reset();
    super.dispose();
  }
  // String getSpecificationName(Specification element)  {
  //   if(item.specifications==null)
  //     return element.name;
  //   List<Specifications> speci=item.specifications;
  //   for( int i=0;i<speci.length;i++)
  //   {
  //     if(speci[i].specificationId==element.specificationId)
  //       return speci[i].values[0].languages[0].value;
  //   }
  //   return element.name;
  // }
  // String getSpecificationId(Specification element)  {
  //   if(item.specifications==null)
  //     return element.specificationId;
  //   List<Specifications> speci=item.specifications;
  //   for( int i=0;i<speci.length;i++)
  //   {
  //     if(speci[i].specification.language.name==element.name)
  //       return speci[i].values[0].languages[0].value;
  //   }
  //   return element.specificationId;
  // }

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

// class _DropdownField extends StatefulWidget {
//   _DropdownModel value;
//   List<_DropdownModel> list;
//   ValueChanged<_DropdownModel> onChanged;
//   String hintText;
//   String labelText;
//   bool isMandatory = true;

//   _DropdownField(
//       {this.value,
//       this.list,
//       this.onChanged,
//       this.hintText,
//       this.labelText,
//       this.isMandatory = true}) {
//     if (list == null) {
//       list = List();
//     }
//   }

//   @override
//   __DropdownFieldState createState() => __DropdownFieldState();
// }

// class __DropdownFieldState extends State<_DropdownField> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: widget.value?.id,
//       isExpanded: true,
//       isDense: true,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//         hintText: widget.hintText,
//         labelText: widget.labelText,
//       ),
//       onChanged: (String newValue) {
//         if ((widget.value == null || newValue != widget.value?.id) &&
//             widget.onChanged != null) {
//           widget.onChanged(
//               widget.list.firstWhere((element) => element.id == newValue));
//         }
//       },
//       validator: (value) {
//         if (widget.isMandatory && value == null) {
//           return 'This field is required';
//         } else {
//           return null;
//         }
//       },
//       items: widget.list.map((_DropdownModel value) {
//         return DropdownMenuItem<String>(
//           value: value.id,
//           child: Text(value.title),
//         );
//       }).toList(),
//     );
//   }
// }
