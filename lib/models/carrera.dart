class Carrera {
  int id;
  String nombre;

  Carrera({required this.id, required this.nombre});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }

  factory Carrera.fromMap(Map<String, dynamic> map) {
    return Carrera(
      id: map['id'],
      nombre: map['nombre'],
    );
  }
}
