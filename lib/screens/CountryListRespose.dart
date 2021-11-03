class CountryList {
  int success;
  String message;
  List<Countries> countries;

  CountryList({this.success, this.message, this.countries});

  CountryList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['countries'] != null) {
      countries = new List<Countries>();
      json['countries'].forEach((v) {
        countries.add(new Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.countries != null) {
      data['countries'] = this.countries.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Countries {
  String id;
  String name;
  String shortcode;
  int dialCode;
  int deliveryAvailable;
  Null createdAt;
  String updatedAt;

  Countries(
      {this.id,
        this.name,
        this.shortcode,
        this.dialCode,
        this.deliveryAvailable,
        this.createdAt,
        this.updatedAt});

  Countries.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    shortcode = json['shortcode'];
    dialCode = json['dial_code'];
    deliveryAvailable = json['delivery_available'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shortcode'] = this.shortcode;
    data['dial_code'] = this.dialCode;
    data['delivery_available'] = this.deliveryAvailable;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}