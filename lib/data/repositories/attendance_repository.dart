import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants.dart';
import '../models/attendance.dart';
import '../../../core/helpers/date_helper.dart';
import '../../../core/supabase_filter_ext.dart';

class AttendanceRepository {
  final SupabaseClient client = Supabase.instance.client;

  // ============================================================
  // INSERT ABSENSI (Supabase v2 FIX)
  // ============================================================
  Future<bool> insertAttendance(int studentId, {String? device}) async {
    try {
      final response = await client.from('attendances').insert({
        'student_id': studentId,
        'device': device ?? Constants.defaultDevice,
        'status': 'present',
        'scanned_at': DateTime.now().toIso8601String(),
      }).select(); // Penting di Supabase v2 untuk dapat return

      return response.isNotEmpty;
    } catch (e) {
      print("❌ ERROR INSERT: $e");
      return false;
    }
  }

  // ============================================================
  // CEK SUDAH ABSEN HARI INI
  // ============================================================
  Future<bool> isAlreadyCheckedToday(int studentId) async {
    try {
      final start = DateHelper.startOfToday().toIso8601String();

      final result = await client
          .from('attendances')
          .select('id')
          .eq('student_id', studentId)
          .gte('scanned_at', start);

      return result.isNotEmpty;
    } catch (e) {
      print("❌ ERROR CHECK TODAY: $e");
      return false;
    }
  }

  // ============================================================
  // GET ABSENSI HARI INI (JOIN STUDENT & CLASS)
  // ============================================================
  Future<List<Attendance>> getTodayAttendances({int? classId}) async {
    try {
      final start = DateHelper.startOfToday().toIso8601String();

      final data = await client
          .from('attendances')
          .select('''
            id,
            student_id,
            scanned_at,
            device,
            status,
            students (
              id,
              nama,
              class_id,
              classes (id, nama_kelas)
            )
          ''')
          .gte('scanned_at', start)
          .maybeEq('students.class_id', classId == 0 ? null : classId)
          .order('scanned_at');

      return data
          .map<Attendance>((json) => Attendance.fromSupabase(json))
          .toList();
    } catch (e) {
      print("❌ ERROR GET TODAY: $e");
      return [];
    }
  }
}
