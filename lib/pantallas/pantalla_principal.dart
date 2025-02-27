import 'package:flutter/material.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_historial.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_perfil.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_farmacias.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_farmacias_cercanas.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_configuracion.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  PantallaPrincipalState createState() => PantallaPrincipalState();
}

class PantallaPrincipalState extends State<PantallaPrincipal> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    debugPrint('PantallaPrincipal initState');
    _audioPlayer = AudioPlayer();
    _playMusic();
  }

  void _playMusic() async {
    await _audioPlayer.play(AssetSource('music/musica_fondo.mp3'), volume: 0.5, mode: PlayerMode.mediaPlayer);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget _buildCard(String titulo, IconData icono, Widget pantallaDestino) {
    return Expanded(
      child: Card(
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
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icono, size: 35, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
        backgroundColor: CustomColors.primaryColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [CustomColors.primaryColor, CustomColors.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4.0,
        shadowColor: Colors.black54,
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomColors.primaryColor, CustomColors.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: <Widget>[
                    _buildCard('Inicio', Icons.home, const PantallaPrincipal()),
                    _buildCard('Historial', Icons.history, const PantallaHistorial()),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    _buildCard('Perfil', Icons.person, const PantallaPerfil()),
                    _buildCard('Turno', Icons.local_pharmacy, const PantallaFarmacias(farmaciasInfo: [],)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    _buildCard('Cercanas', Icons.location_on, const PantallaFarmaciasCercanas()),
                    _buildCard('Configuración', Icons.settings, const PantallaConfiguracion()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
