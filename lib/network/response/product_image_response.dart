class ProductImageResponse {
  int success;
  String message;
  List<Images> images;

  ProductImageResponse({this.success, this.message, this.images});

  ProductImageResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int id;
  String image;
  int isDefault;

  Images({this.id, this.image, this.isDefault});

  Images.fromJson(Map<String, dynamic> json) {
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
