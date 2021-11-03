class VendorEditProductResponse {
  int success;
  String message;
  Products product;
  List<SpecificationEdit> specification;
  List<Manufacturers> manufacturers;

  VendorEditProductResponse(
      {this.success,
        this.message,
        this.product,
        this.specification,
        this.manufacturers});

  VendorEditProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    product =
    json['product'] != null ? new Products.fromJson(json['product']) : null;
    if (json['specification'] != null) {
      specification = new List<SpecificationEdit>();
      json['specification'].forEach((v) {
        specification.add(new SpecificationEdit.fromJson(v));
      });
    }
    if (json['manufacturers'] != null) {
      manufacturers = new List<Manufacturers>();
      json['manufacturers'].forEach((v) {
        manufacturers.add(new Manufacturers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    if (this.specification != null) {
      data['specification'] =
          this.specification.map((v) => v.toJson()).toList();
    }
    if (this.manufacturers != null) {
      data['manufacturers'] =
          this.manufacturers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String productId;
  String slug;
  String status;
  String storeslug;
  String purchaseReward;
  String rewardPoint;
  String code;
  String name;
  String appDescription;
  String description;
  String orderNumber;
  String symbolLeft;
  String symbolRight;
  String productactivation;
  String productinactivation;
  String editproduct;
  String defaultPrice;
  String cost;
  String returnPeriod;
  String stock;
  String minQuantity;
  String tags;
  String categoryId;
  String categoryParentId;
  String isShowInList;
  String productActive;
  String currentPrice;
  String image;
  String store;
  String manufacturer;
  List<SpecificationEdit> specifications;
  List<ProductImages> productImages;
  List<Images> images;

  Products(
      {this.productId,
        this.slug,
        this.status,
        this.storeslug,
        this.purchaseReward,
        this.rewardPoint,
        this.code,
        this.name,
        this.appDescription,
        this.description,
        this.orderNumber,
        this.symbolLeft,
        this.symbolRight,
        this.productactivation,
        this.productinactivation,
        this.editproduct,
        this.defaultPrice,
        this.cost,
        this.returnPeriod,
        this.stock,
        this.minQuantity,
        this.tags,
        this.categoryId,
        this.categoryParentId,
        this.isShowInList,
        this.productActive,
        this.currentPrice,
        this.image,
        this.store,
        this.manufacturer,
        this.specifications,
        this.productImages,
        this.images});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'].toString();
    slug = json['slug'].toString();
    status = json['status'].toString();
    storeslug = json['storeslug'].toString();
    purchaseReward = json['purchase_reward'].toString();
    rewardPoint = json['reward_point'].toString();
    code = json['code'].toString();
    name = json['name'].toString();
    appDescription = json['app_description'].toString();
    description = json['description'].toString();
    orderNumber = json['order_number'].toString();
    symbolLeft = json['symbol_left'].toString();
    symbolRight = json['symbol_right'].toString();
    productactivation = json['productactivation'].toString();
    productinactivation = json['productinactivation'].toString();
    editproduct = json['editproduct'].toString();
    defaultPrice = json['default_price'].toString();
    cost = json['cost'].toString();
    returnPeriod = json['return_period'].toString();
    stock = json['stock'].toString();
    minQuantity = json['min_quantity'].toString();
    tags = json['tags'].toString();
    categoryId = json['category_id'].toString();
    categoryParentId = json['category_parent_id'].toString();
    isShowInList = json['is_show_in_list'].toString();
    productActive = json['product_active'].toString();
    currentPrice = json['current_price'].toString();
    image = json['image'].toString();
    store = json['store'].toString();
    manufacturer = json['manufacturer'];
    if (json['specifications'] != null) {
      specifications = new List<SpecificationEdit>();
      json['specifications'].forEach((v) {
        specifications.add(new SpecificationEdit.fromJson(v));
      });
    }
    if (json['product_images'] != null) {
      productImages = new List<ProductImages>();
      json['product_images'].forEach((v) {
        productImages.add(new ProductImages.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['storeslug'] = this.storeslug;
    data['purchase_reward'] = this.purchaseReward;
    data['reward_point'] = this.rewardPoint;
    data['code'] = this.code;
    data['name'] = this.name;
    data['app_description'] = this.appDescription;
    data['description'] = this.description;
    data['order_number'] = this.orderNumber;
    data['symbol_left'] = this.symbolLeft;
    data['symbol_right'] = this.symbolRight;
    data['productactivation'] = this.productactivation;
    data['productinactivation'] = this.productinactivation;
    data['editproduct'] = this.editproduct;
    data['default_price'] = this.defaultPrice;
    data['cost'] = this.cost;
    data['return_period'] = this.returnPeriod;
    data['stock'] = this.stock;
    data['min_quantity'] = this.minQuantity;
    data['tags'] = this.tags;
    data['category_id'] = this.categoryId;
    data['category_parent_id'] = this.categoryParentId;
    data['is_show_in_list'] = this.isShowInList;
    data['product_active'] = this.productActive;
    data['current_price'] = this.currentPrice;
    data['image'] = this.image;
    data['store'] = this.store;
    data['manufacturer'] = this.manufacturer;
    if (this.specifications != null) {
      data['specifications'] =
          this.specifications.map((v) => v.toJson()).toList();
    }
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Images {
  String image;
  Images.fromJson(dynamic json) {
    image = json["image"].toString();
  }

  toJson() {}
}

class SpecificationEdit {
  int id;
  int productId;
  int specificationId;
  String createdAt;
  String updatedAt;
  Specification specification;
  List<Values> values;

  SpecificationEdit(
      {this.id,
        this.productId,
        this.specificationId,
        this.createdAt,
        this.updatedAt,
        this.specification,
        this.values});

  SpecificationEdit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    specificationId = json['specification_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    specification = json['specification'] != null
        ? new Specification.fromJson(json['specification'])
        : null;
    if (json['values'] != null) {
      values = new List<Values>();
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['specification_id'] = this.specificationId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.specification != null) {
      data['specification'] = this.specification.toJson();
    }
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specification {
  int id;
  int specificationGroupId;
  int inQuickview;
  int inFilter;
  int status;
  String createdAt;
  String updatedAt;
  Language language;

  Specification(
      {this.id,
        this.specificationGroupId,
        this.inQuickview,
        this.inFilter,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.language});

  Specification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specificationGroupId = json['specification_group_id'];
    inQuickview = json['in_quickview'];
    inFilter = json['in_filter'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    language = json['language'] != null
        ? new Language.fromJson(json['language'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specification_group_id'] = this.specificationGroupId;
    data['in_quickview'] = this.inQuickview;
    data['in_filter'] = this.inFilter;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.language != null) {
      data['language'] = this.language.toJson();
    }
    return data;
  }
}

class Language {
  int id;
  int specificationId;
  int languageId;
  String name;
  String createdAt;
  String updatedAt;

  Language(
      {this.id,
        this.specificationId,
        this.languageId,
        this.name,
        this.createdAt,
        this.updatedAt});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specificationId = json['specification_id'];
    languageId = json['language_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specification_id'] = this.specificationId;
    data['language_id'] = this.languageId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Values {
  int id;
  int productSpecificationId;
  int specificationValueId;
  String createdAt;
  String updatedAt;
  List<Languages> languages;

  Values(
      {this.id,
        this.productSpecificationId,
        this.specificationValueId,
        this.createdAt,
        this.updatedAt,
        this.languages});

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productSpecificationId = json['product_specification_id'];
    specificationValueId = json['specification_value_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['languages'] != null) {
      languages = new List<Languages>();
      json['languages'].forEach((v) {
        languages.add(new Languages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_specification_id'] = this.productSpecificationId;
    data['specification_value_id'] = this.specificationValueId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.languages != null) {
      data['languages'] = this.languages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Languages {
  int id;
  int specificationValueId;
  int languageId;
  String value;
  String createdAt;
  String updatedAt;

  Languages(
      {this.id,
        this.specificationValueId,
        this.languageId,
        this.value,
        this.createdAt,
        this.updatedAt});

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specificationValueId = json['specification_value_id'];
    languageId = json['language_id'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specification_value_id'] = this.specificationValueId;
    data['language_id'] = this.languageId;
    data['value'] = this.value;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ProductImages {
  int id;
  String image;
  int isDefault;

  ProductImages({this.id, this.image, this.isDefault});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['is_default'] = this.isDefault;
    return data;
  }
}

class Specificationss {
  int specificationId;
  String name;
  List<Values> values;

  Specificationss({this.specificationId, this.name, this.values});

  Specificationss.fromJson(Map<String, dynamic> json) {
    specificationId = json['specification_id'];
    name = json['name'];
    if (json['values'] != null) {
      values = new List<Values>();
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specification_id'] = this.specificationId;
    data['name'] = this.name;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Valuess {
  int id;
  String name;

  Valuess({this.id, this.name});

  Valuess.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Manufacturers {
  int id;
  int status;
  String image;
  String slug;
  String name;

  Manufacturers({this.id, this.status, this.image, this.slug, this.name});

  Manufacturers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    image = json['image'];
    slug = json['slug'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['image'] = this.image;
    data['slug'] = this.slug;
    data['name'] = this.name;
    return data;
  }
}
