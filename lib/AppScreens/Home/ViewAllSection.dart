// ignore_for_file: must_be_immutable, avoid_print, prefer_const_constructors, unused_catch_clause, file_names, prefer_is_empty

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/Controller/AppControllerApi.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';

import '../../ApiServices/Api_werper.dart';
import 'search_catogory_screen.dart';

class ViewAllSectionPage extends StatefulWidget {
  final String? catID;
  final String? catTital;
  String? sectionID;
  ViewAllSectionPage({Key? key, this.sectionID, this.catTital, this.catID})
      : super(key: key);

  @override
  State<ViewAllSectionPage> createState() => _ViewAllSectionPageState();
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

class _ViewAllSectionPageState extends State<ViewAllSectionPage> {
  final x = Get.put(AppControllerApi());
  bool isSelected = true;
  bool isSelectedGrid = false;
  bool isVisibalVertical = true;
  bool isLoading = false;
  final search = TextEditingController();

  @override
  void initState() {
    setState(() {});
    isLoading = true;
    x.viewAllSectionApi(widget.sectionID).then((val) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
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

  late ColorNotifire notifire;
  vendorSearchApi(String? val) {
    setState(() {});
    var data = {"keyword": val, "section_id": widget.sectionID};
    ApiWrapper.dataPost(Config.sectionsearch, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          for (var e in val["ItemData"]) {
            setState(() {});
            viewAllSectionlist = e["item_list"];
          }
          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: notifire.detail,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            statusBar(context),
            Container(
              width: Get.width,
              color: notifire.getprimerycolor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(14)),
                  child: TextField(
                      controller: search,
                      style: TextStyle(color: notifire.getdarkscolor),
                      onChanged: (val) {
                        val.length != 0
                            ? vendorSearchApi(val)
                            : x.viewAllSectionApi(widget.sectionID).then((val) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                      },
                      cursorColor: notifire.getdarkscolor,
                      decoration: InputDecoration(
                          isDense: true,
                          hintStyle: TextStyle(color: notifire.getdarkscolor),
                          prefixIcon: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back,
                                  color: notifire.getdarkscolor)),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Image(
                                image: AssetImage("assets/roundSearch.png"),
                                height: 4),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: notifire.greyfont),
                              borderRadius: BorderRadius.circular(14)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.grey.shade300),
                              borderRadius: BorderRadius.circular(16)),
                          hintText: 'Search Service')),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            !isLoading
                ? viewAllSectionlist.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Container(
                          decoration: BoxDecoration(
                              color: notifire.getprimerycolor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Ink(
                                      width: Get.width * 0.50,
                                      child: Text(
                                        widget.catTital ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: CustomColors.fontFamily,
                                            fontSize: 18),
                                      ),
                                    ),
                                    const Spacer(),
                                    //! ------- List view To GridView List -------
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isSelected = !isSelected;
                                              isSelectedGrid = false;
                                              isVisibalVertical = true;
                                            });
                                          },
                                          child: Container(
                                              height: 50,
                                              width: 50,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: CustomColors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      blurRadius: 6,
                                                      blurStyle:
                                                          BlurStyle.normal),
                                                ],
                                              ),
                                              child: isSelected
                                                  ? const Icon(Icons.menu,
                                                      color: CustomColors
                                                          .primaryColor)
                                                  : const Icon(Icons.menu,
                                                      color: CustomColors.black)
                                              // Image.asset(ImagePath.listIcon),
                                              ),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isSelectedGrid = !isSelectedGrid;
                                              isSelected = false;
                                              isVisibalVertical = false;
                                            });
                                          },
                                          child: Container(
                                              height: 50,
                                              width: 50,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14),
                                              decoration: BoxDecoration(
                                                color: CustomColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      blurRadius: 6,
                                                      blurStyle:
                                                          BlurStyle.normal),
                                                ],
                                              ),
                                              child: isSelectedGrid
                                                  ? const Icon(
                                                      Icons.grid_on_outlined,
                                                      color: CustomColors
                                                          .primaryColor)
                                                  : Icon(
                                                      Icons.grid_on_outlined)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 5),
                                  child: Column(
                                    children: [
                                      viewAllSectionlist.isEmpty
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 5),
                                              child: Column(children: [
                                                SizedBox(
                                                    height: Get.height * 0.10),
                                                Image(
                                                    image: AssetImage(
                                                        "assets/emptyList1.png"),
                                                    height: Get.height * 0.28),
                                                SizedBox(
                                                    height: Get.height * 0.04),
                                                Center(
                                                  child: SizedBox(
                                                    width: Get.width * 0.80,
                                                    child: Text(
                                                        "Currently, Service not listed on this Category",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: notifire
                                                                .getdarkscolor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                CustomColors
                                                                    .fontFamily,
                                                            fontSize: 18)),
                                                  ),
                                                ),
                                              ]),
                                            )
                                          : isVisibalVertical == true
                                              ? SizedBox(
                                                  height: Get.height * 0.70,
                                                  child: ListView.builder(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          viewAllSectionlist
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              i) {
                                                        return userList(
                                                            viewAllSectionlist,
                                                            i);
                                                      }),
                                                )
                                              : SizedBox(
                                                  height: Get.height * 0.70,
                                                  child: GridView.count(
                                                      crossAxisCount: 2,
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      shrinkWrap: true,
                                                      crossAxisSpacing: 1.0,
                                                      mainAxisSpacing: 8.0,
                                                      children: List.generate(
                                                          viewAllSectionlist
                                                              .length, (i) {
                                                        return userGridview(
                                                            viewAllSectionlist,
                                                            i);
                                                      })),
                                                ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        child: Column(children: [
                          SizedBox(height: Get.height * 0.10),
                          Image(
                              image: AssetImage("assets/emptyList1.png"),
                              height: Get.height * 0.28),
                          SizedBox(height: Get.height * 0.04),
                          Center(
                            child: SizedBox(
                              width: Get.width * 0.80,
                              child: const Text(
                                  "Currently, Service not listed on this Category",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: CustomColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: CustomColors.fontFamily,
                                      fontSize: 18)),
                            ),
                          ),
                        ]),
                      )
                : Column(children: [
                    SizedBox(height: Get.height * 0.34),
                    Center(
                      child: SizedBox(child: isLoadingIndicator()),
                    )
                  ]),
          ],
        ));
  }

  userList(user, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          Get.to(() => SearchCategoryScreen(
              catId: widget.catID, catTital: user[i]["item_title"]));
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                      imageUrl: "${Config.imgBaseUrl}${user[i]["item_img"]}",
                      fit: BoxFit.cover,
                      height: 130,
                      width: 150)),
              const SizedBox(width: 14),
              SizedBox(
                width: Get.width * 0.30,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user[i]["item_title"] ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontFamily: CustomColors.fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                      const SizedBox(height: 8),
                    ]),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz,
                color: notifire.getdarkscolor,
              ),
            ]),
      ),
    );
  }

  userGridview(users, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {
          Get.to(() => SearchCategoryScreen(
              catId: widget.catID, catTital: users[i]["item_title"]));
        },
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                      imageUrl: "${Config.imgBaseUrl}${users?[i]["item_img"]}",
                      fit: BoxFit.cover,
                      height: 110,
                      width: 150)),
              const SizedBox(height: 3),
              Text(users?[i]["item_title"] ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      color: notifire.getdarkscolor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
