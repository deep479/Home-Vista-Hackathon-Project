// ignore_for_file: must_be_immutable, avoid_print, prefer_const_constructors, unused_catch_clause, prefer_is_empty, await_only_futures, depend_on_referenced_packages, prefer_typing_uninitialized_variables, file_names, unrelated_type_equality_checks

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/AppScreens/Home/vendorCat.dart';
import 'package:ucservice_customer/Controller/AppControllerApi.dart';
import 'package:ucservice_customer/AppScreens/Home/salon_at_home_for_woman_screen.dart';
import 'package:ucservice_customer/custom_widegt/Colors.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiServices/Api_werper.dart';
import '../../DataSqf/maineList.dart';

class SeeAllPage extends StatefulWidget {
  final String? catTital;
  const SeeAllPage({
    Key? key,
    this.catTital,
  }) : super(key: key);

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  final x = Get.put(AppControllerApi());
  bool isSelected = true;
  bool isSelectedGrid = false;
  bool isVisibalVertical = true;
  bool isLoading = false;
  final subWise = UserServiceData();
  var userlength;
  List vendorlist = [];

  final search = TextEditingController();

  @override
  void initState() {
    setState(() {});
    viewAllProviderApia();
    insertData();

    super.initState();
  }

  vendorSearchApi(String? val) {
    isLoading = true;
    setState(() {});
    var data = {"keyword": val, "lats": lat, "longs": long, "cat_id": "0"};
    ApiWrapper.dataPost(Config.vendorsearch, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          vendorlist = val["VendorSearchData"];
          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }
      }
    });
  }

  insertData() {
    subWise.saveServiceData(
        serviceid: '',
        mtitle: '',
        quantity: '',
        img: '',
        video: '',
        servicetype: '',
        title: '',
        taketime: '',
        maxquantity: '',
        price: '',
        discount: '',
        servicedesc: '',
        status: '',
        isapprove: '');
  }

  late ColorNotifire notifire;
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: notifire.detail,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.03),
            //! Search textField
            Container(
              width: Get.width,
              color: notifire.bg,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: notifire.getprimerycolor,
                      borderRadius: BorderRadius.circular(14)),
                  child: TextField(
                      controller: search,
                      onChanged: (val) {
                        val.length != 0
                            ? vendorSearchApi(val)
                            : viewAllProviderApia();
                      },
                      cursorColor: notifire.getdarkscolor,
                      decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back,
                                  color: notifire.getdarkscolor)),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Image(
                                image: AssetImage("assets/roundSearch.png"),
                                height: 4),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: notifire.getprimerycolor,
                              ),
                              borderRadius: BorderRadius.circular(14)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: notifire.getprimerycolor),
                              borderRadius: BorderRadius.circular(16)),
                          hintText: 'Search Category')),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            !isLoading
                ? vendorlist.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Container(
                          decoration: BoxDecoration(
                              color: notifire.getprimerycolor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: Get.width * 0.50,
                                        child: Text(
                                          widget.catTital ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: notifire.getdarkscolor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily:
                                                  CustomColors.fontFamily,
                                              fontSize: 18),
                                        )),
                                    const Spacer(),
                                    //! ------- List view To GridView List -------
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isSelected = !isSelected;
                                              isSelectedGrid = false;
                                              isVisibalVertical = true;
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: CustomColors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      blurRadius: 6,
                                                      blurStyle:
                                                          BlurStyle.normal),
                                                ]),
                                            child: isSelected
                                                ? const Icon(Icons.menu,
                                                    color: CustomColors
                                                        .primaryColor)
                                                : const Icon(Icons.menu,
                                                    color: CustomColors.black),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isSelectedGrid = !isSelectedGrid;
                                              isSelected = false;
                                              isVisibalVertical = false;
                                            });
                                          },
                                          child: Container(
                                              height: 50,
                                              width: 50,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14),
                                              decoration: BoxDecoration(
                                                color: CustomColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      blurRadius: 6,
                                                      blurStyle:
                                                          BlurStyle.normal),
                                                ],
                                              ),
                                              child: isSelectedGrid
                                                  ? const Icon(
                                                      Icons.grid_on_outlined,
                                                      color: CustomColors
                                                          .primaryColor)
                                                  : Icon(
                                                      Icons.grid_on_outlined)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 10),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 5),
                                  child: Column(
                                    children: [
                                      vendorlist.length == 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 5),
                                              child: Column(children: [
                                                SizedBox(
                                                    height: Get.height * 0.10),
                                                Image(
                                                  image: AssetImage(
                                                      "assets/emptyList1.png"),
                                                  height: Get.height * 0.28,
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.04),
                                                Center(
                                                  child: SizedBox(
                                                    width: Get.width * 0.80,
                                                    child: Text(
                                                        "Sorry, there is no any nearby category or data not found ",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: notifire
                                                                .getdarkscolor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                CustomColors
                                                                    .fontFamily,
                                                            fontSize: 18)),
                                                  ),
                                                ),
                                              ]),
                                            )
                                          : isVisibalVertical == true
                                              ? SizedBox(
                                                  height: Get.height * 0.74,
                                                  child: ListView.builder(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          vendorlist.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int i) {
                                                        return userList(
                                                            vendorlist, i);
                                                      }),
                                                )
                                              : SizedBox(
                                                  height: Get.height * 0.74,
                                                  child: GridView.builder(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            mainAxisSpacing: 2,
                                                            crossAxisSpacing: 2,
                                                            childAspectRatio:
                                                                0.62),
                                                    itemBuilder: (context, i) =>
                                                        userGridview(
                                                            vendorlist, i),
                                                    itemCount:
                                                        vendorlist.length,
                                                  ),
                                                ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        child: Column(children: [
                          SizedBox(height: Get.height * 0.10),
                          Image(
                              image: AssetImage("assets/emptyList1.png"),
                              height: Get.height * 0.28),
                          SizedBox(height: Get.height * 0.04),
                          Center(
                            child: SizedBox(
                              width: Get.width * 0.80,
                              child: Text(
                                  "Sorry, there is no any nearby category or data not found ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: notifire.getdarkscolor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: CustomColors.fontFamily,
                                      fontSize: 18)),
                            ),
                          ),
                        ]),
                      )
                : Column(
                    children: [
                      SizedBox(height: Get.height * 0.34),
                      Center(
                        child: SizedBox(
                          child: isLoadingIndicator(),
                        ),
                      )
                    ],
                  ),
          ],
        ));
  }

  userList(users, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          setState(() {});
          selectCartList.clear();
          Get.to(
            () => VendorCatAllPage(
                title: users[i]["provider_title"],
                pID: users[i]["provider_id"]),
          );
        },
        child: SizedBox(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                        imageUrl:
                            "${Config.imgBaseUrl}${users[i]["provider_img"]}",
                        fit: BoxFit.cover,
                        height: 160,
                        width: 150)),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Image.asset(ImagePath.starImg, scale: 22),
                      Text(users[i]["provider_rate"] ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: notifire.getdarkscolor)),
                    ],
                  ),
                  const SizedBox(height: 7),
                  SizedBox(
                    width: Get.width * 0.3,
                    child: Text(users[i]["provider_title"] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: notifire.getdarkscolor,
                            fontFamily: CustomColors.fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                  const SizedBox(height: 8),
                  Text("Satrts From",
                      style: TextStyle(
                          color: notifire.greyfont,
                          fontFamily: CustomColors.fontFamily,
                          fontSize: 14)),
                  const SizedBox(height: 12),
                  Container(
                    height: 28,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CustomColors.accentColor),
                    child: Center(
                      child: Text("$currency${users[i]["start_from"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: BlackColor)),
                    ),
                  ),
                ]),
                const Spacer(),
                Icon(
                  Icons.more_horiz,
                  color: notifire.getdarkscolor,
                ),
              ]),
        ),
      ),
    );
  }

  userGridview(users, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          setState(() {});
          selectCartList.clear();
          Get.to(
            () => VendorCatAllPage(
                title: users[i]["provider_title"],
                pID: users[i]["provider_id"]),
          );
        },
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                    imageUrl: "${Config.imgBaseUrl}${users[i]["provider_img"]}",
                    fit: BoxFit.cover,
                    height: 140,
                    width: 150),
              ),
              const SizedBox(height: 8),
              Text(users[i]["provider_title"] ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
              const SizedBox(height: 3),
              const Text(TextString.startsFrom,
                  style: TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.grey,
                      fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomColors.accentColor),
                    child: Center(
                      child: Text("$currency${users[i]["start_from"] ?? ""}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(ImagePath.starImg, scale: 22),
                      Text(
                        users[i]["provider_rate"] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future viewAllProviderApia() async {
    isLoading = true;
    setState(() {});
    var body = {
      "uid": uid,
      "lats": lat ?? "21.2381646",
      "longs": long ?? "72.8878507",
    };
    try {
      var url = Uri.parse(Config.baseUrl + Config.viewAllprovider);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(body));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        isLoading = false;
        setState(() {});
        vendorlist = response["ProviderData"];
        return response["ProviderData"];
      } else {
        setState(() {});
        vendorlist = [];
        isLoading = false;
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }
}
