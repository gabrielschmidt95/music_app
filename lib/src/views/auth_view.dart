import 'package:flutter/material.dart';
import 'artist_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Entrar'),
          onPressed: () {
            Navigator.pushReplacementNamed(context, ArtistListView.routeName);
          },
        ),
      ),
    );
  }
}
