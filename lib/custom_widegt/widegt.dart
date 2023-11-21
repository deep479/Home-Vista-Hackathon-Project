// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:ucservice_customer/utils/color_widget.dart';

CustomAppbar(
    {centertext,
    ActionIcon,
    bgcolor,
    Color? actioniconcolor,
    leadingiconcolor,
    Function()? onback,
    titlecolor}) {
  return AppBar(
      actions: [Icon(ActionIcon, color: actioniconcolor)],
      title: Text(centertext,
          style: TextStyle(color: titlecolor, fontFamily: "Gilroy Bold")),
      leading: BackButton(color: leadingiconcolor, onPressed: onback),
      elevation: 0.7,
      backgroundColor: bgcolor);
}

// ignore: non_constant_identifier_names
AppButton({onclick, buttontext}) {
  return InkWell(
      onTap: onclick,
      child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: CustomColors.primaryColor),
          child: Center(
              child: Text(
            buttontext,
            style: const TextStyle(
                color: CustomColors.white,
                fontFamily: CustomColors.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ))));
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
List AddressList = [
  {
    "id": "1",
    "uid": "1",
    "hno": "a1",
    "address": "test",
    "c_name": "sandip",
    "c_number": "9284798223",
    "lat_map": "1.25154",
    "long_map": "1.2555",
    "landmark": "surat",
    "type": "Home"
  },
  {
    "id": "7",
    "uid": "1",
    "hno": "412",
    "address": "ambika pinnacle, Mota Varachha, Surat,",
    "c_name": "sandip",
    "c_number": "9284798223",
    "lat_map": "21.2383215",
    "long_map": "72.8880614",
    "landmark": " beside Lajamani Chowk",
    "type": "Office"
  }
];
