class ProfileResponse {
  String success;
  String message;
  String joined;
  String orders;
  String profilePhoto;
  String logo;
  String banner;
  String email;
  String storename;
  String phoneNumber;
  String mobileVerified;
  String emailVerified;
  String latitude;
  String longtitude;
  String country;
  String location;
  String storeVerifiedStatus;
  String facebook;
  String whatsapp;
  String instagram;
  String youtube;
  String websiteUrl;
  String freeDeliveryRadius;
  String minDeliveryCharge;
  String freeDeliveryAmount;
  String storeTime;
  String editProfile;
  String changeVendorPassword;
  String logout;
  String is_closed;
  String whatsapp_prefix;
  ProfileResponse(
      {this.success,
        this.message,
        this.joined,
        this.orders,
        this.profilePhoto,
        this.logo,
        this.banner,
        this.email,
        this.storename,
        this.phoneNumber,
        this.mobileVerified,
        this.emailVerified,
        this.latitude,
        this.longtitude,
        this.country,
        this.location,
        this.storeVerifiedStatus,
        this.facebook,
        this.whatsapp,
        this.instagram,
        this.youtube,
        this.websiteUrl,
        this.freeDeliveryRadius,
        this.minDeliveryCharge,
        this.freeDeliveryAmount,
        this.storeTime,
        this.editProfile,
        this.changeVendorPassword,
        this.is_closed,
        this.logout,
        this.whatsapp_prefix});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    message = json['message'].toString();
    joined = json['joined'].toString();
    orders = json['orders'].toString();
    profilePhoto = json['profile_photo'];
    logo = json['logo'];
    banner = json['banner'];
    email = json['email'].toString();
    storename = json['storename'].toString();
    phoneNumber = json['phone_number'].toString();
    mobileVerified = json['mobile_verified'].toString();
    emailVerified = json['email_verified'].toString();
    latitude = json['latitude'].toString();
    longtitude = json['longtitude'].toString();
    country = json['country'].toString();
    location = json['location'].toString();
    storeVerifiedStatus = json['store_verified_status'].toString();
    facebook = json['facebook'].toString();
    whatsapp = json['whatsapp'].toString();
    instagram = json['instagram'].toString();
    youtube = json['youtube'].toString();
    websiteUrl = json['website_url'].toString();
    freeDeliveryRadius = json['free_delivery_radius'].toString();
    minDeliveryCharge = json['min_delivery_charge'].toString();
    freeDeliveryAmount = json['free_delivery_amount'].toString();
    storeTime = json['store_time'].toString();
    editProfile = json['edit_profile'].toString();
    changeVendorPassword = json['change_vendor_password'];
    logout = json['logout'];
    is_closed = json['is_closed'].toString();
    whatsapp_prefix = json['whatsapp_prefix'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['joined'] = this.joined;
    data['orders'] = this.orders;
    data['profile_photo'] = this.profilePhoto;
    data['logo'] = this.logo;
    data['banner'] = this.banner;
    data['email'] = this.email;
    data['storename'] = this.storename;
    data['phone_number'] = this.phoneNumber;
    data['mobile_verified'] = this.mobileVerified;
    data['email_verified'] = this.emailVerified;
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longtitude;
    data['country'] = this.country;
    data['location'] = this.location;
    data['store_verified_status'] = this.storeVerifiedStatus;
    data['facebook'] = this.facebook;
    data['whatsapp'] = this.whatsapp;
    data['instagram'] = this.instagram;
    data['youtube'] = this.youtube;
    data['website_url'] = this.websiteUrl;
    data['free_delivery_radius'] = this.freeDeliveryRadius;
    data['min_delivery_charge'] = this.minDeliveryCharge;
    data['free_delivery_amount'] = this.freeDeliveryAmount;
    data['store_time'] = this.storeTime;
    data['edit_profile'] = this.editProfile;
    data['change_vendor_password'] = this.changeVendorPassword;
    data['logout'] = this.logout;
    data['is_closed'] = this.is_closed;
    data['whatsapp_prefix'] = this.whatsapp_prefix;
    return data;
  }
}
