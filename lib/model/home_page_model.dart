class HomePageModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  HomeData? homeData;

  HomePageModel(
      {this.responseCode, this.result, this.responseMsg, this.homeData});

  HomePageModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    homeData =
        json['HomeData'] != null ? HomeData.fromJson(json['HomeData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (homeData != null) {
      data['HomeData'] = homeData!.toJson();
    }
    return data;
  }
}

class HomeData {
  List<Banner>? banner;
  List<Catlist>? catlist;
  String? currency;
  String? referCredit;
  String? wallet;
  List<ProviderData>? providerData;
  List<SectionData>? sectionData;

  HomeData(
      {this.banner,
      this.catlist,
      this.currency,
      this.referCredit,
      this.wallet,
      this.providerData,
      this.sectionData});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['Banner'] != null) {
      banner = <Banner>[];
      json['Banner'].forEach((v) {
        banner!.add(Banner.fromJson(v));
      });
    }
    if (json['Catlist'] != null) {
      catlist = <Catlist>[];
      json['Catlist'].forEach((v) {
        catlist!.add(Catlist.fromJson(v));
      });
    }
    currency = json['currency'];
    referCredit = json['Refer_Credit'];
    wallet = json['wallet'].toString();
    if (json['Provider_Data'] != null) {
      providerData = <ProviderData>[];
      json['Provider_Data'].forEach((v) {
        providerData!.add(ProviderData.fromJson(v));
      });
    }
    if (json['SectionData'] != null) {
      sectionData = <SectionData>[];
      json['SectionData'].forEach((v) {
        sectionData!.add(SectionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (banner != null) {
      data['Banner'] = banner!.map((v) => v.toJson()).toList();
    }
    if (catlist != null) {
      data['Catlist'] = catlist!.map((v) => v.toJson()).toList();
    }
    data['currency'] = currency;
    data['Refer_Credit'] = referCredit;
    data['wallet'] = wallet;
    if (providerData != null) {
      data['Provider_Data'] = providerData!.map((v) => v.toJson()).toList();
    }
    if (sectionData != null) {
      data['SectionData'] = sectionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  String? id;
  String? img;

  Banner({this.id, this.img});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['img'] = img;
    return data;
  }
}

class Catlist {
  String? id;
  String? title;
  String? catImg;

  Catlist({this.id, this.title, this.catImg});

  Catlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    catImg = json['cat_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['cat_img'] = catImg;
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

class SectionData {
  String? sectionId;
  String? catId;
  String? sectionTitle;
  List<ItemList>? itemList;

  SectionData({this.sectionId, this.catId, this.sectionTitle, this.itemList});

  SectionData.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    catId = json['cat_id'];
    sectionTitle = json['section_title'];
    if (json['item_list'] != null) {
      itemList = <ItemList>[];
      json['item_list'].forEach((v) {
        itemList!.add(ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['section_id'] = sectionId;
    data['cat_id'] = catId;
    data['section_title'] = sectionTitle;
    if (itemList != null) {
      data['item_list'] = itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemList {
  String? itemTitle;
  String? itemImg;

  ItemList({this.itemTitle, this.itemImg});

  ItemList.fromJson(Map<String, dynamic> json) {
    itemTitle = json['item_title'];
    itemImg = json['item_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_title'] = itemTitle;
    data['item_img'] = itemImg;
    return data;
  }
}
