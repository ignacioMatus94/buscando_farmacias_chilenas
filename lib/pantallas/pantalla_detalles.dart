import 'package:flutter/material.dart';
import '../modelos/farmacias_informacion.dart';

class PantallaDetalles extends StatelessWidget {
  final List<Farmacias_informacion> farmacias; // Cambiado de Farmacias_informacion a List<Farmacias_informacion>

  const PantallaDetalles({Key? key, required this.farmacias, required Farmacias_informacion farmacia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Farmacia'),
      ),
      body: ListView.builder(
        itemCount: farmacias.length,
        itemBuilder: (context, index) {
          final farmacia = farmacias[index];
          return ListTile(
            title: Text(farmacia.localNombre),
            subtitle: Text(farmacia.direccion),
          );
        },
      ),
    );
  }
}
