import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../modelos/farmacias_informacion.dart';

class PantallaDetalles extends StatelessWidget {
  final List<Farmacias_informacion> farmacias;

  const PantallaDetalles({super.key, required this.farmacias, required Farmacias_informacion farmacia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Farmacia'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3C8CE7), Color(0xFF00EAFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: farmacias.length,
        itemBuilder: (context, index) {
          final farmacia = farmacias[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        FontAwesomeIcons.pills,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      farmacia.localNombre,
                      style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      farmacia.direccion,
                      style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_city, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        'Comuna: ${farmacia.comunaNombre}',
                        style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.green),
                      const SizedBox(width: 10),
                      Text(
                        'Localidad: ${farmacia.localidadNombre}',
                        style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.orange),
                      const SizedBox(width: 10),
                      Text(
                        'Teléfono: ${farmacia.telefono}',
                        style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.red),
                      const SizedBox(width: 10),
                      Text(
                        'Horario: ${farmacia.funcionamientoHoraApertura} - ${farmacia.funcionamientoHoraCierre}',
                        style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
