import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/places.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:great_places/widgets/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPosition;

  const LocationInput({Key key, this.onSelectPosition}) : super(key: key);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  LocationData _userLocation;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getUserLocation();
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      print('${locData.latitude}, ${locData.longitude}');
      _showPreview(LatLng(locData.latitude, locData.longitude));

      widget.onSelectPosition(LatLng(locData.latitude, locData.longitude));
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> getUserLocation() async {
    await Location().getLocation().then((data) {
      print(data);
      setState(() {
        _userLocation = data;
      });
    });
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedPosition =
        await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => MapScreen(
        initialLocation: PlaceLocation(
            latitude: _userLocation.latitude,
            longitude: _userLocation.longitude),
      ),
    ));

    if (selectedPosition == null) return;

    _showPreview(selectedPosition);

    widget.onSelectPosition(selectedPosition);
  }

  void _showPreview(LatLng selectedPosition) {
    final _staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: selectedPosition.latitude,
        longitude: selectedPosition.longitude);

    setState(() {
      _previewImageUrl = _staticMapImageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text('Localização não informada!')
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        OutlineButton.icon(
          onPressed: _getCurrentUserLocation,
          icon: Icon(Icons.location_on),
          textColor: Theme.of(context).primaryColor,
          label: Text('Localização atual'),
        ),
        OutlineButton.icon(
          onPressed: _selectOnMap,
          icon: Icon(Icons.map),
          textColor: Theme.of(context).primaryColor,
          label: Text('Selecione no mapa'),
        ),
      ],
    );
  }
}
