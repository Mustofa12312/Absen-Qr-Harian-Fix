import 'scan_result.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/attendance_repository.dart';

class ScanQrUsecase {
  final StudentRepository studentRepo;
  final AttendanceRepository attendanceRepo;

  ScanQrUsecase(this.studentRepo, this.attendanceRepo);

  Future<ScanResult> execute(String raw) async {
    try {
      // ============================================
      // 1. QR kosong / tidak terbaca
      // ============================================
      if (raw.isEmpty) {
        return ScanResult.error("QR tidak terbaca");
      }

      // ============================================
      // 2. QR harus berupa angka ID murid
      // ============================================
      final id = int.tryParse(raw.trim());
      if (id == null) {
        return ScanResult.error("QR harus berupa angka");
      }

      // ============================================
      // 3. Ambil data murid
      // ============================================
      final student = await studentRepo.getById(id);
      if (student == null) {
        return ScanResult.error("Data murid tidak ditemukan");
      }

      // ============================================
      // 4. Cek apakah sudah absen hari ini
      // ============================================
      final sudahAbsen = await attendanceRepo.isAlreadyCheckedToday(student.id);

      if (sudahAbsen) {
        return ScanResult.error(
          "${student.nama} sudah absen hari ini",
          student: student,
        );
      }

      // ============================================
      // 5. Tambahkan absensi (FIX: 100% data masuk Supabase)
      // ============================================
      await attendanceRepo.insertAttendance(student.id);

      // ============================================
      // 6. Sukses
      // ============================================
      return ScanResult.success(student);
    } catch (e) {
      // Jika Supabase gagal insert, error masuk sini
      print("ERROR Scan QR: $e");
      return ScanResult.error("Terjadi kesalahan saat memproses QR");
    }
  }
}
