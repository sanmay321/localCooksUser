import 'package:geolocator/geolocator.dart' as Geo;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as PH;

class LocationService {
  /// Check and request location permissions
  static Future<PermissionStatus> checkAndRequestLocationPermissions() async {

    var _serviceEnabled = await Location().serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await Location().requestService();
    }

    if(!_serviceEnabled){
      return PermissionStatus.denied;
    }else{
      var _permissionGranted = await Location().hasPermission();
      if(_permissionGranted == PermissionStatus.denied || _permissionGranted == PermissionStatus.deniedForever){
        return await Location().requestPermission();
      }else{
        return _permissionGranted;
      }
    }
  }

  /// Handle all possible permission scenarios
  static Future<Geo.Position?> getCurrentLocation() async {
    try {
      PermissionStatus status = await checkAndRequestLocationPermissions();

      if (status == PermissionStatus.granted || status == PermissionStatus.grantedLimited) {
        return await Geo.Geolocator.getCurrentPosition(
          locationSettings: Geo.LocationSettings(
            accuracy: Geo.LocationAccuracy.best,
          ),
        );
      } else if (status == PermissionStatus.deniedForever) {
        // The user opted to never again see the permission request dialog
        // You should redirect them to app settings
        await PH.openAppSettings();
        return null;
      } else {
        // Permission denied (but not permanently)
        return null;
      }
    } catch (e) {
      print('Location error: $e');
      return null;
    }
  }

  /// Check if location permission is permanently denied
  static Future<bool> isLocationPermanentlyDenied() async {
    final status = await Location().hasPermission();
    return status == PermissionStatus.deniedForever;
  }

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geo.Geolocator.isLocationServiceEnabled();
  }
}