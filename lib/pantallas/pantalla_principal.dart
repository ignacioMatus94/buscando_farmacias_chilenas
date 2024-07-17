import 'package:flutter/material.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_historial.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_perfil.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_farmacias.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_farmacias_cercanas.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  PantallaPrincipalState createState() => PantallaPrincipalState();
}

class PantallaPrincipalState extends State<PantallaPrincipal> {
  @override
  void initState() {
    super.initState();
    debugPrint('PantallaPrincipal initState');
  }

  Widget _buildCard(String titulo, IconData icono, Widget pantallaDestino) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: InkWell(
        onTap: () {
          debugPrint('Navegando a $titulo');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pantallaDestino),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 70, // Tamaño ajustado
                height: 70, // Tamaño ajustado
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, size: 35, color: Colors.blue), // Tamaño del icono ajustado
              ),
              const SizedBox(height: 20),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 22, // Tamaño de texto ajustado
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Construyendo PantallaPrincipal...');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Farmacias Chile'),
      ),
      drawer: const CustomDrawer(),
      body: Container(
        color: Colors.grey[100], // Color de fondo suave
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1, // Valor ajustado para hacer las cartas cuadradas
            children: <Widget>[
              _buildCard('Inicio', Icons.home, const PantallaPrincipal()),
              _buildCard('Historial', Icons.history, const PantallaHistorial()),
              _buildCard('Perfil', Icons.person, const PantallaPerfil()),
              _buildCard('Turno', Icons.local_pharmacy, const PantallaFarmacias(farmaciasInfo: [],)),
              _buildCard('Cercanas', Icons.location_on, const PantallaFarmaciasCercanas()),
            ],
          ),
        ),
      ),
    );
  }
}
