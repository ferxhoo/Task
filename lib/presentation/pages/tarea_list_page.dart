import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tareas/domain/controllers/tarea_controller.dart';

class TareaListPage extends StatelessWidget {
  const TareaListPage({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(TareaController());
    return const Center(child: Text('Tarea'));
  }
}
