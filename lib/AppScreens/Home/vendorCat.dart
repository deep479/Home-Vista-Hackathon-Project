// ignore_for_file: must_be_immutable, avoid_print, prefer_const_constructors, unused_catch_clause, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/Controller/AppControllerApi.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DataSqf/maineList.dart';
import '../../utils/colors.dart';
import 'salon_at_home_for_woman_screen.dart';

class VendorCatAllPage extends StatefulWidget {
  final String? pID;
  final String? title;
  const VendorCatAllPage({Key? key, this.pID, this.title}) : super(key: key);

  @override
  State<VendorCatAllPage> createState() => _VendorCatAllPageState();
}

class _VendorCatAllPageState extends State<VendorCatAllPage> {
  final x = Get.put(AppControllerApi());
  bool isSelected = true;
  bool isSelectedGrid = false;
  bool isVisibalVertical = true;
  bool isLoading = false;
  final search = TextEditingController();
  final subWise = UserServiceData();

  @override
  void initState() {
    setState(() {});
    insertData();
    isLoading = true;
    x.providerWiseCategoryList(widget.pID).then((val) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  insertData() {
    subWise.saveServiceData(
        serviceid: '',
        mtitle: '',
        quantity: '',
        img: '',
        video: '',
        servicetype: '',
        title: '',
        taketime: '',
        maxquantity: '',
        price: '',
        discount: '',
        servicedesc: '',
        status: '',
        isapprove: '');
  }

  late ColorNotifire notifire;
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.bg,
      appBar: AppBar(
        backgroundColor: notifire.bg,
        elevation: 0,
        leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: notifire.getdarkscolor, size: 28),
            onPressed: () {
              Get.back();
            }),
        title: Text(widget.title ?? "".toString(),
            style: TextStyle(
                color: notifire.getdarkscolor,
                fontWeight: FontWeight.bold,
                fontFamily: CustomColors.fontFamily,
                fontSize: 18)),
      ),
      body: isLoading == false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: GetBuilder<AppControllerApi>(
                        builder: (_) => Container(
                          decoration: BoxDecoration(
                              color: notifire.detail,
                              borderRadius: BorderRadius.circular(10)),
                          child: FutureBuilder(
                            future: x.providerWiseCategoryList(widget.pID),
                            builder: (ctx, AsyncSnapshot snap) {
                              if (snap.hasData) {
                                var users = snap.data;
                                return users.length == 0
                                    ? Column(children: [
                                        SizedBox(height: Get.height * 0.36),
                                        Center(
                                            child: Text("No Data Found",
                                                style: TextStyle(
                                                    color:
                                                        notifire.getdarkscolor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16))),
                                      ])
                                    : GridView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: users.length,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisExtent: 150),
                                        itemBuilder: (BuildContext context, i) {
                                          return userGridview(users, i);
                                        },
                                      );
                              } else {
                                return Center(
                                    heightFactor: Get.height / 50,
                                    child: const CircularProgressIndicator(
                                      backgroundColor:
                                          CustomColors.primaryColor,
                                    ));
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                  backgroundColor: CustomColors.primaryColor)),
    );
  }

  userGridview(user, i) {
    return InkWell(
      onTap: () {
        setState(() {});
        selectCartList.clear();

        Get.to(() => SalonAtHomeForWomanScreen(
            title: user[i]["cat_name"],
            storeName: widget.title,
            vendorId: widget.pID,
            catId: user?[i]["cat_id"]));
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          width: 100,
          decoration: BoxDecoration(
              color: notifire.bg, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                const SizedBox(height: 3),
                Container(
                  height: Get.height * 0.10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                              "${Config.imgBaseUrl}${user?[i]["cat_img"]}"))),
                ),
                const SizedBox(height: 4),
                Text(user[i]["cat_name"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontFamily: CustomColors.fontFamily,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
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
