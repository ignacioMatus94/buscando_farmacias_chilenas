import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';
import 'package:buscando_farmacias_chilenas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import '../modelos/perfil_usuario.dart';
import '../servicios/servicio_base_datos.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  PantallaPerfilState createState() => PantallaPerfilState();
}

class PantallaPerfilState extends State<PantallaPerfil> {
  final ServicioBaseDatos _servicioBaseDatos = ServicioBaseDatos();
  List<PerfilUsuario> _perfilesUsuario = [];
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  PerfilUsuario? _perfilSeleccionado;
  bool _mostrarFormulario = false;

  @override
  void initState() {
    super.initState();
    _cargarPerfilesUsuario();
  }

  Future<void> _cargarPerfilesUsuario() async {
    final perfiles = await _servicioBaseDatos.obtenerPerfilesUsuario();
    if (!mounted) return;
    setState(() {
      _perfilesUsuario = perfiles;
    });
  }

  Future<void> _guardarPerfilUsuario() async {
    if (_formKey.currentState!.validate()) {
      final nuevoPerfil = PerfilUsuario(
        id: _perfilSeleccionado?.id ?? 0,
        nombre: _nombreController.text,
        correo: _correoController.text,
      );
      if (_perfilSeleccionado != null) {
        await _servicioBaseDatos.actualizarPerfilUsuario(nuevoPerfil);
      } else {
        await _servicioBaseDatos.insertarPerfilUsuario(nuevoPerfil);
      }
      await _cargarPerfilesUsuario();
      if (!mounted) return;
      setState(() {
        _perfilSeleccionado = null;
        _nombreController.clear();
        _correoController.clear();
        _mostrarFormulario = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil guardado con éxito')),
      );
    }
  }

  Future<void> _eliminarPerfilUsuario(int id) async {
    await _servicioBaseDatos.eliminarPerfilUsuario(id);
    await _cargarPerfilesUsuario();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil eliminado con éxito')),
    );
  }

  Widget _buildFormularioPerfil() {
    return Visibility(
      visible: _mostrarFormulario || _perfilesUsuario.isEmpty,
      child: Form(
        key: _formKey,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _correoController,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _guardarPerfilUsuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: const Icon(Icons.save, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerfilCard(PerfilUsuario perfil) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 30, color: CustomColors.primaryColor),
                const SizedBox(width: 10),
                Text(
                  perfil.nombre,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email, size: 30, color: CustomColors.primaryColor),
                const SizedBox(width: 10),
                Text(
                  perfil.correo,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 24),
                    onPressed: () {
                      setState(() {
                        _perfilSeleccionado = perfil;
                        _nombreController.text = perfil.nombre;
                        _correoController.text = perfil.correo;
                        _mostrarFormulario = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 24),
                    onPressed: () async {
                      await _eliminarPerfilUsuario(perfil.id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _perfilesUsuario.length,
                  itemBuilder: (context, index) {
                    return _buildPerfilCard(_perfilesUsuario[index]);
                  },
                ),
              ),
              _buildFormularioPerfil(),
            ],
          ),
        ),
      ),
    );
  }
}
