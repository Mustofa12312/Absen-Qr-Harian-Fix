class Student {
  final int id;
  final String nama;
  final int classId;
  final String namaKelas;

  Student({
    required this.id,
    required this.nama,
    required this.classId,
    required this.namaKelas,
  });

  factory Student.fromSupabase(Map<String, dynamic> json) {
    final classData = json['classes'] as Map<String, dynamic>?;

    return Student(
      id: json['id'] as int,
      nama: json['nama'] as String,
      classId: (classData?['id'] as int?) ?? json['class_id'] as int,
      namaKelas: (classData?['nama_kelas'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama": nama,
      "class_id": classId,
      "nama_kelas": namaKelas,
    };
  }
}
