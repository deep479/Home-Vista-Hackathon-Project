// ignore_for_file: file_names, non_constant_identifier_names, avoid_types_as_parameter_names, deprecated_member_use

import 'dart:io';

import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'color_widget.dart';

final getData = GetStorage();
save(Key, val) {
  final data = GetStorage();
  data.write(Key, val);
}

isLoadingIndicator() {
  return const CircularProgressIndicator(
    backgroundColor: CustomColors.primaryColor,
  );
}

Widget statusBar(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: Get.height * 0.01),
    child: Container(
        height: MediaQuery.of(context).padding.top,
        width: Get.width,
        decoration: const BoxDecoration(color: Colors.transparent)),
  );
}

//! pick image
Future pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    // ApiWrapper.showToastMessage(e.toString());
  }
  return image;
}

shimmerLoading() {
  return AnimatedShimmer(
    height: Get.height * 0.12,
    width: Get.width * 0.28,
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    delayInMilliSeconds: const Duration(milliseconds: 0 * 200),
  );
}

cartButton({String? total1, total2, Function()? onTap}) {
  return SizedBox(
    height: 60,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(total1 ?? "",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: CustomColors.black,
                  fontFamily: CustomColors.fontFamily)),
        ),
        const SizedBox(width: 10),
        Text(total2,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough,
                fontSize: 16,
                color: CustomColors.grey,
                fontFamily: CustomColors.fontFamily)),
        const Expanded(child: SizedBox(width: 10)),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                  color: CustomColors.primaryColor,
                  borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: const Text("View Cart",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: CustomColors.white,
                      fontFamily: CustomColors.fontFamily)),
            ),
          ),
        ),
      ],
    ),
  );
}

//! payment widget
Payment(
    {text1,
    text2,
    fontstyle2,
    fontstyle,
    TextDecoration? decoration,
    TextDecorationStyle? dotted,
    Color? textcolor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(text1,
          style: TextStyle(
              fontFamily: fontstyle2,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              decoration: decoration,
              decorationStyle: dotted)),
      Text(text2,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: fontstyle,
              fontSize: 14,
              color: textcolor))
    ],
  );
}

//! payment widget
orderPayment(
    {text1,
    text2,
    TextDecoration? decoration,
    TextDecorationStyle? dotted,
    Color? textcolor,
    txcolor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1,
            style: TextStyle(
                color: txcolor,
                fontFamily: CustomColors.fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                decoration: decoration,
                decorationStyle: dotted)),
        Text(text2,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: CustomColors.fontFamily,
                fontSize: 16,
                color: textcolor))
      ],
    ),
  );
}

doublevaluPer(first, second) {
  return (double.parse(first.toString()) *
          double.parse(second.toString()) /
          100)
      .toStringAsFixed(2);
}

doublevaluemulti(first, second) {
  return (double.parse(first.toString()) * double.parse(second.toString()))
      .toStringAsFixed(2);
}

// value --
valueCal(first, second) {
  return (double.parse(first.toString()) - double.parse(second.toString()))
      .toStringAsFixed(2);
}

//value ++
valuePlus(first, second) {
  return (double.parse(first.toString()) + double.parse(second.toString()))
      .toStringAsFixed(2);
}

Widget sugestlocationtype(
    {Function()? ontap,
    title,
    val,
    image,
    adress,
    radio,
    Color? borderColor,
    Color? titleColor}) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width / 18),
        child: Container(
          height: Get.height / 10,
          decoration: BoxDecoration(
              border: Border.all(color: borderColor!, width: 1),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(11)),
          child: Row(
            children: [
              SizedBox(width: Get.width / 55),
              Container(
                  height: Get.height / 12,
                  width: Get.width / 5.5,
                  decoration: BoxDecoration(
                      color: const Color(0xffF2F4F9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: FadeInImage(
                        placeholder: const AssetImage("assets/loading2.gif"),
                        image: NetworkImage(image)),
                    // Image.network(image, height: Get.height / 08)
                  )),
              SizedBox(width: Get.width / 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.01),
                  Text(title,
                      style: TextStyle(
                        fontSize: Get.height / 55,
                        fontFamily: 'Gilroy_Bold',
                        color: titleColor,
                      )),
                  SizedBox(
                    width: Get.width * 0.50,
                    child: Text(adress,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: Get.height / 65,
                            fontFamily: 'Gilroy_Medium',
                            color: Colors.grey)),
                  ),
                ],
              ),
              const Spacer(),
              radio
            ],
          ),
        ),
      ),
    );
  });
}

addButton({Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 38,
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
            color: CustomColors.white),
        child: const Center(
          child: Text("Add",
              style: TextStyle(
                  fontFamily: "Gilroy Bold",
                  fontWeight: FontWeight.w600,
                  color: CustomColors.primaryColor,
                  fontSize: 16)),
        ),
      ),
    ),
  );
}

emptyBooking() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
          padding: EdgeInsets.only(left: Get.width * 0.02),
          child: Image(
              image: const AssetImage("assets/emptybooking.png"),
              height: Get.height * 0.14)),
      SizedBox(height: Get.height * 0.02),
      const Center(
        child: Text("Go & Book your favorite service.",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Gilroy Bold')),
      ),
      SizedBox(height: Get.height * 0.02),
    ],
  );
}

// Phone Call
Future<void> makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
