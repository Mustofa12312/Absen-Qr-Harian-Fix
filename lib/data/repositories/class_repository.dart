import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/class_model.dart';

class ClassRepository {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<ClassModel>> getAll() async {
    final data = await client
        .from('classes')
        .select('id, nama_kelas')
        .order('nama_kelas');

    return data
        .map<ClassModel>((json) => ClassModel.fromSupabase(json))
        .toList();
  }
}
