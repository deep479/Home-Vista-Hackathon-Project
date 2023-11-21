// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucservice_customer/ApiServices/api_call_service.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/BootomBar.dart';
import 'package:ucservice_customer/loginAuth/login_screen.dart';
import 'package:ucservice_customer/AppScreens/pagview_onbording_screen.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiServices/Api_werper.dart';
import '../ApiServices/url.dart';

var countryCode = [];

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    cCodeApi();
    setState(() {});
    uid = "0";
    Timer(
        const Duration(seconds: 2),
        () => getData.read("Firstuser") != true
            ? Get.to(() => PagviewOnordingScreen())
            : getData.read("Remember") != true
                ? Get.to(() => LoginScreen())
                : Get.to(() => BottomNavigationBarScreen()));

    super.initState();
  }

  //! user CountryCode
  cCodeApi() {
    ApiWrapper.dataGet(Config.countryCodea).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["CountryCode"].forEach((e) {
            countryCode.add(e['ccode']);
          });
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Column(children: [
        SizedBox(height: Get.height * 0.36),
        Center(child: Image.asset(ImagePath.applogo, scale: 14)),
        SizedBox(height: 14),
        Text(
          "Homevista",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
              letterSpacing: 0.5),
        )
      ]),
    );
  }
}
