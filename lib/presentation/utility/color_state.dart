import 'package:flutter/material.dart';
import 'package:tareas/data/models/tarea.dart';

class ColorState {
  Color colorWithOpacity(Color color, double opacity) {
    return color.withValues(
      red: color.r,
      green: color.g,
      blue: color.b,
      alpha: opacity,
    );
  }

  Color getEstadoColor(Tarea tarea) {
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

  IconData getEstadoIcon(Tarea tarea) {
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
}
