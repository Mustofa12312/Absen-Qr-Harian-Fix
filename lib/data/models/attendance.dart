class Attendance {
  final int id;
  final int studentId;
  final DateTime scannedAt;
  final String device;
  final String status;

  Attendance({
    required this.id,
    required this.studentId,
    required this.scannedAt,
    required this.device,
    required this.status,
  });

  factory Attendance.fromSupabase(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      scannedAt: DateTime.parse(json['scanned_at']),
      device: json['device'] ?? "",
      status: json['status'] ?? "present",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "student_id": studentId,
      "scanned_at": scannedAt.toIso8601String(),
      "device": device,
      "status": status,
    };
  }
}
