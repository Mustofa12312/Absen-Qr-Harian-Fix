import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants.dart';
import '../models/attendance.dart';
import '../../../core/helpers/date_helper.dart';

class AttendanceRepository {
  final SupabaseClient client = Supabase.instance.client;

  Future<void> insertAttendance(int studentId, {String? device}) async {
    await client.from('attendances').insert({
      'student_id': studentId,
      'device': device ?? Constants.defaultDevice,
      'status': 'present',
    });
  }

  Future<bool> isAlreadyCheckedToday(int studentId) async {
    final start = DateHelper.startOfToday().toIso8601String();

    final data = await client
        .from('attendances')
        .select('id')
        .eq('student_id', studentId)
        .gte('scanned_at', start);

    return data.isNotEmpty;
  }

  Future<List<Attendance>> getTodayAttendances({int? classId}) async {
    final start = DateHelper.startOfToday().toIso8601String();

    var query = client
        .from('attendances')
        .select(
          'id, student_id, scanned_at, device, status, students(*, classes(*))',
        )
        .gte('scanned_at', start);

    if (classId != null && classId > 0) {
      query = query.eq('students.class_id', classId);
    }

    final data = await query;

    return data
        .map<Attendance>((json) => Attendance.fromSupabase(json))
        .toList();
  }
}
