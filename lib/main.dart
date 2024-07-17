import 'package:buscando_farmacias_chilenas/pantallas/pantalla_splash.dart';
import 'package:flutter/material.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_bienvenida.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscando Farmacias Chilenas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PantallaSplash(),
    );
  }
}
