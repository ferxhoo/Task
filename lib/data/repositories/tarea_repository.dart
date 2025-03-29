import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tareas/data/models/tarea.dart';

class TareaRepository {
  final String baseUrl = 'https://x8ki-letl-twmt.n7.xano.io/api:UIdqgh6f';

  Future<List<Tarea>> getTareas() async {
    final response = await http.get(Uri.parse('$baseUrl/tareas'));
    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((json) => Tarea.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar tareas: ${response.statusCode}');
    }
  }

  Future<Tarea> getTareaById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/tareas/$id'));
    if (response.statusCode == 200) {
      return Tarea.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener tarea: ${response.statusCode}');
    }
  }

  Future<Tarea> createTarea(Tarea tarea) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tareas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tarea.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Tarea.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear tarea: ${response.statusCode}');
    }
  }

  Future<Tarea> updateTarea(Tarea tarea) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tareas/${tarea.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tarea.toJson()),
    );
    if (response.statusCode == 200) {
      return Tarea.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar tarea: ${response.statusCode}');
    }
  }

  Future<void> deleteTarea(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tareas/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar tarea: ${response.statusCode}');
    }
  }
}
