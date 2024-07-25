import 'package:buscando_farmacias_chilenas/pantallas/pantalla_detalles.dart';
import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../modelos/farmacias_informacion.dart';
import '../modelos/historial.dart';
import '../servicios/servicio_base_datos.dart';

class PantallaHistorial extends StatefulWidget {
  final List<Farmacias_informacion>? farmacias;

  const PantallaHistorial({super.key, this.farmacias});

  @override
  PantallaHistorialState createState() => PantallaHistorialState();
}

class PantallaHistorialState extends State<PantallaHistorial> {
  final ServicioBaseDatos _servicioBaseDatos = ServicioBaseDatos();
  final Logger logger = Logger();
  late Future<List<Historial>> _futureHistorial;
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    logger.d('Iniciando PantallaHistorial');
    _futureHistorial = _obtenerHistorial();
    if (widget.farmacias != null && widget.farmacias!.isNotEmpty) {
      _guardarEnHistorial(widget.farmacias!);
    }
  }

  /// Obtiene el historial de visitas a farmacias desde la base de datos.
  Future<List<Historial>> _obtenerHistorial() async {
    final historial = await _servicioBaseDatos.obtenerHistorial();
    logger.d('Historial recuperado: $historial');
    return historial;
  }

  /// Guarda las farmacias visitadas en el historial.
  Future<void> _guardarEnHistorial(List<Farmacias_informacion> farmacias) async {
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
    setState(() {
      _futureHistorial = _obtenerHistorial();
    });
  }

  /// Filtra el historial según el filtro seleccionado.
  List<Historial> _filtrarHistorial(List<Historial> historial) {
    if (_selectedFilter == 'Todos') {
      return historial;
    }

    return historial.where((accion) {
      final matchesFilter = _selectedFilter == 'Todos' || accion.accion == _selectedFilter;
      return matchesFilter;
    }).toList();
  }

  /// Construye una tarjeta para cada entrada en el historial.
  Widget _buildHistorialCard(Historial accion) {
    final farmacias = accion.farmaciasInfo;
    logger.d('Construyendo tarjeta de historial para la acción: ${accion.accion}');
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: const Icon(Icons.history, size: 40, color: CustomColors.primaryColor),
          title: Text(
            '${farmacias.length}',
            style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.primaryColor),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fecha: ${accion.fecha}',
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
              ),
              Text(
                'Hora: ${accion.hora}',
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
              ),
              ...farmacias.map((farmacia) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      logger.d('Farmacia seleccionada: ${farmacia.localNombre}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PantallaDetalles(farmacias: farmacias, farmaciaSeleccionada: farmacia)),
                      );
                    },
                    child: Text(
                      'Farmacia: ${farmacia.localNombre}',
                      style: GoogleFonts.roboto(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                  Text(
                    'Dirección: ${farmacia.direccion}',
                    style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Comuna: ${farmacia.comunaNombre}',
                    style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Teléfono: ${farmacia.telefono}',
                    style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () async {
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Confirmar Eliminación',
                    style: TextStyle(color: Colors.black),
                  ),
                  content: const Text(
                    '¿Estás seguro de que quieres eliminar este elemento del historial?',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
              if (confirmDelete == true) {
                logger.d('Eliminando historial: ${accion.id}');
                await _servicioBaseDatos.eliminarHistorial(accion.id);
                setState(() {
                  _futureHistorial = _obtenerHistorial();
                });
              }
            },
          ),
          onTap: () {
            if (farmacias.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PantallaDetalles(farmacias: farmacias, farmaciaSeleccionada: farmacias.first)),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Construyendo PantallaHistorial');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Historial de Búsquedas'),
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
        child: FutureBuilder<List<Historial>>(
          future: _futureHistorial,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              logger.d('Cargando historial...');
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              logger.e('Error al cargar historial: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              logger.d('No hay acciones en el historial');
              return const Center(
                child: Text(
                  'No hay acciones en el historial',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              final historial = _filtrarHistorial(snapshot.data!);
              logger.d('Historial filtrado: $historial');
              return ListView.separated(
                padding: const EdgeInsets.all(10.0),
                itemCount: historial.length,
                itemBuilder: (context, index) {
                  final accion = historial[index];
                  return _buildHistorialCard(accion);
                },
                separatorBuilder: (context, index) => const Divider(color: Colors.white),
              );
            }
          },
        ),
      ),
    );
  }
}
