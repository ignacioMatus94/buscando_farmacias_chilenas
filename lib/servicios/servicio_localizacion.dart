import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:buscando_farmacias_chilenas/modelos/farmacias_informacion.dart';
import 'package:buscando_farmacias_chilenas/servicios/servicio_base_datos.dart';
import 'dart:math';

class ServicioLocalizacion {
  final ServicioBaseDatos _servicioBaseDatos = ServicioBaseDatos();

  Future<Position> _detectarPosicion() async {
    bool serviceEnabled;
    LocationPermission permission;

    debugPrint('Verificando si el servicio de localización está habilitado...');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('El servicio de localización está deshabilitado.');
    }

    debugPrint('Verificando permisos de localización...');
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de localización han sido denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Los permisos de localización han sido denegados permanentemente.');
    }

    debugPrint('Obteniendo la posición actual...');
    Position position = await Geolocator.getCurrentPosition();
    debugPrint('Posición detectada: (${position.latitude}, ${position.longitude})');
    return position;
  }

  Future<void> insertarFarmaciasDePrueba() async {
    debugPrint('Insertando farmacias de prueba...');
    List<Farmacias_informacion> farmaciasPrueba = [
      Farmacias_informacion(
        localId: '1',
        localNombre: 'Farmacia Prueba 1',
        comunaNombre: 'Talca',
        localidadNombre: 'Localidad Prueba 1',
        direccion: 'Dirección Prueba 1',
        funcionamientoHoraApertura: '08:00',
        funcionamientoHoraCierre: '20:00',
        funcionamientoDia: 'Lunes a Domingo',
        telefono: '123456789',
        latitud: '-35.4232',
        longitud: '-71.6485',
      ),
      Farmacias_informacion(
        localId: '2',
        localNombre: 'Farmacia Prueba 2',
        comunaNombre: 'Talca',
        localidadNombre: 'Localidad Prueba 2',
        direccion: 'Dirección Prueba 2',
        funcionamientoHoraApertura: '08:00',
        funcionamientoHoraCierre: '20:00',
        funcionamientoDia: 'Lunes a Domingo',
        telefono: '123456789',
        latitud: '-35.4233',
        longitud: '-71.6486',
      ),
    ];

    for (var farmacia in farmaciasPrueba) {
      await _servicioBaseDatos.insertarFarmacia(farmacia);
    }
    debugPrint('Farmacias de prueba insertadas.');
  }

  Future<List<Farmacias_informacion>> farmaciasCercanas() async {
    Position posicionActual = await _detectarPosicion();
    debugPrint('Posición actual detectada: (${posicionActual.latitude}, ${posicionActual.longitude})');

    List<Farmacias_informacion> todasLasFarmacias = await _servicioBaseDatos.obtenerFarmacias();
    debugPrint('Total de farmacias obtenidas: ${todasLasFarmacias.length}');

    List<Farmacias_informacion> farmaciasCercanas = todasLasFarmacias.where((farmacia) {
      double distancia = _calcularDistancia(
        posicionActual.latitude,
        posicionActual.longitude,
        double.parse(farmacia.latitud),
        double.parse(farmacia.longitud),
      );
      debugPrint('Distancia a ${farmacia.localNombre}: $distancia km');
      return distancia <= 5.0; // Filtra farmacias a menos de 5 km
    }).toList();

    debugPrint('Farmacias cercanas encontradas: ${farmaciasCercanas.length}');

    farmaciasCercanas.sort((a, b) {
      double distanciaA = _calcularDistancia(
        posicionActual.latitude,
        posicionActual.longitude,
        double.parse(a.latitud),
        double.parse(a.longitud),
      );
      double distanciaB = _calcularDistancia(
        posicionActual.latitude,
        posicionActual.longitude,
        double.parse(b.latitud),
        double.parse(b.longitud),
      );
      return distanciaA.compareTo(distanciaB);
    });

    return farmaciasCercanas;
  }

  double _calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Pi / 180
    const c = cos;
    final a = 0.5 - c((lat2 - lat1) * p)/2 +
              c(lat1 * p) * c(lat2 * p) *
              (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }
}
