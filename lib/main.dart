import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tareas/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tareas',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.tareaList,
      getPages: AppRoutes.routes,
    );
  }
}
