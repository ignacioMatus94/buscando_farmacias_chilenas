import 'package:flutter/material.dart';

import '../modelos/farmacias_informacion.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LogicaPrincipal {
  Future<Map<String, Map<String, List<Farmacias_informacion>>>> cargarFarmaciasAgrupadas() async {
    debugPrint('Iniciando carga de farmacias agrupadas...');
    final response = await http.get(Uri.parse('https://midas.minsal.cl/farmacia_v2/WS/getLocalesTurnos.php'));

    if (response.statusCode == 200) {
      debugPrint('Datos recibidos correctamente desde la API.');
      List<dynamic> data = json.decode(response.body);
      List<Farmacias_informacion> farmacias = data.map((item) {
        return Farmacias_informacion.fromJson(item);
      }).toList();
      debugPrint('Datos transformados en objetos Farmacias_informacion: ${farmacias.length}');
      return _agruparPorComuna(farmacias);
    } else {
      debugPrint('Error al cargar farmacias: ${response.statusCode}');
      throw Exception('Error al cargar farmacias');
    }
  }

  Map<String, Map<String, List<Farmacias_informacion>>> _agruparPorComuna(List<Farmacias_informacion> farmacias) {
    debugPrint('Iniciando agrupación de farmacias por comuna...');
    Map<String, Map<String, List<Farmacias_informacion>>> agrupado = {};

    for (var farmacia in farmacias) {
      debugPrint('Procesando farmacia: ${farmacia.localNombre} - Comuna: ${farmacia.comunaNombre}');
      if (!agrupado.containsKey(farmacia.comunaNombre)) {
        agrupado[farmacia.comunaNombre] = {};
      }
      if (!agrupado[farmacia.comunaNombre]!.containsKey(farmacia.localidadNombre)) {
        agrupado[farmacia.comunaNombre]![farmacia.localidadNombre] = [];
      }
      agrupado[farmacia.comunaNombre]![farmacia.localidadNombre]!.add(farmacia);
    }

    debugPrint('Agrupación completa.');
    return agrupado;
  }
}
