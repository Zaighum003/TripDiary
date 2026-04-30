

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission permanently denied');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () async {
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
          );
        },
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  static Future<String?> getPlaceName(double latitude, double longitude) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final parts = <String>[];

        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          parts.add(placemark.locality!);
        }
        if (placemark.administrativeArea != null &&
            placemark.administrativeArea!.isNotEmpty) {
          parts.add(placemark.administrativeArea!);
        }
        if (placemark.country != null && placemark.country!.isNotEmpty) {
          parts.add(placemark.country!);
        }

        if (parts.isNotEmpty) {
          return parts.join(', ');
        }
      }

      return 'Lat: ${latitude.toStringAsFixed(2)}, Lon: ${longitude.toStringAsFixed(2)}';
    } catch (e) {
      print('Error reverse geocoding: $e');
      return 'Lat: ${latitude.toStringAsFixed(2)}, Lon: ${longitude.toStringAsFixed(2)}';
    }
  }

  static Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      print('Error checking location service: $e');
      return false;
    }
  }

  static Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      print('Error opening location settings: $e');
    }
  }
}
