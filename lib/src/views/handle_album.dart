import 'package:flutter/material.dart';
import '../models/album.dart';
import 'package:intl/intl.dart';
import '../utils/api.dart';

class HandleAlbumView extends StatefulWidget {
  final Object album;
  const HandleAlbumView({super.key, required this.album});

  static const routeName = '/handle_album';

  @override
  State<HandleAlbumView> createState() => _HandleAlbumViewState();
}

class _HandleAlbumViewState extends State<HandleAlbumView> {
  final api = API();
  Map<String, dynamic> _resultAlbum = {};

  @override
  Widget build(BuildContext context) {
    Album album = widget.album as Album;
    final formKey = GlobalKey<FormState>();

    if (_resultAlbum.isEmpty) {
      _resultAlbum = album.toJson();
    }

    bool isNumeric(String s) {
      if (s == "") {
        return false;
    }
      return double.tryParse(s) != null;
    }

    validateYear(String value) {
      if (value.isEmpty || !isNumeric(value)) {
        return 'Por favor insira um ano';
      }
      if (int.parse(value) > DateTime.now().year || int.parse(value) < 1900) {
        return 'Insira um ano válido';
      }
      return null;
    }

    Widget textField(String label, String key, {bool required = true}) {
      String value = _resultAlbum[key];

      if (value == "null" || value == "0") {
        value = "";
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
          ),
          validator: (value) {
            if (value!.isEmpty && required) {
              return 'Por favor insira um $label';
            }
            return null;
          },
          onChanged: (value) => _resultAlbum[key] = value,
        ),
      );
    }

    Widget discogsField() {
      String value;
      value = album.discogs.id.toString();

      if (value == "null" || value == "0") {
        value = "";
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: TextEditingController(text: value),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Discogs ID",
          ),
          onChanged: (value) => _resultAlbum["discogs"]["id"] = value,
        ),
      );
    }

    Widget numberField(String label, String key) {
      int value = _resultAlbum[key];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller:
              TextEditingController(text: value == 0 ? "" : value.toString()),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            return validateYear(value!);
          },
          onChanged: (value) =>
              _resultAlbum[key] = value != "" ? int.parse(value) : 0,
        ),
      );
    }

    Widget dateField(String label, String value) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            controller: TextEditingController(text: _resultAlbum["purchase"]),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label,
            ),
            keyboardType: TextInputType.datetime,
            validator: (value) {
              return null;
            },
            readOnly: true,
            onTap: () async {
              final pickedDate = (await showDatePicker(
                locale: const Locale("pt", "BR"),
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2015),
                lastDate: DateTime.now(),
              ));

              if (pickedDate == null) {
                return;
              }

              String formattedDate =
                  DateFormat('dd/MM/yyyy').format(pickedDate);

              _resultAlbum["purchase"] = formattedDate;
              setState(() {
                album = Album.fromJSON(_resultAlbum);
              });
            }),
      );
    }

    void returnMessage(String message) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.pop(context, "updated");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(album.id == "" ? "Novo Album" : "Editar Album"),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  album = Album.fromJSON(_resultAlbum);
                  var result = await api.handleAlbum(album);
                  if (result == "1") {
                    result = "Album atualizado com sucesso";
                  }
                  returnMessage(result);
                }
              },
            ),
          ],
        ),
        body: // add form here to add an album
            SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                textField("Titulo", "title"),
                textField("Artista", "artist"),
                numberField("Ano de Lançamento", "releaseYear"),
                textField("Media", "media"),
                numberField("Ano da Edição", "editionYear"),
                dateField("Compra", "purchase"),
                textField("Origem", "origin"),
                textField("Código de Barras", "barcode", required: false),
                textField("Matriz", "matriz", required: false),
                textField("Lote", "lote",required: false),
                textField("IFPI Mastering", "ifpiMastering",required: false),
                textField("IFPI Mould", "ifpiMould",required: false),
                discogsField(),
              ],
            ),
          ),
        ));
  }
}
