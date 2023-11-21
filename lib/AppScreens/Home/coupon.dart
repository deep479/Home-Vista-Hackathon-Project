// ignore_for_file: depend_on_referenced_packages, avoid_print, unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ucservice_customer/custom_widegt/Colors.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';

import '../../ApiServices/Api_werper.dart';
import '../../ApiServices/url.dart';
import 'home_screen.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;

class MyCupon extends StatefulWidget {
  final String? bill;
  final String? vendorID;
  const MyCupon({super.key, this.vendorID, this.bill});

  @override
  State<MyCupon> createState() => _MyCuponState();
}

class _MyCuponState extends State<MyCupon> {
  dynamic bill = 0.0;
  @override
  void initState() {
    super.initState();
    setState(() {});
    bill = double.parse(widget.bill.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: bgcolor,
        leading: BackButton(color: BlackColor),
        title: Text("Coupon",
            style: TextStyle(color: BlackColor, fontFamily: "Gilroy Bold")),
      ),
      backgroundColor: bgcolor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              FutureBuilder(
                future: getCouponList(),
                builder: (ctx, AsyncSnapshot snap) {
                  if (snap.hasData) {
                    var users = snap.data;
                    return users.length == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: Get.height * 0.18),
                              Image(
                                  image: const AssetImage(
                                      "assets/emptyCoupon.png"),
                                  height: Get.height * 0.16),
                              SizedBox(height: Get.height * 0.04),
                              const Center(
                                child: Text("Sorry, No coupon found",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: 'Gilroy Bold',
                                    )),
                              ),
                              SizedBox(height: Get.height * 0.02),
                            ],
                          )
                        : Ink(
                            height: Get.height * 0.85,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: users.length,
                              itemBuilder: (ctx, i) {
                                return couponList(users, i);
                              },
                            ),
                          );
                  } else {
                    return Column(
                      children: [
                        SizedBox(height: Get.height * 0.35),
                        Center(child: isLoadingIndicator()),
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  cupon(
      {text1, text2, exdate, buttontext, Function()? onClick, Color? bColor}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(text1,
            style: TextStyle(
                fontSize: 14, color: greycolor, fontFamily: "Gilroy Medium")),
        const SizedBox(height: 4),
        Text(text2,
            style: TextStyle(
                fontSize: 16, color: BlackColor, fontFamily: "Gilroy Bold")),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Text("Ex Date : ",
                  style: TextStyle(
                      fontSize: 14,
                      color: BlackColor,
                      fontFamily: "Gilroy Medium")),
              Text(exdate ?? "",
                  style: TextStyle(
                      fontSize: 14,
                      color: greycolor,
                      fontFamily: "Gilroy Medium")),
            ],
          ),
        ),
        const SizedBox(height: 4),
      ]),
      InkWell(
        onTap: onClick,
        child: Container(
          height: 40,
          width: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: bColor),
          child: Center(
            child: Text(buttontext,
                style: TextStyle(
                    fontSize: 15,
                    color: WhiteColor,
                    fontFamily: "Gilroy Bold")),
          ),
        ),
      ),
    ]);
  }

  couponList(user, i) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: WhiteColor),
          child: Column(
            children: [
              ListTile(
                  leading: Container(
                    height: 80,
                    width: Get.width * 0.20,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          Config.imgBaseUrl + user[i]["coupon_img"],
                        )),
                  ),
                  title: Ink(
                    child: Text(user[i]["title"].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: "Gilroy Bold",
                            fontSize: 16,
                            color: BlackColor)),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user[i]["subtitle"].toString(),
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: greycolor,
                              fontFamily: "Gilroy Medium")),
                      ReadMoreText(
                        user[i]["description"],
                        trimLines: 2,
                        lessStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: buttonColor),
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' Show more',
                        trimExpandedText: ' Show less',
                        moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: buttonColor),
                      ),
                    ],
                  )),
              bill > double.parse(user[i]["min_amt"].toString())
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: cupon(
                          text1: "Voucher Code",
                          text2: user[i]["coupon_code"].toString(),
                          exdate: "${user[i]["expire_date"]}",
                          buttontext: "Use",
                          bColor: buttonColor,
                          onClick: () {
                            couponCheckApi(user[i]);
                          }),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: cupon(
                        text1: "Voucher Code",
                        text2: user[i]["coupon_code"].toString(),
                        exdate: "${user[i]["expire_date"]}",
                        bColor: buttonColor.withOpacity(0.3),
                        buttontext: "Use",
                      ),
                    )
            ],
          ),
        ));
  }

  Future getCouponList() async {
    var body = {"vendor_id": widget.vendorID};
    log(body.toString(), name: "Get Coupon list Api : ");
    try {
      var url = Uri.parse(Config.baseUrl + Config.couponList);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(body));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        print(response["couponlist"]);
        return response["couponlist"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  Future couponCheckApi(user) async {
    var data = {"uid": uid, "cid": user["id"]};
    ApiWrapper.dataPost(Config.checkCoupon, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          Get.back(result: user);
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
