import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/ApiServices/api_call_service.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:ucservice_customer/widget/text_form_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String? mobile;
  final String? type;
  const ChangePasswordScreen({Key? key, this.mobile, this.type})
      : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
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

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isObscure = true;
  bool _isObscureConfirm = true;
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
              Get.back();
            }),
        title: Text(
          TextString.changePassword,
          style: TextStyle(
              color: notifire.getprimerycolor,
              fontWeight: FontWeight.bold,
              fontFamily: CustomColors.fontFamily,
              fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(TextString.changePassword,
                    style: TextStyle(
                        fontSize: 34,
                        color: notifire.getdarkscolor,
                        fontWeight: FontWeight.w700,
                        fontFamily: CustomColors.fontFamily)),
                const SizedBox(height: 16),
                const Text(
                  TextString.Enteryourmobilenumbertoresetpassword,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: CustomColors.fontFamily,
                      color: CustomColors.grey),
                ),
                const SizedBox(height: 30),

                /// Password Text Field
                passwordTextFormField(),

                const SizedBox(height: 24),

                /// Confirm Password
                confirmPasswordTextFormField(),

                const SizedBox(height: 28),

                /// Submit Button
                submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Password Text Field
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

  /// Confirm Password
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

  /// ----------------------------------- Submit Button ------------------------------------------------///
  Widget submitButton() {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          ApiService().forgetPasswordApi(
              widget.mobile, passwordController.text, context);
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
            TextString.submitText,
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
}
