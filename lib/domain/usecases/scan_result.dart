import '../../data/models/student.dart';

class ScanResult {
  final bool success;
  final String message;
  final Student? student;

  /// Hasil scan sukses
  ScanResult.success(this.student)
      : success = true,
        message = "Absensi berhasil disimpan";

  /// Hasil scan gagal
  ScanResult.error(this.message, {this.student})
      : success = false;
}
