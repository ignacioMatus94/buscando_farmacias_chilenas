import 'package:flutter/material.dart';
import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';

class PantallaAbout extends StatelessWidget {
  const PantallaAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: CustomColors.primaryColor,
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomColors.backgroundColor, CustomColors.backgroundLight],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Equipo de Desarrollo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1.0),
                  const SizedBox(height: 20),
                  const Text(
                    'Este proyecto fue desarrollado por:',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: CustomColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Ignacio Matus',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1.0),
                  const SizedBox(height: 20),
                  const Text(
                    'Agradecimientos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Agradezco su apoyo y espero que disfruten usando mi aplicación.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const Divider(thickness: 1.0),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Versión 1.0.0',
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(height: 10),
                        Icon(
                          Icons.local_pharmacy,
                          size: 50,
                          color: CustomColors.primaryColor,
                        ),
                      ],
                    ),
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
