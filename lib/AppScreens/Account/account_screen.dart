// ignore_for_file: prefer_typing_uninitialized_variables, sort_child_properties_last, use_build_context_synchronously, non_constant_identifier_names, depend_on_referenced_packages, prefer_adjacent_string_concatenation, deprecated_member_use, unused_catch_clause, empty_catches

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ucservice_customer/ApiServices/api_call_service.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/AppScreens/Booking/Booking.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/custom_widegt/Colors.dart';
import 'package:ucservice_customer/model/login_model.dart';
import 'package:ucservice_customer/model/register_model.dart';
import 'package:ucservice_customer/AppScreens/Account/faqs_screen.dart';
import 'package:ucservice_customer/loginAuth/login_screen.dart';
import 'package:ucservice_customer/AppScreens/Account/privacy_policy_screen.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:ucservice_customer/widget/text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ApiServices/Api_werper.dart';
import '../../utils/colors.dart';
import '../Wallet/WalletHistory.dart';
import 'ReferFriend.dart';

class AccountScreen extends StatefulWidget {
  final String? type;
  const AccountScreen({Key? key, this.type}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool showpassword = false;
  bool _isObscure = false;
  bool isLoading = false;
  String? _image;
  LoginModel? loginModel;
  String? emailId;
  String? name;
  String? pImage;
  String? base64Image;
  var height;
  var width;
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;

  String? networkimage;
  final Email = TextEditingController();
  final mobile = TextEditingController();
  bool isdark = false;
  String? text;
  List<DynamicPageData> dynamicPageDataList = [];

  final _formKey = GlobalKey<FormState>();

  RegisterModel? registerModel;
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmePassword = TextEditingController();

  /// Clear Login Data
  clearLoginData() async {
    save("Remember", false);
    getData.remove("UserLogin");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("loginModel");
    preferences.setBool("seen", false);
    Fluttertoast.showToast(msg: "Logout Successfully");
    Navigator.pop(context, true);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()));
  }

  getLoginData() async {
    isLoading = true;
    setState(() {});

    nameController.text = getData.read("UserLogin")["name"] ?? "";
    passwordController.text = getData.read("UserLogin")["password"] ?? "";
    Email.text = getData.read("UserLogin")["email"] ?? "";
    mobile.text = getData.read("UserLogin")["mobile"] ?? "";
    networkimage = getData.read("UserLogin")["pro_pic"] ?? "";

    isLoading = false;
  }

  getRegisterData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mydata = (preferences.getString('registerModel'));
    var jsondecode = jsonDecode(mydata.toString());
    setState(() {
      registerModel = RegisterModel.fromJson(jsondecode);
      uid = loginModel!.userLogin!.id!;
    });
  }

  @override
  void initState() {
    getData.read("UserLogin") != null ? getLoginData() : null;
    getWebData();
    getPackage();
    super.initState();
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  void getWebData() {
    Map<String, dynamic> data = {};

    dynamicPageDataList.clear();
    ApiWrapper.dataPost(Config.pagelist, data).then((value) {
      if ((value != null) &&
          (value.isNotEmpty) &&
          (value['ResponseCode'] == "200")) {
        List da = value['pagelist'];
        for (int i = 0; i < da.length; i++) {
          Map<String, dynamic> mapData = da[i];
          DynamicPageData a = DynamicPageData.fromJson(mapData);
          dynamicPageDataList.add(a);
        }
      }
    });
  }

  late ColorNotifire notifire;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.type == "Home"
                      ? Column(mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(height: Get.height * 0.03),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: notifire.getdarkscolor,
                                  ))),
                        ])
                      : const SizedBox(),
                  widget.type == "Home"
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03)
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                  Column(children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return showDialogBox();
                              },
                            );
                          },
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              height: Get.height * 0.10,
                              width: Get.width * 0.24,
                              child: _image == null
                                  ? networkimage != ""
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                              imageUrl: Config.imgBaseUrl +
                                                  networkimage!,
                                              placeholder: (context, url) =>
                                                  shimmerLoading(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              fit: BoxFit.cover))
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey.shade200,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: Get.height / 18,
                                              child: Image.asset(
                                                  "assets/user.png",
                                                  fit: BoxFit.cover)),
                                        )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(File(_image.toString()),
                                          fit: BoxFit.cover),
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 114,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return showDialogBox();
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: lightgrey,
                                    child: Icon(Icons.edit,
                                        color: notifire.getdarkscolors,
                                        size: 12)),
                              ),
                            ))
                      ],
                    ),
                    Text(getData.read("UserLogin")["name"] ?? "",
                        style: TextStyle(
                            fontSize: 17,
                            color: notifire.getdarkscolor,
                            fontFamily: "Gilroy Bold",
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.006),
                    getData.read("UserLogin") != null
                        ? Text(getData.read("UserLogin")["email"] ?? "",
                            style: TextStyle(
                                color: notifire.getdarkscolor,
                                fontSize: 17,
                                fontFamily: "Gilroy Bold"))
                        : const SizedBox(),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: () {
                        _showModal();
                      },
                      child: Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                            border: Border.all(color: blueColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          TextString.editProfile,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Gilroy Bold",
                              color: blueColor),
                        )),
                      ),
                    )
                  ]),
                  SizedBox(height: Get.height * 0.02),
                  profileList(),
                ]),
          ),
        ));
  }

  /// Profile List
  Widget profileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Profile",
            style: TextStyle(
                fontSize: 18,
                color: notifire.getdarkscolor,
                fontFamily: CustomColors.fontFamily,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        profilemenu(
            icon: Icons.keyboard_arrow_right_rounded,
            image: ImagePath.appointmentImg,
            text: "My Booking",
            onclick: () {
              Get.to(() => const BookingScreen(type: "hide"));
            }),
        profilemenu(
            icon: Icons.keyboard_arrow_right_rounded,
            image: ImagePath.walletimg,
            text: "Wallet",
            onclick: () {
              Get.to(() => const WalletReportPage(type: "hide"));
            }),
        profilemenu(
            icon: Icons.keyboard_arrow_right_rounded,
            image: ImagePath.shareImg,
            text: "Share and Earn",
            onclick: () {
              Get.to(() => const ReferFriendPage());
            }),
        profilemenu(
            icon: Icons.keyboard_arrow_right_rounded,
            image: ImagePath.star1Img,
            text: "Rate us",
            onclick: () {
              share();
            }),
        profilemenu(
            icon: Icons.keyboard_arrow_right_rounded,
            image: ImagePath.faqImg,
            text: "FAQ's",
            onclick: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Faq()));
            }),
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: dynamicPageDataList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            return profilemenu(
                icon: Icons.keyboard_arrow_right_rounded,
                image: ImagePath.privacy1Img,
                text: dynamicPageDataList[i].title,
                onclick: () {
                  Get.to(() => Loream(
                      title: dynamicPageDataList[i].title,
                      description: dynamicPageDataList[i].description));
                });
          },
        ),
        profilemenu(
            image: ImagePath.darkshow,
            text: "Dark Mode",
            darkmode: Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(
                  activeColor: CustomColors.primaryColor,
                  value: isdark,
                  onChanged: (val) async {
                    setState(() {
                      isdark = val;
                      notifire.setIsDark = val;
                    });
                  },
                )),
            onclick: () {}),
        profilemenu(
            icon: Icons.keyboard_arrow_right_rounded,
            image: ImagePath.delete,
            text: "Delete Account",
            onclick: () {
              dialogShow(
                  title: "Are you sure ?\n You want to delete the account");
            }),
        profilemenu(
            icon: Icons.keyboard_arrow_right_rounded,
            image: ImagePath.logoutImg,
            text: "Logout",
            onclick: () {
              logOutShowModalBottomSheet();
            }),
      ],
    );
  }

  ///
  profilemenu(
      {String? text,
      image,
      IconData? icon,
      Function()? onclick,
      Widget? darkmode}) {
    return Column(
      children: [
        Container(
          height: height / 16,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: notifire.detail, width: 1)),
          child: InkWell(
            onTap: onclick,
            child: Row(children: [
              Row(
                children: [
                  SizedBox(width: width / 80),
                  Container(
                    height: 35,
                    width: 35,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(image, color: notifire.getdarkscolor),
                  ),
                  Text(text!,
                      style: TextStyle(
                          fontSize: 16,
                          color: notifire.getdarkscolor,
                          fontFamily: "Gilroy Bold",
                          fontWeight: FontWeight.normal)),
                ],
              ),
              const Spacer(),
              darkmode ??
                  Icon(
                    icon,
                    size: 25,
                    color: notifire.getdarkscolor,
                  ),
              const SizedBox(width: 10)
            ]),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.008),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }

  galleryImagePic() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        if (image != null) {
          _image = image.path;
          File imageFile = File(_image.toString());
          List<int> imageBytes = imageFile.readAsBytesSync();
          base64Image = base64Encode(imageBytes);
          ApiService().profileImageUploadApi(base64Image, context);
        }
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to Pick Image $e');
      }
    }
  }

  camaraImagePic() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        if (image != null) {
          _image = image.path;
          File imageFile = File(_image.toString());
          List<int> imageBytes = imageFile.readAsBytesSync();
          base64Image = base64Encode(imageBytes);
          ApiService().profileImageUploadApi(base64Image, context);
        }
      });
    } on PlatformException {}
  }

  Widget showDialogBox() {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        GestureDetector(
            onTap: () {
              Get.back();
              galleryImagePic();
            },
            child:
                const Icon(Icons.photo_size_select_actual_outlined, size: 32)),
        GestureDetector(
            onTap: () {
              camaraImagePic();
            },
            child: const Icon(Icons.camera_alt_outlined, size: 32)),
      ]),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('Gallery'),
            Text('Camara'),
          ]),
    );
  }

  logOutShowModalBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: bgcolor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        )),
        builder: (context) {
          return Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  const Text(TextString.lOur,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomColors.fontFamily,
                          fontSize: 20)),
                  const SizedBox(height: 14),
                  const Text(TextString.areSureLogOut,
                      style: TextStyle(
                          fontFamily: CustomColors.fontFamily, fontSize: 14)),
                  const Expanded(child: SizedBox(height: 14)),
                  logoutButton(),
                  const SizedBox(height: 10),
                  cancelButton(),
                ]),
          );
        });
  }

  /// ----------------------------------- Yes Logout Button ------------------------------------------------///
  Widget logoutButton() {
    return GestureDetector(
      onTap: () {
        clearLoginData();
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: CustomColors.blue),
        child: const Center(
          child: Text(TextString.yesLogout,
              style: TextStyle(
                  color: CustomColors.white,
                  fontFamily: CustomColors.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  /// Cancel Button
  Widget cancelButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: CustomColors.grey.shade300),
        child: const Center(
          child: Text(TextString.cancel,
              style: TextStyle(
                  color: CustomColors.grey,
                  fontFamily: CustomColors.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  /// ----------------------------------- Edit profile Show Model Bottom Sheet -------------------------------------------///

  void _showModal() {
    Future<void> future = showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return Container(
            color: notifire.getprimerycolor,
            padding: const EdgeInsets.all(12),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    Center(
                      child: Container(
                          height: height / 80,
                          width: width / 5,
                          decoration: BoxDecoration(
                              color: notifire.detail,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)))),
                    ),
                    const SizedBox(height: 20),
                    Text(TextString.editProfile,
                        style: TextStyle(
                            fontSize: 20,
                            color: notifire.getdarkscolor,
                            fontWeight: FontWeight.bold,
                            fontFamily: CustomColors.fontFamily)),
                    const SizedBox(height: 24),
                    nameTextField(),
                    const SizedBox(height: 16),
                    passwordTextFormField(),
                    const SizedBox(height: 16),
                    email(),
                    const SizedBox(height: 16),
                    number(),
                    const SizedBox(height: 24),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cancelEditButton(),
                          saveButton(),
                        ])
                  ]),
                ),
              ),
            ));
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    if (kDebugMode) {
      print('modal closed');
    }
  }

  /// -------------------------------- Edit profile -------------------------///

  Widget nameTextField() {
    return CustomTextfield(
        hint: TextString.fullName,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
        fieldController: nameController,
        hintStyle: TextStyle(
            fontFamily: CustomColors.fontFamily, color: notifire.greyfont));
  }

  Widget email() {
    return CustomTextfield(
      hint: TextString.email,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Email';
        }
        return null;
      },
      fieldController: Email,
      hintStyle: TextStyle(
          fontFamily: CustomColors.fontFamily, color: notifire.greyfont),
    );
  }

  Widget number() {
    return CustomTextfield(
        hint: TextString.number,
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your number';
          }
          return null;
        },
        fieldController: mobile,
        hintStyle: TextStyle(
            fontFamily: CustomColors.fontFamily, color: notifire.greyfont));
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
        hintStyle: TextStyle(
            fontFamily: CustomColors.fontFamily, color: notifire.greyfont),
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

  /// Mobile Number
  Widget mobileNumber() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: Colors.grey)),
      height: 63.0,
      width: double.infinity,
      child: Text(
        loginModel?.userLogin?.mobile ?? "",
        style: const TextStyle(
            fontFamily: CustomColors.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 15),
      ),
    );
  }

  /// Email Field
  Widget emailField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: Colors.grey)),
      height: 63.0,
      width: double.infinity,
      child: Text(loginModel?.userLogin?.email ?? "",
          style: const TextStyle(
              fontFamily: CustomColors.fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 15)),
    );
  }

  /// Save button
  Widget saveButton() {
    return InkWell(
      onTap: saveProfile,
      child: Container(
          width: 166,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: CustomColors.primaryColor),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(TextString.save,
                  style: TextStyle(
                      color: CustomColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: CustomColors.fontFamily)),
            ),
          )),
    );
  }

  saveProfile() {
    var body = {
      "name": nameController.text.toString(),
      "password": passwordController.text.toString(),
      "uid": uid,
    };

    ApiWrapper.dataPost(Config.profileEdit, body).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          save("UserLogin", jsonStringToMap(val["UserLogin"].toString()));

          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  jsonStringToMap(String data) {
    List<String> str = data
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("\"", "")
        .replaceAll("'", "")
        .split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    return result;
  }

  /// cancel edit button
  Widget cancelEditButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: 166,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: CustomColors.grey.shade300),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              TextString.cancelEdit,
              style: TextStyle(
                  color: CustomColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: CustomColors.fontFamily),
            ),
          ),
        ),
      ),
    );
  }

  dialogShow({required String title}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              content: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              actions: <Widget>[
                TextButton(
                    child: const Text("Delete",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                    onPressed: accountDelete),
                TextButton(
                  child: const Text("No",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                  onPressed: () {
                    Get.back();
                  },
                )
              ]);
        });
  }

  //! Account Delete User
  accountDelete() {
    var data = {"uid": uid};
    ApiWrapper.dataPost(Config.deleteAc, data).then((accDelete) {
      if ((accDelete != null) && (accDelete.isNotEmpty)) {
        if ((accDelete['ResponseCode'] == "200") &&
            (accDelete['Result'] == "true")) {
          save("Remember", false);
          getData.remove("UserLogin");
          Get.offAll(() => const LoginScreen());
          ApiWrapper.showToastMessage(accDelete["ResponseMsg"]);
        } else {
          Get.back();
          ApiWrapper.showToastMessage(accDelete["ResponseMsg"]);
        }
      }
    });
  }

  Future<void> share() async {
    try {
      launch("market://details?id=" + "$packageName");
    } on PlatformException catch (e) {
      launch("https://play.google.com/store/apps/details?id=$packageName");
    } finally {
      launch("https://play.google.com/store/apps/details?id=$packageName");
    }
    // await FlutterShare.share(
    //     title: '$appName',
    //     text: '$appName',
    //     linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
    //     chooserTitle: '$appName');
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }
}
