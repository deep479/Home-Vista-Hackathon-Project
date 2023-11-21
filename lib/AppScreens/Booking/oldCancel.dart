// ignore_for_file: prefer_const_constructors, deprecated_member_use, file_names

import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({Key? key}) : super(key: key);

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.skin,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new_outlined,
                    color: CustomColors.black)),
          ),
        ),
        title: const Text(
          TextString.num,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: CustomColors.black,
              fontFamily: CustomColors.fontFamily),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.green.shade50,
              radius: 24,
              child: InkWell(
                  onTap: () {
                    _makePhoneCall("tel:8320064177");
                  },
                  child: const Icon(Icons.call, color: CustomColors.green)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              title: Text(
                TextString.apartment,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: CustomColors.fontFamily,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                TextString.repairReplacement,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: CustomColors.fontFamily,
                    color: CustomColors.grey,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                "\$ ${49}",
                style: TextStyle(
                    color: CustomColors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
            const Divider(thickness: 1),
            const ListTile(
              title: Text(
                TextString.wastePipeLeakage,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: CustomColors.fontFamily,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                TextString.repairReplacement,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: CustomColors.fontFamily,
                    color: CustomColors.grey,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                "\$ ${49}",
                style: TextStyle(
                    color: CustomColors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          TextString.num,
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: CustomColors.fontFamily),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Get.to(() => JobCompletedRatingScreen());
                          },
                          child: Container(
                            height: 30,
                            // width: 92,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  textAlign: TextAlign.center,
                                  TextString.accepted,
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: CustomColors.fontFamily),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      TextString.tyroneMitchell,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomColors.fontFamily,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      TextString.pvtLtd,
                      style: TextStyle(
                          fontFamily: CustomColors.fontFamily,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5),
                    const Text(
                      TextString.singleStreetUSA,
                      style: TextStyle(
                          color: CustomColors.grey,
                          fontFamily: CustomColors.fontFamily,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            cancellationPolicy(),
            orderSummary(),
            cancelBookingButton(),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget cancellationPolicy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FDottedLine(
        color: Colors.red,
        corner: FDottedLineCorner.all(10.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          color: Colors.red[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                TextString.cancellationPolicy,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: CustomColors.fontFamily,
                    fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                TextString.cancellationDescription,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: CustomColors.fontFamily,
                    fontSize: 14,
                    color: CustomColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderSummary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            TextString.orderSummary,
            style: TextStyle(
                fontFamily: CustomColors.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const ListTile(
            trailing: Text(
              "\$${156.00}",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  fontFamily: CustomColors.fontFamily),
            ),
            title: Text(
              "Subtotal",
              style: TextStyle(
                  fontFamily: CustomColors.fontFamily,
                  color: CustomColors.grey,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const ListTile(
            trailing: Text(
              "\$${12.00}",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  fontFamily: CustomColors.fontFamily),
            ),
            title: Text(
              "Est.Tax",
              style: TextStyle(
                  fontFamily: CustomColors.fontFamily,
                  color: CustomColors.grey,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Total",
                  style: TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "\$${168}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      fontFamily: CustomColors.fontFamily),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ----------------------------------- Cancel Booking Button ------------------------------------------------///
  Widget cancelBookingButton() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: SizedBox(
        height: 56,
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.blue),
                borderRadius: BorderRadius.circular(16.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    TextString.cancelBooking,
                    style: TextStyle(
                        color: CustomColors.blue,
                        fontFamily: CustomColors.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
