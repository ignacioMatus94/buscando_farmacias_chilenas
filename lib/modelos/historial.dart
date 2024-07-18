import 'dart:convert';
import 'package:buscando_farmacias_chilenas/modelos/farmacias_informacion.dart';

class Historial {
  final int id;
  final String idFarmacia;
  final String accion;
  final String fecha;
  final String hora;
  final List<Farmacias_informacion> farmaciasInfo;

  Historial({
    required this.id,
    required this.idFarmacia,
    required this.accion,
    required this.fecha,
    required this.hora,
    required this.farmaciasInfo,
  });

  factory Historial.fromJson(Map<String, dynamic> json) {
    var farmaciasList = jsonDecode(json['farmaciasInfo']) as List;
    List<Farmacias_informacion> farmacias = farmaciasList.map((i) => Farmacias_informacion.fromJson(i)).toList();
    return Historial(
      id: json['id'],
      idFarmacia: json['idFarmacia'],
      accion: json['accion'],
      fecha: json['fecha'],
      hora: json['hora'],
      farmaciasInfo: farmacias,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> farmacias = farmaciasInfo.map((i) => i.toJson()).toList();
    return {
      'id': id,
      'idFarmacia': idFarmacia,
      'accion': accion,
      'fecha': fecha,
      'hora': hora,
      'farmaciasInfo': jsonEncode(farmacias), // Serializar a JSON
    };
  }

  Historial copyWith({List<Farmacias_informacion>? farmaciasInfo}) {
    return Historial(
      id: id,
      idFarmacia: idFarmacia,
      accion: accion,
      fecha: fecha,
      hora: hora,
      farmaciasInfo: farmaciasInfo ?? this.farmaciasInfo,
    );
  }
}
