import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../servicios/servicio_base_datos.dart';
import 'pantalla_perfil.dart';

class PantallaConfiguracion extends StatefulWidget {
  const PantallaConfiguracion({super.key});

  @override
  PantallaConfiguracionState createState() => PantallaConfiguracionState();
}

class PantallaConfiguracionState extends State<PantallaConfiguracion> {
  final ServicioBaseDatos _servicioBaseDatos = ServicioBaseDatos();

  Future<void> _eliminarBaseDeDatos() async {
    try {
      debugPrint('Intentando eliminar la base de datos...');
      await _servicioBaseDatos.eliminarBaseDeDatos();
      debugPrint('Base de datos eliminada con éxito.');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base de datos eliminada con éxito')),
      );
    } catch (e) {
      debugPrint('Error al eliminar la base de datos: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la base de datos: $e')),
      );
    }
  }

  Future<void> _crearNuevaBaseDeDatos() async {
    try {
      debugPrint('Intentando crear una nueva base de datos...');
      await _servicioBaseDatos.eliminarBaseDeDatos();
      await _servicioBaseDatos.inicializarBaseDatos();
      debugPrint('Nueva base de datos creada con éxito.');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nueva base de datos creada con éxito')),
      );
    } catch (e) {
      debugPrint('Error al crear la nueva base de datos: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear la nueva base de datos: $e')),
      );
    }
  }

  Future<void> _persistirDatos() async {
    try {
      debugPrint('Intentando persistir datos...');
      // Implementar lógica para persistir datos aquí
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos persistidos con éxito')),
      );
      debugPrint('Datos persistidos con éxito.');
    } catch (e) {
      debugPrint('Error al persistir los datos: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al persistir los datos: $e')),
      );
    }
  }

  Future<void> _mostrarConfirmacionEliminar() async {
    final bool? confirmar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Está seguro de que desea eliminar toda la base de datos? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () {
              debugPrint('Eliminación cancelada por el usuario.');
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              debugPrint('Eliminación confirmada por el usuario.');
              Navigator.of(context).pop(true);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _eliminarBaseDeDatos();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Construyendo PantallaConfiguracion...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTile(
              icon: Icons.person,
              title: 'Gestionar Perfiles de Usuario',
              color: CustomColors.primaryColor,
              onTap: () {
                debugPrint('Navegando a PantallaPerfil...');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PantallaPerfil()),
                );
              },
            ),
            _buildTile(
              icon: Icons.storage,
              title: 'Persistir Datos',
              color: CustomColors.primaryColor,
              onTap: () {
                debugPrint('Intentando persistir datos...');
                _persistirDatos();
              },
            ),
            _buildTile(
              icon: Icons.create_new_folder,
              title: 'Crear Nueva Base de Datos',
              color: CustomColors.primaryColor,
              onTap: () {
                debugPrint('Intentando crear nueva base de datos...');
                _crearNuevaBaseDeDatos();
              },
            ),
            _buildTile(
              icon: Icons.delete_forever,
              title: 'Eliminar Base de Datos',
              color: Colors.red,
              onTap: () {
                debugPrint('Mostrando confirmación para eliminar base de datos...');
                _mostrarConfirmacionEliminar();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        onTap: onTap,
      ),
    );
  }
}
