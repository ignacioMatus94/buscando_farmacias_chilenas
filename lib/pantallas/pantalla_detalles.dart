import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:share/share.dart';
import '../modelos/farmacias_informacion.dart';

var logger = Logger();

class PantallaDetalles extends StatelessWidget {
  final List<Farmacias_informacion> farmacias;
  final Farmacias_informacion farmaciaSeleccionada;

  const PantallaDetalles({super.key, required this.farmacias, required this.farmaciaSeleccionada});

  Future<void> _abrirEnGoogleMaps(BuildContext context, double latitud, double longitud) async {
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitud,$longitud");
    logger.d('Intentando abrir Google Maps con URL: $googleMapsUrl');

    if (await canLaunchUrl(googleMapsUrl)) {
      logger.d('Lanzando URL...');
      try {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        logger.d('Google Maps lanzado exitosamente.');
      } catch (e) {
        logger.e('Error al lanzar Google Maps: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al abrir Google Maps: $e')),
        );
      }
    } else {
      logger.w('No hay aplicación disponible para abrir Google Maps');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay aplicación disponible para abrir Google Maps.')),
      );
    }
  }

  void _compartirInformacion(BuildContext context) {
    final String info = 'Farmacia: ${farmaciaSeleccionada.localNombre}\n'
        'Dirección: ${farmaciaSeleccionada.direccion}\n'
        'Comuna: ${farmaciaSeleccionada.comunaNombre}\n'
        'Horario: ${farmaciaSeleccionada.funcionamientoHoraApertura} - ${farmaciaSeleccionada.funcionamientoHoraCierre}\n'
        'Teléfono: ${farmaciaSeleccionada.telefono}';
    Share.share(info);
  }

  Future<void> _llamarFarmacia(BuildContext context, String telefono) async {
    final Uri telUrl = Uri.parse('tel:$telefono');
    if (await canLaunchUrl(telUrl)) {
      await launchUrl(telUrl);
    } else {
      logger.w('No hay aplicación disponible para realizar la llamada');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay aplicación disponible para realizar la llamada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Construyendo UI con datos de: ${farmaciaSeleccionada.localNombre}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          farmaciaSeleccionada.localNombre,
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.blue[200], // Establecer el color de fondo azul
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Información de la Farmacia',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Divider(
                      color: Colors.blueAccent,
                      thickness: 2,
                      height: 20,
                      indent: 20,
                      endIndent: 20,
                    ),
                    _buildInfoRow('Dirección:', farmaciaSeleccionada.direccion),
                    _buildInfoRow('Comuna:', farmaciaSeleccionada.comunaNombre),
                    _buildInfoRow('Horario:', '${farmaciaSeleccionada.funcionamientoHoraApertura} - ${farmaciaSeleccionada.funcionamientoHoraCierre}'),
                    _buildInfoRow('Teléfono:', farmaciaSeleccionada.telefono),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        try {
                          _abrirEnGoogleMaps(context, double.parse(farmaciaSeleccionada.latitud), double.parse(farmaciaSeleccionada.longitud));
                        } catch (e) {
                          logger.e('Error al abrir Google Maps: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al abrir Google Maps: $e')),
                          );
                        }
                      },
                      icon: const Icon(Icons.navigation, color: Colors.white),
                      label: Text(
                        'Ver Ubicación en el Mapa',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => _compartirInformacion(context),
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: Text(
                        'Compartir Información',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => _llamarFarmacia(context, farmaciaSeleccionada.telefono),
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: Text(
                        'Llamar a la Farmacia',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    logger.d('Mostrando información - $label: $value');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,  // Ancho fijo para las etiquetas
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
