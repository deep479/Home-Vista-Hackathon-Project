// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_field, prefer_final_fields, unnecessary_brace_in_string_interps, avoid_print, unused_catch_clause, prefer_const_constructors, unused_element

import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/custom_widegt/Colors.dart';
import 'package:ucservice_customer/custom_widegt/widegt.dart';
import 'package:ucservice_customer/model/address_list_model.dart';
import 'package:ucservice_customer/model/register_model.dart';
import 'package:ucservice_customer/AppScreens/Home/Summery.dart';
import 'package:ucservice_customer/AppScreens/Home/traking.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';
import 'package:ucservice_customer/utils/text_widget.dart';

import 'home_screen.dart';

class Servicedetail extends StatefulWidget {
  const Servicedetail({super.key});

  @override
  State<Servicedetail> createState() => _ServicedetailState();
}

class _ServicedetailState extends State<Servicedetail> {
  int selectedIndex = 0;
  int service = 0;
  int _counter1 = 0;
  List addressList = [];
  var height;
  var width;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _groupValue = 0;
  int _payValue = 0;
  String? paddress = "choosepickupaddress";
  String? pcNumber = "";
  String? paddresstype;
  String? daddress = "chooicedropaddress";
  String? dcNumber = "";
  String? daddresstype;
  String? taskaddress = "taskdetails";
  String? taskselectitem;
  String? tasktype = "taskdetails";
  String? taskDetail;
  String? selectidpay = "3";
  String? paymenttital;
  String? addressID = "0";
  String? addressID1 = "0";
  bool itemValue = false;
  String phno = "";
  String dhno = "";
  String? plandmark;
  String? dlandmark;
  String? validationAddress;
  String? selectid = "0";
  bool? pick = false;
  bool? drop = false;
  String? pname;
  String? dname;
  String ptracking = "0";
  String dtracking = "0";
  dynamic dcharge = "0";
  bool isloading = false;
  bool isload = false;
  var inumber = 0;
  int inumber2 = 0;

  bool? showButton = false;
  var lat1;
  var lon1;
  var lat2;
  var lon2;
  List paymentList = [];

  double totaldistance = 0.0;
  dynamic totaltime = 0;
  dynamic deliveryfees = "0";
  var complexitycharges = "0";
  var exmilecharge = "0";
  var deliveryvat = "0";
  var removevat = "0";
  var vatremove = "0";
  bool upDistance = false;

  final custNumber = TextEditingController();
  final dropNumber = TextEditingController();

  Dio dio = Dio();
  var iconImage;
  // var uid;

  AddressListModel? addressListModel;

  RegisterModel? registerModel;

  /// Address List Api
  checkAddress() async {
    try {
      var data = {"uid": uid};
      final response =
          await dio.post(Config.baseUrl + Config.addressList, data: data);
      if (response.statusCode == 200) {
        setState(() {
          addressListModel = AddressListModel.fromJson(response.data);
        });
        if (addressListModel?.result == "true") {
          Fluttertoast.showToast(msg: addressListModel!.responseMsg!);
          addressList = addressListModel!.addressList!.toList();
        } else {
          Fluttertoast.showToast(msg: addressListModel!.responseMsg!);
        }
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: "Error");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        color: WhiteColor,
        padding: const EdgeInsets.all(8),
        height: 70,
        child: AppButton(
            buttontext: TextString.addad,
            onclick: () {
              timeoftheday();
            }),
      ),
      backgroundColor: bgcolor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppbar(
              bgcolor: bgcolor,
              leadingiconcolor: BlackColor,
              titlecolor: BlackColor,
              centertext: TextString.summar,
              ActionIcon: null)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(TextString.youre,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Gilroy Bold",
                            color: BlackColor)),
                  ),
                  Image.asset(ImagePath.coinImg, height: 30),
                ],
              ),
            ),
            Divider(color: greycolor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Text(
                          TextString.make,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Gilroy Bold",
                              color: BlackColor),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 90,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: perpulshadow),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      _counter1--;
                                    });
                                  },
                                  child: const Icon(Icons.remove, size: 15)),
                              Text("$_counter1",
                                  style: TextStyle(
                                      fontFamily: "Gilroy Bold",
                                      color: buttonColor,
                                      fontSize: 16)),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      _counter1++;
                                    });
                                  },
                                  child: const Icon(Icons.add, size: 15)),
                            ]),
                      ),
                      Column(
                        children: [
                          Text(
                            "₹1,376",
                            style: TextStyle(
                                fontFamily: "Gilroy Bold",
                                color: BlackColor,
                                fontSize: 16),
                          ),
                          Text(
                            "₹1,503",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontFamily: "Gilroy Bold",
                                color: greycolor,
                                fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  DottedLine(dashColor: greycolor),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  /// List of  Detail Description
                  detailDescription(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  /// Plus MemberShip
                  plusMembership(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  Text(
                    TextString.frequently,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Gilroy Bold",
                        color: BlackColor),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future bottomsheets(BuildContext context, String stype, String? ptype) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: CustomColors.white,
      isDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              SizedBox(height: height / 40),
              Center(
                child: Container(
                    height: height / 80,
                    width: width / 5,
                    decoration: BoxDecoration(
                        color: greycolor.withOpacity(0.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)))),
              ),
              const SizedBox(height: 50),
              InkWell(
                  onTap: () async {
                    Get.to(() => const TrackingPage());
                  },
                  child: bottomsheetaddlocation()),
              SizedBox(height: height / 50),
              Row(
                children: [
                  SizedBox(width: width / 14),
                  Text("Select Location",
                      style: TextStyle(
                          fontSize: height / 40, fontFamily: 'Gilroy_Bold')),
                ],
              ),
              SizedBox(height: height / 50),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: addressListModel?.addressList?.length ?? 0,
                  itemBuilder: (ctx, i) {
                    //! switch case Add
                    switch (addressListModel!.addressList![i].type) {
                      case "Home":
                        inumber = 0;
                        iconImage = "assets/selecthome.png";
                        break;
                      case "office":
                        inumber = 1;
                        iconImage = "assets/selectoffice.png";
                        break;
                      case "other":
                        inumber = 2;
                        iconImage = "assets/selectothers.png";
                        break;
                      default:
                    }

                    switch (ptype) {
                      case "Home":
                        ptype = "Home";
                        _groupValue = 0;
                        break;
                      case "Office":
                        ptype = "Office";
                        _groupValue = 1;
                        break;
                      case "Other":
                        ptype = "Other";
                        _groupValue = 2;
                        break;
                      default:
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: sugestlocation(
                        borderColor:
                            ptype == addressListModel!.addressList![i].type
                                ? CustomColors.primaryColor
                                : const Color(0xffD6D6D6),
                        title: addressListModel!.addressList![i].type,
                        val: 0,
                        image: iconImage ?? "",
                        adress: addressListModel!.addressList![i].landmark != ""
                            ? "${addressListModel!.addressList![i].hno}, ${addressListModel!.addressList![i].landmark}, ${addressListModel!.addressList![i].address}"
                            : "${addressListModel!.addressList![i].hno}, ${addressListModel!.addressList![i].address}",
                        ontap: () {
                          setState(() {});
                          selectid = addressListModel!.addressList![i].id;
                          _groupValue = i;
                          switch (addressListModel!.addressList![i].type) {
                            case "Home":
                              ptype = "Home";
                              break;
                            case "Office":
                              ptype = "Office";
                              break;
                            case "Other":
                              ptype = "Other";
                              break;
                            default:
                          }
                          if (paddresstype !=
                                  addressListModel!.addressList![i].type &&
                              daddresstype !=
                                  addressListModel!.addressList![i].type) {
                            if (stype == "Pickup") {
                              setState(() {});
                              pick = true;
                              addressID = addressListModel!.addressList![i].id;
                              lat1 = double.parse(addressListModel!
                                  .addressList![i].latMap
                                  .toString());
                              lon1 = double.parse(addressListModel!
                                  .addressList![i].longMap
                                  .toString());
                              phno = addressListModel!.addressList![i].hno!;
                              pname = addressListModel!.addressList![i].cName
                                  .toString();

                              plandmark =
                                  addressListModel!.addressList![i].landmark;
                              paddress =
                                  addressListModel!.addressList![i].address;
                              custNumber.text =
                                  addressListModel!.addressList![i].cName!;
                              paddresstype =
                                  addressListModel!.addressList![i].type;
                              if ((lat1 != null &&
                                  lat2 != null &&
                                  lon1 != null &&
                                  lon2 != null)) {}
                            } else {
                              setState(() {});
                              drop = true;

                              addressID1 = addressListModel!.addressList![i].id;
                              lat2 = double.parse(addressListModel!
                                  .addressList![i].latMap
                                  .toString());
                              lon2 = double.parse(addressListModel!
                                  .addressList![i].longMap
                                  .toString());
                              dhno = addressListModel!.addressList![i].hno!;
                              dlandmark =
                                  addressListModel!.addressList![i].landmark;
                              dname = addressListModel!.addressList![i].cName
                                  .toString();

                              daddress =
                                  addressListModel!.addressList![i].address;
                              dropNumber.text =
                                  addressListModel!.addressList![i].cNumber!;
                              daddresstype =
                                  addressListModel!.addressList![i].type;
                            }
                            if ((lat1 != null &&
                                lat2 != null &&
                                lon1 != null &&
                                lon2 != null)) {
                              // calculateDistance(lat1, lon1, lat2, lon2);
                            }
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            if (stype == "Pickup") {
                              drop = false;
                              daddresstype = null;
                              daddress = "chooicedropaddress";
                              addressID = addressListModel!.addressList![i].id;
                              lat1 = double.parse(addressListModel!
                                  .addressList![i].latMap
                                  .toString());
                              lon1 = double.parse(addressListModel!
                                  .addressList![i].longMap
                                  .toString());
                              phno = addressListModel!.addressList![i].hno!;
                              pname = addressListModel!.addressList![i].cName;
                              // ptracking =
                              //     addressList[i]["is_tracking"].toString();

                              plandmark =
                                  addressListModel!.addressList![i].landmark;
                              paddress =
                                  addressListModel!.addressList![i].address;
                              custNumber.text =
                                  addressListModel!.addressList![i].cNumber!;
                              paddresstype = addressList[i]["type"];
                              if ((lat1 != null &&
                                  lat2 != null &&
                                  lon1 != null &&
                                  lon2 != null)) {}
                            } else {
                              pick = false;
                              paddresstype = null;
                              paddress = "choosepickupaddress";

                              addressID1 = addressListModel!.addressList![i].id;
                              lat2 = double.parse(addressListModel!
                                  .addressList![i].latMap
                                  .toString());
                              lon2 = double.parse(addressListModel!
                                  .addressList![i].longMap
                                  .toString());
                              dhno = addressListModel!.addressList![i].hno!;
                              dlandmark =
                                  addressListModel!.addressList![i].landmark;
                              dname = addressListModel!.addressList![i].cName
                                  .toString();
                              daddress =
                                  addressListModel!.addressList![i].address;
                              dropNumber.text =
                                  addressListModel!.addressList![i].cNumber!;
                              daddresstype =
                                  addressListModel!.addressList![i].type;
                              if ((lat1 != null &&
                                  lat2 != null &&
                                  lon1 != null &&
                                  lon2 != null)) {}
                            }
                          }
                        },
                        radio: Radio(
                          activeColor: CustomColors.primaryColor,
                          value: inumber,
                          groupValue: _groupValue,
                          onChanged: (value) {
                            setState(() {
                              _groupValue = inumber;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: height / 50),
            ],
          );
        });
      },
    );
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
          padding: EdgeInsets.symmetric(horizontal: width / 18),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
                border: Border.all(color: borderColor!, width: 1),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(11)),
            child: Row(children: [
              SizedBox(width: width / 55),
              Container(
                  height: height / 12,
                  width: width / 5.5,
                  decoration: BoxDecoration(
                      color: const Color(0xffF2F4F9),
                      borderRadius: BorderRadius.circular(10)),
                  child:
                      Center(child: Image.asset(image, height: height / 26))),
              SizedBox(width: width / 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.012),
                  Text(title,
                      style: TextStyle(
                          fontSize: height / 55,
                          fontFamily: 'Gilroy_Bold',
                          color: CustomColors.black)),
                  SizedBox(
                    width: width * 0.50,
                    child: Text(adress,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: height / 65,
                            fontFamily: 'Gilroy_Medium',
                            color: CustomColors.grey)),
                  ),
                ],
              ),
              const Spacer(),
              radio
            ]),
          ),
        ),
      );
    });
  }

  Widget bottomsheetaddlocation() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        height: height / 14,
        width: width / 1.15,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF3F3F3)),
            borderRadius: BorderRadius.circular(13)),
        child: Row(children: [
          SizedBox(width: width / 30),
          Image.asset("assets/images/add_icon.png", height: height / 27),
          SizedBox(width: width / 30),
          Text("Add New Address",
              style: TextStyle(
                  color: CustomColors.black,
                  fontSize: height / 50,
                  fontFamily: 'Gilroy_Bold'))
        ]),
      );
    });
  }

  /// List of detail Description
  Widget detailDescription() {
    return ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (BuildContext Context, int index) {
          return Column(children: [
            Row(children: [
              CircleAvatar(radius: 4, backgroundColor: greycolor),
              SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              Text(
                TextString.cutfile,
                style: TextStyle(
                    fontSize: 16,
                    color: greycolor,
                    fontFamily: "Gilroy Medium"),
              ),
            ]),
            const SizedBox(height: 10),
          ]);
        });
  }

  /// Plus Membership Widget
  Widget plusMembership() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(TextString.plus,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: CustomColors.fontFamily,
                  color: BlackColor)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          Text(
            TextString.month,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: CustomColors.fontFamily,
                color: greycolor),
          ),
        ]),
        InkWell(
          onTap: () {},
          child: Container(
            height: 40,
            width: 70,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: perpulshadow),
            child: Center(
              child: Text("Add",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Gilroy Bold",
                      color: buttonColor)),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              "₹299",
              style: TextStyle(
                  fontFamily: "Gilroy Bold", color: BlackColor, fontSize: 16),
            ),
            Text(
              "₹999",
              style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontFamily: "Gilroy Bold",
                  color: greycolor,
                  fontSize: 16),
            ),
          ],
        )
      ],
    );
  }

  Payment(
      {text1, text2, TextDecoration? decoration, TextDecorationStyle? dotted}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: TextStyle(
              fontFamily: "Gilroy Medium",
              fontSize: 16,
              decoration: decoration,
              decorationStyle: dotted),
        ),
        Text(
          text2,
          style: const TextStyle(fontFamily: "Gilroy Medium", fontSize: 16),
        )
      ],
    );
  }

  Addtip({text}) {
    return Container(
      height: 40,
      width: 85,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: WhiteColor),
      child: Center(
          child: Text(text,
              style:
                  const TextStyle(fontFamily: "Gilroy Medium", fontSize: 16))),
    );
  }

  void _showToast(BuildContext context) {
    ////////////// toast code ////////////////
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xffe3f2de),
        content: Text(
          TextString.logged,
          style: TextStyle(color: Color(0xff5bac80)),
        ),
      ),
    );
  }

  timeoftheday() {
    return showModalBottomSheet(
        backgroundColor: bgcolor,
        isScrollControlled: true,
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            // ignore: sized_box_for_whitespace
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      TextString.select,
                      style: TextStyle(fontSize: 18, fontFamily: "Gilroy Bold"),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      TextString.yourser,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Gilroy Medium",
                          color: greycolor),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    /// List Of Date
                    SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(4),
                                    height: 60,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: greycolor),
                                        borderRadius: BorderRadius.circular(10),
                                        color: selectedIndex == index
                                            ? perpulshadow
                                            : WhiteColor),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Sun",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Gilroy Bold",
                                                color: greycolor)),
                                        const Text("01",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Gilroy Bold"))
                                      ],
                                    )),
                              ));
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    ///
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: greycolor.withOpacity(0.2)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(TextString.freecen,
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Gilroy Bold")),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const Text(TextString.selected,
                        style:
                            TextStyle(fontSize: 15, fontFamily: "Gilroy Bold")),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    /// Time List
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 4,
                          children: [
                            ...List.generate(
                              5,
                              (index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = service;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Chip(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 4.5),
                                    deleteIcon: null,
                                    deleteIconColor: BlackColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    label: Text(
                                      "05:30 PM",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: BlackColor,
                                          fontFamily: "Gilroy Medium"),
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    backgroundColor: WhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015),
                    Divider(color: greycolor),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    AppButton(
                        buttontext: "Proceed to checkout",
                        onclick: () {
                          setState(() {
                            editpackage = !editpackage;
                          });
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Summery()));
                        })
                  ],
                ),
              ),
            );
          });
        });
  }

  calander({text, text1, Function()? onclick}) {
    return InkWell(
      onTap: onclick,
      child: Container(
          margin: EdgeInsets.all(4),
          height: 60,
          width: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: WhiteColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Gilroy Bold",
                      color: greycolor)),
              Text(text1,
                  style:
                      const TextStyle(fontSize: 15, fontFamily: "Gilroy Bold"))
            ],
          )),
    );
  }
}
