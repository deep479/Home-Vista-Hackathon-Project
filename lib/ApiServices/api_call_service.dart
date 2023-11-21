// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unused_catch_clause

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/model/edit_profile_model.dart';
import 'package:ucservice_customer/model/forget_password_model.dart';
import 'package:ucservice_customer/model/image_upload_model.dart';
import 'package:ucservice_customer/model/login_model.dart';
import 'package:ucservice_customer/model/register_model.dart';
import 'package:ucservice_customer/BootomBar.dart';
import 'package:ucservice_customer/loginAuth/login_screen.dart';
import 'package:ucservice_customer/loginAuth/otpverification_screen_2.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../AppScreens/Home/home_screen.dart';

class ApiService {
  Dio dio = Dio();

  // String? uid;

  /// Get Login Data
  getLoginData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('loginModel'));
    var jsondecode = jsonDecode(mydata.toString());
    if (kDebugMode) {}

    loginModel = LoginModel.fromJson(jsondecode);
    uid = loginModel!.userLogin!.id!;
  }

  /// set Image
  setImage() async {
    String raJson = jsonEncode(imageUploadModel);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("imageUploadModel", raJson);
  }

  setData() async {
    String raJson = jsonEncode(registerModel);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("registerModel", raJson);
  }

  setLoginData() async {
    String raJson = jsonEncode(loginModel);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("loginModel", raJson);
    if (kDebugMode) {}
    if (kDebugMode) {}
  }

  /// ------------------------------- Register Api ----------------------------- ///
  RegisterModel? registerModel;

  Future registerApi(String? name, email, mobile, countryCode, password,
      refcode, context) async {
    try {
      var params = {
        "name": name,
        "email": email,
        "mobile": mobile,
        "ccode": countryCode,
        "password": password,
        "refercode": refcode
      };

      final response =
          await dio.post(Config.baseUrl + Config.register, data: params);
      if (response.statusCode == 200) {
        save("Firstuser", true);
        save("Remember", true);
        save("UserLogin", response.data["UserLogin"]);
        loginModel = LoginModel.fromJson(response.data);
        setData();
        setLoginData();

        if (loginModel!.result == "true") {
          save("Firstuser", true);
          save("UserLogin", response.data["UserLogin"]);
          uid = response.data["UserLogin"]["id"];
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavigationBarScreen()));
        } else {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        }
      }
    } on DioError {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  LoginModel? loginModel;
  Future loginApi(String? mobile, password, context, type) async {
    try {
      var params = {"mobile": mobile, "password": password};

      final response =
          await dio.post(Config.baseUrl + Config.login, data: params);
      if (response.statusCode == 200) {
        loginModel = LoginModel.fromJson(response.data);
        setLoginData();
        setImage();

        if (loginModel?.result == "true") {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
          save("Firstuser", true);
          save("UserLogin", response.data["UserLogin"]);
          uid = response.data["UserLogin"]["id"];
          if (type == "payment") {
            Get.back();
          } else {
            Get.off(() => const BottomNavigationBarScreen());
          }

          (route) => false;

          /// OneSignal Shared SendTag
          OneSignal.shared.sendTag("user_id", loginModel?.userLogin?.id);
        } else if (loginModel == null) {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        } else {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        }
      }
    } on DioError {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  loginApi2(String? mobile, password, context, type) async {
    try {
      var params = {"mobile": mobile, "password": password};

      final response =
          await dio.post(Config.baseUrl + Config.login, data: params);
      if (response.statusCode == 200) {
        loginModel = LoginModel.fromJson(response.data);
        setLoginData();
        setImage();

        if (loginModel?.result == "true") {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
          if (type == "payment") {
            Get.back();
          } else {
            Get.off(() => const BottomNavigationBarScreen());
          }
          (route) => false;

          /// OneSignal Shared SendTag
          OneSignal.shared.sendTag("user_id", loginModel?.userLogin?.id);
          save("Firstuser", false);
          save("UserLogin", response.data["UserLogin"]);
        } else if (loginModel == null) {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        } else {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        }
      }
    } on DioError {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  /// --------------------------- forgot Password Api ----------------------------- ///
  ForgotPasswordModel? forgotPasswordModel;

  /// Forgot password Api
  Future forgetPasswordApi(String? number, password, context) async {
    try {
      var params = {"mobile": number, "password": password};
      final response =
          await dio.post(Config.baseUrl + Config.forgotPassword, data: params);
      if (response.statusCode == 200) {
        forgotPasswordModel = ForgotPasswordModel.fromJson(response.data);

        if (forgotPasswordModel?.result == "true") {
          Fluttertoast.showToast(msg: "${forgotPasswordModel?.responseMsg}");
          Get.to(() => const LoginScreen());
        } else if (forgotPasswordModel == null) {
          Fluttertoast.showToast(msg: "${forgotPasswordModel?.responseMsg}");
        } else {
          Fluttertoast.showToast(msg: "${forgotPasswordModel?.responseMsg}");
        }
      }
    } on DioError {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  /// Forgot verification code
  Future<void> forgotVerifyPhone(number, context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + number,
      verificationCompleted: (PhoneAuthCredential credential) {
        // ApiWrapper.showToastMessage("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        // ApiWrapper.showToastMessage("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) async {
        var signature = await SmsAutoFill().getAppSignature;

        print(signature);
        Fluttertoast.showToast(msg: "Otp sent successfully");
        Get.to(() => OtpVerificationScreenTwo());
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // ApiWrapper.showToastMessage("Timeout!");
      },
    );
  }

  /// -------------------------- Profile Image UpLoad Api --------------------------///
  ImageUploadModel? imageUploadModel;
  profileImageUploadApi(String? image, context) async {
    try {
      var params = {
        "uid": uid,
        "img": image,
      };

      final response =
          await dio.post(Config.baseUrl + Config.profileImage, data: params);
      if (response.statusCode == 200) {
        loginModel = LoginModel.fromJson(response.data);
        setLoginData();
        setData();
        if (loginModel?.result == "true") {
          save("UserLogin", response.data["UserLogin"]);

          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        } else if (loginModel == null) {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        } else {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        }
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  /// -------------------------- Profile Edit Api --------------------------///
  EditProfileModel? editProfileModel;
  profileEditApi(String? uid, name, password, context) async {
    try {
      var params = {"name": name, "password": password, "uid": uid};
      final response =
          await dio.post(Config.baseUrl + Config.profileEdit, data: params);
      if (response.statusCode == 200) {
        loginModel = LoginModel.fromJson(response.data);

        setLoginData();
        if (loginModel?.result == "true") {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
          Navigator.pop(context);

          /// Get Login Data
          getLoginData();
        } else if (loginModel == null) {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        } else {
          Fluttertoast.showToast(msg: "${loginModel?.responseMsg}");
        }
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: "Error");
    }
  }
}
