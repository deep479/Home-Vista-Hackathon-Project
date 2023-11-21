// ignore_for_file: file_names, depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:ucservice_customer/utils/colors.dart';

import '../../ApiServices/Api_werper.dart';
import '../../ApiServices/url.dart';
import '../../utils/color_widget.dart';
import 'package:http/http.dart' as http;
import 'addWallet.dart';

class WalletReportPage extends StatefulWidget {
  final String? type;
  const WalletReportPage({Key? key, this.type}) : super(key: key);

  @override
  State<WalletReportPage> createState() => _WalletWalletReportPageState();
}

class _WalletWalletReportPageState extends State<WalletReportPage> {
  String? totalAmount = "0";

  @override
  void initState() {
    walletgetdata();
    super.initState();
  }

  late ColorNotifire notifire;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();

    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  walletgetdata1() async {
    var data = {"uid": uid};

    ApiWrapper.dataPost(Config.walletreport, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          totalAmount = val["wallet"];
        } else {
          setState(() {});
        }
      }
    });
  }

  Future walletgetdata() async {
    var data = {"uid": uid};
    try {
      var url = Uri.parse(Config.baseUrl + Config.walletreport);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        setState(() {});
        totalAmount = response["wallet"];
        return response["Walletitem"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    setState(() {
      totalAmount;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: widget.type == "hide"
            ? InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: notifire.getdarkscolor))
            : const SizedBox(),
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          "Wallet",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: notifire.getdarkscolor),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      floatingActionButton: SizedBox(
        height: 45,
        width: 410,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddWalletPage(amount: totalAmount))!.then((value) {
              walletgetdata();
            });
          },
          child: Custombutton.button(
              CustomColors.primaryColor,
              "Add AMOUNT".toUpperCase(),
              SizedBox(width: Get.width / 4),
              SizedBox(width: Get.width / 10)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.03),
            child: Container(
              height: Get.height * 0.20,
              width: Get.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/walletTop.png'),
                      fit: BoxFit.fill)),
              child: Padding(
                padding: EdgeInsets.only(left: Get.width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$currency$totalAmount",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: CustomColors.white),
                    ),
                    const Text(
                      "Your current Balance ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: CustomColors.white),
                    ),
                    Container(height: Get.height * 0.04)
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "History",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy Bold',
                    color: notifire.getdarkscolor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                FutureBuilder(
                  future: walletgetdata(),
                  builder: (context, AsyncSnapshot snap) {
                    if (snap.hasData) {
                      var users = snap.data;
                      return users.length != 0
                          ? SizedBox(
                              height: Get.height * 0.56,
                              child: ListView.builder(
                                itemCount: users.length,
                                padding:
                                    EdgeInsets.only(bottom: Get.height * 0.08),
                                shrinkWrap: true,
                                itemBuilder: (ctx, i) {
                                  return walletList(users, i);
                                },
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: Get.height * 0.12),
                                Image(
                                    image: const AssetImage(""),
                                    height: Get.height * 0.14),
                                SizedBox(height: Get.height * 0.02),
                                Center(
                                  child:
                                      Text("Looks like you haven't booked yet",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: 16,
                                            fontFamily: 'Gilroy Bold',
                                          )),
                                ),
                                SizedBox(height: Get.height * 0.02),
                              ],
                            );
                    } else {
                      return Center(child: isLoadingIndicator());
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  walletList(user, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        color: notifire.getprimerycolor,
        elevation: 0,
        child: Container(
          width: Get.width * 0.90,
          height: Get.height * 0.08,
          decoration: BoxDecoration(
            border: Border.all(color: notifire.getgreycolor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Image(
                  image: const AssetImage("assets/wallet1.png"),
                  height: Get.height * 0.05),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Ink(
                  width: Get.width * 0.60,
                  child: Text(
                    user[i]["message"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Gilroy Bold',
                        color: notifire.getdarkscolor),
                  ),
                ),
                Ink(
                  width: Get.width * 0.60,
                  child: Text(
                    user[i]["tdate"],
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Gilroy Medium',
                        color: notifire.greyfont),
                  ),
                ),
              ],
            ),
            SizedBox(width: Get.width * 0.02),
            user[i]["status"] == "Credit"
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      "${user[i]["amt"]}$currency+",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: CustomColors.primaryColor),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      "${user[i]["amt"]}$currency- ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: Colors.orange.shade300),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}

class Custombutton {
  static Widget button(clr, text, siz, siz2) {
    return Center(
        child: Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          color: clr),
      height: Get.height / 15,
      width: Get.width / 1.3,
      child: Row(children: [
        siz,
        Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        siz2,
      ]),
    ));
  }
}
