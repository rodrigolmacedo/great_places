import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/places.dart';
import 'package:great_places/utils/location_util.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isReadOnly;

  const MapScreen(
      {Key key,
      this.initialLocation =
          const PlaceLocation(latitude: 37.419857, longitude: -122.078827),
      this.isReadOnly = false})
      : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedPosition;
  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  GoogleMapController _controller;

  void setMapController(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isReadOnly ? 'Local' : 'Selecione...'),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
                icon: Icon(Icons.check),
                onPressed: _pickedPosition == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedPosition);
                      })
        ],
      ),
      body: Stack(children: [
        GoogleMap(
          onMapCreated: setMapController,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          compassEnabled: true,
          // mapType: MapType.normal,
          zoomGesturesEnabled: true,
          trafficEnabled: true,
          minMaxZoomPreference: MinMaxZoomPreference(13, 18),
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.initialLocation.latitude,
                  widget.initialLocation.longitude),
              zoom: 15),
          onTap: widget.isReadOnly ? null : _selectPosition,
          markers: (_pickedPosition == null && !widget.isReadOnly)
              ? null
              : {
                  Marker(
                      markerId: MarkerId('p1'),
                      position:
                          _pickedPosition ?? widget.initialLocation.toLatLng())
                },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 80,
            width: 200,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.style_outlined),
                      onPressed: () {
                        if (_controller != null) {
                          _controller.setMapStyle(LocationUtil.mapStyle());
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
