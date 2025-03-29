import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tareas/data/models/tarea.dart';

class TareaRepository {
  final String baseUrl = 'https://x8ki-letl-twmt.n7.xano.io/api:UIdqgh6f';

  Future<List<Tarea>> getTareas() async {
    final response = await http.get(Uri.parse('$baseUrl/tareas'));
    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);

      print(JsonEncoder.withIndent("  ").convert(jsonList));

      return jsonList.map((json) => Tarea.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar tareas: ${response.statusCode}');
    }
  }
}
