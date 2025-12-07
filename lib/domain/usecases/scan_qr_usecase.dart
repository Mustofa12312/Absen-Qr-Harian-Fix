import 'scan_result.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/attendance_repository.dart';

class ScanQrUsecase {
  final StudentRepository studentRepo;
  final AttendanceRepository attendanceRepo;

  ScanQrUsecase(this.studentRepo, this.attendanceRepo);

  Future<ScanResult> execute(String raw) async {
    if (raw.isEmpty) {
      return ScanResult.error("QR tidak terbaca");
    }

    final id = int.tryParse(raw.trim());
    if (id == null) {
      return ScanResult.error("QR harus berupa angka");
    }

    final student = await studentRepo.getById(id);

    if (student == null) {
      return ScanResult.error("Data murid tidak ditemukan");
    }

    final sudahAbsen = await attendanceRepo.isAlreadyCheckedToday(student.id);

    if (sudahAbsen) {
      return ScanResult.error(
        "${student.nama} sudah absen hari ini",
        student: student,
      );
    }

    await attendanceRepo.insertAttendance(student.id);

    return ScanResult.success(student);
  }
}
