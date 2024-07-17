import 'package:flutter/material.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_principal.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_historial.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_perfil.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_farmacias.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_farmacias_cercanas.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_bienvenida.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_about.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaHistorial()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaPerfil()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_pharmacy),
            title: const Text('Turno'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaFarmacias()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Cercanas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaFarmaciasCercanas()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Bienvenida'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaBienvenida()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaAbout()),
              );
            },
          ),
        ],
      ),
    );
  }
}
