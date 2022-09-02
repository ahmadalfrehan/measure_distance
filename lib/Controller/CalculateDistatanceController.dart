import 'dart:developer';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlng/Model/LocationModel.dart';
import 'package:location/location.dart';

class CalculateDistanceController extends GetxController {
  List<LocationModel> locations = <LocationModel>[].obs;
  RxDouble totalDistance = 0.0.obs;
  RxDouble a = 0.0.obs;
  final RxInt returnType = 12742.obs;
  RxBool serviceEnabled = false.obs;
  PermissionStatus? _permissionGranted;
  LocationData? _location;
  RxDouble latitude1 = 0.0.obs;
  RxDouble longitude2 = 0.0.obs;

  RxDouble calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    a.value = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    final RxDouble d = asin(sqrt(a.value)).obs;
    RxDouble star = (returnType.value * d.value).obs;
    return star;
  }

  List<dynamic> data = [
    {"lat": 44.968046, "lng": -94.420307},
    {"lat": 44.33328, "lng": -89.132008},
    {"lat": 33.755787, "lng": -116.359998},
    {"lat": 33.844843, "lng": -116.54911},
    {"lat": 44.92057, "lng": -93.44786},
    {"lat": 44.240309, "lng": -91.493619},
    {"lat": 44.968041, "lng": -94.419696},
    {"lat": 44.333304, "lng": -89.132027},
    {"lat": 33.755783, "lng": -116.360066},
    {"lat": 33.844847, "lng": -116.549069},
  ];

  calculate() {
    totalDistance = 0.0.obs;
    print(totalDistance);
    for (int i = 0; i < locations.length - 1; i++) {
      print('${locations[i].lat} , ${locations[i].lng}');
      totalDistance.value += calculateDistance(locations[i].lat,
              locations[i].lng, locations[i + 1].lat, locations[i + 1].lng)
          .value;
    }
    log((totalDistance * 1000).toString());
  }

  pickCurrentLocation() async {
    Location location = Location();
    serviceEnabled.value = await location.serviceEnabled();
    if (serviceEnabled.value == true) {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        location.onLocationChanged.listen((LocationData currentLocation) {
          latitude1.value = currentLocation.latitude!;
          longitude2.value = currentLocation.longitude!;
          locations.add(LocationModel.fromJson({
            'lat': latitude1.value,
            'lng': longitude2.value,
          }));
        });
        _location = await location.getLocation();
        debugPrint("${_location!.latitude}   ${_location!.longitude}");
      } else {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.granted) {
        } else {
          SystemNavigator.pop();
        }
      }
    } else {
      serviceEnabled.value = await location.requestService();
      if (serviceEnabled.value == true) {
        _permissionGranted = await location.hasPermission();

        if (_permissionGranted == PermissionStatus.granted) {
          print('its granted second first');
        } else {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted == PermissionStatus.granted) {
            print('excellent you are allowed 2');
          } else {
            SystemNavigator.pop();
          }
        }
        print('start_tracking 2');
      } else {
        SystemNavigator.pop();
      }
    }
  }
}
