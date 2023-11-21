// ignore_for_file: unused_field

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/utils/colors.dart';

import '../../ApiServices/Api_werper.dart';
import '../../ApiServices/url.dart';
import '../../utils/color_widget.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  List faqList = [];
  final _loremIpsum =
      "Justo, fames odio enim, risus, ac tristique turpis. Ut molestie tempus, donec mauris nibh dolor urna eu. In dapibus eget eget in semper.";
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getfaqApi();
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
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: notifire.getdarkscolor)),
        centerTitle: true,
        title: Text(
          "Faq's",
          style: TextStyle(
              fontFamily: CustomColors.fontFamily,
              color: notifire.getdarkscolor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      // appBar: AppBar(
      //   titleSpacing: 0,
      //   elevation: 0,
      //   leading: InkWell(
      //       onTap: () {
      //         Get.back();
      //       },
      //       child: const Icon(Icons.arrow_back, color: Colors.black)),
      //   backgroundColor: CustomColors.skin,
      //   title: const Text("Faq's",
      //       style: TextStyle(
      //           fontSize: 18,
      //           fontWeight: FontWeight.w700,
      //           color: Colors.black)),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(height: 250),
                    Center(
                        child: Image(
                      image: AssetImage("assets/loading.gif"),
                      height: 70,
                    )),
                  ],
                )
              : Column(
                  children: [
                    Accordion(
                      disableScrolling: true,
                      flipRightIconIfOpen: true,
                      contentVerticalPadding: 0,
                      scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                      contentBorderColor: Colors.transparent,
                      maxOpenSections: 1,
                      headerBackgroundColorOpened: notifire.detail,
                      headerBackgroundColor: notifire.detail,
                      contentBackgroundColor: notifire.detail,
                      headerPadding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 15),
                      children: [
                        for (var i = 0; i < faqList.length; i++)
                          AccordionSection(
                              rightIcon: Icon(Icons.add,
                                  color: notifire.getdarkscolor),
                              headerPadding: const EdgeInsets.all(15),
                              flipRightIconIfOpen: true,
                              header: Text(faqList[i]["question"],
                                  style: TextStyle(
                                      color: notifire.getdarkscolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              content: Text(faqList[i]["answer"],
                                  style: _contentStyle),
                              contentHorizontalPadding: 20,
                              contentBackgroundColor: notifire.detail,
                              contentBorderWidth: 1),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  getfaqApi() {
    isLoading = true;

    var body = {"uid": uid};
    ApiWrapper.dataPost(Config.faq, body)!.then((faq) {
      if ((faq != null) && (faq.isNotEmpty)) {
        if ((faq['ResponseCode'] == "200") && (faq['Result'] == "true")) {
          setState(() {});
          isLoading = false;
          faqList = faq["FaqData"];
        }
      }
    });
  }
}
