// ignore_for_file: file_names, unnecessary_brace_in_string_interps, depend_on_referenced_packages, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:ucservice_customer/ApiServices/Api_werper.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ucservice_customer/utils/colors.dart';

import '../../ApiServices/url.dart';
import '../../utils/color_widget.dart';
import '../Wallet/WalletHistory.dart';

class ReferFriendPage extends StatefulWidget {
  final String? amount;
  const ReferFriendPage({Key? key, this.amount}) : super(key: key);

  @override
  State<ReferFriendPage> createState() => _ReferFriendPageState();
}

class _ReferFriendPageState extends State<ReferFriendPage> {
  final addAmount = TextEditingController();
  String code = "0";
  String signupcredit = "0";
  String refercredit = "0";
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;

  @override
  void initState() {
    walletrefar();
    getPackage();
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

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  walletrefar() async {
    var data = {"uid": uid};

    ApiWrapper.dataPost(Config.referdata, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          code = val["code"];
          signupcredit = val["signupcredit"];
          refercredit = val["refercredit"];
        } else {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      floatingActionButton: SizedBox(
        height: 45,
        width: 410,
        child: FloatingActionButton(
          onPressed: () {
            share();
          },
          child: Custombutton.button(
              CustomColors.primaryColor,
              "Refer a friend".toUpperCase(),
              SizedBox(width: Get.width / 4.5),
              SizedBox(width: Get.width / 10)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          SizedBox(height: Get.height / 20),
          //! ------- AppBar -------

          Row(children: [
            SizedBox(width: Get.width / 40),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Row(children: [
                Icon(Icons.arrow_back, color: notifire.getdarkscolor),
                SizedBox(width: Get.width / 80),
                Text(
                  "Refer a Friend",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Gilroy Medium',
                      color: notifire.getdarkscolor),
                ),
              ]),
            ),
          ]),
          SizedBox(height: Get.height * 0.08),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Image.asset('assets/refer.png', height: 140)),
                SizedBox(height: Get.height * 0.03),
                Column(
                  children: [
                    SizedBox(
                      width: Get.width * 0.60,
                      child: Text(
                        "Earn $currency${refercredit} for Each Friend you refer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilroy Bold',
                            color: notifire.getdarkscolor),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.04),
                    rowText(title: "Share the referral link with your fiends"),
                    SizedBox(height: Get.height * 0.01),
                    rowText(
                        title:
                            "Friend get $currency${refercredit} on their first complete transaction"),
                    SizedBox(height: Get.height * 0.01),
                    rowText(
                        title:
                            "You get $currency${signupcredit} on your wallet"),
                    SizedBox(height: Get.height * 0.04),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "#$code"));
                        ApiWrapper.showToastMessage("Copied to Code");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Tooltip(
                              preferBelow: false,
                              message: "Copy",
                              child: Text("#$code",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Gilroy Medium',
                                      color: notifire.getdarkscolor))),
                          const SizedBox(width: 8),
                          Image(
                              image: const AssetImage("assets/Copy.png"),
                              color: notifire.getdarkscolor,
                              height: Get.height * 0.02)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: '$appName',
        text:
            'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code $code & Enjoy your shopping !!!',
        linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
        chooserTitle: '$appName');
  }

  rowText({String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Icon(Icons.circle, color: notifire.getdarkscolor, size: 8),
          SizedBox(width: Get.width * 0.02),
          Ink(
            width: Get.width * 0.77,
            child: Text(title ?? "",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy Medium',
                    color: notifire.getdarkscolor)),
          ),
        ],
      ),
    );
  }
}
