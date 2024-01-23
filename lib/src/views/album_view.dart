import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:music_app/src/models/album.dart';
import 'package:url_launcher/url_launcher.dart';
import 'handle_album.dart';
import '../utils/api.dart';

/// Displays detailed information about a SampleItem.
class AlbumItemDetailsView extends StatefulWidget {
  final Object album;
  const AlbumItemDetailsView({super.key, required this.album});

  static const routeName = '/album';

  @override
  State<AlbumItemDetailsView> createState() => _AlbumItemDetailsViewState();
}

class _AlbumItemDetailsViewState extends State<AlbumItemDetailsView> {
  final api = API();

  void returnScreen(String id) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.pop(context, id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Disco deletado com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    Album album = Album.fromJSON(widget.album as Map<String, dynamic>);
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(fit: BoxFit.fitWidth, child: Text(album.title)),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: const Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                value: "fix_discogs",
                child: TextButton.icon(
                    onPressed: () async {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text("Discogs ID"),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                const Text("Insira o ID do álbum no Discogs"),
                                const SizedBox(height: 20),
                                CupertinoTextField(
                                  placeholder: "Discogs ID",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text("Cancelar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text("Confirmar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text("Corrigir Discogs")),
              ),
              DropdownMenuItem(
                value: "edit",
                child: TextButton.icon(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        HandleAlbumView.routeName,
                        arguments: album,
                      );
                      if (result != null) {
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Editar")),
              ),
              DropdownMenuItem(
                value: "delte",
                child: TextButton.icon(
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text("Deletar"),
                            content:
                                const Text("Tem certeza que deseja deletar?"),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text("Não"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text("Sim"),
                                onPressed: () async {
                                  await api.deleteAlbum(album);
                                  returnScreen(album.id);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Deletar")),
              ),
            ],
            onChanged: (value) {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: album.discogs.coverImage != ""
                  ? Image.network(
                      album.discogs.coverImage,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator();
                      },
                      fit: BoxFit.cover,
                    )
                  : const Text("Não há imagem"),
            ),
            ListTile(
              leading: const Text("Título:"),
              title: Text(
                album.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("Artista:"),
              title: Text(
                album.artist,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("Ano de lançamento:"),
              title: Text(
                album.releaseYear.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("Mídia:"),
              title: Text(
                album.media,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("Origem:"),
              title: Text(
                album.origin,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("Ano de edição:"),
              title: Text(
                album.editionYear.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("Compra:"),
              title: Text(
                album.purchase,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("IFPI Mastering:"),
              title: Text(
                album.ifpiMastering,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("IFPI Mould:"),
              title: Text(
                album.ifpiMould,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("Barcode:"),
              title: Text(
                album.barcode,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("Matriz:"),
              title: Text(
                album.matriz,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Text("Lote:"),
              title: Text(
                album.lote,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Add section for tracklist
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white30,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Tracklist",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  album.discogs.tracks == []
                      ? Container(
                          alignment: Alignment.center,
                          height: 100,
                          child: const Text("Não há tracklist"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: album.discogs.tracks.length,
                          itemBuilder: (context, index) {
                            final item = album.discogs.tracks[index];
                            return ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              leading: Text(
                                item.position,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              title: Text(
                                item.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                item.duration,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spaceBetweenChildren: 20,
        children: [
          SpeedDialChild(
            child: Image.asset("assets/images/discogs.png"),
            backgroundColor: Colors.transparent,
            label: "Discogs",
            onTap: () async {
              if (album.discogs.urls == []) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Não há link para o Discogs"),
                  ),
                );
                return;
              }
              Uri spotifyUrl = Uri.parse(
                  "https://www.discogs.com${album.discogs.urls[0].uri}");
              // Check if Spotify is installed
              if (await canLaunchUrl(spotifyUrl)) {
                // Launch the url which will open Spotify
                launchUrl(spotifyUrl);
              }
            },
          ),
          SpeedDialChild(
              child: Image.asset("assets/images/spotify.png"),
              backgroundColor: Colors.transparent,
              label: "Spotify",
              onTap: () async {
                if (album.spotify.externalUrls["spotify"] == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Não há link para o Spotify"),
                    ),
                  );
                  return;
                }
                Uri spotifyUrl =
                    Uri.parse(album.spotify.externalUrls["spotify"]!);
                // Check if Spotify is installed
                if (await canLaunchUrl(spotifyUrl)) {
                  // Launch the url which will open Spotify
                  launchUrl(spotifyUrl);
                }
              })
        ],
      ),
    );
  }
}
