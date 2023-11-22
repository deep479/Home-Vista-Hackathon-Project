// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_const_constructors, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:ucservice_customer/model/add_or_edit_address_model.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/widget/text_form_field.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../../ApiServices/Api_werper.dart';
import '../../ApiServices/url.dart';
import '../../utils/AppWidget.dart';

class TrackingPage extends StatefulWidget {
  final String? addressAdd;
  final String? type;
  final String? type2;
  const TrackingPage({
    Key? key,
    this.type,
    this.addressAdd,
    this.type2,
  }) : super(key: key);

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final getdata = GetStorage();
  GoogleMapController? _controller;
  bool isLoading = false;

  bool sendmsg = false;
  bool addsave = false;
  String? currentAddress;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng lastLatLng = LatLng(80.24599079, 29.6593457);
  Completer<GoogleMapController> mapController = Completer();
  double lang = 80.24599079;
  double lat = 29.6593457;
  String hno = "";
  String type = "Home";
  int selectediteam = 0;
  List<dynamic> addressList = [];

  List item = ["Home", "Office", "Other"];
  List itemimagelist = [
    "assets/selecthome.png",
    "assets/selectoffice.png",
    "assets/selectothers.png"
  ];

  @override
  void initState() {
    super.initState();
    setLocation();

    if (widget.type2 == "Edit") {
      if (widget.type == "Pickup") {
        hno = getdata.read("PickupAddress")[0]["hno"];
        complatetheadresshousenumber.text =
            getdata.read("PickupAddress")[0]["c_ddress"];
        currentAddress = getdata.read("PickupAddress")[0]["address"];
        c_name.text = getdata.read("PickupAddress")[0]["c_name"];
        c_number.text = getdata.read("PickupAddress")[0]["c_number"];
        lat = double.parse(
            getdata.read("PickupAddress")[0]["lat_map"].toString());
        lang = double.parse(
            getdata.read("PickupAddress")[0]["long_map"].toString());
        landmarkoptional.text = getdata.read("PickupAddress")[0]["landmark"];
        type = getdata.read("PickupAddress")[0]["type"];
      }
    }

    setCustomMapPin();
    getCurrentData();
  }

  setLocation() async {
    setState(() {});
    _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: lastLatLng, zoom: 17)));
  }

  Map<String, bool> values = {
    "sendthetrakinglinkviasms": false,
    "addtosavedadress": false,
  };
  var tmpArray = [];

  getCheckboxItems() {
    values.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      }
    });
    tmpArray.clear();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  kmDistance() {}
  BitmapDescriptor? pinLocationIcon;

  TextEditingController complatetheadresshousenumber = TextEditingController();
  TextEditingController landmarkoptional = TextEditingController();
  TextEditingController c_number = TextEditingController();
  TextEditingController c_name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: CustomColors.white,
          elevation: 0,
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back, color: CustomColors.black)),
          centerTitle: true,
          title: const Text(
            "Detail Location",
            style: TextStyle(
                fontFamily: CustomColors.fontFamily,
                color: CustomColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {});
                var place = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: Config.googleKey,
                  mode: Mode.overlay,
                  strictbounds: false,
                  // components: [Component(Component.country, 'In')],
                );
                if (place != null) {
                  setState(() {
                    currentAddress = place.description.toString();
                  });
                  final plist = GoogleMapsPlaces(
                      apiKey: Config.googleKey,
                      apiHeaders: await const GoogleApiHeaders().getHeaders());
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  lat = geometry.location.lat;
                  lang = geometry.location.lng;
                  lastLatLng = LatLng(lat, lang);
                  getCurrentMap(lastLatLng);
                  _controller?.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: lastLatLng, zoom: 17)));
                  setState(() {});
                }
              },
              icon: const Icon(Icons.search, color: Colors.black),
            ),
          ]),
      body: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ///----------------------------- Google Map -----------------------------///
            !isLoading
                ? Ink(
                    height: Get.height / 2.5,
                    width: Get.width,
                    child: GoogleMap(
                      compassEnabled: true,
                      myLocationButtonEnabled: true,
                      liteModeEnabled: false,
                      mapType: MapType.normal,
                      gestureRecognizers: <
                          Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      initialCameraPosition:
                          CameraPosition(target: lastLatLng, zoom: 14),
                      markers: Set<Marker>.of(markers.values),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      onTap: (latLag) {
                        getCurrentMap(latLag);
                      },
                    ),
                  )
                : Column(children: [
                    SizedBox(height: Get.height * 0.12),
                    Center(child: isLoadingIndicator()),
                  ]),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SELECT PICKUP LOCATION",
                        style: TextStyle(
                            fontSize: Get.height / 55,
                            fontFamily: 'Gilroy_Medium',
                            color: CustomColors.grey)),
                    SizedBox(height: Get.height / 100),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/images/location_mark.png",
                            height: Get.height / 30),
                        SizedBox(width: Get.width / 40),
                        Flexible(
                          child: Text(currentAddress ?? '',
                              style: TextStyle(
                                  fontSize: Get.height / 50,
                                  fontFamily: CustomColors.fontFamily,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height / 45),
                    CustomTextfield(
                        fieldController: complatetheadresshousenumber,
                        hint: "Complete the address house number"),
                    SizedBox(height: Get.height / 45),
                    CustomTextfield(
                        hint: "Land Mark Optional",
                        fieldController: landmarkoptional),
                    SizedBox(height: Get.height / 50),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.width * 0.45,
                            child: CustomTextfield(
                                hint: "Mobile number",
                                fieldController: c_number,
                                fieldInputType: TextInputType.phone),
                          ),
                          SizedBox(
                            width: Get.width * 0.45,
                            child: CustomTextfield(
                                hint: "Contact Name", fieldController: c_name),
                          )
                        ]),
                  ]),
            ),

            SizedBox(height: Get.height / 50),

            //! List of Home , office , other
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Container(
                color: Colors.transparent,
                height: Get.height / 20,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: Get.height / 10,
                      mainAxisExtent: Get.height / 7.7,
                      childAspectRatio: Get.width / 500,
                      crossAxisSpacing: 50,
                      mainAxisSpacing: 10),
                  itemCount: item.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          type = item[index];
                          selectediteam = index;
                        });
                      },
                      child: Container(
                        width: Get.width / 2,
                        decoration: BoxDecoration(
                            color: selectediteam == index
                                ? Colors.transparent
                                : Colors.transparent,
                            border: Border.all(
                                color: selectediteam == index
                                    ? CustomColors.primaryColor
                                    : CustomColors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(itemimagelist[index],
                                    height: Get.height / 35,
                                    color: selectediteam == index
                                        ? CustomColors.primaryColor
                                        : CustomColors.grey),
                                SizedBox(width: Get.width / 40),
                                Text(
                                  item[index],
                                  style: TextStyle(
                                      fontFamily: 'Gilroy_Bold',
                                      color: selectediteam == index
                                          ? CustomColors.primaryColor
                                          : CustomColors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: Get.height / 60),
                                ),
                              ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: Get.height / 40),

            //! Select this button
            InkWell(
                onTap: () {
                  if (complatetheadresshousenumber.text.isNotEmpty &&
                      c_name.text.isNotEmpty &&
                      c_name.text.isNotEmpty) {
                    addressList.clear();
                    //! lat long Add --------------------------------

                    var addressdata = {
                      "hno": complatetheadresshousenumber.text.toString(),
                      "c_ddress": complatetheadresshousenumber.text.toString(),
                      "address": currentAddress,
                      "c_name": c_name.text.toString(),
                      "c_number": c_number.text.toString(),
                      "lat_map": lat,
                      "long_map": lang,
                      "landmark": landmarkoptional.text == ""
                          ? ""
                          : landmarkoptional.text.toString(),
                      "type": type
                    };
                    addressList.add(addressdata);

                    save("PickupAddress", addressList);

                    setState(() {});
                    addAdressApi();
                  } else {
                    ApiWrapper.showToastMessage("Fill All data");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xff6F42E5)),
                    child: Center(
                      child: const Text(
                        "SELECT THIS ADDRESS",
                        style: TextStyle(
                            color: CustomColors.white,
                            fontFamily: CustomColors.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                )),

            SizedBox(height: Get.height * 0.02)
          ])),
    );
  }

  Future<void> getCurrentData() async {
    isLoading = true;
    Position position = await getLatLong();
    lat = position.latitude;
    lang = position.longitude;
    getCurrentMap(LatLng(position.latitude, position.longitude));
  }

  Future<void> getCurrentMap(LatLng latLng) async {
    lat = latLng.latitude;
    lang = latLng.longitude;
    const MarkerId markerId = MarkerId("markerIdVal");
    final Marker marker = Marker(
        markerId: markerId,
        position: latLng,
        icon: pinLocationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 1000),
          'assets/map_pin.png',
        ));
    markers.clear();
    markers[markerId] = marker;
    _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 17)));

    getAddressFromLatLong(latLng);
    isLoading = false;
    setState(() {});
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/map_pin.png');
  }

  Future<Position> getLatLong() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getAddressFromLatLong(LatLng latLng) async {
    lastLatLng = latLng;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];

      String name = place.name.toString();
      String thoroughfare = place.thoroughfare.toString();
      String area = place.subLocality.toString();
      String city = place.locality.toString();
      String state = place.administrativeArea.toString();
      String country = place.country.toString();

      currentAddress =
          "$name${(name.isNotEmpty) ? ", " : ""}$thoroughfare${(thoroughfare.isNotEmpty) ? ", " : ""}$area${(area.isNotEmpty) ? ", " : ""}$city${(city.isNotEmpty) ? ", " : ""}$state${(state.isNotEmpty) ? ", " : ""}$country.";
      setState(() {});
    }
  }

  AddOrEditAddressModel? addOrEditAddressModel;

  addAdressApi() {
    var data = {
      "uid": uid,
      "address": currentAddress,
      "houseno": complatetheadresshousenumber.text,
      "type": type,
      "lat_map": lat,
      "long_map": lang,
      "aid": widget.addressAdd,
      "c_name": c_name.text.toString(),
      "c_number": c_number.text.toString(),
      "landmark": landmarkoptional.text.toString(),
    };

    ApiWrapper.dataPost(Config.addAddress, data).then((val) {
      getdata.remove("PickupAddress");
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          var addressdata = {
            "hno": complatetheadresshousenumber.text.toString(),
            "c_ddress": complatetheadresshousenumber.text.toString(),
            "address": currentAddress,
            "c_name": c_name.text.toString(),
            "c_number": c_number.text.toString(),
            "lat_map": lat,
            "long_map": lang,
            "landmark": landmarkoptional.text.toString(),
            "type": type
          };
          addressList.add(addressdata);
          save("PickupAddress", addressList);
          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
