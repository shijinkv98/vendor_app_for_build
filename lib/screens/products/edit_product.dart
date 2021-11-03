import 'dart:io';
import 'dart:convert' show json;
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:textfield_tags/textfield_tags.dart';
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
import 'package:vendor_app/screens/products/ProductCategoryScreen.dart';

class EditProduct extends StatefulWidget {
  Data product;
  String slug;
  List<ProductImages> images;
  @override
  _EditProductState createState() => _EditProductState(item: this.product,images:this.images,slug: this.slug);
  EditProduct(Data response,this.images,this.slug)
  {
    this.product=response;
    this.images=images;
    this.slug=slug;
  }
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Data item;
  String slug;
  List<String> tags = [];
  List<ProductImages> images;
  _EditProductState({ this.item, this.images,this.slug}) ;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  File imageFile;
  final List<FileModel> _images = List();

  ImageAddedNotifier _imageAddedNotifier;
  AddProductLoadingNotifier _loadingNotifier;
  CategorySelectedNotifier _categorySelectedNotifier;

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
    if(item.productImages!=null) {
      for (int i = 0; i < item.productImages.length; i++) {
        _images.insert(i,
            FileModel(imageU8L: null,
                fileName: item.productImages[i].image,
                imageStr: '$productThumbUrl${item.productImages[i].image}',
                isNetwork: true));
        _imageAddedNotifier.imageAdded();
      }
      if (item.productImages.length==0) {
        _images.insert(0,
            FileModel(imageU8L: null,
                fileName: item.image,
                imageStr: '$productThumbUrl${item.image}',
                isNetwork: true));
        _imageAddedNotifier.imageAdded();
      }
    }
    // fetchData();
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
          hintText: "Product name",
          labelText: 'Product name',
          contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
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
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
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
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
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
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
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
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
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
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
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
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
      ),
    );
    final searchTag=TextFieldTags(
        onDelete: (value){
          tags.remove(value);
        },
        onTag: (value){
          tags.add(value);
        },
        initialTags:item?.tags?.split(", ") ?? [],
        validator: (value){},
        tagsStyler: TagsStyler(
          tagTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
          tagDecoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(8.0), ),
          tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.white),
          tagPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 06),
          tagTextPadding: const EdgeInsets.only(right: 5),

        ),
        textFieldStyler: TextFieldStyler(
          hintText: "Search Tags*",
          helperText: "",
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          hintStyle: style,
          isDense: true,
          textFieldEnabledBorder: UnderlineInputBorder(
            borderSide:
            BorderSide(color: Colors.white, width: 0.3),
          ),
          textFieldBorder: UnderlineInputBorder(
            borderSide:
            BorderSide(color: Colors.white, width: 0.3),
          ),
          textFieldFocusedBorder: UnderlineInputBorder(
            borderSide:
            BorderSide(color: Colors.white, width: 0.3),
          ),
        )
    );

    // var _guaranties = ['Guarantee', 'Warranty'];
    // String _guarantee;
    // final _guaranteeField = DropdownButtonFormField(
    //   value: _guarantee,
    //   decoration: InputDecoration(
    //     contentPadding: EdgeInsets.fromLTRB(8, 0.0, 5, 0.0),
    //     hintStyle: TextStyle(fontSize: 14),
    //       
    //     hintText: 'Guarantee',
    //     labelText: 'Guarantee',
    //   ),
    //   isExpanded: true,
    //   isDense: true,
    //   onChanged: (String newValue) {
    //     // setState(() {
    //     _guarantee = newValue;
    //     // state.didChange(newValue);
    //     // });
    //   },
    //   items: _guaranties.map((String value) {
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Text(
    //         value,
    //         style: TextStyle(fontSize: 14),
    //       ),
    //     );
    //   }).toList(),
    // );

    // var _guaranteePriods = ['Month', 'Year'];
    // String _month;
    // final _monthField = DropdownButtonFormField(
    //   value: _month,
    //   decoration: InputDecoration(
    //     contentPadding: EdgeInsets.fromLTRB(8, 0.0, 5, 0.0),
    //     hintStyle: TextStyle(fontSize: 14),
    //       
    //     hintText: 'Month',
    //     labelText: 'Month',
    //   ),
    //   isExpanded: true,
    //   isDense: true,
    //   onChanged: (String newValue) {
    //     // setState(() {
    //     _month = newValue;
    //     // state.didChange(newValue);
    //     // });
    //   },
    //   items: _guaranteePriods.map((String value) {
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Text(
    //         value,
    //         style: TextStyle(fontSize: 14),
    //       ),
    //     );
    //   }).toList(),
    // );

    // String _guaranteePeriod = '0';
    // final _guaranteePeriodField = TextFormField(
    //   obscureText: false,
    //   onChanged: (value) {
    //     _guaranteePeriod = value;
    //   },
    //   initialValue: _guaranteePeriod,
    //   style: style,
    //   validator: (value) {
    //     if (value.trim().isEmpty) {
    //       return 'This field is required';
    //     } else {
    //       return null;
    //     }
    //   },
    //   keyboardType: TextInputType.number,
    //   textInputAction: TextInputAction.next,
    //   decoration: InputDecoration(
    //     contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
    //     hintText: "Period",
    //     labelText: 'Period',
    //   ),
    // );

    var _returnsArray = ['Return', 'Replace'];
    final _returnField = DropdownButtonFormField(
      value: _return,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(8, 0.0, 5, 0.0),
        hintStyle: TextStyle(fontSize: 14),
          
        hintText: 'Return',
        labelText: 'Return',
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
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

    final _returnDaysField = TextFormField(
      obscureText: false,
      autofocus: true,
      onChanged: (value) {
        _returnDays = value;
      },
      initialValue: item.returnPeriod,
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
        hintText: "Days",
        labelText: 'Days',
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
      ),
    );

    final _orderNoField = TextFormField(
      obscureText: false,
      autofocus: true,
      onChanged: (value) {
        _orderNo = value;
      },
      initialValue:item.orderNumber,
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
        hintText: "Product Serial number",
        labelText: 'Product Serial number',
          labelStyle: TextStyle(color: colorPrimary,fontWeight: FontWeight.bold),
          border: InputBorder.none
      ),
    );

    final submitButon = Material(
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
          ApiCall()
              .executeNew('${"updateproduct/"}${item.productId}',null, multipartRequest: request,isGet:true)
              .then((value) {
            _loadingNotifier.isLoading = false;

            ApiCall().showToast("Successfully updated");
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => ProductsScreen()),
            // );

          });
        },
        child: Text("Save",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        leading: InkWell(
            onTap:() {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ProductCategoryScreen(slug: slug)));
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          'Edit item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorPrimary,
      ),
      backgroundColor: Colors.white,
      body:
      FutureBuilder<CategoryResponse>(
          future:
          ApiCall().execute<CategoryResponse, Null>('getcategories', null),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // _mainCategory=snapshot.data.categories[item.categoryId] as _DropdownModel;
              List<Widget> specifications = [];


              snapshot.data.specification.asMap().forEach((key, value) {});
              snapshot.data.specification.forEach((element) {
                specifications.add(
                    Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 60,
                    child: _DropdownField(

                      hintText: getSpecificationName(element)!=null?getSpecificationName(element):element.name,
                      labelText: getSpecificationName(element).toString(),

                      list: element.values
                          .map((e) => _DropdownModel(e.id, e.name))
                          .toList(),
                      value: _specifications[getSpecificationId(element)],
                      onChanged: (newValue) {

                        _specifications[element.specificationId] = newValue;
                      },
                      isMandatory: false,
                    ),
                  ),
                ));
                specifications.add(SizedBox(height: 10));

              });


              String categoryName="Main category";
              for(int i=0;i<snapshot.data.categories.length;i++)
              {
                if(item.categoryParentId==snapshot.data.categories[i].id)
                  categoryName=snapshot.data.categories[i].language.name;
              }
              String subcategoryName="Sub category";
              for(int i=0;i<snapshot.data.categories.length;i++)
              {
                if(item.categoryId==snapshot.data.categories[i].id)
                  subcategoryName=snapshot.data.categories[i].language.name;
              }
              String manufaturesName="Manufatures";
              for(int i=0;i<snapshot.data.manufacturers.length;i++)
              {
                if(item.manufacturer==snapshot.data.manufacturers[i].id)
                  manufaturesName=snapshot.data.manufacturers[i].name;
              }

              String specification="Guarantee by";
              for(int i=0;i<snapshot.data.specification.length;i++)
                {
                  if(item.manufacturer==snapshot.data.specification[i].specificationId)
                    manufaturesName=snapshot.data.specification[i].name;
                }
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: 60,
                              child:  _DropdownField(
                                hintText: categoryName,
                                // labelText:  'Category Name',
                                list: snapshot.data.categories
                                    .where((element) =>
                                element.subcategorieslanguage != null &&
                                    element.subcategorieslanguage.isNotEmpty)
                                    .map((e) =>
                                    _DropdownModel(e.id, e.language.name))
                                    .toList(),
                                value: _mainCategory,

                                onChanged: (newValue) {
                                  debugPrint(
                                      'Main category dropdown onChanged: $newValue');
                                  _subCategories = snapshot.data.categories
                                      .firstWhere(
                                          (element) => element.id == newValue.id)
                                      .subcategorieslanguage
                                      .map((e) => _DropdownModel(e.id, e.name))
                                      .toList();
                                  _mainCategory = newValue;
                                  // _subCategory = _subCategories[0];
                                  _categorySelectedNotifier.categorySelected();
                                },
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Consumer<CategorySelectedNotifier>(
                                  builder: (context, value, child) {
                                    return _subCategories != null &&
                                        _subCategories.isNotEmpty
                                        ? Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                          child: Container(
                                            height: 60,
                                            child: _DropdownField(
                                      hintText: subcategoryName,
                                      // labelText: subcategoryName,
                                      list: _subCategories,
                                      value: _subCategory,
                                      onChanged: (newValue) {
                                            _subCategory = newValue;
                                      },
                                    ),
                                          ),
                                        )
                                        : SizedBox();
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                      height: 50,
                                      child:  _orderNoField),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                      child:  productNameField),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                      child:  _desscriptionField),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                      height: 50,
                                      child:  _sellingPriceField),
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                snapshot.data.manufacturers != null &&
                                    snapshot.data.manufacturers.isNotEmpty
                                    ?
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    height: 60,
                                    child:  _DropdownField(

                                  hintText:item.manufacturer,
                                  // labelText: 'Fast Moving Products',
                                  list: snapshot.data.manufacturers
                                          .map(
                                              (e) => _DropdownModel(e.id, e.name))
                                          .toList(),
                                  value: _manufacturers,
                                  onChanged: (newValue) {
                                        _manufacturers = newValue;
                                  },
                                ),
                                      ),
                                    )
                                    : SizedBox(),
                                SizedBox(
                                  height: 5,
                                ),
                                Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      height: 72,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            searchTag,
                                          ],
                                        ))),
                                SizedBox(
                                  height: 5,
                                ),

                                Row(
                                  children: [
                                    Expanded(child:  Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          height: 50,
                                          child: _returnField),
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                          height: 50,
                                          child:  _returnDaysField),
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ]
                                ..addAll(specifications)
                                ..addAll([
                                  Consumer<ImageAddedNotifier>(
                                    builder: (context, value, child) =>
                                        Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Container(

                                            child:  GridView.count(
                                              crossAxisCount: 3,
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(2.0),
                                              primary: false,
                                              childAspectRatio: 1.0,
                                              children: _gridTile(),
                                              mainAxisSpacing: 6.0,
                                              crossAxisSpacing: 6.0,
                                            ),
                                          ),
                                        ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  submitButon,
                                  SizedBox(
                                    height: 20,
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
            } else if (snapshot.hasError) {
              return errorScreen('Error: ${snapshot.error}');
            } else {
              return progressBar;
            }
          }),
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
        height: 100,
        alignment: Alignment.center,
        child: Stack(
          children: [
            // InkWell(
            //   onTap: (){
            //     _showremovealert();
            //   },
            //   child: Align(
            //     alignment: Alignment.topRight,
            //     child: Icon(Icons.close,color: Colors.red,),
            //   ),
            // ),
            Align(
                alignment: Alignment.center,
                child: getGridChild(index, imageModel)),
          ],
        )),
  );

  Widget getGridChild(int index, FileModel imageModel) {
    if (imageModel == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              _showAlertDialog(context, index, imageModel);
            },
            child: Icon(
              Icons.add,
              size: 30,
              color: primaryTextColor,
            ),
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
        imageModel.imageStr.trim().isNotEmpty &&
        imageModel.isNetwork) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/images/no_image.png',
        image: imageModel.imageStr,
      );
    } else {
      return Image.file(File(imageModel.imageStr));
    }
  }
  _showremovealert(){
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Are you sure to remove",
      desc: "Alert Dialog with 2 Buttons.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
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
        // Navigator.of(context).pop();
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
  String getSpecificationName(Specification element)  {
    if(item.specificationsVendor==null)
      return element.name;
    List<SpecificationsVendor> speci=item.specificationsVendor;
    for( int i=0;i<speci.length;i++)
    {
      if(speci[i].specificationId==element.specificationId)
        return speci[i].values[0].languages[0].value;
    }
    return element.name;
  }
  String getSpecificationId(Specification element)  {
    if(item.specificationsVendor==null)
      return element.specificationId;
    List<SpecificationsVendor> speci=item.specificationsVendor;
    for( int i=0;i<speci.length;i++)
    {
      if(speci[i].specification.language.name==element.name)
        return speci[i].values[0].languages[0].value;
    }
    return element.specificationId;
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
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
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
