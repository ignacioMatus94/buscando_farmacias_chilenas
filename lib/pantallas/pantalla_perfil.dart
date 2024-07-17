import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import '../modelos/perfil_usuario.dart';
import '../servicios/servicio_base_datos.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  _PantallaPerfilState createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  final ServicioBaseDatos _servicioBaseDatos = ServicioBaseDatos();
  PerfilUsuario? _perfilUsuario;

  @override
  void initState() {
    super.initState();
    debugPrint('PantallaPerfil initState');
    _cargarPerfilUsuario();
  }

  Future<void> _cargarPerfilUsuario() async {
    try {
      debugPrint('Cargando perfil de usuario...');
      final perfil = await _servicioBaseDatos.obtenerPerfilUsuario();
      debugPrint('Perfil obtenido: ${perfil?.nombre}, ${perfil?.correo}');
      setState(() {
        _perfilUsuario = perfil;
      });
    } catch (e) {
      debugPrint('Error al obtener el perfil de usuario: $e');
      // Manejar error
    }
  }

  Widget _buildPerfilCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${_perfilUsuario!.nombre}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Correo: ${_perfilUsuario!.correo}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Funcionalidad de edición de perfil
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar Perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Construyendo PantallaPerfil...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Usuario'),
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
        child: _perfilUsuario == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildPerfilCard(),
              ),
      ),
    );
  }
}
