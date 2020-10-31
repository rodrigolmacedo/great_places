import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/places.dart';
import 'package:great_places/utils/db_util.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:permission_handler/permission_handler.dart';

class GreatePlaces with ChangeNotifier {
  List<Place> _items = [];

  Future<void> doPermissions() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      // Permission.sensors,
      // Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                  latitude: item['latitude'],
                  longitude: item['longitude'],
                  address: item['address']),
            ))
        .toList();
    notifyListeners();
  }

  List<Place> get items => [..._items];

  int get itemsCount => _items.length;

  Place itemByIndex(int index) => _items.elementAt(index);
  Future<bool> deletePlace(Place place) async {
    bool deleted = await DbUtil.delete('places', place.id);
    if (deleted) {
      _items.remove(place);

      notifyListeners();
    }

    return deleted;
  }

  Future<void> addPlace(String title, File image, LatLng position) async {
    String address = await LocationUtil.getAddressFrom(position);
    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      image: image,
      location: PlaceLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address),
    );

    _items.add(newPlace);
    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
    });
    notifyListeners();
  }
}
