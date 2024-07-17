class Farmacias_informacion {
  final String localId;
  final String localNombre;
  final String comunaNombre;
  final String localidadNombre;
  final String direccion;
  final String funcionamientoHoraApertura;
  final String funcionamientoHoraCierre;
  final String funcionamientoDia;
  final String telefono;
  final String latitud;
  final String longitud;

  Farmacias_informacion({
    required this.localId,
    required this.localNombre,
    required this.comunaNombre,
    required this.localidadNombre,
    required this.direccion,
    required this.funcionamientoHoraApertura,
    required this.funcionamientoHoraCierre,
    required this.funcionamientoDia,
    required this.telefono,
    required this.latitud,
    required this.longitud,
  });

  factory Farmacias_informacion.fromJson(Map<String, dynamic> json) {
    return Farmacias_informacion(
      localId: json['local_id'] ?? 'Desconocido',
      localNombre: json['local_nombre'] ?? 'Desconocido',
      comunaNombre: json['comuna_nombre'] ?? 'Desconocido',
      localidadNombre: json['localidad_nombre'] ?? 'Desconocido',
      direccion: json['local_direccion'] ?? 'Desconocido',
      funcionamientoHoraApertura: json['funcionamiento_hora_apertura'] ?? '00:00',
      funcionamientoHoraCierre: json['funcionamiento_hora_cierre'] ?? '00:00',
      funcionamientoDia: json['funcionamiento_dia'] ?? 'Desconocido',
      telefono: json['local_telefono'] ?? 'Desconocido',
      latitud: json['local_lat'] ?? '0.0',
      longitud: json['local_lng'] ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local_id': localId,
      'local_nombre': localNombre,
      'comuna_nombre': comunaNombre,
      'localidad_nombre': localidadNombre,
      'local_direccion': direccion,
      'funcionamiento_hora_apertura': funcionamientoHoraApertura,
      'funcionamiento_hora_cierre': funcionamientoHoraCierre,
      'funcionamiento_dia': funcionamientoDia,
      'local_telefono': telefono,
      'local_lat': latitud,
      'local_lng': longitud,
    };
  }
}
