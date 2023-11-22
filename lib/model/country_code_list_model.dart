class CountryCodeListModel {
  List<CountryCode>? countryCode;
  String? responseCode;
  String? result;
  String? responseMsg;

  CountryCodeListModel(
      {this.countryCode, this.responseCode, this.result, this.responseMsg});

  CountryCodeListModel.fromJson(Map<String, dynamic> json) {
    if (json['CountryCode'] != null) {
      countryCode = <CountryCode>[];
      json['CountryCode'].forEach((v) {
        countryCode!.add(CountryCode.fromJson(v));
      });
    }
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (countryCode != null) {
      data['CountryCode'] = countryCode!.map((v) => v.toJson()).toList();
    }
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    return data;
  }
}

class CountryCode {
  String? id;
  String? ccode;
  String? status;

  CountryCode({this.id, this.ccode, this.status});

  CountryCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ccode = json['ccode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ccode'] = ccode;
    data['status'] = status;
    return data;
  }
}
