class OfferBannersResponse {
  int success;
  String message;
  Data data;

  OfferBannersResponse({this.success, this.message, this.data});

  OfferBannersResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Ads> allAds;
  List<Ads> onGoing;
  List<Ads> history;

  Data({this.allAds, this.onGoing, this.history});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['All Ads'] != null) {
      allAds = new List<Ads>();
      json['All Ads'].forEach((v) {
        allAds.add(new Ads.fromJson(v));
      });
    }
    if (json['On Going'] != null) {
      onGoing = new List<Ads>();
      json['On Going'].forEach((v) {
        onGoing.add(new Ads.fromJson(v));
      });
    }
    if (json['History'] != null) {
      history = new List<Ads>();
      json['History'].forEach((v) {
        history.add(new Ads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allAds != null) {
      data['All Ads'] = this.allAds.map((v) => v.toJson()).toList();
    }
    if (this.onGoing != null) {
      data['On Going'] = this.onGoing.map((v) => v.toJson()).toList();
    }
    if (this.history != null) {
      data['History'] = this.history.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ads {
  int id;
  int vendorId;
  String image;
  String description;
  String startTime;
  String endTime;
  String status;
  String createdAt;
  String updatedAt;
  String deletedAt;

  Ads(
      {this.id,
        this.vendorId,
        this.image,
        this.description,
        this.startTime,
        this.endTime,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    image = json['image'];
    description = json['description'].toString();
    startTime = json['start_time'];
    endTime = json['end_time'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['image'] = this.image;
    data['description'] = this.description;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
