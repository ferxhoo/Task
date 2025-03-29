import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tareas/domain/controllers/tarea_controller.dart';
import 'package:tareas/presentation/widgets/tarea_tile.dart';
import 'package:tareas/routes/app_routes.dart';

class TareaListPage extends StatelessWidget {
  const TareaListPage({super.key});

  Color colorWithOpacity(Color color, double opacity) {
    return color.withValues(
      red: color.r,
      green: color.g,
      blue: color.b,
      alpha: opacity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TareaController controller = Get.put(TareaController());
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        title: Text(
          'Mis Tareas',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w800,
            color: Colors.blueGrey[800],
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          _buildActionButton(
            icon: Icons.add_circle_outline,
            color: Colors.teal.shade400,
            onPressed: () {
              Get.toNamed(AppRoutes.tareaForm)?.then((result) {
                if (result != null) {
                  Get.snackbar(
                    'Éxito',
                    result,
                    backgroundColor: colorWithOpacity(Colors.green, 0.7),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                }
              });
            },
          ),
          _buildActionButton(
            icon: Icons.sync,
            color: Colors.indigo.shade400,
            onPressed: controller.fetchTareas,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingIndicator();
            }
            if (controller.error.isNotEmpty) {
              return _buildErrorWidget(controller.error.value);
            }
            if (controller.tareas.isEmpty) {
              return _buildEmptyState();
            }
            return _buildTaskList(controller);
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoutes.tareaForm)?.then((result) {
            if (result != null) {
              Get.snackbar(
                'Éxito',
                result,
                backgroundColor: colorWithOpacity(Colors.green, 0.7),
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            }
          });
        },
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Nueva Tarea',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(icon: Icon(icon, color: color), onPressed: onPressed);
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade600),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red.shade300,
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'Ocurrió un error',
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.quicksand(
              color: Colors.blueGrey[600],
              textStyle: const TextStyle(fontStyle: FontStyle.italic),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checklist_rounded, size: 100, color: Colors.blueGrey[300]),
          const SizedBox(height: 16),
          Text(
            'No hay tareas',
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Comienza agregando una nueva tarea',
            style: GoogleFonts.quicksand(
              color: Colors.blueGrey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(TareaController controller) {
    return ListView.builder(
      itemCount: controller.tareas.length,
      itemBuilder: (context, index) {
        final tarea = controller.tareas[index];
        return TareaTile(
          tarea: tarea,
          onDelete: () => controller.deleteTarea(tarea.id),
          onTap:
              () => Get.toNamed(AppRoutes.tareaForm, arguments: tarea)?.then((
                result,
              ) {
                if (result != null) {
                  Get.snackbar(
                    'Éxito',
                    result,
                    backgroundColor: colorWithOpacity(Colors.green, 0.7),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                }
              }),
        );
      },
    );
  }
}
