class CategoryWiseModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  List<ProviderData>? providerData;

  CategoryWiseModel(
      {this.responseCode, this.result, this.responseMsg, this.providerData});

  CategoryWiseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    if (json['ProviderData'] != null) {
      providerData = <ProviderData>[];
      json['ProviderData'].forEach((v) {
        providerData!.add(ProviderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (providerData != null) {
      data['ProviderData'] = providerData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProviderData {
  String? providerId;
  String? providerImg;
  String? providerTitle;
  String? providerRate;
  dynamic startFrom;

  ProviderData(
      {this.providerId,
      this.providerImg,
      this.providerTitle,
      this.providerRate,
      this.startFrom});

  ProviderData.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    providerImg = json['provider_img'];
    providerTitle = json['provider_title'];
    providerRate = json['provider_rate'];
    startFrom = json['start_from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provider_id'] = providerId;
    data['provider_img'] = providerImg;
    data['provider_title'] = providerTitle;
    data['provider_rate'] = providerRate;
    data['start_from'] = startFrom;
    return data;
  }
}
