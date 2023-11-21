// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/AppScreens/Account/account_screen.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/loginAuth/login_screen.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';

import 'AppScreens/Booking/Booking.dart';
import 'AppScreens/Wallet/WalletHistory.dart';
import 'utils/AppWidget.dart';

var isLoagin;
int selectedIndex = 0;

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    setState(() {});
    isLoagin = getData.read("UserLogin");

    tabController = TabController(length: 4, vsync: this);
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

  List<Widget> myChilders = [
    const HomeScreen(),
    const BookingScreen(),
    const WalletReportPage(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: myChilders),
        bottomNavigationBar: BottomAppBar(
          color: notifire.getprimerycolor,
          child: TabBar(
            onTap: (index) {
              setState(() {});

              if (isLoagin != null) {
                selectedIndex = index;
              } else {
                index != 0
                    ? Get.to(() => const LoginScreen())
                    : const SizedBox();
              }
            },
            indicator: const UnderlineTabIndicator(
              insets: EdgeInsets.only(bottom: 52),
              borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            ),
            labelColor: Colors.blueAccent,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: notifire.greyfont,
            controller: tabController,
            padding: const EdgeInsets.symmetric(vertical: 6),
            tabs: [
              Tab(
                  child: Column(children: [
                Image.asset(ImagePath.homeImg, scale: 19),
                const Text('Home', style: TextStyle(fontSize: 12)),
              ])),
              Tab(
                  child: Column(children: [
                Image.asset(ImagePath.bookingImg, scale: 19),
                const Text('Booking', style: TextStyle(fontSize: 12)),
              ])),
              Tab(
                  child: Column(children: [
                Image.asset(ImagePath.walletIcon, scale: 19),
                const Text('Wallet', style: TextStyle(fontSize: 12)),
              ])),
              Tab(
                  child: Column(children: [
                Image.asset(
                  ImagePath.userIcon,
                  scale: 19,
                ),
                const Text('Account', style: TextStyle(fontSize: 12)),
              ])),
            ],
          ),
        ),
      ),
    );
  }
}
