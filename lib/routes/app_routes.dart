import 'package:get/get.dart';
import 'package:tareas/presentation/pages/tarea_form_page.dart';
import 'package:tareas/presentation/pages/tarea_list_page.dart';

class AppRoutes {
  static const String tareaList = '/';
  static const String tareaForm = '/tareaForm';

  static final routes = [
    GetPage(name: tareaList, page: () => const TareaListPage()),
    GetPage(name: tareaForm, page: () => const TareaFormPage()),
  ];
}
