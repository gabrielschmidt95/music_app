import 'package:flutter/material.dart';
import 'package:music_app/src/views/handle_album.dart';
import '../models/album.dart';
import '../utils/api.dart';
import 'album_view.dart';

/// Displays detailed information about a SampleItem.
class AlbumsItemDetailsView extends StatefulWidget {
  final Object artist;
  const AlbumsItemDetailsView({super.key, required this.artist});

  static const routeName = '/discograpy';

  @override
  State<AlbumsItemDetailsView> createState() => _AlbumsItemDetailsViewState();
}

class _AlbumsItemDetailsViewState extends State<AlbumsItemDetailsView> {
  final api = API();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.artist as String),
        ),
        body: FutureBuilder(
          future: api.fetchAlbumByArtist(widget.artist as String),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.separated(
                    // Providing a restorationId allows the ListView to restore the
                    // scroll position when a user leaves and returns to the app after it
                    // has been killed while running in the background.
                    restorationId: 'sampleItemListView',
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      Album item = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                            title: Text(item.title),
                            leading: snapshot.data![index].discogs.coverImage !=
                                    ""
                                ? Image.network(
                                    snapshot.data![index].discogs.coverImage,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const CircularProgressIndicator();
                                    },
                                  )
                                : const IconButton(
                                    iconSize: 50,
                                    icon: Icon(Icons.album),
                                    onPressed: null,
                                  ),
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                AlbumItemDetailsView.routeName,
                                arguments: item.toJson(),
                              );
                              if (result != null) {
                                setState(() {
                                  if (result == "updated") {
                                    return;
                                  }
                                  int deleteIndex = -1;
                                  for (int i = 0;
                                      i < snapshot.data!.length;
                                      i++) {
                                    if (snapshot.data![i].id == result) {
                                      deleteIndex = i;
                                      break;
                                    }
                                  }
                                  if (deleteIndex != -1) {
                                    snapshot.data!.removeAt(deleteIndex);
                                  }
                                });
                              }
                            }),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
          // Providing a restorationId allows the ListView to restore the
          // scroll position when a user leaves and returns to the app after it
          // has been killed while running in the background.
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(
              context,
              HandleAlbumView.routeName,
              arguments: Album.fromJSON({"artist": widget.artist}),
            );
            if (result != null) {
              setState(() {});
            }
          },
          tooltip: 'Add Album',
          child: const Icon(Icons.add),
        ));
  }
}
