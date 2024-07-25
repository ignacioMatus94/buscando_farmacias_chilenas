import 'package:buscando_farmacias_chilenas/pantallas/pantalla_about.dart';
import 'package:buscando_farmacias_chilenas/pantallas/pantalla_perfil.dart';
import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PantallaConfiguracion extends StatefulWidget {
  const PantallaConfiguracion({super.key});

  @override
  PantallaConfiguracionState createState() => PantallaConfiguracionState();
}

class PantallaConfiguracionState extends State<PantallaConfiguracion> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Construyendo PantallaConfiguracion...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        centerTitle: true,
        backgroundColor: CustomColors.primaryColor,
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
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Configuración',
                    style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold, color: CustomColors.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Gestionar Cuenta'),
                    onTap: () {
                      debugPrint('Gestionar Cuenta seleccionada');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PantallaPerfil()),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Acerca de'),
                    onTap: () {
                      debugPrint('Acerca de seleccionada');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PantallaAbout()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
