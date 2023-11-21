// ignore_for_file: avoid_print, duplicate_ignore, must_be_immutable, unused_catch_clause, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiServices/Api_werper.dart';
import '../custom_widegt/widegt.dart';
import 'change_password_screen.dart';

//! forgot password send
class OtpVerificationScreenTwo extends StatefulWidget {
  String? mobile;
  String? verID;
  String? ccode;
  String? type;
  OtpVerificationScreenTwo(
      {Key? key, this.mobile, this.ccode, this.verID, this.type})
      : super(key: key);

  @override
  State<OtpVerificationScreenTwo> createState() =>
      _OtpVerificationScreenTwoState();
}

class _OtpVerificationScreenTwoState extends State<OtpVerificationScreenTwo> {
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController pinPutController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool resendotp = false;

  String? name;
  String? email;
  String? mobile;
  String? password;
  String? confirmPassword;
  String? referralCode;
  String? countryCode;
  String? verificationCode;

  var height;
  var width;

  bool isLoading = false;

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
  }

  Timer? timer;
  int _start = 30;
  formatedTime(timeinsecond) {
    int sec = timeinsecond % 60;

    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return second;
  }

  @override
  void initState() {
    getData();
    isLoading = true;
    startTimer();

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

  String? vID = "";

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {
        ApiWrapper.showToastMessage("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        ApiWrapper.showToastMessage("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        ApiWrapper.showToastMessage("OTP Sent!");
        vID = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        ApiWrapper.showToastMessage("Timeout!");
      },
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: notifire.getprimerycolor,
        appBar: AppBar(
          backgroundColor: notifire.getprimerycolor,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: notifire.getdarkscolor, size: 28),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            TextString.otpVerification,
            style: TextStyle(
                color: notifire.getdarkscolor,
                fontWeight: FontWeight.bold,
                fontFamily: CustomColors.fontFamily,
                fontSize: 18),
          ),
          centerTitle: true,
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
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "(${widget.ccode}) ${widget.mobile}",
                            style: const TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: CustomColors.fontFamily),
                          ),
                          const SizedBox(height: 35),

                          /// Pin Put Field
                          Pinput(
                              length: 6,
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              defaultPinTheme: defaultPinTheme,
                              pinputAutovalidateMode:
                                  PinputAutovalidateMode.onSubmit,
                              showCursor: true,
                              controller: pinPutController,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              onCompleted: (pin) => print(pin),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your otp';
                                }
                                return null;
                              }),
                          const SizedBox(height: 24),

                          /// Submit Button
                          submitButton(),

                          const SizedBox(height: 24),
                          resendotp
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      InkWell(
                                        onTap: () {
                                          pinPutController.clear();
                                          verifyPhone(widget.mobile.toString());
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ],
                                )),
                        ]),
                  ),
                ),
              )
            : Center(
                heightFactor: height / 50,
                child: const CircularProgressIndicator(
                  backgroundColor: CustomColors.primaryColor,
                ),
              ));
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
        Get.to(() =>
            ChangePasswordScreen(type: widget.type, mobile: widget.mobile));

        ApiWrapper.showToastMessage("Auth Completed!");
      } else {
        ApiWrapper.showToastMessage("Auth Failed!");
      }
    } on FirebaseAuthException catch (e) {
      ApiWrapper.showToastMessage("Auth Failed! ");
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
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
