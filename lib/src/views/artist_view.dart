import 'package:flutter/material.dart';
import '../settings/settings_view.dart';
import 'albums_view.dart';
import '../utils/api.dart';
import '../models/artist.dart';

/// Displays a list of SampleItems.
class ArtistListView extends StatefulWidget {
  const ArtistListView({super.key});

  static const routeName = '/artist';

  @override
  State<ArtistListView> createState() => _ArtistListViewState();
}

class _ArtistListViewState extends State<ArtistListView> {
  final api = API();
  bool _searchBar = false;
  TextEditingController editingController = TextEditingController();
  List<Artist> artists = [];
  List<Artist> artistsFiltered = [];

  void _searchArtist() async {    
    if (artists.isEmpty) {
      artists = await api.fetchArtists();
    }
    if (editingController.text.isEmpty) {
      setState(() {
        this.artistsFiltered = artists;
      });
      return;
    }

    List<Artist> artistsFiltered = [];

    for (var _artist in artists) {
      if (_artist.name
          .toLowerCase()
          .contains(editingController.text.toLowerCase())) {
        artistsFiltered.add(_artist);
      }
    }

    setState(() {
      artistsFiltered = artistsFiltered;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchArtist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.blue[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _searchBar == false ? 0 : 500,
          height: 50,
          child: TextField(
            controller: editingController,
            decoration: InputDecoration(
              hintText: "Digite o Artista",
              hintStyle: const TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                style: ButtonStyle(
                  iconSize:
                      MaterialStateProperty.all(_searchBar == false ? 0 : 20),
                ),
                onPressed: () {
                  setState(() {
                    editingController.clear();
                    _searchArtist();
                  });
                },
                icon: const Icon(Icons.clear),
              ),
            ),
            autofocus: _searchBar == true ? true : false,
            enableSuggestions: false,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                _searchArtist();
              });
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                if (_searchBar == true) {
                  FocusScope.of(context).unfocus();
                  editingController.clear();
                  _searchArtist();
                }
                _searchBar = !_searchBar;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: artistsFiltered == []
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.builder(
                    // Providing a restorationId allows the ListView to restore the
                    // scroll position when a user leaves and returns to the app after it
                    // has been killed while running in the background.
                    restorationId: 'ArtistListView',
                    itemCount: artistsFiltered.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = artistsFiltered[index];

                      return Column(
                        children: [
                          ListTile(
                              title: Text(item.name),
                              leading: const IconButton(
                                iconSize: 50,
                                icon: Icon(Icons.person),
                                onPressed: null,
                              ),
                              onTap: () {
                                // Navigate to the details page. If the user leaves and returns to
                                // the app after it has been killed while running in the
                                // background, the navigation stack is restored.
                                Navigator.restorablePushNamed(
                                  context,
                                  AlbumsItemDetailsView.routeName,
                                  arguments: item.name,
                                );
                              }),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                )),
    );
  }
}
