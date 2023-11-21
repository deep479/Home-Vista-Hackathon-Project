import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ucservice_customer/loginAuth/login_screen.dart';
import 'package:ucservice_customer/model/country_code_list_model.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:ucservice_customer/widget/text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiServices/Api_werper.dart';
import '../ApiServices/url.dart';
import '../IntroScreen/splash_screen.dart';
import '../model/mobileCheckModel.dart';
import 'otp_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  bool isSelected = false;
  bool isLoading = false;

  String? _selectedCountryCode = '';

  String emailRegularParttern = r"([a-z0-9_@.]}";

  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  setRegisterData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", fullNameController.text);
    prefs.setString("email", emailAddressController.text);
    prefs.setString("mobile", mobileController.text);
    prefs.setString("password", passwordController.text);
    prefs.setString("confirmPassword", confirmPasswordController.text);
    prefs.setString("referralCode", referralCodeController.text);
    prefs.setString("countryCode", _selectedCountryCode!);
  }

  CountryCodeListModel? countryCodeListModel;
  final bool _load = false;
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
        centerTitle: true,
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: notifire.getdarkscolor, size: 28),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(TextString.register,
            style: TextStyle(
                color: notifire.getdarkscolor,
                fontWeight: FontWeight.bold,
                fontFamily: CustomColors.fontFamily,
                fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          child: !isLoading
              ? Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(TextString.gettingStarted,
                          style: TextStyle(
                              fontSize: 36,
                              color: notifire.getdarkscolor,
                              fontWeight: FontWeight.w700,
                              fontFamily: CustomColors.fontFamily)),
                      SizedBox(height: Get.height * 0.01),
                      const Text(TextString.Seemsyouarenewhere,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: CustomColors.fontFamily,
                              color: CustomColors.grey)),
                      SizedBox(height: Get.height * 0.03),
                      nameTextField(),
                      SizedBox(height: Get.height * 0.02),
                      emailTextField(),
                      SizedBox(height: Get.height * 0.02),
                      phoneNumberTextField(),
                      SizedBox(height: Get.height * 0.02),
                      passwordTextFormField(),
                      SizedBox(height: Get.height * 0.02),
                      confirmPasswordTextFormField(),
                      SizedBox(height: Get.height * 0.02),
                      referralCodeTextField(),
                      SizedBox(height: Get.height * 0.02),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                splashRadius: 30,
                                value: isSelected,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                                activeColor: CustomColors.primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    isSelected = value!;
                                  });
                                }),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                      TextString
                                          .Bycreatinganaccountyouagreetoour,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: CustomColors.grey,
                                          fontSize: 13,
                                          fontFamily: CustomColors.fontFamily)),
                                  SizedBox(height: 5),
                                  Text(TextString.TermandConditions,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: CustomColors.primaryColor,
                                          fontFamily: CustomColors.fontFamily)),
                                ]),
                          ]),
                      const SizedBox(height: 27),
                      continueButton(),
                      const SizedBox(height: 18),
                      loginButton(),
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

  /// --------------------------------------------  Text Fields ---------------------------------------------///

  /// Name Field
  Widget nameTextField() {
    return CustomTextfield(
        hint: TextString.fullName,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
        fieldController: fullNameController,
        hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily));
  }

  Widget emailTextField() {
    return CustomTextfield(
        hint: TextString.emailaddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
        fieldController: emailAddressController,
        hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily));
  }

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
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.grey)));
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedCountryCode = value;
              });
            },
            style: Theme.of(context).textTheme.headline6),
      ),
    ));
    return countryDropDown;
  }

  Widget phoneNumberTextField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1, color: Colors.grey)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [cpicker()]),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: CustomTextfield(
              fieldController: mobileController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                return null;
              },
              hint: TextString.mobileNumber,
              fieldInputType: TextInputType.number,
              hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily)),
        ),
      ],
    );
  }

  Widget passwordTextFormField() {
    return CustomTextfield(
        hint: TextString.password,
        obscureText: _isObscure,
        fieldController: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily),
        suffixIcon: IconButton(
            icon: _isObscure
                ? const Icon(Icons.remove_red_eye_outlined,
                    color: CustomColors.grey)
                : const Icon(Icons.visibility_off_outlined,
                    color: CustomColors.grey),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }));
  }

  Widget confirmPasswordTextFormField() {
    return CustomTextfield(
        hint: TextString.confirmPassword,
        obscureText: _isObscureConfirm,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please enter your confirm password';
          }
          if (val != passwordController.text) {
            return 'Not Match';
          }
          return null;
        },
        fieldController: confirmPasswordController,
        hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily),
        suffixIcon: IconButton(
            icon: _isObscureConfirm
                ? const Icon(Icons.remove_red_eye_outlined,
                    color: CustomColors.grey)
                : const Icon(Icons.visibility_off_outlined,
                    color: CustomColors.grey),
            onPressed: () {
              setState(() {
                _isObscureConfirm = !_isObscureConfirm;
              });
            }));
  }

  /// Referral Code field
  Widget referralCodeTextField() {
    return CustomTextfield(
        hint: TextString.referralCode,
        fieldController: referralCodeController,
        fieldInputType: TextInputType.number,
        hintStyle: const TextStyle(fontFamily: CustomColors.fontFamily));
  }

  /// ----------------------------------- Continue Button ------------------------------------------------///
  Widget continueButton() {
    return _load == false
        ? InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                if (isSelected == true) {
                  setRegisterData();
                  isLoading = true;
                  setState(() {});
                  mobileCheckApi(mobileController.text, context,
                      _selectedCountryCode, mobileController.text);
                } else {
                  Fluttertoast.showToast(msg: "selected term and condition");
                }
              }
            },
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: CustomColors.primaryColor),
              child: const Center(
                child: Text(TextString.Continue,
                    style: TextStyle(
                        color: CustomColors.white,
                        fontFamily: CustomColors.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          )
        : const CircularProgressIndicator();
  }

  /// ----------------------------------- Login Button ------------------------------------------------///
  Widget loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(TextString.Alreadyhaveanaccount,
            style: TextStyle(
                fontFamily: CustomColors.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: CustomColors.grey)),
        GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Text(TextString.login,
                style: TextStyle(
                    fontFamily: CustomColors.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryColor)))
      ],
    );
  }

  Dio dio = Dio();

  MobileCheckModel? mobileCheckModel;
  Future mobileCheckApi(String? mobile, context, String? ccode, number) async {
    try {
      var params = {"mobile": mobile};

      final response =
          await dio.post(Config.baseUrl + Config.mobileCheck, data: params);
      if (response.statusCode == 200) {
        mobileCheckModel =
            MobileCheckModel.fromJson(json.decode(response.data));

        if (mobileCheckModel!.result == "true") {
          verifyPhone(ccode, number, context);

          Fluttertoast.showToast(msg: "${mobileCheckModel?.responseMsg}");
        } else if (mobileCheckModel == null) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "${mobileCheckModel?.responseMsg}");
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "${mobileCheckModel?.responseMsg}");
        }
      }
    } on DioError {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  /// verification code
  Future<void> verifyPhone(String? ccode, number, context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: ccode! + number,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          isLoading = false;
        });
        ApiWrapper.showToastMessage("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isLoading = false;
        });
        ApiWrapper.showToastMessage("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          isLoading = false;
        });
        Get.to(() => OtpVarificationScreen(verID: verificationId));
        ApiWrapper.showToastMessage("OTP Sent!");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          isLoading = false;
        });
        ApiWrapper.showToastMessage("Timeout!");
      },
    );
  }
}
