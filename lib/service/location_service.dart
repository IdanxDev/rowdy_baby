// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:dating/widgets/app_logs.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final GeolocatorPlatform geoLocatorPlatform = GeolocatorPlatform.instance;
  Position? position;

  Future<bool> checkLocationService(BuildContext context) async {
    bool isServiceAvailable =
        await geoLocatorPlatform.isLocationServiceEnabled();
    if (!isServiceAvailable) {
      showMessage(context, message: 'Enable location', isError: true);
      await geoLocatorPlatform.openLocationSettings();
    }
    return isServiceAvailable;
  }

  Future<bool> checkLocationPermission(BuildContext context) async {
    bool isServiceAvailable = await checkLocationService(context);
    logs('service --> $isServiceAvailable');
    if (isServiceAvailable) {
      LocationPermission locationPermission =
          await geoLocatorPlatform.checkPermission();
      logs('locationPermission --> $locationPermission');
      switch (locationPermission) {
        case LocationPermission.denied:
          // await geoLocatorPlatform.requestPermission();
          return false;
        case LocationPermission.deniedForever:
          // await geoLocatorPlatform.requestPermission();
          return false;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          await getCurrentLocation();
          return true;
        case LocationPermission.unableToDetermine:
          // await checkLocationPermission(context);
          return false;
        default:
          return false;
      }
    }
    return isServiceAvailable;
  }

  Future<void> getCurrentLocation() async {
    position = await GeolocatorPlatform.instance.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );
    logs('message --> ${position!.toJson()}');
  }

  static String calculateDistance(lat1, lon1, lat2, lon2) {
    double p = 0.017453292519943295;
    double Function(num radians) c = cos;
    double a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double distance = 12742 * asin(sqrt(a));
    num totalDistance = num.parse(distance.toString());
    return totalDistance.toStringAsFixed(2);
  }
}
