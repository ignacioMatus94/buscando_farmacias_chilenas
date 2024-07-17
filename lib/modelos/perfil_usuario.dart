class PerfilUsuario {
  final int id;
  final String nombre;
  final String correo;

  PerfilUsuario({
    required this.id,
    required this.nombre,
    required this.correo,
  });

  factory PerfilUsuario.fromJson(Map<String, dynamic> json) {
    return PerfilUsuario(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
    };
  }
}
