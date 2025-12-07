import '../../data/models/student.dart';

class ScanResult {
  final bool success;
  final String message;
  final Student? student;

  ScanResult.success(this.student)
    : success = true,
      message = "Absensi berhasil disimpan";

  ScanResult.error(this.message, {this.student}) : success = false;
}
