import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<(String?, String?)> getCurrentCityAndStreet() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Standortberechtigung verweigert');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Standortberechtigung dauerhaft verweigert');
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final Placemark place = placemarks.first;
      final city =
          place.locality?.isEmpty ?? true
              ? place.subLocality
              : place.subLocality?.isEmpty ?? true
              ? place.locality
              : place.locality;
      return (city, place.street);
    } else {
      return (null, null);
    }
  }
}
