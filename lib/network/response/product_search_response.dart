class ProductSearchResponseNew {
  int _success;
  String _message;
  List<Products> _products;

  ProductSearchResponseNew(
      {int success, String message, List<Products> products}) {
    this._success = success;
    this._message = message;
    this._products = products;
  }

  int get success => _success;
  set success(int success) => _success = success;
  String get message => _message;
  set message(String message) => _message = message;
  List<Products> get products => _products;
  set products(List<Products> products) => _products = products;

  ProductSearchResponseNew.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['products'] != null) {
      _products = new List<Products>();
      json['products'].forEach((v) {
        _products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['message'] = this._message;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String _productId;
  String _slug;
  int _status;
  String _storeslug;
  String _purchaseReward;
  String _rewardPoint;
  String _code;
  String _name;
  String _appDescription;
  String _description;
  String _orderNumber;
  String _symbolLeft;
  String _symbolRight;
  String _productactivation;
  String _productinactivation;
  String _editproduct;
  String _defaultPrice;
  String _cost;
  String _returnPeriod;
  String _stock;
  String _minQuantity;
  String _tags;
  String _categoryId;
  String _categoryParentId;
  String _isShowInList;
  String _productActive;
  String _currentPrice;
  String _image;
  String _store;
  String _manufacturer;
  List<Specifications> _specifications;
  List<ProductImages> _productImages;
  List<Images> _images;

  Products(
      {int productId,
        String slug,
        int status,
        String storeslug,
        String purchaseReward,
        String rewardPoint,
        String code,
        String name,
        String appDescription,
        String description,
        int orderNumber,
        String symbolLeft,
        String symbolRight,
        String productactivation,
        String productinactivation,
        String editproduct,
        String defaultPrice,
        String cost,
        int returnPeriod,
        String stock,
        String minQuantity,
        String tags,
        int categoryId,
        int categoryParentId,
        int isShowInList,
        int productActive,
        String currentPrice,
        String image,
        String store,
        String manufacturer,
        List<Specifications> specifications,
        List<ProductImages> productImages,
        List<Images> images}) {
    this._productId = productId.toString();
    this._slug = slug;
    this._status = status;
    this._storeslug = storeslug;
    this._purchaseReward = purchaseReward;
    this._rewardPoint = rewardPoint;
    this._code = code;
    this._name = name;
    this._appDescription = appDescription;
    this._description = description;
    this._orderNumber = orderNumber.toString();
    this._symbolLeft = symbolLeft;
    this._symbolRight = symbolRight;
    this._productactivation = productactivation;
    this._productinactivation = productinactivation;
    this._editproduct = editproduct;
    this._defaultPrice = defaultPrice;
    this._cost = cost;
    this._returnPeriod = returnPeriod.toString();
    this._stock = stock;
    this._minQuantity = minQuantity;
    this._tags = tags;
    this._categoryId = categoryId.toString();
    this._categoryParentId = categoryParentId.toString();
    this._isShowInList = isShowInList.toString();
    this._productActive = productActive.toString();
    this._currentPrice = currentPrice;
    this._image = image;
    this._store = store;
    this._manufacturer = manufacturer;
    this._specifications = specifications;
    this._productImages = productImages;
    this._images = images;
  }

  String get productId => _productId;
  set productId(String productId) => _productId = productId.toString();
  String get slug => _slug;
  set slug(String slug) => _slug = slug;
  int get status => _status;
  set status(int status) => _status = status;
  String get storeslug => _storeslug;
  set storeslug(String storeslug) => _storeslug = storeslug;
  String get purchaseReward => _purchaseReward;
  set purchaseReward(String purchaseReward) => _purchaseReward = purchaseReward;
  String get rewardPoint => _rewardPoint;
  set rewardPoint(String rewardPoint) => _rewardPoint = rewardPoint;
  String get code => _code;
  set code(String code) => _code = code;
  String get name => _name;
  set name(String name) => _name = name;
  String get appDescription => _appDescription;
  set appDescription(String appDescription) => _appDescription = appDescription;
  String get description => _description;
  set description(String description) => _description = description;
  String get orderNumber => _orderNumber;
  set orderNumber(String orderNumber) => _orderNumber = orderNumber;
  String get symbolLeft => _symbolLeft;
  set symbolLeft(String symbolLeft) => _symbolLeft = symbolLeft;
  String get symbolRight => _symbolRight;
  set symbolRight(String symbolRight) => _symbolRight = symbolRight;
  String get productactivation => _productactivation;
  set productactivation(String productactivation) =>
      _productactivation = productactivation;
  String get productinactivation => _productinactivation;
  set productinactivation(String productinactivation) =>
      _productinactivation = productinactivation;
  String get editproduct => _editproduct;
  set editproduct(String editproduct) => _editproduct = editproduct;
  String get defaultPrice => _defaultPrice;
  set defaultPrice(String defaultPrice) => _defaultPrice = defaultPrice;
  String get cost => _cost;
  set cost(String cost) => _cost = cost;
  String get returnPeriod => _returnPeriod;
  set returnPeriod(String returnPeriod) => _returnPeriod = returnPeriod;
  String get stock => _stock;
  set stock(String stock) => _stock = stock;
  String get minQuantity => _minQuantity;
  set minQuantity(String minQuantity) => _minQuantity = minQuantity;
  String get tags => _tags;
  set tags(String tags) => _tags = tags;
  String get categoryId => _categoryId;
  set categoryId(String categoryId) => _categoryId = categoryId;
  String get categoryParentId => _categoryParentId;
  set categoryParentId(String categoryParentId) =>
      _categoryParentId = categoryParentId;
  String get isShowInList => _isShowInList;
  set isShowInList(String isShowInList) => _isShowInList = isShowInList;
  String get productActive => _productActive;
  set productActive(String productActive) => _productActive = productActive;
  String get currentPrice => _currentPrice;
  set currentPrice(String currentPrice) => _currentPrice = currentPrice;
  String get image => _image;
  set image(String image) => _image = image;
  String get store => _store;
  set store(String store) => _store = store;
  String get manufacturer => _manufacturer;
  set manufacturer(String manufacturer) => _manufacturer = manufacturer;
  List<Specifications> get specifications => _specifications;
  set specifications(List<Specifications> specifications) =>
      _specifications = specifications;
  List<ProductImages> get productImages => _productImages;
  set productImages(List<ProductImages> productImages) =>
      _productImages = productImages;
  List<Images> get images => _images;
  set images(List<Images> images) => _images = images;

  Products.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'].toString();
    _slug = json['slug'].toString();
    _status = json['status'];
    _storeslug = json['storeslug'].toString();
    _purchaseReward = json['purchase_reward'].toString();
    _rewardPoint = json['reward_point'].toString();
    _code = json['code'].toString();
    _name = json['name'].toString();
    _appDescription = json['app_description'].toString();
    _description = json['description'].toString();
    _orderNumber = json['order_number'].toString();
    _symbolLeft = json['symbol_left'].toString();
    _symbolRight = json['symbol_right'].toString();
    _productactivation = json['productactivation'].toString();
    _productinactivation = json['productinactivation'].toString();
    _editproduct = json['editproduct'].toString();
    _defaultPrice = json['default_price'].toString();
    _cost = json['cost'].toString();
    _returnPeriod = json['return_period'].toString();
    _stock = json['stock'].toString();
    _minQuantity = json['min_quantity'].toString();
    _tags = json['tags'].toString();
    _categoryId = json['category_id'].toString();
    _categoryParentId = json['category_parent_id'].toString();
    _isShowInList = json['is_show_in_list'].toString();
    _productActive = json['product_active'].toString();
    _currentPrice = json['current_price'].toString();
    _image = json['image'].toString();
    _store = json['store'].toString();
    _manufacturer = json['manufacturer'].toString();
    if (json['specifications'] != null) {
      _specifications = new List<Specifications>();
      json['specifications'].forEach((v) {
        _specifications.add(new Specifications.fromJson(v));
      });
    }
    if (json['product_images'] != null) {
      _productImages = new List<ProductImages>();
      json['product_images'].forEach((v) {
        _productImages.add(new ProductImages.fromJson(v));
      });
    }
    if (json['images'] != null) {
      _images = new List<Images>();
      json['images'].forEach((v) {
        _images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['slug'] = this._slug;
    data['status'] = this._status;
    data['storeslug'] = this._storeslug;
    data['purchase_reward'] = this._purchaseReward;
    data['reward_point'] = this._rewardPoint;
    data['code'] = this._code;
    data['name'] = this._name;
    data['app_description'] = this._appDescription;
    data['description'] = this._description;
    data['order_number'] = this._orderNumber;
    data['symbol_left'] = this._symbolLeft;
    data['symbol_right'] = this._symbolRight;
    data['productactivation'] = this._productactivation;
    data['productinactivation'] = this._productinactivation;
    data['editproduct'] = this._editproduct;
    data['default_price'] = this._defaultPrice;
    data['cost'] = this._cost;
    data['return_period'] = this._returnPeriod;
    data['stock'] = this._stock;
    data['min_quantity'] = this._minQuantity;
    data['tags'] = this._tags;
    data['category_id'] = this._categoryId;
    data['category_parent_id'] = this._categoryParentId;
    data['is_show_in_list'] = this._isShowInList;
    data['product_active'] = this._productActive;
    data['current_price'] = this._currentPrice;
    data['image'] = this._image;
    data['store'] = this._store;
    data['manufacturer'] = this._manufacturer;
    if (this._specifications != null) {
      data['specifications'] =
          this._specifications.map((v) => v.toJson()).toList();
    }
    if (this._productImages != null) {
      data['product_images'] =
          this._productImages.map((v) => v.toJson()).toList();
    }
    else
    {
      images = [];
    }
    return data;
  }
}

class Images {
  String image;
  Images.fromJson(dynamic json) {
    image = json["image"].toString();
  }
}

class Specifications {
  int _id;
  int _productId;
  int _specificationId;
  String _createdAt;
  String _updatedAt;
  Specification _specification;
  List<Values> _values;

  Specifications(
      {int id,
        int productId,
        int specificationId,
        String createdAt,
        String updatedAt,
        Specification specification,
        List<Values> values}) {
    this._id = id;
    this._productId = productId;
    this._specificationId = specificationId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._specification = specification;
    this._values = values;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get productId => _productId;
  set productId(int productId) => _productId = productId;
  int get specificationId => _specificationId;
  set specificationId(int specificationId) =>
      _specificationId = specificationId;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  Specification get specification => _specification;
  set specification(Specification specification) =>
      _specification = specification;
  List<Values> get values => _values;
  set values(List<Values> values) => _values = values;

  Specifications.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _specificationId = json['specification_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _specification = json['specification'] != null
        ? new Specification.fromJson(json['specification'])
        : null;
    if (json['values'] != null) {
      _values = new List<Values>();
      json['values'].forEach((v) {
        _values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_id'] = this._productId;
    data['specification_id'] = this._specificationId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    if (this._specification != null) {
      data['specification'] = this._specification.toJson();
    }
    if (this._values != null) {
      data['values'] = this._values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specification {
  int _id;
  int _specificationGroupId;
  int _inQuickview;
  int _inFilter;
  int _status;
  String _createdAt;
  String _updatedAt;
  Language _language;

  Specification(
      {int id,
        int specificationGroupId,
        int inQuickview,
        int inFilter,
        int status,
        String createdAt,
        String updatedAt,
        Language language}) {
    this._id = id;
    this._specificationGroupId = specificationGroupId;
    this._inQuickview = inQuickview;
    this._inFilter = inFilter;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._language = language;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get specificationGroupId => _specificationGroupId;
  set specificationGroupId(int specificationGroupId) =>
      _specificationGroupId = specificationGroupId;
  int get inQuickview => _inQuickview;
  set inQuickview(int inQuickview) => _inQuickview = inQuickview;
  int get inFilter => _inFilter;
  set inFilter(int inFilter) => _inFilter = inFilter;
  int get status => _status;
  set status(int status) => _status = status;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  Language get language => _language;
  set language(Language language) => _language = language;

  Specification.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _specificationGroupId = json['specification_group_id'];
    _inQuickview = json['in_quickview'];
    _inFilter = json['in_filter'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _language = json['language'] != null
        ? new Language.fromJson(json['language'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['specification_group_id'] = this._specificationGroupId;
    data['in_quickview'] = this._inQuickview;
    data['in_filter'] = this._inFilter;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    if (this._language != null) {
      data['language'] = this._language.toJson();
    }
    return data;
  }
}

class Language {
  int _id;
  int _specificationId;
  int _languageId;
  String _name;
  String _createdAt;
  String _updatedAt;

  Language(
      {int id,
        int specificationId,
        int languageId,
        String name,
        String createdAt,
        String updatedAt}) {
    this._id = id;
    this._specificationId = specificationId;
    this._languageId = languageId;
    this._name = name;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get specificationId => _specificationId;
  set specificationId(int specificationId) =>
      _specificationId = specificationId;
  int get languageId => _languageId;
  set languageId(int languageId) => _languageId = languageId;
  String get name => _name;
  set name(String name) => _name = name;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;

  Language.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _specificationId = json['specification_id'];
    _languageId = json['language_id'];
    _name = json['name'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['specification_id'] = this._specificationId;
    data['language_id'] = this._languageId;
    data['name'] = this._name;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class Values {
  int _id;
  int _productSpecificationId;
  int _specificationValueId;
  String _createdAt;
  String _updatedAt;
  List<Languages> _languages;

  Values(
      {int id,
        int productSpecificationId,
        int specificationValueId,
        String createdAt,
        String updatedAt,
        List<Languages> languages}) {
    this._id = id;
    this._productSpecificationId = productSpecificationId;
    this._specificationValueId = specificationValueId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._languages = languages;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get productSpecificationId => _productSpecificationId;
  set productSpecificationId(int productSpecificationId) =>
      _productSpecificationId = productSpecificationId;
  int get specificationValueId => _specificationValueId;
  set specificationValueId(int specificationValueId) =>
      _specificationValueId = specificationValueId;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  List<Languages> get languages => _languages;
  set languages(List<Languages> languages) => _languages = languages;

  Values.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productSpecificationId = json['product_specification_id'];
    _specificationValueId = json['specification_value_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['languages'] != null) {
      _languages = new List<Languages>();
      json['languages'].forEach((v) {
        _languages.add(new Languages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_specification_id'] = this._productSpecificationId;
    data['specification_value_id'] = this._specificationValueId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    if (this._languages != null) {
      data['languages'] = this._languages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Languages {
  int _id;
  int _specificationValueId;
  int _languageId;
  String _value;
  String _createdAt;
  String _updatedAt;

  Languages(
      {int id,
        int specificationValueId,
        int languageId,
        String value,
        String createdAt,
        String updatedAt}) {
    this._id = id;
    this._specificationValueId = specificationValueId;
    this._languageId = languageId;
    this._value = value;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get specificationValueId => _specificationValueId;
  set specificationValueId(int specificationValueId) =>
      _specificationValueId = specificationValueId;
  int get languageId => _languageId;
  set languageId(int languageId) => _languageId = languageId;
  String get value => _value;
  set value(String value) => _value = value;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;

  Languages.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _specificationValueId = json['specification_value_id'];
    _languageId = json['language_id'];
    _value = json['value'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['specification_value_id'] = this._specificationValueId;
    data['language_id'] = this._languageId;
    data['value'] = this._value;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class ProductImages {
  int _id;
  String _image;
  int _isDefault;

  ProductImages({int id, String image, int isDefault}) {
    this._id = id;
    this._image = image;
    this._isDefault = isDefault;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get image => _image;
  set image(String image) => _image = image;
  int get isDefault => _isDefault;
  set isDefault(int isDefault) => _isDefault = isDefault;

  ProductImages.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _image = json['image'];
    _isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['image'] = this._image;
    data['is_default'] = this._isDefault;
    return data;
  }
}
