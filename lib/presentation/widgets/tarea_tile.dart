import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tareas/data/models/tarea.dart';

class TareaTile extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  Color colorWithOpacity(Color color, double opacity) {
    return color.withValues(
      red: color.r,
      green: color.g,
      blue: color.b,
      alpha: opacity,
    );
  }

  const TareaTile({
    super.key,
    required this.tarea,
    required this.onDelete,
    required this.onTap,
  });

  Color _getEstadoColor() {
    switch (tarea.estado) {
      case 'pendiente':
        return Colors.orange.shade200;
      case 'en progreso':
        return Colors.blue.shade200;
      case 'completado':
        return Colors.green.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  IconData _getEstadoIcon() {
    switch (tarea.estado) {
      case 'pendiente':
        return Icons.pending_outlined;
      case 'en progreso':
        return Icons.play_circle_outline_rounded;
      case 'completado':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorWithOpacity(Colors.blueGrey, 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          decoration: BoxDecoration(
            color: _getEstadoColor(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(_getEstadoIcon(), color: Colors.white, size: 24),
          ),
        ),
        title: Text(
          tarea.nombre,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w700,
            color: Colors.blueGrey[800],
          ),
        ),
        subtitle: Text(
          tarea.detalle,
          style: GoogleFonts.quicksand(
            color: Colors.blueGrey[600],
            fontStyle: FontStyle.italic,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: Text(
                  'Eliminar Tarea',
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w700),
                ),
                content: Text(
                  '¿Estás seguro de eliminar "${tarea.nombre}"?',
                  style: GoogleFonts.quicksand(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancelar', style: GoogleFonts.quicksand()),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onDelete();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Eliminar', style: GoogleFonts.quicksand()),
                  ),
                ],
              ),
            );
          },
        ),
        onTap: onTap,
      ),
    );
  }
}
