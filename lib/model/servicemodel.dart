// ignore_for_file: unnecessary_this

class ServiceDetailModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  ServiceData? serviceData;

  ServiceDetailModel(
      {this.responseCode, this.result, this.responseMsg, this.serviceData});

  ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    serviceData = json['ServiceData'] != null
        ? ServiceData.fromJson(json['ServiceData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = this.responseCode;
    data['Result'] = this.result;
    data['ResponseMsg'] = this.responseMsg;
    if (this.serviceData != null) {
      data['ServiceData'] = this.serviceData!.toJson();
    }
    return data;
  }
}

class ServiceData {
  List<String>? cover;
  Provider? provider;
  List<Subcategory>? subcategory;
  List<SubWiseServiceData>? subWiseServiceData;
  List<CouponList>? couponList;

  ServiceData(
      {this.cover,
      this.provider,
      this.subcategory,
      this.subWiseServiceData,
      this.couponList});

  ServiceData.fromJson(Map<String, dynamic> json) {
    cover = json['Cover'].cast<String>();
    provider =
        json['Provider'] != null ? Provider.fromJson(json['Provider']) : null;
    if (json['Subcategory'] != null) {
      subcategory = <Subcategory>[];
      json['Subcategory'].forEach((v) {
        subcategory!.add(Subcategory.fromJson(v));
      });
    }
    if (json['SubWiseServiceData'] != null) {
      subWiseServiceData = <SubWiseServiceData>[];
      json['SubWiseServiceData'].forEach((v) {
        subWiseServiceData!.add(SubWiseServiceData.fromJson(v));
      });
    }
    if (json['CouponList'] != null) {
      couponList = <CouponList>[];
      json['CouponList'].forEach((v) {
        couponList!.add(CouponList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Cover'] = this.cover;
    if (this.provider != null) {
      data['Provider'] = this.provider!.toJson();
    }
    if (this.subcategory != null) {
      data['Subcategory'] = this.subcategory!.map((v) => v.toJson()).toList();
    }
    if (this.subWiseServiceData != null) {
      data['SubWiseServiceData'] =
          this.subWiseServiceData!.map((v) => v.toJson()).toList();
    }
    if (this.couponList != null) {
      data['CouponList'] = this.couponList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Provider {
  String? id;
  String? couponImg;
  String? expireDate;
  String? description;
  String? subtitle;
  String? couponVal;
  String? couponCode;
  String? title;
  String? minAmt;
  String? providerId;
  String? providerImg;
  String? providerTitle;
  String? providerRate;
  dynamic startFrom;

  Provider(
      {this.id,
      this.couponImg,
      this.expireDate,
      this.description,
      this.subtitle,
      this.couponVal,
      this.couponCode,
      this.title,
      this.minAmt,
      this.providerId,
      this.providerImg,
      this.providerTitle,
      this.providerRate,
      this.startFrom});

  Provider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponImg = json['coupon_img'];
    expireDate = json['expire_date'];
    description = json['description'];
    subtitle = json['subtitle'];
    couponVal = json['coupon_val'];
    couponCode = json['coupon_code'];
    title = json['title'];
    minAmt = json['min_amt'];
    providerId = json['provider_id'];
    providerImg = json['provider_img'];
    providerTitle = json['provider_title'];
    providerRate = json['provider_rate'];
    startFrom = json['start_from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['coupon_img'] = this.couponImg;
    data['expire_date'] = this.expireDate;
    data['description'] = this.description;
    data['subtitle'] = this.subtitle;
    data['coupon_val'] = this.couponVal;
    data['coupon_code'] = this.couponCode;
    data['title'] = this.title;
    data['min_amt'] = this.minAmt;
    data['provider_id'] = this.providerId;
    data['provider_img'] = this.providerImg;
    data['provider_title'] = this.providerTitle;
    data['provider_rate'] = this.providerRate;
    data['start_from'] = this.startFrom;
    return data;
  }

  // static ColorNotifire of(BuildContext context, {required bool listen}) {}

  // static ColorNotifire of(BuildContext context, {required bool listen}) {}
}

class Subcategory {
  String? id;
  String? catId;
  String? title;
  String? img;
  String? status;
  String? vendorId;
  String? isApprove;

  Subcategory(
      {this.id,
      this.catId,
      this.title,
      this.img,
      this.status,
      this.vendorId,
      this.isApprove});

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catId = json['cat_id'];
    title = json['title'];
    img = json['img'];
    status = json['status'];
    vendorId = json['vendor_id'];
    isApprove = json['is_approve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['cat_id'] = this.catId;
    data['title'] = this.title;
    data['img'] = this.img;
    data['status'] = this.status;
    data['vendor_id'] = this.vendorId;
    data['is_approve'] = this.isApprove;
    return data;
  }
}

class SubWiseServiceData {
  String? subId;
  String? subTitle;
  List<Servicelist>? servicelist;

  SubWiseServiceData({this.subId, this.subTitle, this.servicelist});

  SubWiseServiceData.fromJson(Map<String, dynamic> json) {
    subId = json['sub_id'];
    subTitle = json['sub_title'];
    if (json['servicelist'] != null) {
      servicelist = <Servicelist>[];
      json['servicelist'].forEach((v) {
        servicelist!.add(Servicelist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_id'] = this.subId;
    data['sub_title'] = this.subTitle;
    if (this.servicelist != null) {
      data['servicelist'] = this.servicelist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

String tableNotes = "serviceList";

class NoteFields {
  // static final List<String> values = [
  //   /// Add all fields
  //   id, isImportant, number, title, description, time
  // ];

  static const String id = 'id';
  static const String serviceId = 'service_id';
  static const String img = 'img';
  static const String video = 'video';
  static const String serviceType = 'service_type';
  static const String title = 'title';
  static const String takeTime = 'take_time';
  static const String maxQuantity = 'max_quantity';
  static const String price = 'price';
  static const String discount = 'discount';
  static const String serviceDesc = 'service_desc';
  static const String status = 'status';
  static const String isApprove = 'is_approve';
}

class Servicelist {
  String? serviceId;
  String? img;
  String? video;
  String? serviceType;
  String? title;
  String? takeTime;
  String? maxQuantity;
  String? price;
  String? discount;
  String? serviceDesc;
  String? status;
  String? isApprove;

  Servicelist(
      {this.serviceId,
      this.img,
      this.video,
      this.serviceType,
      this.title,
      this.takeTime,
      this.maxQuantity,
      this.price,
      this.discount,
      this.serviceDesc,
      this.status,
      this.isApprove});

  Servicelist.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    img = json['img'];
    video = json['video'];
    serviceType = json['service_type'];
    title = json['title'];
    takeTime = json['take_time'];
    maxQuantity = json['max_quantity'];
    price = json['price'];
    discount = json['discount'];
    serviceDesc = json['service_desc'];
    status = json['status'];
    isApprove = json['is_approve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = this.serviceId;
    data['img'] = this.img;
    data['video'] = this.video;
    data['service_type'] = this.serviceType;
    data['title'] = this.title;
    data['take_time'] = this.takeTime;
    data['max_quantity'] = this.maxQuantity;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['service_desc'] = this.serviceDesc;
    data['status'] = this.status;
    data['is_approve'] = this.isApprove;
    return data;
  }
}

class CouponList {
  String? id;
  String? couponImg;
  String? expireDate;
  String? description;
  String? subtitle;
  String? couponVal;
  String? couponCode;
  String? title;
  String? minAmt;

  CouponList(
      {this.id,
      this.couponImg,
      this.expireDate,
      this.description,
      this.subtitle,
      this.couponVal,
      this.couponCode,
      this.title,
      this.minAmt});

  CouponList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponImg = json['coupon_img'];
    expireDate = json['expire_date'];
    description = json['description'];
    subtitle = json['subtitle'];
    couponVal = json['coupon_val'];
    couponCode = json['coupon_code'];
    title = json['title'];
    minAmt = json['min_amt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['coupon_img'] = this.couponImg;
    data['expire_date'] = this.expireDate;
    data['description'] = this.description;
    data['subtitle'] = this.subtitle;
    data['coupon_val'] = this.couponVal;
    data['coupon_code'] = this.couponCode;
    data['title'] = this.title;
    data['min_amt'] = this.minAmt;
    return data;
  }
}
