// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously, must_be_immutable, duplicate_ignore

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ucservice_customer/ApiServices/api_call_service.dart';
import 'package:ucservice_customer/custom_widegt/widegt.dart';
import 'package:ucservice_customer/model/register_model.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiServices/Api_werper.dart';

// ignore: must_be_immutable
//! register
class OtpVarificationScreen extends StatefulWidget {
  String? verID;
  String? number;
  OtpVarificationScreen({Key? key, this.number, this.verID}) : super(key: key);

  @override
  State<OtpVarificationScreen> createState() => _OtpVarificationScreenState();
}

class _OtpVarificationScreenState extends State<OtpVarificationScreen> {
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController pinPutController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Timer? timer;
  int _start = 60;

  String? name;
  String? email;
  String? mobile;
  String? password;
  String? confirmPassword;
  String? referralCode;
  String? countryCode;

  String? _verificationCode;

  var height;
  var width;
  late ColorNotifire notifire;
  bool isLoading = false;
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  Future getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name");
      email = prefs.getString("email");
      mobile = prefs.getString("mobile");
      password = prefs.getString("password");
      confirmPassword = prefs.getString("confirmPassword");
      referralCode = prefs.getString("referralCode");
      countryCode = prefs.getString("countryCode");
    });
    // verifyPhone();
  }

  RegisterModel? registerModel;
  bool resendotp = false;

  @override
  void initState() {
    isLoading = true;
    getData();
    startTimer();
    super.initState();
  }

  formattedTime(timeinsecond) {
    int sec = timeinsecond % 60;
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return second;
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: notifire.getprimerycolor,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: notifire.getdarkscolor, size: 28),
              onPressed: () {
                Get.back();
              }),
          title: Text(TextString.otpVerification,
              style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontWeight: FontWeight.bold,
                  fontFamily: CustomColors.fontFamily,
                  fontSize: 18)),
        ),
        body: isLoading != false
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                              child: Text(
                            TextString.AnAuthentecationcodehasbeensentto,
                            style: TextStyle(
                                color: CustomColors.grayBlack,
                                fontSize: 14,
                                fontFamily: CustomColors.fontFamily),
                          )),
                          const SizedBox(height: 5),
                          Text(
                            "($countryCode) $mobile",
                            style: const TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: CustomColors.fontFamily),
                          ),
                          const SizedBox(height: 35),
                          Pinput(
                              length: 6,
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              pinputAutovalidateMode:
                                  PinputAutovalidateMode.onSubmit,
                              showCursor: true,
                              controller: pinPutController,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              defaultPinTheme: defaultPinTheme,
                              onSubmitted: (pin) async {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithCredential(
                                          PhoneAuthProvider.credential(
                                              verificationId:
                                                  _verificationCode!,
                                              smsCode: pin))
                                      .then((value) async {
                                    if (value.user != null) {
                                      _verifyPhone(context);
                                    }
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Invalid OTP")));
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your otp';
                                }
                                return null;
                              }),
                          const SizedBox(height: 24),
                          submitButton(),
                          const SizedBox(height: 24),
                          resendotp
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      InkWell(
                                        onTap: () {
                                          pinPutController.clear();
                                          _verifyPhone(context);
                                        },
                                        child: Text(
                                          "Re-send OTP",
                                          style: TextStyle(
                                              color: notifire.getdarkscolor,
                                              fontSize: 16,
                                              fontFamily: 'Gilroy Bold'),
                                        ),
                                      )
                                    ])
                              : SizedBox(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                      Text(
                                        "Re-send code in ",
                                        style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: 16,
                                            fontFamily: 'Gilroy Medium'),
                                      ),
                                      Text(
                                        durationToString(_start).toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: notifire.getdarkscolor,
                                            fontSize: 16),
                                      ),
                                    ])),
                        ]),
                  ),
                ),
              )
            : Center(heightFactor: height / 50, child: isLoadingIndicator()));
  }

  /// ----------------------------------- Submit Button ------------------------------------------------///
  Widget submitButton() {
    return AppButton(
        buttontext: TextString.submit,
        onclick: () async {
          if (_formKey.currentState!.validate()) {
            try {
              _verifyPhone(context);
            } catch (e) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Invalid OTP")));
            }
          }
        });
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w700),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12)),
  );

  Future<void> _verifyPhone(BuildContext context) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verID!, smsCode: pinPutController.text);
    print("phoneAuthCredential:::$phoneAuthCredential");
    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  final auth = FirebaseAuth.instance;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        ApiService().registerApi(
            name, email, mobile, countryCode, password, referralCode, context);

        ApiWrapper.showToastMessage("Auth Completed!");
      } else {
        ApiWrapper.showToastMessage("Auth Failed!");
      }
    } on FirebaseAuthException catch (e) {
      ApiWrapper.showToastMessage("Auth Failedaaaa! ");
      print(e);
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            resendotp = true;
            timer.cancel();
          });
        } else {
          setState(() {});
          _start--;
        }
      },
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
}
