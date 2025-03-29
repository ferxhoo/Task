import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tareas/data/models/tarea.dart';
import 'package:tareas/domain/controllers/tarea_controller.dart';
import 'package:tareas/presentation/pages/tarea_form_page.dart';

class TareaFormPageState extends State<TareaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TareaController controller = Get.find<TareaController>();
  late TextEditingController nombreController;
  late TextEditingController detalleController;
  String estado = 'pendiente';
  int? tareaId;

  Color colorWithOpacity(Color color, double opacity) {
    return color.withValues(
      red: color.r,
      green: color.g,
      blue: color.b,
      alpha: opacity,
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final Tarea? tarea = Get.arguments;
    if (tarea != null) {
      tareaId = tarea.id;
      nombreController = TextEditingController(text: tarea.nombre);
      detalleController = TextEditingController(text: tarea.detalle);
      estado = tarea.estado;
    } else {
      nombreController = TextEditingController();
      detalleController = TextEditingController();
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    detalleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final nuevaTarea = Tarea(
        id: tareaId ?? 0,
        nombre: nombreController.text.trim(),
        detalle: detalleController.text.trim(),
        estado: estado,
      );

      try {
        String mensaje;
        if (tareaId == null) {
          controller.addTarea(nuevaTarea);
          mensaje = 'Tarea creada correctamente';
        } else {
          controller.updateTarea(nuevaTarea);
          mensaje = 'Tarea actualizada correctamente';
        }
        // Cierra la pantalla enviando el mensaje de éxito a la vista anterior
        Get.back(result: mensaje);
      } catch (e) {
        // En caso de error se muestra el snackbar de error y no se cierra la pantalla
        Get.snackbar(
          'Error',
          'No se pudo guardar la tarea: ${e.toString()}',
          backgroundColor: colorWithOpacity(Colors.red, 0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        tareaId == null ? 'Agregar Tarea' : 'Actualizar Tarea',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
      actions: [
        if (tareaId != null)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _showDeleteConfirmation,
          ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Confirmar eliminación',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar esta tarea?',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancelar', style: GoogleFonts.montserrat()),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteTarea(tareaId!);
              Get.back(result: 'Tarea eliminada correctamente');
            },
            child: Text(
              'Eliminar',
              style: GoogleFonts.montserrat(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: nombreController,
            label: 'Nombre de la Tarea',
            icon: Icons.task_alt,
            validator:
                (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Ingrese un nombre para la tarea'
                        : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: detalleController,
            label: 'Descripción',
            icon: Icons.description,
            maxLines: 4,
            validator:
                (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Ingrese una descripción'
                        : null,
          ),
          const SizedBox(height: 20),
          _buildEstadoDropdown(),
          const SizedBox(height: 32),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.deepPurpleAccent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: GoogleFonts.montserrat(color: Colors.grey.shade700),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      style: GoogleFonts.montserrat(),
      validator: validator,
    );
  }

  Widget _buildEstadoDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado de la tarea',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: estado,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.speed, color: Colors.deepPurpleAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.deepPurpleAccent,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
          items: [
            _buildDropdownItem(
              'pendiente',
              Icons.pending_outlined,
              Colors.orange,
            ),
            _buildDropdownItem('en progreso', Icons.loop, Colors.blue),
            _buildDropdownItem(
              'completado',
              Icons.check_circle_outline,
              Colors.green,
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                estado = value;
              });
            }
          },
          dropdownColor: Colors.white,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.deepPurpleAccent,
          ),
          style: GoogleFonts.montserrat(),
          isExpanded: true,
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(
    String value,
    IconData icon,
    Color color,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Text(
            _capitalizeFirstLetter(value),
            style: GoogleFonts.montserrat(color: Colors.black87, fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: _submit,
      icon: Icon(
        tareaId == null ? Icons.add_circle_outline : Icons.update,
        size: 22,
      ),
      label: Text(
        tareaId == null ? 'Crear Tarea' : 'Actualizar Tarea',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }
}
