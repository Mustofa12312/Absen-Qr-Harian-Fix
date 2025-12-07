import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';
import '../../../core/app_colors.dart';

class KelasDropdown extends StatelessWidget {
  const KelasDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AttendanceController>();

    return Obx(() {
      final kelas = c.allClasses;

      if (kelas.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return DropdownButtonFormField<int>(
        value: c.selectedClassId.value,
        decoration: InputDecoration(
          labelText: "Pilih Kelas",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: kelas
            .map((k) => DropdownMenuItem(value: k.id, child: Text(k.namaKelas)))
            .toList(),
        onChanged: (v) {
          if (v != null) c.changeClass(v);
        },
      );
    });
  }
}
