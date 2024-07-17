import 'package:buscando_farmacias_chilenas/modelos/farmacias_informacion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class ServicioApi {
  final String urlApi = 'https://midas.minsal.cl/farmacia_v2/WS/getLocales.php';

  Future<List<Farmacias_informacion>> obtenerFarmacias() async {
    try {
      debugPrint('Iniciando petición a la API...');
      final respuesta = await http.get(Uri.parse(urlApi));
      if (respuesta.statusCode == 200) {
        List<dynamic> respuestaJson = json.decode(respuesta.body);
        debugPrint('Datos recibidos desde la API: ${respuestaJson.length} elementos.');
        return respuestaJson.map((json) => Farmacias_informacion.fromJson(json)).toList();
      } else {
        debugPrint('Error al cargar farmacias desde la API: ${respuesta.statusCode}');
        throw Exception('Error al cargar farmacias');
      }
    } catch (e) {
      debugPrint('Error de conexión al cargar farmacias: $e');
      throw Exception('Error de conexión al cargar farmacias');
    }
  }
}
