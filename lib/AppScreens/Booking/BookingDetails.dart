// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, deprecated_member_use, depend_on_referenced_packages, avoid_print, unrelated_type_equality_checks, unnecessary_string_interpolations, prefer_const_constructors, no_duplicate_case_values, dead_code

import 'dart:convert';

import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/custom_widegt/widegt.dart';
import 'package:ucservice_customer/model/OrderHistory.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:http/http.dart' as http;

import '../../ApiServices/Api_werper.dart';
import '../../utils/AppWidget.dart';
import '../Home/home_screen.dart';

class OrderDetailsPage extends StatefulWidget {
  final String? orderID;
  const OrderDetailsPage({Key? key, this.orderID}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool isLoading = false;
  OrderHistory? orderData;
  Color? buttoncol;
  int providerrate = 1;
  int deliveryrate = 1;
  final provider = TextEditingController();
  final delivery = TextEditingController();
  @override
  void initState() {
    super.initState();
    orderhistoryApi();
    setState(() {});
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
        titleSpacing: 0,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: notifire.getdarkscolor)),
        backgroundColor: notifire.getprimerycolor,
        title: Text("Booking #${widget.orderID ?? ""}",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: notifire.getdarkscolor)),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      //! Button
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (orderData?.orderFlowId == "0") ...{
                AppButton(
                    buttontext: TextString.cancelBooking,
                    onclick: () => dialogShow())
              },
              //! success order
              if (orderData?.orderFlowId == "7" &&
                  orderData?.isRate != "1") ...{
                AppButton(
                  buttontext: TextString.giveFeedBack,
                  onclick: reviewRider,
                )
              },
            ],
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: Get.height * 0.08),
          child: !isLoading
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  //! order Status & id
                  orderStatus(),
                  //! user Job Completed Rating
                  orderData!.riderName != ""
                      ? userJobCompletedRating()
                      : const SizedBox(),
                  //! Your Rating
                  const SizedBox(height: 10),
                  //! Vendor Comment
                  // vendorComment(),
                  //! item list
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderData!.orderProductData!.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      return itemListget(orderData!.orderProductData![i]);
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                          thickness: 1,
                          color: notifire.greyfont,
                          endIndent: Get.width * 0.04,
                          indent: Get.width * 0.04);
                    },
                  ),

                  Divider(
                      thickness: 1,
                      color: notifire.greyfont,
                      endIndent: Get.width * 0.04,
                      indent: Get.width * 0.04),

                  //! order Summary Amount
                  orderSummary(),

                  const SizedBox(height: 10),
                  // notice(),
                  orderData!.status != "Completed"
                      ? orderData!.status != "Cancelled"
                          ? cancellationPolicy()
                          : orderData!.commentReject != ""
                              ? cancellation()
                              : SizedBox()
                      : SizedBox(),

                  const SizedBox(height: 14),
                ])
              : Center(
                  child: Column(children: [
                    SizedBox(height: Get.height * 0.38),
                    isLoadingIndicator(),
                  ]),
                ),
        ),
      ),
    );
  }

  itemListget(OrderProductData item) {
    return ListTile(
      dense: true,
      leading: Container(
          width: Get.width * 0.13,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
              image: DecorationImage(
                  image:
                      NetworkImage("${Config.imgBaseUrl}${item.productImage}"),
                  fit: BoxFit.cover))),
      title: Text("${item.productName}",
          style: TextStyle(
              fontSize: 16,
              color: notifire.getdarkscolor,
              fontFamily: CustomColors.fontFamily,
              fontWeight: FontWeight.w600)),
      subtitle: Text("Qty : ${item.productQuantity}",
          style: TextStyle(
              fontSize: 14,
              fontFamily: CustomColors.fontFamily,
              color: notifire.greyfont,
              fontWeight: FontWeight.w600)),
      trailing: Column(children: [
        item.productPrice != item.productTotal
            ? Column(children: [
                Text("$currency${item.productTotal}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Gilroy Bold",
                        color: CustomColors.green,
                        fontSize: 14)),
                Text("$currency${item.productPrice}",
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontFamily: "Gilroy Bold",
                        color: notifire.greyfont,
                        fontSize: 14)),
              ])
            : Text("$currency${item.productTotal}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Gilroy Bold",
                    color: CustomColors.green,
                    fontSize: 14)),
      ]),
    );
  }

  orderStatus() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(TextString.serviceprovider,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: notifire.getdarkscolor,
                          fontFamily: CustomColors.fontFamily,
                          fontSize: 16)),
                  SizedBox(height: 4),
                  Text("#${orderData!.id}",
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: CustomColors.fontFamily)),
                  SizedBox(height: 4),
                  Text(" ${orderData!.storeName ?? ""}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomColors.fontFamily,
                          color: notifire.getdarkscolor,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: Get.width * 0.60,
                    child: Text(
                      "${orderData!.storeAddress}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: CustomColors.grey,
                          fontFamily: CustomColors.fontFamily,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
            Column(children: [
              Chip(
                backgroundColor: buttoncol,
                label: Text("${orderData!.status}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CustomColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: CustomColors.fontFamily)),
              ),
              orderData!.orderFlowId != "0"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.green.shade50,
                        radius: 24,
                        child: InkWell(
                            onTap: () => makePhoneCall(
                                "tel:${orderData!.customerPmobile}"),
                            child: const Icon(Icons.call,
                                color: CustomColors.green)),
                      ))
                  : SizedBox(),
            ]),
          ]),
        ));
  }

  // Doted Cancellation Policy
  Widget cancellationPolicy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FDottedLine(
          color: Colors.red,
          corner: FDottedLineCorner.all(10.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(TextString.cancellationPolicy,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: notifire.black,
                      fontFamily: CustomColors.fontFamily,
                      fontSize: 16)),
              SizedBox(height: 5),
              Text(
                TextString.cancellationDescription,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: CustomColors.fontFamily,
                    fontSize: 14,
                    color: notifire.greyfont),
              ),
            ]),
          )),
    );
  }

  // Doted Cancellation Policy
  Widget cancellation() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FDottedLine(
          color: Colors.red,
          corner: FDottedLineCorner.all(10.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${orderData!.commentReject ?? ""}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: CustomColors.fontFamily,
                      fontSize: 16)),
            ]),
          ),
        ));
  }

  userJobCompletedRating() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(TextString.servicepartner,
                      style: TextStyle(
                          fontSize: 16,
                          color: notifire.getdarkscolor,
                          fontFamily: CustomColors.fontFamily,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text("${orderData!.riderName}",
                      style: TextStyle(
                          fontSize: 16,
                          color: notifire.getdarkscolor,
                          fontFamily: CustomColors.fontFamily,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text("${orderData!.riderMobile}",
                      style: TextStyle(
                          fontSize: 16,
                          color: notifire.getdarkscolor,
                          fontFamily: CustomColors.fontFamily,
                          fontWeight: FontWeight.w600)),
                ]),
                orderData!.riderImg != ""
                    ? Column(children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                              "${Config.imgBaseUrl}${orderData!.riderImg}"),
                        ),
                        SizedBox(height: 4),
                        orderData!.orderFlowId == "4" &&
                                orderData!.orderFlowId == "6" &&
                                orderData!.orderFlowId == "7"
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue.shade50,
                                  radius: 24,
                                  child: InkWell(
                                      onTap: () => makePhoneCall(
                                          "tel:${orderData!.riderMobile}"),
                                      child: const Icon(Icons.call,
                                          color: CustomColors.blue)),
                                ),
                              )
                            : SizedBox(),
                      ])
                    : const SizedBox(),
              ],
            ),
            Divider(
              thickness: 1,
              color: notifire.greyfont,
            ),
            orderData!.jobStart != null
                ? Text(
                    "Job Start : ${orderData!.jobStart ?? ""} ",
                    style: TextStyle(
                      color: notifire.getdarkscolor,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 4),
            orderData!.jobEnd != null
                ? Text(
                    "Job Completed : ${orderData!.jobEnd ?? ""}",
                    style: TextStyle(
                      color: notifire.getdarkscolor,
                    ),
                  )
                : SizedBox(),
            const SizedBox(height: 4)
          ])),
    );
  }

  /// Your Rating
  Widget yourRating() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(TextString.yourRating,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: CustomColors.fontFamily)),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset(ImagePath.starImg, scale: 14),
              Image.asset(ImagePath.starImg, scale: 14),
              Image.asset(ImagePath.starImg, scale: 14),
              Image.asset(ImagePath.starImg, scale: 14),
              Image.asset(ImagePath.starImg, scale: 14),
              const Spacer(),
              Container(
                width: 70,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text(TextString.ratting,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: CustomColors.fontFamily)),
              )
            ],
          ),
        ]),
      ),
    );
  }

  // Vendor Comment
  // Widget vendorComment() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     child: Container(
  //       width: double.infinity,
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //       decoration: BoxDecoration(
  //           border: Border.all(color: Colors.grey),
  //           borderRadius: BorderRadius.circular(12)),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: const [
  //           Text(
  //             TextString.vendorComment,
  //             style: TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.w600,
  //                 fontFamily: CustomColors.fontFamily),
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             TextString.commentFromVendor,
  //             style: TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.w600,
  //                 color: CustomColors.grey,
  //                 fontFamily: CustomColors.fontFamily),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// order Summary Amount
  Widget orderSummary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(TextString.orderSummary,
              style: TextStyle(
                  fontFamily: CustomColors.fontFamily,
                  fontSize: 18,
                  color: notifire.getdarkscolor,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: Get.height * 0.01),

          orderPayment(
              text1: "Sub Total ",
              txcolor: notifire.greyfont,
              text2: "$currency${orderData!.subtotal}",
              textcolor: notifire.getdarkscolor),
          SizedBox(height: Get.height * 0.018),

          orderPayment(
              text1: "Tax",
              txcolor: notifire.greyfont,
              text2: "$currency${orderData!.tax}",
              textcolor: notifire.getdarkscolor),
          SizedBox(height: Get.height * 0.018),
          orderPayment(
              text1: TextString.convenience,
              txcolor: notifire.greyfont,
              text2: "$currency${orderData!.convFee}",
              textcolor: notifire.getdarkscolor),
          SizedBox(height: Get.height * 0.018),
          orderData!.totalDiscount != "0"
              ? Column(children: [
                  orderPayment(
                      text1: TextString.itemdis,
                      txcolor: notifire.greyfont,
                      text2: "-$currency${orderData!.totalDiscount}",
                      textcolor: notifire.getdarkscolor),
                  SizedBox(height: Get.height * 0.018),
                ])
              : const SizedBox(),
          orderData!.couAmt != "0"
              ? Column(children: [
                  orderPayment(
                      text1: TextString.couponAmount,
                      txcolor: notifire.greyfont,
                      text2: "-$currency${orderData!.couAmt}",
                      textcolor: notifire.getdarkscolor),
                  SizedBox(height: Get.height * 0.018),
                ])
              : const SizedBox(),
          orderData!.wallAmt != "0"
              ? Column(children: [
                  orderPayment(
                      text1: TextString.wallet,
                      txcolor: notifire.greyfont,
                      text2: "$currency${orderData!.wallAmt}",
                      textcolor: notifire.getdarkscolor),
                  SizedBox(height: Get.height * 0.018),
                ])
              : const SizedBox(),

          orderData!.paymentTitle != null
              ? Column(children: [
                  orderPayment(
                      text1: "payment Methods",
                      txcolor: notifire.greyfont,
                      text2: "${orderData!.paymentTitle}",
                      textcolor: notifire.getdarkscolor),
                  SizedBox(height: Get.height * 0.014),
                ])
              : SizedBox(),

          Divider(
            thickness: 1,
            color: notifire.greyfont,
          ),
          //! Total price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total",
                    style: TextStyle(
                        fontFamily: CustomColors.fontFamily,
                        fontSize: 16,
                        color: notifire.getdarkscolor,
                        fontWeight: FontWeight.w600)),
                Text("$currency${orderData!.total}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: notifire.getdarkscolor,
                        fontFamily: CustomColors.fontFamily)),
              ],
            ),
          )
        ],
      ),
    );
  }

  notice() {
    return Column(
      children: const [
        Center(
          child: Text(TextString.copyBillYourEmailId,
              style: TextStyle(
                  color: CustomColors.grey,
                  fontSize: 14,
                  fontFamily: CustomColors.fontFamily,
                  fontWeight: FontWeight.bold)),
        ),
        Center(
          child: Text(TextString.emailId,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: CustomColors.blue,
                  fontSize: 14,
                  fontFamily: CustomColors.fontFamily,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Future reviewRider() {
    return showModalBottomSheet(
      backgroundColor: notifire.getprimerycolor,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: Get.height / 40),
                Ink(
                  width: Get.width * 0.90,
                  child: Text(
                    "Please submit review for ${TextString.serviceprovider}",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 18,
                        color: notifire.getdarkscolor,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: Get.height / 50),
                RatingBar.builder(
                  unratedColor: notifire.greyfont,
                  initialRating: providerrate.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  glowColor: Colors.grey,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: CustomColors.lightyello),
                  onRatingUpdate: (rating) {
                    providerrate = rating.ceil();
                  },
                ),
                SizedBox(height: Get.height / 70),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Comment",
                          style: TextStyle(
                              fontSize: 16,
                              color: notifire.getdarkscolor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.05)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: Get.width * 0.85,
                  child: TextFormField(
                    controller: provider,
                    style: TextStyle(
                        fontSize: Get.height / 50,
                        color: notifire.getdarkscolor),
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter comment",
                        hintStyle: TextStyle(
                            color: notifire.greyfont,
                            fontSize: Get.height / 55),
                        disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                SizedBox(height: Get.height / 30),
                Ink(
                  width: Get.width * 0.90,
                  child: Text(
                    "Please submit review for delivery boy",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 18,
                        color: notifire.getdarkscolor,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: Get.height / 60),
                RatingBar.builder(
                  unratedColor: notifire.greyfont,
                  initialRating: deliveryrate.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  glowColor: notifire.greyfont,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: CustomColors.lightyello),
                  onRatingUpdate: (rating) {
                    deliveryrate = rating.ceil();
                  },
                ),
                SizedBox(height: Get.height / 70),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Comment",
                        style: TextStyle(
                            fontSize: 16,
                            color: notifire.getdarkscolor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.05),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: Get.width * 0.85,
                  child: TextFormField(
                    controller: delivery,
                    style: TextStyle(
                        fontSize: Get.height / 50,
                        color: notifire.getdarkscolor),
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter comment",
                        hintStyle: TextStyle(
                            color: notifire.getgreycolor,
                            fontSize: Get.height / 55),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: notifire.greyfont),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: notifire.greyfont),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: notifire.greyfont),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: notifire.greyfont),
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                SizedBox(height: Get.height / 30),
                SizedBox(
                  width: Get.width * 0.80,
                  child: AppButton(buttontext: "Submit", onclick: isRating),
                ),
                SizedBox(height: Get.height / 40),
              ],
            ),
          );
        });
      },
    );
  }

//! rating Api
  isRating() {
    var data = {
      "uid": uid,
      "orderid": widget.orderID,
      "provider_rate": "$providerrate",
      "provider_text": provider.text,
      "rider_rate": "$deliveryrate",
      "rider_text": delivery.text
    };
    ApiWrapper.dataPost(Config.rateupdate, data)!.then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          Get.back();
          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
          setState(() {});
        }
      }
    });
  }

  Future orderhistoryApi() async {
    isLoading = true;
    setState(() {});
    var body = {"order_id": widget.orderID, "uid": uid};
    try {
      var url = Uri.parse(Config.baseUrl + Config.orderDetail);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(body));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        orderData = OrderHistory.fromJson(response["OrderDetails"]);

        switch (orderData!.status) {
          case "Accepted":
            buttoncol = CustomColors.gradientColor;
            break;
          case "Pending":
            buttoncol = CustomColors.orangeColor;
            break;
          case "Cancelled":
            buttoncol = CustomColors.RedColor;
            break;
          case "Job_start":
            buttoncol = CustomColors.gradientColor;
            break;
          case "Processing":
            buttoncol = CustomColors.gradientColor;
            break;
          case "Completed":
            buttoncol = CustomColors.gradientColor;
            break;
          default:
        }

        setState(() {});
        isLoading = false;
      } else {
        setState(() {});
        isLoading = false;
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  dialogShow() {
    showDialog(
        barrierDismissible: false,
        // barrierColor: notifire.getdarkscolor,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text(
              "Are you sure cancel this order",
              style: TextStyle(color: notifire.getdarkscolor),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text("Yes",
                      style: TextStyle(
                          color: notifire.getdarkscolor,
                          fontWeight: FontWeight.w600)),
                  onPressed: () {
                    orderCancellApi();
                  }),
              TextButton(
                  child: Text("No",
                      style: TextStyle(
                          color: notifire.getdarkscolor,
                          fontWeight: FontWeight.w600)),
                  onPressed: () {
                    Get.back();
                  })
            ],
          );
        });
  }

  orderCancellApi() {
    try {
      var body = {"uid": uid, "order_id": orderData!.id};
      ApiWrapper.dataPost(Config.cancelorder, body).then((val) {
        if ((val != null) && (val.isNotEmpty)) {
          if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
            setState(() {});
            Get.back();
            Get.back();
            ApiWrapper.showToastMessage(val["ResponseMsg"]);
          } else {
            setState(() {});
            ApiWrapper.showToastMessage(val["ResponseMsg"]);
          }
        }
      });
    } catch (e) {
      return e;
    }
  }
}
