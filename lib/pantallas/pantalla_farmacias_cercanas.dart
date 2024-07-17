import 'package:buscando_farmacias_chilenas/modelos/farmacias_informacion.dart';
import 'package:buscando_farmacias_chilenas/servicios/servicio_localizacion.dart';
import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class PantallaFarmaciasCercanas extends StatefulWidget {
  const PantallaFarmaciasCercanas({super.key});

  @override
  _PantallaFarmaciasCercanasState createState() => _PantallaFarmaciasCercanasState();
}

class _PantallaFarmaciasCercanasState extends State<PantallaFarmaciasCercanas> {
  final ServicioLocalizacion _servicioLocalizacion = ServicioLocalizacion();
  late Future<List<Farmacias_informacion>> _farmaciasCercanas;

  @override
  void initState() {
    super.initState();
    debugPrint('Iniciando detección de farmacias cercanas...');
    _farmaciasCercanas = _cargarFarmaciasCercanas();
  }

  Future<List<Farmacias_informacion>> _cargarFarmaciasCercanas() async {
    try {
      await _servicioLocalizacion.insertarFarmaciasDePrueba();
      return await _servicioLocalizacion.farmaciasCercanas();
    } catch (e) {
      debugPrint('Error al cargar farmacias cercanas: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmacias Cercanas'),
      ),
      drawer: const CustomDrawer(),  // Añade el Drawer aquí
      body: FutureBuilder<List<Farmacias_informacion>>(
        future: _farmaciasCercanas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('Esperando resultados de farmacias cercanas...');
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            debugPrint('Error al obtener farmacias cercanas: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            debugPrint('No se encontraron farmacias cercanas.');
            return const Center(child: Text('No se encontraron farmacias cercanas.'));
          } else {
            final farmacias = snapshot.data!;
            debugPrint('Farmacias cercanas encontradas: ${farmacias.length}');
            return ListView.builder(
              itemCount: farmacias.length,
              itemBuilder: (context, index) {
                final farmacia = farmacias[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15.0),
                    leading: const CircleAvatar(
                      backgroundColor: CustomColors.primaryColor,
                      child: Icon(Icons.local_pharmacy, size: 30, color: Colors.white),
                      radius: 30,
                    ),
                    title: Text(
                      farmacia.localNombre,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${farmacia.direccion}\n${farmacia.comunaNombre}'),
                    onTap: () {
                      debugPrint('Tapped on farmacia: ${farmacia.localNombre}');
                      // Navegar a detalles de la farmacia si es necesario
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
