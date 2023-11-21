// ignore_for_file: depend_on_referenced_packages, must_be_immutable, unused_field, prefer_typing_uninitialized_variables, prefer_final_fields, unnecessary_string_interpolations, prefer_is_empty, avoid_print, unused_local_variable, unnecessary_brace_in_string_interps, sort_child_properties_last, library_private_types_in_public_api, non_constant_identifier_names, unnecessary_import

import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/ApiServices/Api_werper.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/AppScreens/Home/bottom_sheet_menu_screen.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/Controller/AppControllerApi.dart';
import 'package:ucservice_customer/DataSqf/maineList.dart';
import 'package:ucservice_customer/AppScreens/Home/Summery.dart';
import 'package:ucservice_customer/model/servicemodel.dart' as prefix;
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/text_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:video_player/video_player.dart';
import '../../custom_widegt/Colors.dart';
import '../../utils/AppWidget.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../../utils/colors.dart';
import '../Account/faqs_screen.dart';

class ItemListCart {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'sub.db'), version: 1);
  }
}

List selectCartList = [];
var addressID = "0";
var drop_address = "";
var daddresstype = "";
var hno;
var dname = "";
var daddress = "";
var lat2;
var lon2;

class SalonAtHomeForWomanScreen extends StatefulWidget {
  final String? title;
  String? vendorId;
  String? storeName;
  String? catId;
  SalonAtHomeForWomanScreen(
      {Key? key, this.vendorId, this.catId, this.title, this.storeName})
      : super(key: key);

  @override
  State<SalonAtHomeForWomanScreen> createState() =>
      _SalonAtHomeForWomanScreenState();
}

class _SalonAtHomeForWomanScreenState extends State<SalonAtHomeForWomanScreen> {
  final subWise = UserServiceData();
  late ColorNotifire notifire;

  TargetPlatform? _platform;
  final x = Get.put(AppControllerApi());

  ChewieController? _chewieController;
  dynamic discount = 0;
  dynamic discounttotal = 0;
  dynamic itemDiscount = 0;

  var height;
  var width;
  var users;
  String serviceIDShow = "0";

  var sid;
  int counter1 = 0;
  final StoryController controller = StoryController();

  Dio dio = Dio();
  prefix.ServiceDetailModel? serviceDetailModel;
  double serviceData = 0.00;
  ScrollController? scrollController;

  @override
  void initState() {
    setState(() {});
    controllersearch = TextEditingController();
    scrollController = ScrollController();
    checkAddress(1);
    serviceDetailApi();
    super.initState();
  }

//
  etdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
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

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }

  late TextEditingController controllersearch;
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    setState(() {
      counter1;
    });

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifire.detail,

      appBar: AppBar(
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        leading: const SizedBox(),
        actions: [
          AnimationSearchBar(
              backIcon: Icons.arrow_back,
              backIconColor: notifire.getdarkscolor,
              centerTitle: widget.title.toString(),
              centerTitleStyle: TextStyle(
                  color: notifire.getdarkscolor,
                  fontWeight: FontWeight.bold,
                  fontFamily: CustomColors.fontFamily,
                  fontSize: 18),
              textStyle: TextStyle(
                  color: notifire.getdarkscolor,
                  fontWeight: FontWeight.bold,
                  fontFamily: CustomColors.fontFamily,
                  fontSize: 18),
              onChanged: (text) => debugPrint(text),
              searchTextEditingController: controllersearch,
              horizontalPadding: 5)
        ],
      ),
      //! View cart Button Bottom
      bottomNavigationBar: selectCartList.isNotEmpty && discounttotal != 0.0
          ? cartButton(
              total1: "$currency${discounttotal.toStringAsFixed(2)}",
              total2: "$currency${serviceData.toStringAsFixed(2)}",
              onTap: () {
                Get.to(() => Summery(
                          catID: widget.catId,
                          vendorID: widget.vendorId,
                          discountPrice: "${discounttotal.toStringAsFixed(2)}",
                          itemDiscount: "${itemDiscount.toStringAsFixed(2)}",
                          totalPrice: "${serviceData.toStringAsFixed(2)}",
                          totalItem: counter1,
                        ))!
                    .then((value) {
                  setState(() {});
                  subWise.fetchUsers();

                  if (value != null) {
                    setState(() {
                      counter1 = int.parse(value["count"].toString());
                      discounttotal = double.parse(value["disp"].toString());
                      serviceData = double.parse(value["total"].toString());
                      itemDiscount =
                          double.parse(value["itemDiscount"].toString());
                    });
                  }

                  //   //! -------- clear data -------
                });
              })
          : const SizedBox(),
      floatingActionButton:
          serviceDetailModel?.serviceData?.subcategory?.length != 0
              ? FloatingActionButton.extended(
                  backgroundColor: notifire.getdarkscolor,
                  onPressed: () {
                    x.subCategoryApi(widget.vendorId, widget.catId);
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return BottomSheetMenuScreen(
                              vendorID: widget.vendorId, catID: widget.catId);
                        }));
                  },
                  icon: const Icon(Icons.menu, color: CustomColors.white),
                  label: const Text(TextString.menu,
                      style: TextStyle(
                          fontFamily: CustomColors.fontFamily,
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold)),
                )
              : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: serviceDetailModel?.serviceData != null
          ? serviceDetailModel?.serviceData?.subcategory?.length != 0
              ? SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: notifire.getprimerycolor,
                        child: Column(
                          children: [
                            //! Carousel Slider Widget
                            serviceDetailModel!.serviceData!.cover!.length != 0
                                ? carouselSliderWidget()
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Ink(
                                    width: Get.width * 0.60,
                                    child: Text(widget.storeName.toString(),
                                        style: TextStyle(
                                            color: notifire.getdarkscolor,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  //! UC Safe
                                  ucSafeButton(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Faq()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            //! Rating
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: notifire.greyfont),
                                  const SizedBox(width: 5),
                                  Text(
                                      "${serviceDetailModel?.serviceData?.provider?.providerRate}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: notifire.greyfont,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: Get.height * 0.006),

                            SizedBox(height: Get.height * 0.01),

                            serviceDetailModel
                                        ?.serviceData?.couponList?.length !=
                                    0
                                ? offerByOrder()
                                : const SizedBox(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      // const Divider(color: CustomColors.skin, thickness: 10),
                      const SizedBox(height: 14),
                      gridViewProduct(),
                      const SizedBox(height: 10),
                      Container(
                        color: notifire.getprimerycolor,
                        child: bestSellerPackage(),
                      ),
                      // const Padding(
                      //     padding: EdgeInsets.symmetric(horizontal: 14.0),
                      //     child: Divider(
                      //       thickness: 20,
                      //       color: Colors.red,
                      //     )),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height * 0.10),
                    Center(
                      child: Image(
                          image: const AssetImage("assets/insidelist.png"),
                          height: Get.height * 0.28),
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Center(
                      child: SizedBox(
                        width: Get.width * 0.80,
                        child: Text(
                            "Currently, Service not listed on this Category",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: notifire.getdarkscolor,
                                fontWeight: FontWeight.bold,
                                fontFamily: CustomColors.fontFamily,
                                fontSize: 18)),
                      ),
                    ),
                  ],
                )
          : Center(
              heightFactor: height / 50,
              child: isLoadingIndicator(),
            ),
    );
  }

  Widget carouselSliderWidget() {
    return SizedBox(
        height: 200,
        width: double.infinity,
        child: StoryView(
          progressPosition: ProgressPosition.bottom,
          repeat: true,
          inline: true,
          controller: controller,
          storyItems: [
            for (var i = 0;
                i < serviceDetailModel!.serviceData!.cover!.length;
                i++)
              StoryItem.inlineImage(
                  imageFit: BoxFit.cover,
                  url:
                      "${Config.imgBaseUrl}${serviceDetailModel?.serviceData?.cover?[i]}",
                  controller: controller),
          ],
          onStoryShow: (s) {},
          onComplete: () {},
        ));
  }

  //! -------- CouponList Data Api ---------
  Widget offerByOrder() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: serviceDetailModel?.serviceData?.couponList?.length,
          itemBuilder: (BuildContext context, i) {
            var coupon = serviceDetailModel?.serviceData?.couponList;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: Get.width * 0.80,
                height: 90,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: notifire.detail,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.network(
                              "${"${Config.imgBaseUrl}${coupon?[i].couponImg}"}",
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      width: Get.width * 0.50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${coupon?[i].title}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: notifire.getdarkscolor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: CustomColors.fontFamily)),
                          Text(
                            "${coupon?[i].subtitle}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: CustomColors.grey,
                                fontFamily: CustomColors.fontFamily),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //! gridView for product
  Widget gridViewProduct() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: notifire.getprimerycolor,
            borderRadius: BorderRadius.circular(12)),
        child: GridView.builder(
          itemCount: serviceDetailModel?.serviceData?.subcategory?.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisExtent: 175),
          itemBuilder: (BuildContext context, i) {
            return userGridview(i);
          },
        ));
  }

  userGridview(i) {
    var user = serviceDetailModel?.serviceData?.subcategory;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: InkWell(
        onTap: () {
          setState(() {});
          double sid = double.parse("${user?[i].id}");

          scrollController?.animateTo(sid,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeIn);
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: SizedBox(
            width: 100,
            child: Column(
              children: [
                Image(
                    image: NetworkImage("${Config.imgBaseUrl}${user?[i].img}")),
                SizedBox(height: Get.height * 0.01),
                Text("${user?[i].title}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: CustomColors.fontFamily,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Best Seller Package
  //!------------
  Widget bestSellerPackage() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          serviceDetailModel?.serviceData?.subWiseServiceData?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Divider(color: CustomColors.skin, thickness: 10),
            SizedBox(height: Get.height * 0.02),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                  "${serviceDetailModel?.serviceData?.subWiseServiceData?[index].subTitle}",
                  style: const TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            const SizedBox(height: 16),
            //! image Listview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder(
                future: subWise.fetchUsers(),
                builder: (ctx, AsyncSnapshot snap) {
                  if (snap.hasData) {
                    users = snap.data;
                    return snap.data.length == 0
                        ? Column(children: [
                            SizedBox(height: Get.height * 0.22),
                            const Center(child: Text("No Data")),
                          ])
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: users.length,
                            itemBuilder: (context, i) {
                              var user1 = serviceDetailModel?.serviceData
                                  ?.subWiseServiceData?[index].subTitle;
                              var user2 = users[i].mtitle;
                              servicelist = prefix.Servicelist(
                                  serviceId: users[i].serviceid,
                                  img: "${Config.imgBaseUrl}${users[i].img}",
                                  video:
                                      "${Config.imgBaseUrl}${users[i].video}",
                                  serviceType: users[i].servicetype,
                                  title: users[i].title,
                                  takeTime: users[i].taketime,
                                  maxQuantity: users[i].maxquantity,
                                  price: users[i].price,
                                  discount: users[i].discount,
                                  serviceDesc: users[i].servicedesc,
                                  status: users[i].status,
                                  isApprove: users[i].isapprove);

                              return user1 == user2
                                  ? users[i].servicetype != "1"
                                      ? subListImageView(users, index, i)
                                      : sublistvideoview(users, index, i)
                                  : const SizedBox();
                            });
                  } else {
                    return Column(
                      children: [
                        SizedBox(height: Get.height * 0.22),
                        Center(child: isLoadingIndicator()),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  subListImageView(user, index, i) {
    var newprice = doublevaluPer(user[i].price, user[i].discount);
    var subDiscount = valueCal(user[i].price, newprice);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: Get.width * 0.60,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${user[i].title}",
                  style: const TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  user[i].discount != "0"
                      ? SizedBox(
                          child: Row(
                            children: [
                              Text("$currency${subDiscount}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: CustomColors.fontFamily,
                                      fontSize: 14)),
                              SizedBox(width: Get.width * 0.02),
                              Text("$currency${user[i].price}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 14,
                                      color: CustomColors.grey,
                                      fontFamily: CustomColors.fontFamily)),
                            ],
                          ),
                        )
                      : Text("$currency${subDiscount}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: CustomColors.fontFamily,
                              fontSize: 14)),
                  Row(
                    children: [
                      const Icon(Icons.watch_later_outlined,
                          size: 18, color: Colors.grey),
                      SizedBox(width: Get.width * 0.02),
                      Text("${user[i].taketime} mins",
                          style: const TextStyle(
                              color: CustomColors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: CustomColors.fontFamily,
                              fontSize: 14)),
                    ],
                  ),
                  Container(),
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              SizedBox(width: Get.width * 0.55, child: dottedline()),
              const SizedBox(height: 10),
              SizedBox(
                width: Get.width * 0.60,
                child: Text("${user[i].servicedesc}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontFamily: CustomColors.fontFamily, fontSize: 14)),
              ),
            ]),
          ),
          const Spacer(),
          Stack(alignment: Alignment.bottomCenter, children: [
            Column(children: [
              SizedBox(
                  width: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                          imageUrl: "${Config.imgBaseUrl}${user[i].img}",
                          height: 100,
                          fit: BoxFit.fill))),
              const SizedBox(height: 25)
            ]),
            !selectCartList.contains(user[i].serviceid)
                ? addButton(onTap: () {
                    setState(() {
                      itemDiscount = itemDiscount +
                          double.parse(
                              doublevaluPer(user[i].price, user[i].discount)
                                  .toString());

                      selectCartList.add(user[i].serviceid.toString());
                      counter1++;

                      serviceData =
                          serviceData + double.parse("${user[i].price}");

                      discounttotal = discounttotal + double.parse(subDiscount);
                      subWise.updateServiceData(
                        serviceid: user[i].serviceid,
                        quantity: (int.parse(user[i].quantity) + 1).toString(),
                      );
                      setState(() {});
                    });
                  })
                : buttonIncrement(
                    //! Counter
                    count: user[i].quantity,
                    //! ---- Decrement Button ------
                    decrement: () {
                      setState(() {
                        if (1 < int.parse(user[i].quantity)) {
                          setState(() {});
                          itemDiscount = itemDiscount -
                              double.parse(
                                  doublevaluPer(user[i].price, user[i].discount)
                                      .toString());
                          counter1--;
                          serviceData =
                              serviceData - double.parse("${user[i].price}");
                          setState(() {});

                          discounttotal =
                              discounttotal - double.parse(subDiscount);
                          subWise.updateServiceData(
                            serviceid: user[i].serviceid,
                            quantity:
                                (int.parse(user[i].quantity) - 1).toString(),
                          );

                          if (kDebugMode) {}
                        } else {
                          setState(() {});
                          itemDiscount = double.parse(itemDiscount.toString()) -
                              double.parse(
                                  doublevaluPer(user[i].price, user[i].discount)
                                      .toString());

                          selectCartList.remove(user[i].serviceid);
                          subWise.updateServiceData(
                            serviceid: user[i].serviceid,
                            quantity:
                                (int.parse(user[i].quantity) - 1).toString(),
                          );
                          serviceData =
                              serviceData - double.parse("${user[i].price}");

                          discounttotal =
                              discounttotal - double.parse(subDiscount);
                        }
                      });
                    },
                    //! ---- Increment Button ------

                    increment: () {
                      setState(() {
                        var sId = "${user[i].serviceid}";
                        if (int.parse("${user[i].maxquantity!}") >
                            int.parse(user[i].quantity)) {
                          setState(() {});
                          counter1++;
                          serviceData =
                              serviceData + double.parse("${user[i].price}");
                          discounttotal =
                              discounttotal + double.parse(subDiscount);
                          itemDiscount = itemDiscount +
                              double.parse(
                                  doublevaluPer(user[i].price, user[i].discount)
                                      .toString());
                          subWise.updateServiceData(
                            serviceid: user[i].serviceid,
                            quantity:
                                (int.parse(user[i].quantity) + 1).toString(),
                          );
                        } else {
                          ApiWrapper.showToastMessage(
                              "You can't add anymore of this item");
                        }
                      });
                    },
                  ),
          ]),
        ]),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            fullDetails(
              title: user[i].title,
              subTitle: user[i].servicedesc,
            );
          },
          child: const Text(TextString.viewDetails,
              style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.primaryColor,
                  fontFamily: CustomColors.fontFamily,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 1),
        const SizedBox(height: 10),
      ]),
    );
  }

//! ------------- subList data video view ---------------
  sublistvideoview(user, index, i) {
    var newprice = doublevaluPer(user[i].price, user[i].discount);
    var subDiscount = valueCal(user[i].price, newprice);
    return Column(children: [
      //! video show view
      Container(
        height: 210,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
        child: Column(children: [
          //! ------- video show -------
          VideoWidget(play: true, url: Config.imgBaseUrl + user[i].video)
        ]),
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Ink(
              width: Get.width * 0.60,
              child: Text(
                "${user[i].title}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontFamily: CustomColors.fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
          !selectCartList.contains(user[i].serviceid)
              ? addButton(onTap: () {
                  setState(() {
                    itemDiscount = itemDiscount +
                        double.parse(
                            doublevaluPer(user[i].price, user[i].discount)
                                .toString());
                    selectCartList.add(user[i].serviceid.toString());
                    counter1++;
                    serviceData =
                        serviceData + double.parse("${user[i].price}");
                    discounttotal = discounttotal + double.parse(subDiscount);
                    subWise.updateServiceData(
                      serviceid: user[i].serviceid,
                      quantity: (int.parse(user[i].quantity) + 1).toString(),
                    );
                    setState(() {});
                  });
                })
              : buttonIncrement(
                  count: user[i].quantity,
                  decrement: () {
                    setState(() {
                      if (1 < int.parse(user[i].quantity)) {
                        setState(() {});
                        itemDiscount = itemDiscount -
                            double.parse(
                                doublevaluPer(user[i].price, user[i].discount)
                                    .toString());
                        counter1--;
                        serviceData =
                            serviceData - double.parse("${user[i].price}");
                        setState(() {});
                        discounttotal =
                            discounttotal - double.parse(subDiscount);
                        subWise.updateServiceData(
                          serviceid: user[i].serviceid,
                          quantity:
                              (int.parse(user[i].quantity) - 1).toString(),
                        );
                        if (kDebugMode) {}
                      } else {
                        setState(() {});
                        itemDiscount = double.parse(itemDiscount.toString()) -
                            double.parse(
                                doublevaluPer(user[i].price, user[i].discount)
                                    .toString());
                        selectCartList.remove(user[i].serviceid);
                        subWise.updateServiceData(
                          serviceid: user[i].serviceid,
                          quantity:
                              (int.parse(user[i].quantity) - 1).toString(),
                        );
                        serviceData =
                            serviceData - double.parse("${user[i].price}");
                        discounttotal =
                            discounttotal - double.parse(subDiscount);
                      }
                    });
                  },
                  increment: () {
                    setState(() {
                      var sId = "${user[i].serviceid}";
                      if (int.parse("${user[i].maxquantity!}") >
                          int.parse(user[i].quantity)) {
                        setState(() {});
                        counter1++;
                        serviceData =
                            serviceData + double.parse("${user[i].price}");
                        discounttotal =
                            discounttotal + double.parse(subDiscount);
                        itemDiscount = itemDiscount +
                            double.parse(
                                doublevaluPer(user[i].price, user[i].discount)
                                    .toString());
                        subWise.updateServiceData(
                          serviceid: user[i].serviceid,
                          quantity:
                              (int.parse(user[i].quantity) + 1).toString(),
                        );
                      } else {
                        ApiWrapper.showToastMessage(
                            "You can't add anymore of this item");
                      }
                    });
                  },
                ),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          user[i].discount != "0"
              ? SizedBox(
                  child: Row(
                    children: [
                      Text("$currency${subDiscount}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: CustomColors.fontFamily,
                              fontSize: 14)),
                      SizedBox(width: Get.width * 0.02),
                      Text("$currency${user[i].price}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                              color: CustomColors.grey,
                              fontFamily: CustomColors.fontFamily)),
                    ],
                  ),
                )
              : Text("$currency${subDiscount}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: CustomColors.fontFamily,
                      fontSize: 14)),
          SizedBox(width: Get.width * 0.08),
          Row(
            children: [
              const Icon(Icons.watch_later_outlined,
                  size: 18, color: Colors.grey),
              SizedBox(width: Get.width * 0.02),
              Text("${user[i].taketime} mins",
                  style: const TextStyle(
                      color: CustomColors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: CustomColors.fontFamily,
                      fontSize: 14)),
            ],
          ),
        ]),
        const SizedBox(height: 12),
        dottedline(),
        const SizedBox(height: 12),
        Ink(
          width: Get.width * 0.85,
          child: Text("${user[i].servicedesc}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontFamily: CustomColors.fontFamily, fontSize: 14)),
        ),
      ]),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          onTap: () {
            fullDetails(
              title: user[i].title,
              subTitle: user[i].servicedesc,
            );
          },
          child: const Text(TextString.viewDetails,
              style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.primaryColor,
                  fontFamily: CustomColors.fontFamily,
                  fontWeight: FontWeight.w600)),
        ),
      ),

      const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(thickness: 1))
    ]);
  }

  /// -------------------------------------------- Service Detail Api ---------------------------------------------------///

  prefix.Servicelist? servicelist;

  serviceDetailApi() async {
    deleteuserList();

    var params = {
      "vendor_id": widget.vendorId ?? "1",
      "cat_id": widget.catId ?? "1"
    };
    ApiWrapper.dataPost(Config.serviceDetail, params).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          serviceDetailModel = prefix.ServiceDetailModel.fromJson(val);

          for (var i = 0;
              i < val["ServiceData"]["SubWiseServiceData"].length;
              i++) {
            var title =
                val["ServiceData"]["SubWiseServiceData"][i]["sub_title"];
            for (var j = 0;
                j <
                    val["ServiceData"]["SubWiseServiceData"][i]["servicelist"]
                        .length;
                j++) {
              var e =
                  val["ServiceData"]["SubWiseServiceData"][i]["servicelist"][j];

              subWise.saveServiceData(
                  serviceid: e["service_id"],
                  mtitle: title,
                  quantity: "0",
                  img: e["img"],
                  video: e["video"],
                  servicetype: e["service_type"],
                  title: e["title"],
                  taketime: e["take_time"],
                  maxquantity: e["max_quantity"],
                  price: e["price"],
                  discount: e["discount"],
                  servicedesc: e["service_desc"],
                  status: e["status"],
                  isapprove: e["is_approve"]);
            }
          }

          setState(() {});
        }
      }
    });
  }

  deleteuserList() async {
    if (sqfList.length != 0) {
      final db = await ItemListCart.database();
      await db.rawQuery('DELETE FROM ServiceData');
      subWise.fetchUsers();
    } else {
      setState(() {});
      final db = await ItemListCart.database();
      await db.rawQuery('DELETE FROM ServiceData');
      subWise.fetchUsers();
    }
  }

  dottedline() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                  width: dashWidth,
                  height: 1,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: CustomColors.grey)));
            }),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal);
      },
    );
  }

  fullDetails({String? title, subTitle}) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), topRight: Radius.circular(14))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: "Gilroy Bold")),
                  SizedBox(height: Get.height * 0.01),
                  Text(subTitle,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Gilroy Medium",
                          color: greycolor)),
                  SizedBox(height: Get.height * 0.01),
                  // Divider(color: greycolor),
                ],
              ),
            );
          });
        });
  }

  /// UC Safe
  Widget ucSafeButton({Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Center(
          child: Container(
        height: 40,
        width: Get.width * 0.28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: CustomColors.grey.shade300,
              width: 1,
              style: BorderStyle.solid),
          color: notifire.getprimerycolor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.security, color: notifire.getdarkscolor),
            Text(TextString.ucSafe,
                style: TextStyle(
                    fontFamily: CustomColors.fontFamily,
                    fontWeight: FontWeight.w800,
                    color: notifire.getdarkscolor)),
          ],
        ),
      )),
    );
  }
}

buttonIncrement({Function()? decrement, increment, String? count}) {
  return Container(
    height: 40,
    width: 92,
    decoration: BoxDecoration(
        border: Border.all(color: CustomColors.primaryColor),
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffF5F2FD)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      InkWell(
          onTap: decrement,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child:
                Icon(Icons.remove, size: 15, color: CustomColors.primaryColor),
          )),
      Text(count ?? "",
          style: const TextStyle(
              fontFamily: "Gilroy Bold",
              color: CustomColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700)),
      InkWell(
          onTap: increment,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.add, size: 15, color: CustomColors.primaryColor),
          )),
    ]),
  );
}

class VideoWidget extends StatefulWidget {
  final bool? play;
  final String? url;

  const VideoWidget({super.key, this.url, this.play});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url!);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Chewie(
              key: PageStorageKey(widget.url),
              controller: ChewieController(
                allowFullScreen: false,
                hideControlsTimer: const Duration(seconds: 2),
                videoPlayerController: videoPlayerController,
                aspectRatio: videoPlayerController.value.aspectRatio,
                autoInitialize: true,
                looping: false,
                autoPlay: false,
                errorBuilder: (context, errorMessage) {
                  return Center(
                    child: Text(errorMessage,
                        style: const TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
          ));
        } else {
          return Column(
            children: [
              SizedBox(height: Get.height * 0.08),
              isLoadingIndicator(),
            ],
          );
        }
      },
    );
  }
}
