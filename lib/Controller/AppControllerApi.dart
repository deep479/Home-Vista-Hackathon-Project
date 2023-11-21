// ignore_for_file: depend_on_referenced_packages, file_names

import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ucservice_customer/ApiServices/Api_werper.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/model/category_wise_model.dart';
import 'package:http/http.dart' as http;

List vendorlist = [];
List viewAllSectionlist = [];

class AppControllerApi extends GetxController {
  CategoryWiseModel? categoryWiseModel;
  List subCatList = [];

  //! ---------------- Category Wise Provider Api -------------------

  Future categoryWiseProviderApi(catID) async {
    var body = {
      "uid": "0",
      "lats": lat,
      "longs": long,
      "cat_id": catID ?? "0",
    };
    try {
      var url = Uri.parse(Config.baseUrl + Config.catWiseProvider);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(body));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        vendorlist = response["ProviderData"];

        categoryWiseModel = CategoryWiseModel.fromJson(response);
        return response["ProviderData"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  Future viewAllProviderApia() async {
    var body = {
      "uid": uid,
      "lats": lat,
      "longs": long,
    };
    try {
      var url = Uri.parse(Config.baseUrl + Config.viewAllprovider);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(body));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        categoryWiseModel = CategoryWiseModel.fromJson(response);
        return response["ProviderData"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  Future viewAllSectionApi(sectionID) async {
    var body = {
      "uid": "0",
      "lats": lat,
      "longs": long,
      "section_id": sectionID,
    };
    try {
      var url = Uri.parse(Config.baseUrl + Config.viewAllpSectionItem);

      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(body));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        categoryWiseModel = CategoryWiseModel.fromJson(response);
        viewAllSectionlist = response["ItemData"][0]["item_list"];
        return response["ItemData"][0]["item_list"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  Future providerWiseCategoryList(String? venID) async {
    var body = {"vendor_id": venID};
    try {
      var url = Uri.parse(Config.baseUrl + Config.catList);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(body));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        return response["Catlist"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  Future subCategoryApi(vendorID, catID) async {
    var body = {
      "vendor_id": vendorID ?? "0",
      "cat_id": catID ?? "0",
    };
    try {
      var url = Uri.parse(Config.baseUrl + Config.serviceDetail);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(body));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        subCatList = response["ServiceData"]["Subcategory"];
        update();
        return response["ServiceData"]["Subcategory"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }
}
