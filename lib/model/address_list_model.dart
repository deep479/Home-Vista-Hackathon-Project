class AddressListModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  List<AddressList>? addressList;

  AddressListModel(
      {this.responseCode, this.result, this.responseMsg, this.addressList});

  AddressListModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    if (json['AddressList'] != null) {
      addressList = <AddressList>[];
      json['AddressList'].forEach((v) {
        addressList!.add(AddressList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (addressList != null) {
      data['AddressList'] = addressList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressList {
  String? id;
  String? uid;
  String? hno;
  String? address;
  String? cName;
  String? cNumber;
  String? latMap;
  String? longMap;
  String? landmark;
  String? type;

  AddressList(
      {this.id,
      this.uid,
      this.hno,
      this.address,
      this.cName,
      this.cNumber,
      this.latMap,
      this.longMap,
      this.landmark,
      this.type});

  AddressList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    hno = json['hno'];
    address = json['address'];
    cName = json['c_name'];
    cNumber = json['c_number'];
    latMap = json['lat_map'];
    longMap = json['long_map'];
    landmark = json['landmark'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['hno'] = hno;
    data['address'] = address;
    data['c_name'] = cName;
    data['c_number'] = cNumber;
    data['lat_map'] = latMap;
    data['long_map'] = longMap;
    data['landmark'] = landmark;
    data['type'] = type;
    return data;
  }
}
