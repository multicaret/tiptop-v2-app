import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as locationPkg;
import 'package:permission_handler/permission_handler.dart';
import 'package:tiptop_v2/models/enums.dart';
import 'package:tiptop_v2/models/google_geocoding.dart';
import 'package:tiptop_v2/models/google_places.dart';
import 'package:tiptop_v2/models/models.dart';
import 'package:tiptop_v2/providers/app_provider.dart';

import 'constants.dart';
import 'http_exception.dart';

Future<bool> getLocationPermissionStatus() async {
  PermissionStatus locationPermission = await Permission.location.status;

  return locationPermission.isGranted;
}

Future<bool> handleLocationPermission() async {
  bool isGranted = await getLocationPermissionStatus();

  if (isGranted) {
    print('Location permission granted! Update user location');
    await updateLocationAndStoreIt();
    return true;
  } else {
    print('Location is denied! ASK and Wait for it to be granted');
    if (await Permission.location.request().isGranted || await Permission.locationWhenInUse.request().isGranted) {
      await updateLocationAndStoreIt();
      return true;
    }
  }
  return false;
}

Future updateLocationAndStoreIt() async {
  var location = new locationPkg.Location();
  locationPkg.LocationData currentLocation = await location.getLocation();
  AppProvider.latitude = currentLocation.latitude;
  AppProvider.longitude = currentLocation.longitude;
  print("UPDATED LOCATION OF USER: Lat: ${AppProvider.latitude}, long: ${AppProvider.longitude}");
}

final googleGeocodeEndpoint = 'https://maps.googleapis.com/maps/api/geocode/json?';

// Reverse Geocoding
Future<String> getLocationAddress(LatLng location) async {
  final endpoint = 'latlng=${location.latitude},${location.longitude}&key=${AppProvider.GOOGLE_API_KEY}';
  Uri url = Uri.http(googleGeocodeEndpoint, endpoint);
  print('endpoint');
  print(endpoint);
  try {
    http.Response response = await http.get(url);
    GoogleGeocodeResponse reverseGeocodeResponse = geocodeResponseFromJson(response.body);
    final status = reverseGeocodeResponse.status;
    if (status != GoogleResponseStatus.OK) {
      handleGoogleRequestError(status);
    }
    final address = reverseGeocodeResponse.results[0].formattedAddress;
    print('status: $status');
    return address;
  } catch (error) {
    throw error;
  }
}

final googlePlacesEndpoint = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?';

// Geocoding
Future<List<Candidate>> findPlaces(String input) async {
  final endpoint = 'input=$input&inputtype=textquery&fields=formatted_address,name,geometry/location&key=${AppProvider.GOOGLE_API_KEY}';
  Uri url = Uri.http(googleGeocodeEndpoint, endpoint);
  http.Response response = await http.get(url);

  print('Request URL');
  print(response.request);

  GooglePlacesResponse googlePlacesResponse = googlePlacesResponseFromJson(response.body);
  final status = googlePlacesResponse.status;
  if (status != GoogleResponseStatus.OK) {
    handleGoogleRequestError(status);
  }
  List<Candidate> foundAddresses = googlePlacesResponse.candidates;
  return foundAddresses;
}

// Handling Google Maps Request Errors
void handleGoogleRequestError(GoogleResponseStatus status) {
  switch (status) {
    case GoogleResponseStatus.ZERO_RESULTS:
      {
        throw HttpException(title: 'Zero Resutls', message: 'No results match your search');
      }
      break;

    case GoogleResponseStatus.OVER_QUERY_LIMIT:
      {
        throw HttpException(title: 'OVER_QUERY_LIMIT', message: 'Query limit reached');
      }
      break;

    case GoogleResponseStatus.REQUEST_DENIED:
      {
        throw HttpException(title: 'REQUEST_DENIED', message: 'Unauthorized request');
      }
      break;

    case GoogleResponseStatus.INVALID_REQUEST:
      {
        throw HttpException(title: 'INVALID_REQUEST', message: 'Missing some request information');
      }
      break;

    default:
      {
        throw HttpException(title: 'Unknown Error', message: 'An error occurred');
        //statements;
      }
      break;
  }
}

Future<Uint8List> getAndCacheMarkerIcon(String imageUrl, {int targetWidth = markerIconCompressedSize}) async {
  final File markerImageFile = await DefaultCacheManager().getSingleFile(imageUrl);
  final Uint8List markerImageBytes = await markerImageFile.readAsBytes();

  final Codec markerImageCodec = await instantiateImageCodec(
    markerImageBytes,
    targetWidth: targetWidth,
  );

  final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
  final ByteData byteData = await frameInfo.image.toByteData(
    format: ImageByteFormat.png,
  );

  final Uint8List resizedMarkerImageBytes = byteData.buffer.asUint8List();
  return resizedMarkerImageBytes;
}

Future<Uint8List> getBytesFromAsset(String path, {int targetWidth = markerIconCompressedSize}) async {
  ByteData data = await rootBundle.load(path);
  Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: targetWidth);
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
}
