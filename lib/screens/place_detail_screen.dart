import 'package:flutter/material.dart';
import 'package:great_places/models/places.dart';
import 'package:great_places/providers/greate_places.dart';
import 'package:great_places/widgets/map_screen.dart';
import 'package:great_places/widgets/place_marker.dart';
import 'package:great_places/widgets/place_polygon.dart';
import 'package:great_places/widgets/place_polyline.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Place place = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                bool deleted =
                    await Provider.of<GreatePlaces>(context, listen: false)
                        .deletePlace(place);
                if (deleted) Navigator.of(context).pop();
              })
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(place.image,
                fit: BoxFit.cover, width: double.infinity),
          ),
          SizedBox(height: 10),
          Text(
            place.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MapScreen(
                        initialLocation: place.location,
                        isReadOnly: true,
                      ),
                  fullscreenDialog: true));
            },
            icon: Icon(Icons.map),
            label: Text('Ver no Mapa'),
            textColor: Theme.of(context).primaryColor,
          ),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlacePolygonPage(),
                  fullscreenDialog: true));
            },
            icon: Icon(Icons.map),
            label: Text('place_polygon'),
            textColor: Theme.of(context).primaryColor,
          ),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlaceMarkerPage(),
                  fullscreenDialog: true));
            },
            icon: Icon(Icons.map),
            label: Text('place_marker'),
            textColor: Theme.of(context).primaryColor,
          ),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlacePolylinePage(),
                  fullscreenDialog: true));
            },
            icon: Icon(Icons.map),
            label: Text('place_marker'),
            textColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
