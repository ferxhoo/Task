import 'package:get/get.dart';
import 'package:tareas/data/models/tarea.dart';
import 'package:tareas/data/repositories/tarea_repository.dart';

class TareaController extends GetxController {
  final TareaRepository repository = TareaRepository();

  var tareas = <Tarea>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTareas();
  }

  Future fetchTareas() async {
    try {
      isLoading.value = true;
      error.value = '';
      var fetched = await repository.getTareas();
      tareas.assignAll(fetched);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future addTarea(Tarea tarea) async {
    try {
      isLoading.value = true;
      var nuevaTarea = await repository.createTarea(tarea);
      tareas.add(nuevaTarea);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future updateTarea(Tarea tarea) async {
    try {
      isLoading.value = true;
      var actualizada = await repository.updateTarea(tarea);
      int index = tareas.indexWhere((t) => t.id == tarea.id);
      if (index != -1) {
        tareas[index] = actualizada;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future deleteTarea(int id) async {
    try {
      isLoading.value = true;
      await repository.deleteTarea(id);
      tareas.removeWhere((t) => t.id == id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
