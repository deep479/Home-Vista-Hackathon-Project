// ignore_for_file: must_be_immutable, avoid_print, prefer_const_constructors, unused_catch_clause, prefer_is_empty, await_only_futures, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/Controller/AppControllerApi.dart';
import 'package:ucservice_customer/AppScreens/Home/salon_at_home_for_woman_screen.dart';
import 'package:ucservice_customer/utils/AppWidget.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';
import 'package:ucservice_customer/utils/text_widget.dart';

import '../../ApiServices/Api_werper.dart';
import '../../DataSqf/maineList.dart';

//! cat search
class SearchCategoryScreen extends StatefulWidget {
  final String? type;

  final String? catTital;
  final List? catList;
  String? catId;
  SearchCategoryScreen(
      {Key? key, this.catId, this.catTital, this.catList, this.type})
      : super(key: key);

  @override
  State<SearchCategoryScreen> createState() => _SearchCategoryScreenState();
}

class _SearchCategoryScreenState extends State<SearchCategoryScreen> {
  final x = Get.put(AppControllerApi());
  bool isSelected = true;
  bool isSelectedGrid = false;
  bool isVisibalVertical = true;
  bool isLoading = false;
  var userslength;
  final subWise = UserServiceData();

  final search = TextEditingController();

  @override
  void initState() {
    setState(() {});
    widget.type == "Search" ? vendorSearchApi("a") : null;

    insertData();
    isLoading = true;

    x.categoryWiseProviderApi(widget.catId).then((val) {
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
    var data = {
      "keyword": val,
      "lats": lat,
      "longs": long,
      "cat_id": widget.catId ?? "0"
    };
    ApiWrapper.dataPost(Config.vendorsearch, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          vendorlist = val["VendorSearchData"];
          setState(() {});
        } else {
          vendorlist = [];
          setState(() {});
        }
      }
    });
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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: notifire.detail,
      body: isLoading == false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                statusBar(context),
                //! Search textField
                Container(
                  width: Get.width,
                  color: notifire.getprimerycolor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14)),
                      child: TextField(
                          controller: search,
                          style: TextStyle(color: notifire.getdarkscolor),
                          onChanged: (val) {
                            val.length != 0
                                ? vendorSearchApi(val)
                                : x
                                    .categoryWiseProviderApi(widget.catId)
                                    .then((val) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                          },
                          cursorColor: notifire.getdarkscolor,
                          decoration: InputDecoration(
                              isDense: true,
                              hintStyle:
                                  TextStyle(color: notifire.getdarkscolor),
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
                                  borderSide: BorderSide(
                                      color: CustomColors.grey.shade300),
                                  borderRadius: BorderRadius.circular(14)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.grey.shade300),
                                  borderRadius: BorderRadius.circular(16)),
                              hintText: 'Search Category')),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                !isLoading
                    ? vendorlist.isNotEmpty
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: Get.width * 0.50,
                                            child: Text(
                                              widget.catTital ?? "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: notifire.getdarkscolor,
                                                  fontFamily:
                                                      CustomColors.fontFamily,
                                                  fontSize: 18),
                                            )),
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
                                                        BorderRadius.circular(
                                                            10),
                                                    color: CustomColors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                          blurRadius: 6,
                                                          blurStyle:
                                                              BlurStyle.normal),
                                                    ]),
                                                child: isSelected
                                                    ? const Icon(Icons.menu,
                                                        color: CustomColors
                                                            .primaryColor)
                                                    : const Icon(Icons.menu,
                                                        color:
                                                            CustomColors.black),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isSelectedGrid =
                                                      !isSelectedGrid;
                                                  isSelected = false;
                                                  isVisibalVertical = false;
                                                });
                                              },
                                              child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 14),
                                                  decoration: BoxDecoration(
                                                      color: CustomColors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.4),
                                                            blurRadius: 6,
                                                            blurStyle: BlurStyle
                                                                .normal),
                                                      ]),
                                                  child: isSelectedGrid
                                                      ? const Icon(
                                                          Icons
                                                              .grid_on_outlined,
                                                          color: CustomColors
                                                              .primaryColor)
                                                      : Icon(Icons
                                                          .grid_on_outlined)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    child: GetBuilder<AppControllerApi>(
                                        builder: (_) =>
                                            nearbyvendorsVerticalList()),
                                  )
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
                    : Column(
                        children: [
                          SizedBox(height: Get.height * 0.34),
                          Center(
                            child: SizedBox(
                              child: isLoadingIndicator(),
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

  Widget nearbyvendorsVerticalList() {
    return vendorlist.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
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
        : isVisibalVertical == true
            ? SizedBox(
                height: Get.height * 0.70,
                child: ListView.builder(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    shrinkWrap: true,
                    itemCount: vendorlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return userList(index);
                    }),
              )
            : SizedBox(
                height: Get.height * 0.70,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 0.62),
                  itemBuilder: (context, i) => userGridview(i),
                  itemCount: vendorlist.length,
                ),
              );
  }

  userList(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          setState(() {});
          selectCartList.clear();
          Get.to(() => SalonAtHomeForWomanScreen(
                  title: widget.catTital,
                  storeName: vendorlist[index]["provider_title"],
                  vendorId: vendorlist[index]["provider_id"],
                  catId: widget.catId))!
              .then((value) {
            FocusScope.of(context).requestFocus(FocusNode());
          });
        },
        child: SizedBox(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                        imageUrl:
                            "${Config.imgBaseUrl}${vendorlist[index]["provider_img"]}",
                        fit: BoxFit.cover,
                        height: 160,
                        width: 150)),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Image.asset(ImagePath.starImg, scale: 22),
                      Text(vendorlist[index]["provider_rate"] ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: notifire.getdarkscolor)),
                    ],
                  ),
                  const SizedBox(height: 7),
                  SizedBox(
                    width: Get.width * 0.3,
                    child: Text(vendorlist[index]["provider_title"] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: notifire.getdarkscolor,
                            fontFamily: CustomColors.fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                  const SizedBox(height: 8),
                  Text("Satrts From",
                      style: TextStyle(
                          color: notifire.greyfont,
                          fontFamily: CustomColors.fontFamily,
                          fontSize: 14)),
                  const SizedBox(height: 12),
                  Container(
                    height: 28,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CustomColors.accentColor),
                    child: Center(
                      child: Text("$currency${vendorlist[index]["start_from"]}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ]),
                const Spacer(),
                const Icon(Icons.more_horiz),
              ]),
        ),
      ),
    );
  }

  userGridview(index) {
    var users = x.categoryWiseModel?.providerData;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          setState(() {});
          selectCartList.clear();
          Get.to(() => SalonAtHomeForWomanScreen(
                  title: widget.catTital,
                  storeName: users?[index].providerTitle,
                  vendorId: users?[index].providerId,
                  catId: widget.catId))!
              .then((value) {
            FocusScope.of(context).requestFocus(FocusNode());
          });
        },
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                    imageUrl:
                        "${Config.imgBaseUrl}${users?[index].providerImg}",
                    fit: BoxFit.cover,
                    height: 140,
                    width: 150),
              ),
              const SizedBox(height: 8),
              Text(users?[index].providerTitle ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
              const SizedBox(height: 3),
              const Text(TextString.startsFrom,
                  style: TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.grey,
                      fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomColors.accentColor),
                    child: Center(
                      child: Text("$currency${users?[index].startFrom ?? ""}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(ImagePath.starImg, scale: 22),
                      Text(
                        users?[index].providerRate ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
