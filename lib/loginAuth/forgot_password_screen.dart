// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/model/register_model.dart';
import 'package:ucservice_customer/loginAuth/otpverification_screen_2.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:ucservice_customer/widget/text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiServices/Api_werper.dart';
import '../IntroScreen/splash_screen.dart';
import '../utils/AppWidget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String? _selectedCountryCode = '';
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController mobileController = TextEditingController();

  String? mobile;
  String? countryCodeString;
  Future getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobile = prefs.getString("mobile");
      countryCodeString = prefs.getString("countryCode");
    });
  }

  RegisterModel? registerModel;

  getRegisterData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('registerModel'));
    var jsondecode = jsonDecode(mydata.toString());
    print(jsondecode);
    setState(() {});
  }

  @override
  void initState() {
    setState(() {
      _selectedCountryCode = countryCode.first;
    });
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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      appBar: AppBar(
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: notifire.getdarkscolor, size: 28),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(TextString.forgetPassword,
            style: TextStyle(
                color: notifire.getdarkscolor,
                fontWeight: FontWeight.bold,
                fontFamily: CustomColors.fontFamily,
                fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: !isloading
              ? Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TextString.forgetPassword,
                        style: TextStyle(
                            fontSize: 36,
                            color: notifire.getdarkscolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: CustomColors.fontFamily),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        TextString.Enteryourmobilenumbertoresetpassword,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: CustomColors.fontFamily,
                            color: CustomColors.grey),
                      ),
                      const SizedBox(height: 28),
                      phoneNumberTextField(),
                      const SizedBox(height: 28),
                      resetButton(),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(height: Get.height * 0.40),
                    Center(
                      child: SizedBox(
                        child: isLoadingIndicator(),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  /// phone Number Field
  Widget phoneNumberTextField() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 1, color: Colors.grey)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [cpicker()],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: CustomTextfield(
              fieldController: mobileController,
              hint: TextString.mobileNumber,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                return null;
              },
              fieldInputType: TextInputType.number,
              hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------- Reset Button ------------------------------------------------///
  Widget resetButton() {
    return InkWell(
      onTap: () {
        if (mobileController.text.isNotEmpty) {
          verifyPhone(_selectedCountryCode! + mobileController.text);
        } else {
          ApiWrapper.showToastMessage('Please enter your mobile number');
        }
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: CustomColors.primaryColor),
        child: const Center(
          child: Text(
            TextString.reset,
            style: TextStyle(
                color: CustomColors.white,
                fontFamily: CustomColors.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  verifyPhone(String mobilenumber) async {
    setState(() {
      isloading = true;
    });
    var mcheck = {"mobile": mobileController.text};

    ApiWrapper.dataPost(Config.mobileCheck, mcheck).then((val) async {
      setState(() {});
      if ((val != null) && (val.isNotEmpty)) {
        if (val["Result"] != "true") {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: mobilenumber,
            timeout: const Duration(seconds: 30),
            verificationCompleted: (PhoneAuthCredential credential) {
              setState(() {
                isloading = false;
              });
              ApiWrapper.showToastMessage("Auth Completed!");
            },
            verificationFailed: (FirebaseAuthException e) {
              setState(() {
                isloading = false;
              });
              ApiWrapper.showToastMessage("Auth Failed!");
            },
            codeSent: (String verificationId, int? resendToken) {
              setState(() {
                isloading = false;
              });
              Get.to(() => OtpVerificationScreenTwo(
                  ccode: _selectedCountryCode,
                  type: "reset",
                  mobile: mobileController.text,
                  verID: verificationId));
              ApiWrapper.showToastMessage("OTP Sent!");
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              setState(() {
                isloading = false;
              });
              ApiWrapper.showToastMessage("Timeout!");
            },
          );
        } else {
          setState(() {
            isloading = false;
          });
          ApiWrapper.showToastMessage(
              "Unable to process request. Please retry.");
        }
      }
    });
  }

  /// Country Code Field
  cpicker() {
    var countryDropDown = Ink(
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
              dropdownColor: notifire.getprimerycolor,
              value: _selectedCountryCode,
              items: countryCode.map((value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(
                            fontSize: 14.0, color: Colors.grey)));
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCountryCode = value;
                });
              },
              style: Theme.of(context).textTheme.headline6),
        ),
      ),
    );
    return countryDropDown;
  }
}
