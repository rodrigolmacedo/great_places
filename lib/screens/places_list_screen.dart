import 'package:flutter/material.dart';
import 'package:great_places/providers/greate_places.dart';
import 'package:great_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      Provider.of<GreatePlaces>(context, listen: false).doPermissions();
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('Meus Lugares'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM))
          ],
        ),
        body: FutureBuilder(
          future:
              Provider.of<GreatePlaces>(context, listen: false).loadPlaces(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatePlaces>(
                  child: Center(
                    child: Text('Nenhum local cadastrado!'),
                  ),
                  builder: (context, greatePlaces, child) => greatePlaces
                              .itemsCount ==
                          0
                      ? child
                      : ListView.builder(
                          itemCount: greatePlaces.itemsCount,
                          itemBuilder: (context, index) => Dismissible(
                            key: Key(greatePlaces.items[index].id),
                            background: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.red,
                                    height: double.infinity,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                            onDismissed: (direction) =>
                                Provider.of<GreatePlaces>(context,
                                        listen: false)
                                    .deletePlace(greatePlaces.items[index]),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: FileImage(
                                      greatePlaces.items[index].image)),
                              title: Text(greatePlaces.items[index].title),
                              subtitle: Text(
                                  greatePlaces.items[index].location.address),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    AppRoutes.PLACE_DETAIL,
                                    arguments: greatePlaces.items[index]);
                              },
                            ),
                          ),
                        ),
                ),
        ));
  }
}
