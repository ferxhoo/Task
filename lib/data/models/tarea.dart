class Tarea {
  final int id;
  final String nombre;
  final String detalle;
  final String estado;

  Tarea({
    required this.id,
    required this.nombre,
    required this.detalle,
    required this.estado,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      nombre: json['nombre'],
      detalle: json['detalle'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'detalle': detalle, 'estado': estado};
  }
}
