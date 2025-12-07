import '../../data/repositories/student_repository.dart';
import '../../data/repositories/attendance_repository.dart';

class DashboardStats {
  final int totalSantri;
  final int totalHadir;
  final int totalTidakHadir;

  DashboardStats({
    required this.totalSantri,
    required this.totalHadir,
    required this.totalTidakHadir,
  });
}

class GetDashboardStatsUsecase {
  final StudentRepository studentRepo;
  final AttendanceRepository attendanceRepo;

  GetDashboardStatsUsecase(this.studentRepo, this.attendanceRepo);

  Future<DashboardStats> load({int? classId}) async {
    final allStudents = await studentRepo.getAll(classId: classId);
    final attendances = await attendanceRepo.getTodayAttendances(
      classId: classId,
    );

    final hadirIds = attendances.map((a) => a.studentId).toSet();

    final totalSantri = allStudents.length;
    final totalHadir = hadirIds.length;
    final totalTidakHadir = totalSantri - totalHadir;

    return DashboardStats(
      totalSantri: totalSantri,
      totalHadir: totalHadir,
      totalTidakHadir: totalTidakHadir,
    );
  }
}
