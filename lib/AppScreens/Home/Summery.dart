// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, prefer_const_constructors, unused_field, prefer_typing_uninitialized_variables, prefer_final_fields, unused_local_variable, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, unnecessary_null_comparison, prefer_adjacent_string_concatenation, prefer_is_empty, unrelated_type_equality_checks

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/BootomBar.dart';
import 'package:ucservice_customer/DataSqf/maineList.dart';

import 'package:ucservice_customer/custom_widegt/Colors.dart';
import 'package:ucservice_customer/custom_widegt/widegt.dart';
import 'package:ucservice_customer/AppScreens/Home/coupon.dart';
import 'package:ucservice_customer/loginAuth/login_screen.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../ApiServices/Api_werper.dart';
import '../../ApiServices/url.dart';
import '../../model/home_page_model.dart';
import '../../payment/InputFormater.dart';
import '../../payment/PayPal.dart';
import '../../payment/Payment_card.dart';
import '../../payment/StripeWeb.dart';
import 'traking.dart';
import 'salon_at_home_for_woman_screen.dart';

extension DateExt on DateTime {
  bool isAtLeastOneDayAfterToday() {
    final now = DateTime.now();

    return (isAfter(now) &&
        (day != now.day || month != now.month || year != now.year));
  }
}

bool editpackage = false;
List addressList = [];
String? selectDate = "";
String? selectTime = "";

class Summery extends StatefulWidget {
  final String? vendorID;
  final String? catID;
  final String? discountPrice;
  final String? totalPrice;
  final int? totalItem;
  final String? itemDiscount;
  const Summery(
      {super.key,
      this.totalPrice,
      this.catID,
      this.totalItem,
      this.itemDiscount,
      this.vendorID,
      this.discountPrice});

  @override
  State<Summery> createState() => _SummeryState();
}

class _SummeryState extends State<Summery> {
  late Razorpay _razorpay;

  int counter1 = 0;
  int selectedIndex = 0;
  int selectedIndextime = 0;
  int service = 0;

  final subWise = UserServiceData();
  var users;
  double serviceData = 0.00;
  dynamic totalprice = 0.00;
  dynamic discountPrice = 0.00;
  dynamic itemDiscount = 0.0;

  int totalItem = 0;
  String? convenienceFee = "0";
  String statusget = '';

  bool isLoding = false;
  bool status = false;
  //! Coupon
  String? c_id;
  String? c_amount;
  String couponamount = "0";
  String couponcode = "";
  String? coupontitle;
  dynamic itemTotal = 0.0;
  int _groupaddress = 0;
  String couponprice = "0";
  List curenttimeList = [];
  List curentDayList = [];
  List tempDayList = [];

  var inumber = 0;
  //! address
  var iconImage1 = "assets/selecthome.png";
  var lat1;
  var lon1;

  String? selectid = "";
  bool itemValue = false;

  String? walletAmount = "";
  String? walletbalence = "0";
  var tempWallet = 0.0;
  var useWallet = 0.0;
  String subtotal = "0.0";
  String itemtax = "0";
  dynamic itemtexPer = 0;

  //!  payment var
  String? selectidpay = "0";
  int _groupValue = 0;
  String? paymenttital;
  String razorpaykey = "";
  String ticketType = "";
  List paymentList = [];
  String savedprice = '0';
  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat("dd");

  @override
  void initState() {
    setState(() {});
    totalprice = double.parse(widget.discountPrice.toString());
    serviceData = double.parse(widget.discountPrice.toString());
    discountPrice = double.parse(widget.totalPrice.toString());
    itemDiscount = double.parse(widget.itemDiscount.toString());
    counter1 = widget.totalItem!;
    savedprice = double.parse(widget.itemDiscount.toString()).toString();
    selectDate = "";
    selectTime = "";
    getDataApi();
    walletAmount = wallet;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    checkAddress(1);
    timeSloatApi();
    paymentgateway();
    super.initState();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        'Error Response: ${"ERROR: " + response.code.toString() + " - " + response.message!}');
    ApiWrapper.showToastMessage(response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ApiWrapper.showToastMessage(response.walletName!);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    buyNoworder(response.paymentId);
    ApiWrapper.showToastMessage("Payment Successfully");
  }

  Future<bool> _willPopCallback() async {
    Get.back(result: {
      "disp": serviceData.toStringAsFixed(2),
      "count": counter1,
      "total": discountPrice,
      "itemDiscount": itemDiscount,
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    curenttimeList;
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        curentDayList;
      });
    });
    return WillPopScope(
      onWillPop: () async {
        return _willPopCallback();
      },
      child: Scaffold(
        bottomNavigationBar: Container(
            color: WhiteColor,
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(color: Colors.grey.shade200, thickness: 2),
                isLoagin != null
                    ? Column(children: [
                        addressList.isNotEmpty ? addressRow() : SizedBox(),
                        selectDate != "" ? timeSloatRow() : SizedBox(),
                      ])
                    : SizedBox(),
                if (isLoagin == null) ...{
                  //! ------- User Login ------
                  AppButton(
                    buttontext: TextString.LoginSignuptoproceed,
                    onclick: () {
                      Get.to(() => LoginScreen(type: "payment"))!.then((value) {
                        setState(() {
                          isLoagin = getData.read("UserLogin");
                          uid = getData.read("UserLogin")["id"];
                          homePageApi();
                          checkAddress(1);
                        });
                      });
                    },
                  ),
                },
                if (addressList.isEmpty && isLoagin != null) ...{
                  //! ------- Address Add ------
                  AppButton(
                    buttontext: TextString.addad,
                    onclick: () {
                      Get.to(() => const TrackingPage(addressAdd: "0"))!
                          .then((value) {
                        if (value != "back") {
                          itemValue = false;
                          lat2 = getData.read("PickupAddress")[0]["lat_map"];
                          lon2 = getData.read("PickupAddress")[0]["long_map"];
                          hno = getData.read("PickupAddress")[0]["hno"];
                          daddress =
                              getData.read("PickupAddress")[0]["landmark"];
                          drop_address =
                              getData.read("PickupAddress")[0]["address"];
                          daddresstype =
                              getData.read("PickupAddress")[0]["type"];
                          switch (getData.read("PickupAddress")[0]["type"]) {
                            case "Home":
                              daddresstype = "Home";
                              iconImage1 = "assets/selecthome.png";
                              break;
                            case "Office":
                              daddresstype = "Office";
                              iconImage1 = "assets/selectoffice.png";
                              break;
                            case "Other":
                              daddresstype = "Other";
                              iconImage1 = "assets/selectothers.png";
                              break;
                            default:
                          }
                          checkAddress(0);
                        }
                      });
                    },
                  ),
                },
                if (addressList.isNotEmpty &&
                    selectDate == "" &&
                    isLoagin != null) ...{
                  //! -----  Add time sloate-----
                  AppButton(
                    buttontext: TextString.selectSloat,
                    onclick: () {
                      //!-----------------------------------------------
                      timeoftheday(context)!.then((e) {
                        setState(() {});
                      });
                    },
                  ),
                },
                if (isLoagin != null &&
                    selectDate != "" &&
                    addressList.isNotEmpty) ...{
                  //! -----  Add time sloate-----
                  !isloading
                      ? AppButton(
                          buttontext: TextString.ptopay,
                          onclick: () {
                            if (selectTime != "" && selectDate != "") {
                              //! Open Payment Sheet
                              if (status == true) {
                                if (double.parse(totalprice.toString()) > 0) {
                                  paymentSheet();
                                } else {
                                  //! book ticket
                                  buyNoworder(0);
                                }
                              } else {
                                if (double.parse(totalprice.toString()) != 0) {
                                  paymentSheet();
                                } else {
                                  buyNoworder(0);
                                }
                              }
                            } else {
                              ApiWrapper.showToastMessage("Select time");
                            }
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(child: isLoadingIndicator()),
                        ),
                },
              ],
            )),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppbar(
                bgcolor: CustomColors.white,
                leadingiconcolor: BlackColor,
                titlecolor: BlackColor,
                onback: () {
                  setState(() {});

                  Get.back(result: {
                    "disp": serviceData.toStringAsFixed(2),
                    "count": counter1,
                    "total": discountPrice,
                    "itemDiscount": itemDiscount,
                  });
                },
                centertext: TextString.summar,
                ActionIcon: null)),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: Get.width * 0.8,
                        child: Text(
                            "You're saving total $currency${itemDiscount} on this order!",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Gilroy Bold",
                                color: BlackColor))),
                    Image.asset(ImagePath.coinImg1, height: 30),
                  ]),
            ),
            Divider(color: greycolor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    FutureBuilder(
                      future: subWise.fetchUsers(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          users = snap.data;
                          return ListView.builder(
                              itemCount: users.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (BuildContext context, i) {
                                String nullqunt = users[i].quantity != ""
                                    ? users[i].quantity.toString()
                                    : "0";
                                return int.parse(nullqunt) > 0
                                    ? sumreyList(users, i)
                                    : SizedBox();
                              });
                        } else {
                          return Center(child: isLoadingIndicator());
                        }
                      },
                    ),

                    SizedBox(height: Get.height * 0.03),
                    Divider(color: Colors.grey.shade200, thickness: 8),

                    //! ----- Coupon offers ------
                    isLoagin != null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 12),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Image.asset("assets/Group.png",
                                          height: 30),
                                      SizedBox(width: Get.width * 0.04),
                                      couponcode != ""
                                          ? Text(
                                              "Coupon applied !",
                                              style: TextStyle(
                                                  color: Colors.green.shade400,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : Text(
                                              "Coupons and offers",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                    ]),
                                    couponcode == ""
                                        ? Row(children: [
                                            InkWell(
                                              onTap: () => Get.to(() => MyCupon(
                                                      bill: serviceData
                                                          .toString(),
                                                      vendorID:
                                                          widget.vendorID))!
                                                  .then((value) {
                                                if (value != null) {
                                                  setState(() {});
                                                  c_id = value["id"];
                                                  c_amount =
                                                      value["coupon_val"];
                                                  couponamount =
                                                      value["coupon_val"];
                                                  couponcode =
                                                      value["coupon_code"];
                                                  coupontitle = value["title"];
                                                  savedprice = (double.parse(
                                                              savedprice
                                                                  .toString()) +
                                                          double.parse(value[
                                                                  "coupon_val"]
                                                              .toString()))
                                                      .toString();

                                                  totalprice = (double.parse(
                                                              totalprice
                                                                  .toString()) -
                                                          double.parse(value[
                                                                  "coupon_val"]
                                                              .toString()))
                                                      .toStringAsFixed(2);
                                                }
                                              }),
                                              child: Text("Offers",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "Gilroy Bold",
                                                      color: buttonColor)),
                                            ),
                                            Icon(Icons.keyboard_arrow_right,
                                                color: buttonColor)
                                          ])
                                        : Row(children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  couponcode = "";
                                                  savedprice = (double.parse(
                                                              savedprice
                                                                  .toString()) -
                                                          double.parse(c_amount
                                                              .toString()))
                                                      .toString();
                                                  totalprice = (double.parse(
                                                              totalprice
                                                                  .toString()) +
                                                          double.parse(c_amount
                                                              .toString()))
                                                      .toStringAsFixed(2);

                                                  couponamount = "0";
                                                  setState(() {});
                                                });
                                              },
                                              child: Text("Remove",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "Gilroy Bold",
                                                      color: buttonColor)),
                                            ),
                                            Icon(Icons.close,
                                                color: buttonColor)
                                          ])
                                  ]),
                            ),
                          )
                        : SizedBox(),
                    isLoagin != null
                        ? Divider(color: Colors.grey.shade200, thickness: 8)
                        : SizedBox(),
                    SizedBox(height: Get.height * 0.02),
                    //! ------ Wallet Details -------
                    isLoagin != null && wallet != "0"
                        ? walletDetail()
                        : SizedBox(),
                    isLoagin != null && wallet != "0"
                        ? SizedBox(height: Get.height * 0.02)
                        : SizedBox(),

                    //! Payment Summary
                    paymentSummary(),
                    SizedBox(height: Get.height * 0.03),
                    //! ------ price label -----
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        color: CustomColors.accentColor,
                        child: Text(
                            "Yay! You have saved $currency${itemDiscount} on final bill",
                            style: TextStyle(
                                fontFamily: "Gilroy Medium",
                                fontSize: 16,
                                color: Colors.teal)),
                      ),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }

//! ----- Address Data ------
  addressRow() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0.0,
      leading:
          Image(image: AssetImage(iconImage1), height: 20, color: Colors.black),
      title: Row(children: [
        Text("$daddresstype" " - ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: "Gilroy")),
        Ink(
          width: Get.width * 0.56,
          child: Text(
              daddress == ""
                  ? "${"${hno}, "
                      "${drop_address}"}"
                  : "${"${hno}, "
                      "${daddress}, "
                      "${drop_address}"}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: "Gilroy")),
        ),
      ]),
      trailing: InkWell(
        onTap: () {
          bottomsheets(daddresstype).then((value) {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {});
          });
        },
        child: Image(image: AssetImage("assets/pen.png"), height: 24),
      ),
    );
  }

//! ---------------------- TimeSloat bottomSheet ----------------------
  timeSloatRow() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0.0,
      leading: Icon(Icons.watch_later_outlined, color: Colors.black),
      title: Ink(
          child: Text("${selectDate}" " - " "${selectTime}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "Gilroy"))),
      trailing: InkWell(
        onTap: () {
          timeoftheday(context)!.then((e) {
            setState(() {});
          });
        },
        child: Image(image: AssetImage("assets/pen.png"), height: 24),
      ),
    );
  }

  //! Payment Summary
  Widget paymentSummary() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(TextString.payment,
          style: TextStyle(
              fontSize: 18,
              fontFamily: CustomColors.fontFamily,
              fontWeight: FontWeight.bold)),
      SizedBox(height: Get.height * 0.03),
      //! ------  total Item -----
      Payment(
        text1: TextString.item,
        text2: "$currency${serviceData}",
      ),
      status ? SizedBox(height: Get.height * 0.018) : SizedBox(),
      //! ------  Wallet balence -----
      status
          ? Payment(
              text1: TextString.wallet,
              text2: "$currency${useWallet.toStringAsFixed(2)}",
            )
          : SizedBox(),
      couponamount != '0' ? SizedBox(height: Get.height * 0.018) : SizedBox(),
      //! ------  Coupon price -----
      couponamount != '0'
          ? Payment(
              text1: TextString.couponAmount,
              text2: "$currency$couponamount",
            )
          : SizedBox(),
      SizedBox(height: Get.height * 0.018),
      //! ----- Item discount -----
      Payment(
          text1: TextString.itemdis,
          textcolor: Colors.green[700],
          text2: "-$currency"
              "${double.parse(itemDiscount.toString()).toStringAsFixed(2)}"),
      SizedBox(height: Get.height * 0.018),
      //! ----- Item Tax -----
      Payment(
        text1: TextString.tax,
        text2: "$currency" "${itemtax}",
      ),
      SizedBox(height: Get.height * 0.018),
      //! ----- Convenience fee -----
      Payment(
          decoration: TextDecoration.underline,
          dotted: TextDecorationStyle.dotted,
          text1: TextString.convenience,
          text2: "$currency$convenienceFee"),
      SizedBox(height: Get.height * 0.01),
      Divider(color: greycolor),
      SizedBox(height: Get.height * 0.01),
      //! ------ total ------
      Payment(
          text1: TextString.totel,
          fontstyle: CustomColors.fontFamily,
          fontstyle2: CustomColors.fontFamily,
          text2:
              "$currency${double.parse(totalprice.toString()).toStringAsFixed(2)}"),
    ]);
  }

  walletCalculation(value) {
    if (value == true) {
      if (double.parse(wallet.toString()) <
          double.parse(totalprice.toString())) {
        tempWallet = double.parse(totalprice.toString()) -
            double.parse(wallet.toString());

        useWallet = double.parse(wallet.toString());

        totalprice = (double.parse(totalprice.toString()) -
                double.parse(wallet.toString()))
            .toString();
        tempWallet = 0;
        setState(() {});
      } else {
        tempWallet = double.parse(wallet.toString()) -
            double.parse(totalprice.toString());
        useWallet = double.parse(wallet.toString()) - tempWallet;
        totalprice = 0;
      }
    } else {
      // itempriceCount();
      tempWallet = double.parse(wallet.toString());
      totalprice = valuePlus(totalprice, useWallet);
      useWallet = 0;
      setState(() {});
    }
  }

  itempriceCount(totalPrice) {
    setState(() {});
    if (couponamount != "0") {
      couponprice = valueCal(totalPrice, couponamount);
    } else {
      couponprice = totalPrice.toString();
    }
    itemtax = doublevaluPer(totalPrice, itemtexPer);

    var newprice = couponprice != "0" ? couponprice : totalPrice;

    var convefee = valuePlus(newprice, convenienceFee);

    totalprice = valuePlus(convefee, itemtax);
  }

  walletDetail() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pay from Wallet",
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: Get.height * 0.01),
            Text("Wallet Balance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: Get.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(height: Get.height * 0.01),
                    Text("Available for Payment ",
                        style: TextStyle(color: Colors.black45)),
                    Text("$currency${tempWallet.toStringAsFixed(2)}",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    activeColor: CustomColors.primaryColor,
                    value: status,
                    onChanged: (value) {
                      setState(() {});
                      status = value;
                      walletCalculation(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  sumreyList(user, i) {
    var newprice;
    var subDiscount;
    if (int.parse(users[i].quantity.toString()) > 0) {
      newprice = doublevaluPer(user[i].price, user[i].discount);
      var disqun = valueCal(user[i].price, newprice);
      subDiscount = doublevaluemulti(disqun, user[i].quantity);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Ink(
              width: Get.width * 0.48,
              child: Text("${user[i].title}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomColors.fontFamily,
                      fontWeight: FontWeight.w600,
                      color: BlackColor)),
            ),
            buttonIncrement(
              count: user[i].quantity,
              //! ---- Decrement Button ------
              decrement: () {
                setState(() {
                  var newprice = doublevaluPer(user[i].price, user[i].discount);
                  var subDiscount = valueCal(user[i].price, newprice);
                  if (1 <= int.parse(user[i].quantity)) {
                    setState(() {});
                    counter1--;
                    subWise.updateServiceData(
                      serviceid: user[i].serviceid,
                      quantity: (int.parse(user[i].quantity) - 1).toString(),
                    );
                    if (counter1 == 0) {
                      setState(() {});
                      itemDiscount = 0.0;

                      Get.back(result: {
                        "disp": '0',
                        "count": '0',
                        "total": '0',
                        "itemDiscount": "0",
                      });
                    }
                    if (int.parse(users[i].quantity.toString()) == 1) {
                      selectCartList.remove(user[i].serviceid);
                    }

                    discountPrice = double.parse(discountPrice.toString()) -
                        double.parse(user[i].price.toString());
                    itemDiscount =
                        itemDiscount - double.parse(newprice.toString());
                    serviceData =
                        serviceData - double.parse(subDiscount.toString());

                    itempriceCount(serviceData);
                    walletCalculation(status);
                  } else {
                    setState(() {});
                  }
                });
              },
              //! ---- Increment Button ------

              increment: () {
                setState(() {
                  if (int.parse("${user[i].maxquantity!}") >
                      int.parse(user[i].quantity)) {
                    setState(() {});
                    var newprice =
                        doublevaluPer(user[i].price, user[i].discount);
                    var subDiscount = valueCal(user[i].price, newprice);
                    counter1++;
                    serviceData =
                        serviceData + double.parse(subDiscount.toString());
                    itemDiscount =
                        itemDiscount + double.parse(newprice.toString());
                    discountPrice = double.parse(discountPrice.toString()) +
                        double.parse(user[i].price.toString());
                    subWise.updateServiceData(
                      serviceid: user[i].serviceid,
                      quantity: (int.parse(user[i].quantity) + 1).toString(),
                    );
                    walletCalculation(status);
                    itempriceCount(serviceData);
                  } else {
                    ApiWrapper.showToastMessage(
                        "You can't add anymore of this item");
                  }
                });
              },
            ),
            user[i].discount != "0"
                ? Column(children: [
                    Text("$currency${subDiscount}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Gilroy Bold",
                            color: BlackColor,
                            fontSize: 14)),
                    Text(
                        "$currency${int.parse(user[i].price) * int.parse(user[i].quantity)}",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontFamily: "Gilroy Bold",
                            color: greycolor,
                            fontSize: 14)),
                  ])
                : Text("$currency${subDiscount}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Gilroy Bold",
                        color: BlackColor,
                        fontSize: 14)),
          ]),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
                width: Get.width * 0.75,
                child: DottedLine(dashColor: Colors.grey.shade300)),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(radius: 3, backgroundColor: greycolor),
              SizedBox(width: Get.width * 0.03),
              Ink(
                  width: Get.width * 0.70,
                  child: Text(user[i].servicedesc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          color: greycolor,
                          fontFamily: "Gilroy Medium"))),
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  getDataApi() {
    try {
      setState(() {});
      isLoding = true;
      var body = {"vendor_id": "1"};
      ApiWrapper.dataPost(Config.getdata, body).then((val) {
        if ((val != null) && (val.isNotEmpty)) {
          if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
            setState(() {});
            convenienceFee = val["CartData"]["cov_fees"];
            itemtexPer = val["CartData"]["tax"];
            walletCalculation(false);
            itempriceCount(double.parse(widget.discountPrice.toString()));

            isLoding = false;
          } else {
            setState(() {});
            isLoding = false;
            ApiWrapper.showToastMessage(val["ResponseMsg"]);
          }
        }
      });
    } catch (e) {
      return e;
    }
  }

  //! Address Sheet seleString? daddresstypected
  Future bottomsheets(stype) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: CustomColors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              SizedBox(height: Get.height / 40),
              Center(
                child: Container(
                    height: Get.height / 80,
                    width: Get.width / 5,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)))),
              ),
              SizedBox(height: Get.height / 50),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const TrackingPage(addressAdd: "0"))!
                        .then((value) {
                      if (value != "back") {
                        itemValue = false;
                        lat2 = getData.read("PickupAddress")[0]["lat_map"];
                        lon2 = getData.read("PickupAddress")[0]["long_map"];
                        hno = getData.read("PickupAddress")[0]["hno"];
                        daddress = getData.read("PickupAddress")[0]["landmark"];
                        drop_address =
                            getData.read("PickupAddress")[0]["address"];
                        daddresstype = getData.read("PickupAddress")[0]["type"];
                        switch (getData.read("PickupAddress")[0]["type"]) {
                          case "Home":
                            stype = "Home";
                            iconImage1 = "assets/selecthome.png";
                            break;
                          case "Office":
                            stype = "Office";
                            iconImage1 = "assets/selectoffice.png";
                            break;
                          case "Other":
                            stype = "Other";
                            iconImage1 = "assets/selectothers.png";
                            break;
                          default:
                        }
                        checkAddress(0);
                      }
                    });
                  },
                  child: bottomsheetaddlocation()),
              SizedBox(height: Get.height / 60),
              Row(
                children: [
                  SizedBox(width: Get.width / 14),
                  Text("Select location",
                      style: TextStyle(
                          fontSize: Get.height * 0.02,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: Get.height / 60),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: addressList.length,
                  itemBuilder: (ctx, i) {
                    var iconImage;
                    //! switch case Add
                    switch (addressList[i]["type"]) {
                      case "Home":
                        inumber = 0;
                        iconImage = "assets/selecthome.png";
                        break;
                      case "Office":
                        inumber = 1;
                        iconImage = "assets/selectoffice.png";
                        break;
                      case "Other":
                        inumber = 1;
                        iconImage = "assets/selectothers.png";
                        break;
                      default:
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: sugestlocation(
                        borderColor: stype == addressList[i]["type"]
                            ? buttonColor
                            : const Color(0xffD6D6D6),
                        title: addressList[i]["type"],
                        val: 0,
                        image: iconImage,
                        adress: addressList[i]["landmark"] == ""
                            ? "${"${addressList[i]["hno"]}, " + addressList[i]["address"]}"
                            : "${"${addressList[i]["hno"]}, " "${addressList[i]["landmark"]}, " + addressList[i]["address"]}",
                        ontap: () {
                          selectid = addressList[i]["id"];
                          itemValue = false;
                          _groupaddress = i;
                          addressID = addressList[i]["id"];
                          lat2 = double.parse(
                              addressList[i]["lat_map"].toString());
                          lon2 = double.parse(
                              addressList[i]["long_map"].toString());
                          daddresstype = addressList[i]["type"];
                          hno = addressList[i]["hno"];
                          dname = addressList[i]["c_name"];
                          drop_address = addressList[i]["address"];
                          daddress = addressList[i]["landmark"];
                          setState(() {});
                          switch (addressList[i]["type"]) {
                            case "Home":
                              stype = "Home";
                              inumber = i;
                              iconImage1 = "assets/selecthome.png";
                              break;
                            case "Office":
                              stype = "Office";
                              inumber = i;
                              iconImage1 = "assets/selectoffice.png";
                              break;
                            case "Other":
                              stype = "Other";
                              inumber = i;
                              iconImage1 = "assets/selectothers.png";
                              break;
                            default:
                          }

                          Get.back();
                        },
                        radio: Radio(
                          activeColor: buttonColor,
                          value: i,
                          groupValue: _groupaddress,
                          onChanged: (value) {
                            setState(() {});
                            _groupValue = inumber;
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: Get.height / 50),
            ],
          );
        });
      },
    );
  }

  Widget bottomsheetaddlocation({Color? bordercolor}) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        height: Get.height / 14,
        width: Get.width / 1.15,
        decoration: BoxDecoration(
            border: Border.all(color: bordercolor ?? const Color(0xffF3F3F3)),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(width: Get.width / 30),
            Image.asset("assets/taskadd.png", height: Get.height / 27),
            SizedBox(width: Get.width / 30),
            Text("Add New Address",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Get.height / 52,
                    fontWeight: FontWeight.bold))
          ],
        ),
      );
    });
  }

  Widget sugestlocation(
      {Function()? ontap,
      title,
      val,
      image,
      adress,
      radio,
      Color? borderColor}) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return InkWell(
        onTap: ontap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 18),
          child: Container(
            height: Get.height / 11,
            decoration: BoxDecoration(
                border: Border.all(color: borderColor!, width: 1),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(11)),
            child: Row(
              children: [
                SizedBox(width: Get.width / 55),
                Container(
                    height: Get.height / 14,
                    width: Get.width / 5.9,
                    decoration: BoxDecoration(
                        color: const Color(0xffF2F4F9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Image.asset(
                      image ?? "",
                      height: Get.height / 28,
                      color: buttonColor,
                    ))),
                SizedBox(width: Get.width / 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height / 50),
                    Text(title,
                        style: TextStyle(
                            fontSize: Get.height / 54,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(
                      width: Get.width * 0.50,
                      child: Text(adress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: Get.height / 60,
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

  timeoftheday(BuildContext context) {
    var tsloat;
    var dsloat;

    return showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(TextString.select,
                      style:
                          TextStyle(fontSize: 18, fontFamily: "Gilroy Bold")),
                  SizedBox(height: Get.height * 0.01),
                  Text(TextString.yourser,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Gilroy Medium",
                          color: greycolor)),
                  SizedBox(height: Get.height * 0.02),
                  curenttimeList.isNotEmpty
                      ? Column(children: [
                          SizedBox(
                            width: double.infinity,
                            child: Column(children: [
                              SizedBox(
                                height: 70,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  itemCount: curentDayList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    dsloat = curentDayList;
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        child: InkWell(
                                          onTap: () {
                                            var cDay = DateFormat('EEE dd')
                                                .format(DateTime.now());

                                            setState(() {
                                              selectDate = curentDayList[index];
                                              selectedIndex = index;
                                            });

                                            if (statusget == "current" &&
                                                cDay == curentDayList[index]) {
                                              curenttimeList.clear();
                                              selectTime = "";
                                              selectDate = "";
                                              var e = DateFormat('hh:mm a')
                                                  .format(DateTime.now());

                                              for (int i = 0;
                                                  i < tempDayList.length;
                                                  i++) {
                                                var format =
                                                    DateFormat("hh:mm a");
                                                var one = format.parse(e);
                                                var two = format.parse(
                                                    tempDayList[i].toString());
                                                if (one.isBefore(two) == true) {
                                                  curenttimeList
                                                      .add(tempDayList[i]);
                                                }
                                              }
                                              selectTime = curenttimeList.first;
                                              selectDate = curentDayList.first;
                                              curenttimeList.isEmpty
                                                  ? curentDayList.remove(
                                                      curentDayList.first)
                                                  : null;
                                            } else {
                                              curenttimeList.clear();
                                              for (var i = 0;
                                                  i < tempDayList.length;
                                                  i++) {
                                                curenttimeList
                                                    .add(tempDayList[i]);
                                              }
                                              selectTime = curenttimeList.first;
                                              selectDate = curentDayList[index];
                                            }
                                          },
                                          child: Container(
                                              margin: const EdgeInsets.all(4),
                                              height: 60,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          selectedIndex == index
                                                              ? buttonColor
                                                              : Colors.grey
                                                                  .shade200),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: selectedIndex == index
                                                      ? perpulshadow
                                                      : WhiteColor),
                                              child: Center(
                                                child: SizedBox(
                                                  width: Get.width * 0.09,
                                                  child: Text(
                                                      curentDayList[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              "Gilroy Bold",
                                                          color: Colors.black)),
                                                ),
                                              )),
                                        ));
                                  },
                                ),
                              ),
                              SizedBox(height: Get.height * 0.02),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(TextString.selected,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Gilroy Bold",
                                        fontWeight: FontWeight.w700)),
                              ),
                              SizedBox(height: Get.height * 0.02),
                              SizedBox(
                                width: Get.width * 0.96,
                                child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 8,
                                    children: [
                                      ...List.generate(curenttimeList.length,
                                          (index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectTime =
                                                    curenttimeList[index];
                                                selectedIndextime = index;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: SizedBox(
                                                width: Get.width * 0.27,
                                                child: Chip(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 4.5),
                                                  deleteIcon: null,
                                                  deleteIconColor: BlackColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  label: Text(
                                                    curenttimeList[index],
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: BlackColor,
                                                        fontFamily:
                                                            "Gilroy Medium"),
                                                  ),
                                                  labelStyle: TextStyle(
                                                      color: Colors.white),
                                                  backgroundColor:
                                                      selectedIndextime == index
                                                          ? perpulshadow
                                                          : WhiteColor,
                                                ),
                                              ),
                                            ));
                                      }),
                                    ]),
                              ),
                            ]),
                          )
                        ])
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          child: Column(children: [
                            Image(
                                image: AssetImage("assets/emptyList.png"),
                                height: Get.height * 0.12),
                            SizedBox(height: Get.height * 0.02),
                            Center(
                              child: SizedBox(
                                width: Get.width * 0.80,
                                child: const Text(
                                    "Its’s look like this service timeslot not available any more...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: CustomColors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: CustomColors.fontFamily,
                                        fontSize: 18)),
                              ),
                            ),
                          ]),
                        ),
                  SizedBox(height: Get.height * 0.015),
                  Divider(color: greycolor),
                  SizedBox(height: Get.height * 0.005),
                  AppButton(
                      buttontext: "Proceed to checkout",
                      onclick: () {
                        curenttimeList.length != 0
                            ? selectTime == ""
                                ? selectTime = curenttimeList.first
                                : null
                            : null;
                        curentDayList.length != 0
                            ? selectDate == ""
                                ? selectDate = curentDayList.first
                                : null
                            : null;

                        Get.back(result: '');
                      })
                ],
              ),
            );
          });
        });
  }

//! -------------------------- payment gatway ------------------------------------
  Future paymentSheet() {
    var isload = false;
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Wrap(children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: 10),
              Center(
                child: Container(
                  height: Get.height / 80,
                  width: Get.width / 5,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
              SizedBox(height: Get.height / 50),
              Row(children: [
                SizedBox(width: Get.width / 14),
                Text("Select Payment Method",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: Get.height / 40,
                        fontFamily: 'Gilroy_Bold')),
              ]),
              SizedBox(height: Get.height / 50),
              //! --------- List view paymente ----------
              SizedBox(
                height: Get.height * 0.50,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: paymentList.length,
                  itemBuilder: (ctx, i) {
                    return paymentList[i]["status"] != "0"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: sugestlocationtype(
                              borderColor: selectidpay == paymentList[i]["id"]
                                  ? buttonColor
                                  : const Color(0xffD6D6D6),
                              title: paymentList[i]["title"],
                              titleColor: Colors.black,
                              val: 0,
                              image:
                                  "${Config.imgBaseUrl + paymentList[i]["img"]}",
                              adress: paymentList[i]["subtitle"],
                              ontap: () async {
                                setState(() {
                                  razorpaykey = paymentList[i]["attributes"];
                                  paymenttital = paymentList[i]["title"];
                                  selectidpay = paymentList[i]["id"];
                                  _groupValue = i;
                                });
                              },
                              radio: Radio(
                                activeColor: buttonColor,
                                value: i,
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ))
                        : SizedBox();
                  },
                ),
              ),

              SizedBox(height: 10),
              InkWell(
                  onTap: () {
                    //!---- Stripe Payment ------
                    if (paymenttital == "Stripe") {
                      Get.back();
                      stripePayment();
                    } else if (paymenttital == "Paypal") {
                      //!---- PayPal Payment ------
                      Get.to(() => PayPalPayment(totalAmount: totalprice))!
                          .then((otid) {
                        if (otid != null) {
                          buyNoworder(otid);
                          ApiWrapper.showToastMessage("Payment Successfully");
                        } else {
                          Get.back();
                        }
                      });
                    } else if (paymenttital == "Razorpay") {
                      //!---- Razorpay Payment ------
                      Get.back();
                      openCheckout();
                    } else if (paymenttital == "Cash On Delivery") {
                      //!---- Cash On Delivery ------
                      Get.back();
                      buyNoworder(0);
                    }
                  },
                  child: paynowbutton())
            ]);
          }),
        ]);
      },
    );
  }

  Widget paynowbutton() {
    return Padding(
      padding: EdgeInsets.only(bottom: Get.height * 0.03),
      child: Container(
        height: Get.height / 16,
        width: Get.width / 1.1,
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
              "PAY NOW | "
              "$currency${totalprice}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Get.height / 50,
                  fontFamily: 'Gilroy_Medium')),
        ),
      ),
    );
  }

  //!--------------------------- payment Widget --------------------
  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  final _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;
  bool isloading = false;

  final _card = PaymentCard();
  stripePayment() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Ink(
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 45),
                    Center(
                      child: Container(
                        height: Get.height / 85,
                        width: Get.width / 5,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.03),
                          Text('Add Your payment information',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5)),
                          SizedBox(height: Get.height * 0.02),
                          Form(
                              key: _formKey,
                              autovalidateMode: _autoValidateMode,
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(19),
                                        CardNumberInputFormatter()
                                      ],
                                      controller: numberController,
                                      onSaved: (String? value) {
                                        _paymentCard.number =
                                            CardUtils.getCleanedNumber(value!);

                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(
                                                _paymentCard.number.toString());
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      onChanged: (val) {
                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(val);
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      validator: CardUtils.validateCardNum,
                                      decoration: InputDecoration(
                                          prefixIcon: SizedBox(
                                              height: 10,
                                              child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                      horizontal: 6),
                                                  child: CardUtils.getCardIcon(
                                                      _paymentCard.type))),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: buttonColor)),
                                          focusedBorder:
                                              OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                          hintText: 'What number is written on card?',
                                          hintStyle: TextStyle(color: Colors.grey),
                                          labelStyle: TextStyle(color: Colors.grey),
                                          labelText: 'Number')),
                                  const SizedBox(height: 20),
                                  Row(children: [
                                    Flexible(
                                      flex: 4,
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.grey),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        decoration: InputDecoration(
                                            prefixIcon: SizedBox(
                                                height: 10,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 14),
                                                    child: Image.asset(
                                                        'image/card_cvv.png',
                                                        width: 6,
                                                        color: buttonColor))),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: buttonColor)),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: buttonColor)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: buttonColor)),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                            hintText: 'Number behind the card',
                                            hintStyle: TextStyle(color: Colors.grey),
                                            labelStyle: TextStyle(color: Colors.grey),
                                            labelText: 'CVV'),
                                        validator: CardUtils.validateCVV,
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) {
                                          _paymentCard.cvv = int.parse(value!);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: Get.width * 0.03),
                                    Flexible(
                                      flex: 4,
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                          CardMonthInputFormatter()
                                        ],
                                        decoration: InputDecoration(
                                            prefixIcon: SizedBox(
                                                height: 10,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 14),
                                                    child: Image.asset(
                                                        'image/calender.png',
                                                        width: 10,
                                                        color: buttonColor))),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: buttonColor)),
                                            focusedErrorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: buttonColor)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: buttonColor)),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonColor)),
                                            hintText: 'MM/YY',
                                            hintStyle: TextStyle(color: Colors.black),
                                            labelStyle: TextStyle(color: Colors.grey),
                                            labelText: 'Expiry Date'),
                                        validator: CardUtils.validateDate,
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) {
                                          List<int> expiryDate =
                                              CardUtils.getExpiryDate(value!);
                                          _paymentCard.month = expiryDate[0];
                                          _paymentCard.year = expiryDate[1];
                                        },
                                      ),
                                    )
                                  ]),
                                  SizedBox(height: Get.height * 0.055),
                                  Container(
                                      alignment: Alignment.center,
                                      child: _getPayButton()),
                                  SizedBox(height: Get.height * 0.065),
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future orderSuccess() {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      enableDrag: false,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      height: Get.height / 80,
                      width: Get.width / 5,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                  SizedBox(height: Get.height / 50),
                  SizedBox(height: Get.height * 0.02),
                  Image(image: AssetImage("assets/Success.png"), height: 120),

                  Text("Order Placed",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: Get.height * 0.02),

                  SizedBox(
                    width: Get.width * 0.80,
                    child: Text("Your order has been Successfully placed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Divider(color: Colors.grey, thickness: 1),
                  SizedBox(height: Get.height * 0.04),

                  //!-------- button --------
                  Padding(
                    padding: EdgeInsets.only(bottom: Get.height * 0.03),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => BottomNavigationBarScreen());
                      },
                      child: Container(
                        height: Get.height / 16,
                        width: Get.width / 1.1,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Go to My Booking",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Get.height / 50,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward)
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      var username = getData.read("UserLogin")["name"] ?? "";
      var email = getData.read("UserLogin")["email"] ?? "";
      _paymentCard.name = username;
      _paymentCard.email = email;
      _paymentCard.amount = totalprice;
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        Get.back();
        //! order Api call
        if (otid != null) {
          //! Api Call Payment Success
          buyNoworder(otid);
        }
      });

      _showInSnackBar('Payment card is valid');
    }
  }

  Widget _getPayButton() {
    return SizedBox(
      width: Get.width,
      child: CupertinoButton(
          onPressed: _validateInputs,
          color: buttonColor,
          child: Text("Pay $currency${totalprice}",
              style: TextStyle(fontSize: 17.0))),
    );
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value), duration: const Duration(seconds: 3)));
  }

  void openCheckout() async {
    var username = getData.read("UserLogin")["name"] ?? "";
    var mobile = getData.read("UserLogin")["mobile"] ?? "";
    var email = getData.read("UserLogin")["email"] ?? "";
    var options = {
      'key': razorpaykey,
      'amount': (double.parse(totalprice) * 100).toString(),
      'name': username,
      'description': ticketType,
      'timeout': 300,
      'prefill': {'contact': mobile, 'email': email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  //! -----------------------  order Api Call ---------------------------
  buyNoworder(otid) {
    setState(() {
      isloading = true;
    });
    List<dynamic> itemList = [];
    var address = daddress == ""
        ? "${"${hno}, "
            "${drop_address}"}"
        : "${"${hno}, "
            "${daddress}, "
            "${drop_address}"}";
    for (var i = 0; i < users.length; i++) {
      if (int.parse(users[i].quantity.toString()) > 0) {
        var newprice = doublevaluPer(users[i].price, users[i].discount);
        var disqun = valueCal(users[i].price, newprice);
        var subDiscount = doublevaluemulti(disqun, users[i].quantity);
        itemList.add({
          "title": users[i].title,
          "cost": (double.parse(users[i].price.toString()) *
                  double.parse(users[i].quantity.toString()))
              .toStringAsFixed(2),
          "qty": users[i].quantity,
          "discount": "$subDiscount",
          "actual_discount": users[i].discount,
          "pimg": users[i].img
        });
      }
    }

    var body = {
      "uid": uid.toString(),
      "vendor_id": widget.vendorID.toString(),
      "catid": widget.catID,
      "tax": "$itemtax",
      "p_method_id": selectidpay.toString(),
      "full_address": address.toString(),
      "time": selectTime ?? "0",
      "date": selectDate ?? "0",
      "wal_amt": useWallet.toString(),
      "cou_amt": couponamount.toString(),
      "cou_id": c_id ?? "0",
      "transaction_id": "$otid",
      "product_total": "$totalprice",
      "subtotal": serviceData.toStringAsFixed(2),
      "conv_fee": convenienceFee.toString(),
      "tip": "0",
      "lats": "$lat",
      "longs": "$long",
      "ProductData": [
        for (var i = 0; i < itemList.length; i++)
          {
            "title": itemList[i]["title"],
            "cost": itemList[i]["cost"],
            "qty": itemList[i]["qty"],
            "discount": itemList[i]["discount"],
            "actual_discount": itemList[i]["actual_discount"],
            "pimg": itemList[i]["pimg"]
          },
      ]
    };

    ApiWrapper.dataPost(Config.ordernow, body).then((val) {
      if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
        walletAmount = wallet;
        setState(() {
          isloading = false;
        });
        Get.back();
        orderSuccess();
        ApiWrapper.showToastMessage(val["ResponseMsg"]);
      } else {
        setState(() {
          isloading = false;
        });
        ApiWrapper.showToastMessage(val["ResponseMsg"]);
      }
    });
  }

  //! user CountryCode
  paymentgateway() {
    ApiWrapper.dataGet(Config.paymentlist).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          paymentList = val["paymentdata"];
          setState(() {});
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  checkAddress(edit) {
    var data = {"uid": uid};
    ApiWrapper.dataPost(Config.addressList, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          addressList = val["AddressList"];
          if (edit == 1) {
            addressID = val["AddressList"][0]["id"];
            drop_address = val["AddressList"][0]["address"];
            daddresstype = val["AddressList"][0]["type"];
            hno = val["AddressList"][0]["hno"];
            dname = val["AddressList"][0]["c_name"];
            daddress = val["AddressList"][0]["landmark"];
            lat2 = double.parse(val["AddressList"][0]["lat_map"].toString());
            lon2 = double.parse(val["AddressList"][0]["long_map"].toString());
          }
        }
      }
    });
  }

  var timeSloate;
  Future timeSloatApi() async {
    curenttimeList.clear();

    var data = {
      "vendor_id": widget.vendorID,
      "cat_id": widget.catID,
    };
    try {
      var url = Uri.parse(Config.baseUrl + Config.timeSloat);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        setState(() {});
        statusget = response["TimeslotData"][0]["status"];
        curentDayList = response["TimeslotData"][0]["days"];
        timeSloate = response["TimeslotData"];
        tempDayList = response["TimeslotData"][0]["timeslot"];

        if (response["TimeslotData"][0]["status"] == "current") {
          var e = DateFormat('hh:mm a').format(DateTime.now());
          for (int i = 0;
              i < response["TimeslotData"][0]["timeslot"].length;
              i++) {
            var format = DateFormat("hh:mm a");
            var one = format.parse(e);

            var two = format
                .parse(response["TimeslotData"][0]["timeslot"][i].toString());

            if (one.isBefore(two) == true) {
              curenttimeList.add(response["TimeslotData"][0]["timeslot"][i]);
            }
          }
          if (curenttimeList.isEmpty) {
            curentDayList.remove(curentDayList.first);
            for (var i = 0;
                i < response["TimeslotData"][0]["timeslot"].length;
                i++) {
              curenttimeList.add(response["TimeslotData"][0]["timeslot"][i]);
            }
          }
        } else {
          for (var i = 0;
              i < response["TimeslotData"][0]["timeslot"].length;
              i++) {
            curenttimeList.add(response["TimeslotData"][0]["timeslot"][i]);
          }
        }
      } else {
        setState(() {});

        curenttimeList = [];
      }
    } catch (e) {
      return e;
    }
  }

  Future timeSloatApi2() async {
    var data = {
      "vendor_id": widget.vendorID,
      "cat_id": widget.catID,
    };
    try {
      var url = Uri.parse(Config.baseUrl + Config.timeSloat);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        setState(() {});
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  homePageApi() {
    try {
      var body = {"uid": uid, "lats": lat, "longs": long};

      ApiWrapper.dataPost(Config.homePage, body).then((val) {
        if ((val != null) && (val.isNotEmpty)) {
          if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
            setState(() {});
            var homePageModel = HomePageModel.fromJson(val);
            currency = val["HomeData"]["currency"];
            referCredit = val["HomeData"]["Refer_Credit"];
            wallet = val["HomeData"]["wallet"].toString();
            walletAmount = val["HomeData"]["wallet"].toString();
            walletCalculation(false);

            setState(() {});
          } else {
            setState(() {});

            isLoding = false;
            ApiWrapper.showToastMessage(val["ResponseMsg"]);
          }
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }
}
