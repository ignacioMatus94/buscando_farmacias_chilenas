import 'dart:convert';
import 'package:buscando_farmacias_chilenas/modelos/farmacias_informacion.dart';
import 'package:buscando_farmacias_chilenas/modelos/historial.dart';
import 'package:buscando_farmacias_chilenas/modelos/perfil_usuario.dart';
import 'package:buscando_farmacias_chilenas/servicios/servicio_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ServicioBaseDatos {
  static final ServicioBaseDatos _instancia = ServicioBaseDatos._interno();
  static Database? _baseDatos;

  factory ServicioBaseDatos() {
    return _instancia;
  }

  ServicioBaseDatos._interno();

  Future<Database> get baseDatos async {
    if (_baseDatos != null) return _baseDatos!;
    _baseDatos = await _inicializarBaseDatos();
    return _baseDatos!;
  }

  Future<Database> _inicializarBaseDatos() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'glasses_in_all.db');
    await deleteDatabase(path);  // Elimina la base de datos existente para pruebas
    return openDatabase(
      path,
      version: 3, // Incrementa la versión aquí
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Farmacias (
        local_id TEXT PRIMARY KEY,
        local_nombre TEXT,
        comuna_nombre TEXT,
        localidad_nombre TEXT,
        local_direccion TEXT,
        funcionamiento_hora_apertura TEXT,
        funcionamiento_hora_cierre TEXT,
        funcionamiento_dia TEXT,
        local_telefono TEXT,
        local_lat TEXT,
        local_lng TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE PerfilUsuario (
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        correo TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE Historial (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idFarmacia TEXT,
        accion TEXT,
        fecha TEXT,
        hora TEXT,
        farmaciasInfo TEXT,
        FOREIGN KEY (idFarmacia) REFERENCES Farmacias (local_id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE Historial ADD COLUMN farmaciasInfo TEXT');
    }
    // Si se incrementa más versiones, agregar más condiciones if aquí
  }

  Future<void> insertarFarmacia(Farmacias_informacion farmacia) async {
    final db = await baseDatos;
    await db.insert('Farmacias', farmacia.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Farmacias_informacion>> obtenerFarmacias() async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> mapas = await db.query('Farmacias');
    return List.generate(mapas.length, (i) {
      return Farmacias_informacion.fromJson(mapas[i]);
    });
  }

  Future<Farmacias_informacion?> obtenerFarmaciaPorId(String idFarmacia) async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> mapas = await db.query('Farmacias', where: 'local_id = ?', whereArgs: [idFarmacia]);
    if (mapas.isNotEmpty) {
      return Farmacias_informacion.fromJson(mapas.first);
    }
    return null;
  }

  Future<void> cargarDatosIniciales() async {
    List<Farmacias_informacion> farmacias = await obtenerFarmacias();
    if (farmacias.isEmpty) {
      List<Farmacias_informacion> farmaciasDesdeApi = await ServicioApi().obtenerFarmacias();
      for (var farmacia in farmaciasDesdeApi) {
        await insertarFarmacia(farmacia);
      }
    }
  }

  Future<Map<String, Map<String, List<Farmacias_informacion>>>> cargarFarmaciasAgrupadas() async {
    await cargarDatosIniciales();
    final db = await baseDatos;
    final List<Map<String, dynamic>> mapas = await db.query('Farmacias');

    Map<String, Map<String, List<Farmacias_informacion>>> farmaciasAgrupadas = {};

    for (var map in mapas) {
      Farmacias_informacion farmacia = Farmacias_informacion.fromJson(map);
      String comuna = farmacia.comunaNombre.isEmpty ? "Desconocida" : farmacia.comunaNombre;
      String localidad = farmacia.localidadNombre.isEmpty ? "Desconocida" : farmacia.localidadNombre;

      if (!farmaciasAgrupadas.containsKey(comuna)) {
        farmaciasAgrupadas[comuna] = {};
      }
      if (!farmaciasAgrupadas[comuna]!.containsKey(localidad)) {
        farmaciasAgrupadas[comuna]![localidad] = [];
      }
      farmaciasAgrupadas[comuna]![localidad]!.add(farmacia);
    }

    return farmaciasAgrupadas;
  }

  Future<List<Historial>> obtenerHistorial() async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> mapas = await db.query('Historial');
    List<Historial> historial = [];
    for (var mapa in mapas) {
      final farmacias = (jsonDecode(mapa['farmaciasInfo']) as List)
          .map((data) => Farmacias_informacion.fromJson(data))
          .toList();
      final Historial itemHistorial = Historial.fromJson(mapa);
      historial.add(itemHistorial.copyWith(farmaciasInfo: farmacias));
    }
    return historial;
  }

  Future<void> insertarHistorial(Historial historial) async {
    final db = await baseDatos;
    await db.insert('Historial', historial.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> eliminarHistorial(int id) async {
    final db = await baseDatos;
    await db.delete('Historial', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> eliminarTodoHistorial() async {
    final db = await baseDatos;
    await db.delete('Historial');
  }

  Future<void> insertarHistorialPrueba() async {
    final db = await baseDatos;
    final farmaciaPrueba = Farmacias_informacion(
      localId: '1',
      localNombre: 'Farmacia Prueba',
      comunaNombre: 'Comuna Prueba',
      localidadNombre: 'Localidad Prueba',
      direccion: 'Dirección Prueba',
      funcionamientoHoraApertura: '08:00',
      funcionamientoHoraCierre: '20:00',
      funcionamientoDia: 'Lunes a Domingo',
      telefono: '123456789',
      latitud: '-33.456',
      longitud: '-70.648',
    );

    await db.insert('Farmacias', farmaciaPrueba.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);

    await db.insert('Historial', {
      'idFarmacia': '1',
      'accion': 'Búsqueda de prueba',
      'fecha': '2023-07-12',
      'hora': '14:00',
      'farmaciasInfo': jsonEncode([farmaciaPrueba.toJson()]) // Asegúrate de que es una lista de farmacias
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<PerfilUsuario?> obtenerPerfilUsuario() async {
    final db = await baseDatos;
    final List<Map<String, dynamic>> mapas = await db.query('PerfilUsuario', limit: 1);
    if (mapas.isNotEmpty) {
      return PerfilUsuario.fromJson(mapas.first);
    }
    return null;
  }

  Future<void> eliminarBaseDeDatos() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'glasses_in_all.db');
    await deleteDatabase(path);
  }
}
