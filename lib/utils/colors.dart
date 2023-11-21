import 'package:flutter/material.dart';

import 'notifire.dart';

class ColorNotifire with ChangeNotifier {
  bool _isDark = true;
  set setIsDark(value) {
    _isDark = value;
    notifyListeners();
  }

  get getbgcolor => _isDark ? primeryColor : d;
  get getprimerycolor => _isDark ? darkPrimeryColor : primeryColor;
  get getdarkscolor => _isDark ? lightColor : darkColor;
  get getdarkscolors => _isDark ? darkColor1 : lightColor1;
  get getgreycolor => _isDark ? lightgreyColor : darkgreyColor;
  get getbluecolor => _isDark ? darkblueColor : lightblueColor;
  get getbox => _isDark ? darkbox : lightbox;
  get greyfont => _isDark ? greydark : greylight;
  get station => _isDark ? stationdark : stationlight;
  get bar => _isDark ? serchbaard : serchbaarl;
  get black => _isDark ? b : l;
  get bg => _isDark ? darkPrimeryColor : bgcolor;
  get detail => _isDark ? a : d;
  get sp => _isDark ? splayd : splayl;
  get bt => _isDark ? btl : btd;
  get iconcolor => _isDark ? dark : light;
}
