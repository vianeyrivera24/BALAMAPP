class Semestre {
  int id;
  String nombre;

  Semestre({required this.id, required this.nombre});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }

  factory Semestre.fromMap(Map<String, dynamic> map) {
    return Semestre(
      id: map['id'],
      nombre: map['nombre'],
    );
  }
}
