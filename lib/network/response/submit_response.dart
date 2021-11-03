class SubmitResponse {
  bool success;
  String message;

  SubmitResponse({this.success = true, this.message});

  SubmitResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] == "1" ? true : false;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
