import 'package:buscando_farmacias_chilenas/pantallas/pantalla_detalles.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../servicios/logica_principal.dart';
import '../modelos/farmacias_informacion.dart';
import '../modelos/historial.dart';
import '../servicios/servicio_base_datos.dart';

class PantallaFarmacias extends StatefulWidget {
  final List<Farmacias_informacion> farmaciasInfo;

  const PantallaFarmacias({super.key, required this.farmaciasInfo});

  @override
  PantallaFarmaciasState createState() => PantallaFarmaciasState();
}

class PantallaFarmaciasState extends State<PantallaFarmacias> {
  final LogicaPrincipal _logicaPrincipal = LogicaPrincipal();
  final ServicioBaseDatos _servicioBaseDatos = ServicioBaseDatos();
  final Logger logger = Logger();
  late Future<Map<String, Map<String, List<Farmacias_informacion>>>> _farmaciasAgrupadas;
  String? _selectedComuna;
  String? _selectedLocalidad;

  @override
  void initState() {
    super.initState();
    logger.d('Iniciando PantallaFarmacias');
    _farmaciasAgrupadas = _logicaPrincipal.cargarFarmaciasAgrupadas();
  }

  /// Guarda las farmacias visitadas en el historial.
  void _guardarEnHistorial(List<Farmacias_informacion> farmacias) async {
    final now = DateTime.now();
    final fecha = '${now.year}-${now.month}-${now.day}';
    final hora = '${now.hour}:${now.minute}';
    const accion = 'Visita a farmacias';
    final historial = Historial(
      id: 0,
      idFarmacia: farmacias.map((f) => f.localId).join(','), // Concatenar IDs de farmacias
      accion: accion,
      fecha: fecha,
      hora: hora,
      farmaciasInfo: farmacias,
    );
    logger.d('Guardando en historial: ${historial.toJson()}');
    await _servicioBaseDatos.insertarHistorial(historial);
    logger.d('Historial guardado');
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Construyendo PantallaFarmacias');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmacias de Turno en Chile'),
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3C8CE7), Color(0xFF00EAFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, Map<String, List<Farmacias_informacion>>>>(
          future: _farmaciasAgrupadas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              logger.d('Cargando datos de farmacias...');
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              logger.e('Error al cargar datos de farmacias: ${snapshot.error}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 64),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              logger.d('No hay farmacias de turno disponibles');
              return const Center(child: Text('No hay farmacias de turno disponibles'));
            } else {
              final comunas = snapshot.data!.keys.toList();
              logger.d('Comunas cargadas: $comunas');
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  if (_selectedComuna == null)
                    _buildComunasList(comunas),
                  if (_selectedComuna != null)
                    ..._buildLocalidadesList(snapshot.data![_selectedComuna!]!.keys.toList()),
                  if (_selectedComuna != null && _selectedLocalidad != null)
                    _buildFarmaciasList(snapshot.data![_selectedComuna!]![_selectedLocalidad!]!),
                  if (_selectedComuna != null)
                    _buildBackButton(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  /// Construye la lista de comunas disponibles.
  Widget _buildComunasList(List<String> comunas) {
    logger.d('Construyendo lista de comunas');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona una comuna:',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...comunas.map((comuna) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.location_city, color: Colors.blueAccent),
              title: Text(comuna, style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
              onTap: () {
                logger.d('Comuna seleccionada: $comuna');
                setState(() {
                  _selectedComuna = comuna;
                  _selectedLocalidad = null;
                });
              },
            ),
          );
        }),
      ],
    );
  }

  /// Construye la lista de localidades dentro de la comuna seleccionada.
  List<Widget> _buildLocalidadesList(List<String> localidades) {
    logger.d('Construyendo lista de localidades');
    return [
      ExpansionTile(
        title: Text(
          'Localidades en $_selectedComuna:',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: true,
        children: localidades.map((localidad) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListTile(
              leading: const Icon(Icons.place, color: Colors.green),
              title: Text(localidad, style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
              onTap: () {
                logger.d('Localidad seleccionada: $localidad');
                setState(() {
                  _selectedLocalidad = localidad;
                });
              },
            ),
          );
        }).toList(),
      ),
    ];
  }

  /// Construye la lista de farmacias dentro de la localidad seleccionada.
  Widget _buildFarmaciasList(List<Farmacias_informacion> farmacias) {
    logger.d('Construyendo lista de farmacias en $_selectedLocalidad');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Farmacias en $_selectedLocalidad:',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        ...farmacias.map((farmacia) {
          return _buildFarmaciaCard(farmacia);
        }),
      ],
    );
  }

  /// Construye la tarjeta de información de una farmacia.
  Widget _buildFarmaciaCard(Farmacias_informacion farmacia) {
    bool estaAbierta = _estaAbierta(farmacia);
    logger.d('Construyendo tarjeta para farmacia: ${farmacia.localNombre}, abierta: $estaAbierta');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: estaAbierta ? Colors.green[100] : Colors.red[100],
      child: ListTile(
        contentPadding: const EdgeInsets.all(15.0),
        leading: CircleAvatar(
          backgroundColor: estaAbierta ? Colors.green : Colors.red,
          radius: 30,
          child: const Icon(Icons.local_pharmacy, size: 30, color: Colors.white),
        ),
        title: Text(
          farmacia.localNombre,
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${farmacia.direccion}\n${farmacia.comunaNombre}',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Abre: ${farmacia.funcionamientoHoraApertura} - Cierra: ${farmacia.funcionamientoHoraCierre}',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          logger.d('Farmacia seleccionada: ${farmacia.localNombre}');
          _guardarEnHistorial([farmacia]); // Cambiado para aceptar una lista de farmacias
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaDetalles(farmacias: widget.farmaciasInfo, farmaciaSeleccionada: farmacia),
            ),
          );
        },
      ),
    );
  }

  /// Construye el botón de volver.
  Widget _buildBackButton() {
    logger.d('Construyendo botón de volver');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.arrow_back, color: Colors.blue),
        title: const Text('Volver', style: TextStyle(color: Colors.blue, fontSize: 18)),
        onTap: () {
          logger.d('Botón de volver presionado');
          setState(() {
            _selectedComuna = null;
            _selectedLocalidad = null;
          });
        },
      ),
    );
  }

  /// Verifica si una farmacia está abierta en función de la hora actual.
  bool _estaAbierta(Farmacias_informacion farmacia) {
    final ahora = TimeOfDay.now();
    final apertura = _parseHora(farmacia.funcionamientoHoraApertura);
    final cierre = _parseHora(farmacia.funcionamientoHoraCierre);

    if (apertura != null && cierre != null) {
      if (ahora.hour > apertura.hour || (ahora.hour == apertura.hour && ahora.minute >= apertura.minute)) {
        if (ahora.hour < cierre.hour || (ahora.hour == cierre.hour && ahora.minute <= cierre.minute)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Parsea un string en formato 'HH:mm' a un objeto TimeOfDay.
  TimeOfDay? _parseHora(String hora) {
    try {
      final partes = hora.split(':');
      final horas = int.parse(partes[0]);
      final minutos = int.parse(partes[1]);
      return TimeOfDay(hour: horas, minute: minutos);
    } catch (e) {
      logger.e('Error al parsear hora: $hora, error: $e');
      return null;
    }
  }
}
