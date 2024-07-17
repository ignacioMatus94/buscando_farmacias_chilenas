import 'package:buscando_farmacias_chilenas/pantallas/pantalla_detalles.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late Future<Map<String, Map<String, List<Farmacias_informacion>>>> _farmaciasAgrupadas;
  String? _selectedComuna;
  String? _selectedLocalidad;

  @override
  void initState() {
    super.initState();
    _farmaciasAgrupadas = _logicaPrincipal.cargarFarmaciasAgrupadas();
  }

  void _guardarEnHistorial(Farmacias_informacion farmacia) async {
    final now = DateTime.now();
    final fecha = '${now.year}-${now.month}-${now.day}';
    final hora = '${now.hour}:${now.minute}';
    final accion = 'Visita a farmacia';
    final historial = Historial(
      id: 0,
      idFarmacia: farmacia.localId,
      accion: accion,
      fecha: fecha,
      hora: hora,
      farmaciasInfo: [farmacia],
    );
    await _servicioBaseDatos.insertarHistorial(historial);
  }

  @override
  Widget build(BuildContext context) {
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
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
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
              return const Center(child: Text('No hay farmacias de turno disponibles'));
            } else {
              final comunas = snapshot.data!.keys.toList();
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

  Widget _buildComunasList(List<String> comunas) {
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
                setState(() {
                  _selectedComuna = comuna;
                  _selectedLocalidad = null;
                });
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  List<Widget> _buildLocalidadesList(List<String> localidades) {
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

  Widget _buildFarmaciasList(List<Farmacias_informacion> farmacias) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Farmacias en $_selectedLocalidad:',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...farmacias.map((farmacia) {
          return _buildFarmaciaCard(farmacia);
        }).toList(),
      ],
    );
  }

  Widget _buildFarmaciaCard(Farmacias_informacion farmacia) {
    bool estaAbierta = _estaAbierta(farmacia);
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
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Abre: ${farmacia.funcionamientoHoraApertura} - Cierra: ${farmacia.funcionamientoHoraCierre}',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          _guardarEnHistorial(farmacia);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaDetalles(farmacia: farmacia, farmacias: const []),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton() {
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
          setState(() {
            _selectedComuna = null;
            _selectedLocalidad = null;
          });
        },
      ),
    );
  }

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

  TimeOfDay? _parseHora(String hora) {
    try {
      final partes = hora.split(':');
      final horas = int.parse(partes[0]);
      final minutos = int.parse(partes[1]);
      return TimeOfDay(hour: horas, minute: minutos);
    } catch (e) {
      return null;
    }
  }
}
