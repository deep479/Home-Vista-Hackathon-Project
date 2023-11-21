// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/Controller/AppControllerApi.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomSheetMenuScreen extends StatefulWidget {
  final String? vendorID;
  final String? catID;
  const BottomSheetMenuScreen({Key? key, this.catID, this.vendorID})
      : super(key: key);

  @override
  State<BottomSheetMenuScreen> createState() => _BottomSheetMenuScreenState();
}

class _BottomSheetMenuScreenState extends State<BottomSheetMenuScreen> {
  final x = Get.put(AppControllerApi());
  bool isLoading = false;

  @override
  void initState() {
    setState(() {});
    getdarkmodepreviousstate();
    super.initState();
  }

  late ColorNotifire notifire;
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    Future.delayed(Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          gridViewProduct(),
          const SizedBox(height: 10),
          CircleAvatar(
              radius: 28,
              backgroundColor: CustomColors.white,
              child: IconButton(
                icon: Icon(Icons.close, color: notifire.getdarkscolor),
                onPressed: () {
                  Get.back();
                },
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// gridView for product
  Widget gridViewProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: CustomColors.white, borderRadius: BorderRadius.circular(12)),
        child: !isLoading
            ? GridView.builder(
                itemCount: x.subCatList.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisExtent: 150),
                itemBuilder: (BuildContext context, i) {
                  return InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Container(
                            width: Get.width * 0.25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                    imageUrl: Config.imgBaseUrl +
                                        x.subCatList[i]["img"],
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(height: Get.height * 0.01),
                          Text(x.subCatList[i]["title"],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: CustomColors.fontFamily))
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                heightFactor: Get.height / 99,
                child: const CircularProgressIndicator(
                    backgroundColor: CustomColors.primaryColor)),
      ),
    );
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
