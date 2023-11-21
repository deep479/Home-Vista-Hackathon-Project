// ignore_for_file: unused_import, file_names, depend_on_referenced_packages, no_duplicate_case_values

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:http/http.dart' as http;

import '../../ApiServices/Api_werper.dart';
import '../../utils/AppWidget.dart';
import 'BookingDetails.dart';
import 'CancelledPage.dart';
import 'oldCancel.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen({Key? key}) : super(key: key);

  @override
  State<ActiveScreen> createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  String? oStatus = '';
  Color? buttonColor;
  @override
  void initState() {
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
      body: FutureBuilder(
        future: bookingActiveApi(),
        builder: (context, AsyncSnapshot snap) {
          if (snap.hasData) {
            var users = snap.data;
            return users.length != 0
                ? ListView.builder(
                    itemCount: users.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      return activeList(users[i]);
                    },
                  )
                : emptyBooking();
          } else {
            return Center(child: isLoadingIndicator());
          }
        },
      ),
    );
  }

  activeList(users) {
    switch (users["status"]) {
      case "Accepted":
        oStatus = users["status"];
        buttonColor = CustomColors.gradientColor;
        break;
      case "Pending":
        oStatus = users["status"];
        buttonColor = CustomColors.orangeColor;
        break;
      case "Ongoing":
        oStatus = users["status"];
        buttonColor = CustomColors.lightyello;
        break;
      case "Pickup Order":
        oStatus = users["status"];
        buttonColor = CustomColors.gradientColor;
        break;
      case "Pickup Order":
        oStatus = users["status"];
        buttonColor = CustomColors.RedColor;
        break;
      case "Job_start":
        oStatus = users["status"];
        buttonColor = CustomColors.gradientColor;
        break;
      case "Processing":
        oStatus = users["status"];
        buttonColor = CustomColors.gradientColor;
        break;
      default:
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: InkWell(
        onTap: () {
          Get.to(() => OrderDetailsPage(orderID: users["id"]));
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: notifire.detail,
              ),
              borderRadius: BorderRadius.circular(12)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${users["id"]}",
                    style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: CustomColors.fontFamily),
                  ),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        users["status"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: CustomColors.fontFamily),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "Service Date",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: notifire.getdarkscolor,
                    fontFamily: CustomColors.fontFamily,
                    fontSize: 16),
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${users["service_date"] + "-" + users["service_time"]}",
                    style: TextStyle(
                        color: notifire.greyfont,
                        fontFamily: CustomColors.fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "$currency${users["total"]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: notifire.getdarkscolor,
                        fontFamily: CustomColors.fontFamily,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [
                const Icon(
                  Icons.location_on_sharp,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: Get.width * 0.80,
                  child: Text(
                    "${users["customer_address"]}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: notifire.getdarkscolor,
                        fontFamily: CustomColors.fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ),
            SizedBox(height: Get.height * 0.01)
          ]),
        ),
      ),
    );
  }

  Future bookingActiveApi() async {
    var data = {"uid": uid, "type": "active"};
    try {
      var url = Uri.parse(Config.baseUrl + Config.orderhistory);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        setState(() {});
        return response["OrderHistory"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }
}
