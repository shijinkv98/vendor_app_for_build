class VendorCategoryResponse {
  int success;
  String message;
  List<Categories> categories;

  VendorCategoryResponse({this.success, this.message, this.categories});

  VendorCategoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String slug;
  String name;
  String image;
  String products_count;

  Categories({this.slug, this.name, this.image,this.products_count});

  Categories.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    name = json['name'].toString();
    image = json['image'].toString();
    products_count = json['products_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['image'] = this.image;
    data['products_count'] = this.products_count;
    return data;
  }
}
