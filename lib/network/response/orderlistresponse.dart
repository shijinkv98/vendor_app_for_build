class OrderStatusListResponse {
  List<OrderStatusList> orderStatusList;
  int success;
  String message;

  OrderStatusListResponse({this.orderStatusList, this.success, this.message});

  OrderStatusListResponse.fromJson(Map<String, dynamic> json) {
    if (json['order_status_list'] != null) {
      orderStatusList = new List<OrderStatusList>();
      json['order_status_list'].forEach((v) {
        orderStatusList.add(new OrderStatusList.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderStatusList != null) {
      data['order_status_list'] =
          this.orderStatusList.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class OrderStatusList {
  int statusId;
  String statusText;

  OrderStatusList({this.statusId, this.statusText});

  OrderStatusList.fromJson(Map<String, dynamic> json) {
    statusId = json['status_id'];
    statusText = json['status_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_id'] = this.statusId;
    data['status_text'] = this.statusText;
    return data;
  }
}
