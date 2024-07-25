import 'dart:convert';
import 'package:buscando_farmacias_chilenas/modelos/farmacias_informacion.dart';
import 'package:buscando_farmacias_chilenas/modelos/historial.dart';
import 'package:buscando_farmacias_chilenas/modelos/perfil_usuario.dart';
import 'package:buscando_farmacias_chilenas/servicios/servicio_api.dart';
import 'package:flutter/material.dart';
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
    if (_baseDatos != null && _baseDatos!.isOpen) return _baseDatos!;
    _baseDatos = await inicializarBaseDatos();
    return _baseDatos!;
  }

  Future<Database> inicializarBaseDatos() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'farmacias_chilenas.db');
    final db = await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    debugPrint('Base de datos inicializada en $path');
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
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
          id INTEGER PRIMARY KEY AUTOINCREMENT,
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
      debugPrint('Tablas creadas con éxito');
    } catch (e) {
      debugPrint('Error al crear las tablas: $e');
      rethrow;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE Historial ADD COLUMN farmaciasInfo TEXT');
      }
      debugPrint('Base de datos actualizada de la versión $oldVersion a $newVersion');
    } catch (e) {
      debugPrint('Error al actualizar la base de datos: $e');
      rethrow;
    }
  }

  Future<void> insertarFarmacia(Farmacias_informacion farmacia) async {
    try {
      final db = await baseDatos;
      await db.insert('Farmacias', farmacia.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Farmacia insertada: ${farmacia.localNombre}');
    } catch (e) {
      debugPrint('Error al insertar la farmacia: $e');
      rethrow;
    }
  }

  Future<List<Farmacias_informacion>> obtenerFarmacias() async {
    try {
      final db = await baseDatos;
      final List<Map<String, dynamic>> mapas = await db.query('Farmacias');
      debugPrint('Farmacias obtenidas: ${mapas.length}');
      return List.generate(mapas.length, (i) {
        return Farmacias_informacion.fromJson(mapas[i]);
      });
    } catch (e) {
      debugPrint('Error al obtener farmacias: $e');
      rethrow;
    }
  }

  Future<Farmacias_informacion?> obtenerFarmaciaPorId(String idFarmacia) async {
    try {
      final db = await baseDatos;
      final List<Map<String, dynamic>> mapas = await db.query('Farmacias', where: 'local_id = ?', whereArgs: [idFarmacia]);
      if (mapas.isNotEmpty) {
        debugPrint('Farmacia obtenida: ${mapas.first}');
        return Farmacias_informacion.fromJson(mapas.first);
      }
      return null;
    } catch (e) {
      debugPrint('Error al obtener la farmacia por ID: $e');
      rethrow;
    }
  }

  Future<void> cargarDatosIniciales() async {
    try {
      List<Farmacias_informacion> farmacias = await obtenerFarmacias();
      if (farmacias.isEmpty) {
        List<Farmacias_informacion> farmaciasDesdeApi = await ServicioApi().obtenerFarmacias();
        for (var farmacia in farmaciasDesdeApi) {
          await insertarFarmacia(farmacia);
        }
        debugPrint('Datos iniciales cargados desde la API');
      }
    } catch (e) {
      debugPrint('Error al cargar datos iniciales: $e');
      rethrow;
    }
  }

  Future<Map<String, Map<String, List<Farmacias_informacion>>>> cargarFarmaciasAgrupadas() async {
    try {
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
      debugPrint('Farmacias agrupadas cargadas con éxito');
      return farmaciasAgrupadas;
    } catch (e) {
      debugPrint('Error al cargar farmacias agrupadas: $e');
      rethrow;
    }
  }

  Future<List<Historial>> obtenerHistorial() async {
    try {
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
      debugPrint('Historial obtenido con éxito: $historial');
      return historial;
    } catch (e) {
      debugPrint('Error al obtener historial: $e');
      rethrow;
    }
  }

  Future<void> insertarHistorial(Historial historial) async {
    try {
      final db = await baseDatos;
      await db.insert('Historial', historial.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Historial insertado: ${historial.toJson()}');
    } catch (e) {
      debugPrint('Error al insertar historial: $e');
      rethrow;
    }
  }

  Future<void> eliminarHistorial(int id) async {
    try {
      final db = await baseDatos;
      await db.delete('Historial', where: 'id = ?', whereArgs: [id]);
      debugPrint('Historial eliminado: $id');
    } catch (e) {
      debugPrint('Error al eliminar historial: $e');
      rethrow;
    }
  }

  Future<void> eliminarTodoHistorial() async {
    try {
      final db = await baseDatos;
      await db.delete('Historial');
      debugPrint('Todo el historial eliminado');
    } catch (e) {
      debugPrint('Error al eliminar todo el historial: $e');
      rethrow;
    }
  }

  Future<List<PerfilUsuario>> obtenerPerfilesUsuario() async {
    try {
      final db = await baseDatos;
      final List<Map<String, dynamic>> mapas = await db.query('PerfilUsuario');
      debugPrint('Perfiles de usuario obtenidos: ${mapas.length}');
      return List.generate(mapas.length, (i) {
        return PerfilUsuario.fromJson(mapas[i]);
      });
    } catch (e) {
      debugPrint('Error al obtener perfiles de usuario: $e');
      rethrow;
    }
  }

  Future<void> insertarPerfilUsuario(PerfilUsuario perfil) async {
    try {
      final db = await baseDatos;
      await db.insert('PerfilUsuario', perfil.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Perfil de usuario insertado: ${perfil.nombre}');
    } catch (e) {
      debugPrint('Error al insertar perfil de usuario: $e');
      rethrow;
    }
  }

  Future<void> actualizarPerfilUsuario(PerfilUsuario perfil) async {
    try {
      final db = await baseDatos;
      await db.update('PerfilUsuario', perfil.toJson(), where: 'id = ?', whereArgs: [perfil.id]);
      debugPrint('Perfil de usuario actualizado: ${perfil.nombre}');
    } catch (e) {
      debugPrint('Error al actualizar perfil de usuario: $e');
      rethrow;
    }
  }

  Future<void> eliminarPerfilUsuario(int id) async {
    try {
      final db = await baseDatos;
      await db.delete('PerfilUsuario', where: 'id = ?', whereArgs: [id]);
      debugPrint('Perfil de usuario eliminado: $id');
    } catch (e) {
      debugPrint('Error al eliminar perfil de usuario: $e');
      rethrow;
    }
  }

  Future<void> eliminarBaseDeDatos() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, 'farmacias_chilenas.db');
      await deleteDatabase(path);
      debugPrint('Base de datos eliminada en $path');
    } catch (e) {
      debugPrint('Error al eliminar la base de datos: $e');
      rethrow;
    }
  }
}
