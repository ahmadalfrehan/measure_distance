import 'dart:async';
import 'dart:developer';
import 'dart:math' show cos, sqrt, asin;

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../Model/LocationModel.dart';

class GeoLocatorController extends GetxController {
  StreamSubscription<Position>? _positionStreamSubscription;
  List<LocationModel> locations = <LocationModel>[].obs;
  RxDouble totalDistance = 0.0.obs;
  RxDouble area = 0.0.obs;
  RxDouble a = 0.0.obs;
  final RxInt returnType = 12742.obs;
  RxBool serviceEnabled = false.obs;
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

  pickWithGeoLocator() async {
    if (_positionStreamSubscription == null) {
      final positionStream = GeolocatorPlatform.instance.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((event) {
        latitude1.value = event.latitude;
        longitude2.value = event.longitude;
        locations.add(LocationModel.fromJson({
          'lat': latitude1.value,
          'lng': longitude2.value,
        }));
        log(event.toString());
        log(event.latitude.toString());
        log(event.longitude.toString());
        log(event.altitude.toString());
      });
      _positionStreamSubscription?.pause();
    }
    if (_positionStreamSubscription == null) {
      return;
    }
    String statusDisplayValue;
    if (_positionStreamSubscription!.isPaused) {
      _positionStreamSubscription!.resume();
      statusDisplayValue = 'resumed';
    } else {
      _positionStreamSubscription!.pause();
      statusDisplayValue = 'paused';
    }
  }

  calculate() {
    totalDistance = 0.0.obs;
    print(totalDistance);
    for (int i = 0; i < locations.length - 1; i++) {
      print('${locations[i].lat} , ${locations[i].lng}');
      totalDistance.value += calculateDistance(locations[i].lat,
              locations[i].lng, locations[i + 1].lat, locations[i + 1].lng)
          .value;
    }
    area.value = (totalDistance * 1000) / 4;
    area.value = area.value * area.value;

    log((totalDistance * 1000).toString());
  }
}
