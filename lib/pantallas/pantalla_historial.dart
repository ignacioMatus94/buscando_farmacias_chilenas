import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../modelos/historial.dart';
import '../modelos/farmacias_informacion.dart';
import '../servicios/servicio_base_datos.dart';
import 'pantalla_detalles.dart';

class PantallaHistorial extends StatefulWidget {
  final List<Farmacias_informacion>? farmacias;

  const PantallaHistorial({super.key, this.farmacias});

  @override
  PantallaHistorialState createState() => PantallaHistorialState();
}

class PantallaHistorialState extends State<PantallaHistorial> {
  final ServicioBaseDatos _servicioBaseDatos = ServicioBaseDatos();
  late Future<List<Historial>> _futureHistorial;
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _futureHistorial = _obtenerHistorial();
    if (widget.farmacias != null && widget.farmacias!.isNotEmpty) {
      _guardarEnHistorial(widget.farmacias!);
    }
  }

  Future<List<Historial>> _obtenerHistorial() async {
    final historial = await _servicioBaseDatos.obtenerHistorial();
    return historial;
  }

  Future<void> _guardarEnHistorial(List<Farmacias_informacion> farmacias) async {
    final now = DateTime.now();
    final fecha = '${now.year}-${now.month}-${now.day}';
    final hora = '${now.hour}:${now.minute}';
    const accion = 'Visita a farmacias';
    final historial = Historial(
      id: 0,
      idFarmacia: farmacias.first.localId,
      accion: accion,
      fecha: fecha,
      hora: hora,
      farmaciasInfo: farmacias,
    );
    await _servicioBaseDatos.insertarHistorial(historial);
    setState(() {
      _futureHistorial = _obtenerHistorial();
    });
  }

  List<Historial> _filtrarHistorial(List<Historial> historial) {
    if (_selectedFilter == 'Todos') {
      return historial;
    }

    return historial.where((accion) {
      final matchesFilter = _selectedFilter == 'Todos' || accion.accion == _selectedFilter;
      return matchesFilter;
    }).toList();
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Todos'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Todos';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Consulta'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Consulta';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistorialCard(Historial accion) {
    final farmacias = accion.farmaciasInfo;
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
            'Visita a ${farmacias.length} farmacias',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PantallaDetalles(farmacia: farmacia, farmacias: farmacias)),
                      );
                    },
                    child: Text(
                      'Farmacia: ${farmacia.localNombre}',
                      style: GoogleFonts.roboto(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                  Text(
                    'Dirección: ${farmacia.direccion}',
                    style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Text(
                    'Comuna: ${farmacia.comunaNombre}',
                    style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Text(
                    'Teléfono: ${farmacia.telefono}',
                    style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
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
                  title: const Text('Confirmar Eliminación'),
                  content: const Text('¿Estás seguro de que quieres eliminar este elemento del historial?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
              if (confirmDelete == true) {
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
                MaterialPageRoute(builder: (context) => PantallaDetalles(farmacia: farmacias.first, farmacias: farmacias)),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterOptions,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: () async {
              bool? confirmDeleteAll = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar Eliminación'),
                  content: const Text('¿Estás seguro de que quieres eliminar todo el historial?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Eliminar Todo', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
              if (confirmDeleteAll == true) {
                await _servicioBaseDatos.eliminarTodoHistorial();
                setState(() {
                  _futureHistorial = _obtenerHistorial();
                });
              }
            },
          ),
        ],
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
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No hay acciones en el historial',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              final historial = _filtrarHistorial(snapshot.data!);
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
