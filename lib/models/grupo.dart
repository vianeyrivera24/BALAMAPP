class Grupo {
  int id;
  String nombre;

  Grupo({required this.id, required this.nombre});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }

  factory Grupo.fromMap(Map<String, dynamic> map) {
    return Grupo(
      id: map['id'],
      nombre: map['nombre'],
    );
  }
}
