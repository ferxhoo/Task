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
}
