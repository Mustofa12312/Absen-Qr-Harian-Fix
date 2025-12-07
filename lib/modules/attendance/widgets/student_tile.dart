import 'package:flutter/material.dart';
import '../../../data/models/student.dart';
import '../../../core/app_colors.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final bool hadir;

  const StudentTile({super.key, required this.student, required this.hadir});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (hadir ? AppColors.success : AppColors.error)
              .withOpacity(.15),
          child: Icon(
            hadir ? Icons.check_circle : Icons.close,
            color: hadir ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(
          student.nama,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          "ID: ${student.id} • Kelas: ${student.namaKelas}",
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
