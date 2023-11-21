// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucservice_customer/IntroScreen/splash_screen.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ColorNotifire())],
    child: GetMaterialApp(
      title: 'Home Vista',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Gilroy"),
      home: const Directionality(
          textDirection: TextDirection.ltr, // set this property
          child: SplashScreen()),
    ),
  ));
}
