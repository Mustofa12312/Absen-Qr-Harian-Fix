class ClassModel {
  final int id;
  final String namaKelas;

  ClassModel({required this.id, required this.namaKelas});

  factory ClassModel.fromSupabase(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as int,
      namaKelas: json['nama_kelas'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "nama_kelas": namaKelas};
  }
}
