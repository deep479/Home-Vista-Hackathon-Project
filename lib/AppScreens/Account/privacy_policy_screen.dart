// ignore_for_file: avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/utils/colors.dart';

import '../../utils/color_widget.dart';

class Loream extends StatefulWidget {
  final String? title;
  final String? description;

  const Loream({Key? key, this.description, this.title}) : super(key: key);
  @override
  State<Loream> createState() => _LoreamState();
}

class _LoreamState extends State<Loream> {
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
    var sp;
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      appBar: AppBar(
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: notifire.getdarkscolor)),
        centerTitle: true,
        title: Text(
          "${widget.title ?? ""}",
          style: TextStyle(
              fontFamily: CustomColors.fontFamily,
              color: notifire.getdarkscolor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // SizedBox(height: Get.height / 20),
          // Row(children: [
          //   SizedBox(width: Get.width / 40),
          //   InkWell(
          //     onTap: () {
          //       Get.back();
          //     },
          //     child: Row(children: [
          //       const Icon(Icons.arrow_back, color: Colors.black),
          //       SizedBox(width: Get.width / 80),
          //       Text(
          //         "${widget.title ?? ""}",
          //         style: const TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.w900,
          //             fontFamily: 'Gilroy Medium',
          //             color: Colors.black),
          //       ),
          //     ]),
          //   ),
          // ]),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Get.height / 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
                    child: Column(children: [
                      (widget.description != null)
                          ? HtmlWidget(widget.description ?? "",
                              textStyle: TextStyle(
                                  color: notifire.getdarkscolor,
                                  fontSize: Get.height / 50,
                                  fontFamily: 'Gilroy Normal'))
                          : Text("",
                              style: TextStyle(
                                  color: notifire.getdarkscolor,
                                  fontSize: Get.height / 50,
                                  fontFamily: 'Gilroy Normal')),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicPageData {
  DynamicPageData(this.title, this.description);

  String? title;
  String? description;

  DynamicPageData.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description};
  }
}
