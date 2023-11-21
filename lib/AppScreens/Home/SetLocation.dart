// // ignore_for_file: avoid_print, unnecessary_const, prefer_interpolation_to_compose_strings, file_names, unused_local_variable

// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, file_names

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:ucservice_customer/ApiServices/url.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/utils/color_widget.dart';

Future<Position> locateUser() async {
  return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

Future getUserLocation(BuildContext context) async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {}
  var currentLocation = await locateUser();
  debugPrint('location: ${currentLocation.latitude}');
  lat = currentLocation.latitude;
  long = currentLocation.longitude;

  List<Placemark> addresses = await placemarkFromCoordinates(
      currentLocation.latitude, currentLocation.longitude);
  first = addresses.first.name;
  Get.back();
}

Future<void> displayPrediction(Prediction? p, BuildContext context) async {
  if (p != null) {
    // get detail (lat/lng)
    GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: Config.googleKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId!);
    lat = detail.result.geometry!.location.lat;
    long = detail.result.geometry!.location.lng;
    first = p.description;
  }
}

curentlocation(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: InkWell(
      onTap: () {
        getUserLocation(context);
      },
      child: Container(
          color: Colors.transparent,
          child: Row(children: [
            SizedBox(width: Get.width / 20),
            Image.asset("assets/location-crosshairs.png",
                height: Get.height / 30),
            SizedBox(width: Get.width / 20),
            Text("Use current location",
                style: TextStyle(
                    color: CustomColors.primaryColor,
                    fontSize: Get.height / 50,
                    fontFamily: 'Gilroy_Medium')),
          ])),
    ),
  );
}
