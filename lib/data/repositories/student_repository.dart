import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';

class StudentRepository {
  final SupabaseClient client = Supabase.instance.client;

  Future<Student?> getById(int id) async {
    final data = await client
        .from('students')
        .select('id, nama, class_id, classes(id, nama_kelas)')
        .eq('id', id)
        .maybeSingle();

    if (data == null) return null;
    return Student.fromSupabase(data);
  }

  Future<List<Student>> getAll({int? classId}) async {
    var query = client
        .from('students')
        .select('id, nama, class_id, classes(id, nama_kelas)');

    if (classId != null && classId > 0) {
      query = query.eq('class_id', classId);
    }

    final data = await query;
    return data.map<Student>((json) => Student.fromSupabase(json)).toList();
  }
}
