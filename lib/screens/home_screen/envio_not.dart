import 'package:flutter/material.dart';
import '../../db_helper.dart';
import '../../models/carrera.dart';
import '../../models/semestre.dart';
import '../../models/grupo.dart';

class NotScreean extends StatefulWidget {
  static String routeName = 'NotScreean';
  const NotScreean({super.key});

  @override
  _NotScreenState createState() => _NotScreenState();
}

class _NotScreenState extends State<NotScreean> {
  DBHelper dbHelper = DBHelper();

  Carrera? selectedCarrera;
  Semestre? selectedSemestre;
  Grupo? selectedGrupo;

  List<Carrera> carreras = [];
  List<Semestre> semestres = [];
  List<Grupo> grupos = [];

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    carreras = await dbHelper.getCarreras();
    semestres = await dbHelper.getSemestres();
    grupos = await dbHelper.getGrupos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Envio de Notificaciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDropdown<Carrera>(
              hint: 'Selecciona Carrera',
              items: carreras,
              selectedItem: selectedCarrera,
              onChanged: (value) {
                setState(() {
                  selectedCarrera = value;
                });
              },
              itemLabel: (carrera) => carrera.nombre,
            ),
            SizedBox(height: 0),
            buildDropdown<Semestre>(
              hint: 'Selecciona Semestre',
              items: semestres,
              selectedItem: selectedSemestre,
              onChanged: (value) {
                setState(() {
                  selectedSemestre = value;
                });
              },
              itemLabel: (semestre) => semestre.nombre,
            ),
            SizedBox(height: 0),
            buildDropdown<Grupo>(
              hint: 'Selecciona Grupo',
              items: grupos,
              selectedItem: selectedGrupo,
              onChanged: (value) {
                setState(() {
                  selectedGrupo = value;
                });
              },
              itemLabel: (grupo) => grupo.nombre,
            ),
            SizedBox(height: 0),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        Color.fromARGB(255, 255, 255, 255), // Color del borde
                    width: 8.0, // Grosor del borde
                  ),
                ),
              ),
              maxLines: 4,
              style:
                  TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final mensaje = messageController.text;
                // Implementar la lógica de envío aquí
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(
                    255, 254, 255, 255), // Color de fondo del botón
                textStyle: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(
                        255, 0, 0, 0)), // Estilo del texto del botón
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown<T>({
    required String hint,
    required List<T> items,
    required T? selectedItem,
    required void Function(T?) onChanged,
    required String Function(T) itemLabel,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255), fontSize: 16),
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: selectedItem,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item), style: TextStyle(fontSize: 16)),
            );
          }).toList(),
          onChanged: onChanged,
          style: TextStyle(fontSize: 16, color: Colors.black),
          dropdownColor: const Color.fromARGB(255, 255, 255, 255),
          isExpanded: true,
        ),
      ),
    );
  }
}
