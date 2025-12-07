import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/student.dart';
import '../../../data/models/class_model.dart';
import '../../../data/repositories/student_repository.dart';
import '../../../data/repositories/class_repository.dart';
import '../../../data/repositories/attendance_repository.dart';

import '../../../domain/usecases/scan_qr_usecase.dart';
import '../../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../../domain/usecases/filter_by_class_usecase.dart';
import '../../../domain/usecases/scan_result.dart';

class AttendanceController extends GetxController {
  // Repository
  final StudentRepository studentRepo = StudentRepository();
  final AttendanceRepository attendanceRepo = AttendanceRepository();
  final ClassRepository classRepo = ClassRepository();

  // Usecases
  late final ScanQrUsecase scanQrUsecase;
  late final GetDashboardStatsUsecase dashboardUsecase;
  late final FilterByClassUsecase filterClassUsecase;

  // Observables
  Rx<Student?> scannedStudent = Rx<Student?>(null);
  RxBool loadingScan = false.obs;

  // Dashboard
  RxInt totalSantri = 0.obs;
  RxInt totalHadir = 0.obs;
  RxInt totalTidakHadir = 0.obs;

  // Kelas
  RxList<ClassModel> allClasses = <ClassModel>[].obs;
  RxInt selectedClassId = 0.obs;

  // Lists
  RxList<Student> hadirList = <Student>[].obs;
  RxList<Student> tidakHadirList = <Student>[].obs;

  // Result popup
  RxBool lastSuccess = false.obs;
  RxString lastMessage = "".obs;

  @override
  void onInit() {
    super.onInit();

    scanQrUsecase = ScanQrUsecase(studentRepo, attendanceRepo);
    dashboardUsecase = GetDashboardStatsUsecase(studentRepo, attendanceRepo);
    filterClassUsecase = FilterByClassUsecase(studentRepo);

    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await loadClasses();
    await loadDashboard();
    await loadLists();
  }

  // ============================================================
  // LOAD DATA
  // ============================================================

  Future<void> loadClasses() async {
    final data = await classRepo.getAll();
    allClasses.assignAll([ClassModel(id: 0, namaKelas: "Semua"), ...data]);
  }

  Future<void> loadDashboard() async {
    final stats = await dashboardUsecase.load(
      classId: selectedClassId.value == 0 ? null : selectedClassId.value,
    );

    totalSantri.value = stats.totalSantri;
    totalHadir.value = stats.totalHadir;
    totalTidakHadir.value = stats.totalTidakHadir;
  }

  Future<void> loadLists() async {
    int? cid = selectedClassId.value == 0 ? null : selectedClassId.value;

    final all = await studentRepo.getAll(classId: cid);
    final hadir = await attendanceRepo.getTodayAttendances(classId: cid);

    final hadirIds = hadir.map((a) => a.studentId).toSet();

    hadirList.assignAll(all.where((s) => hadirIds.contains(s.id)).toList());

    tidakHadirList.assignAll(
      all.where((s) => !hadirIds.contains(s.id)).toList(),
    );
  }

  // ============================================================
  // SCAN QR
  // ============================================================

  Future<void> processScan(String qr) async {
    loadingScan.value = true;

    final result = await scanQrUsecase.execute(qr);

    lastSuccess.value = result.success;
    lastMessage.value = result.message;
    scannedStudent.value = result.student;

    await loadDashboard();
    await loadLists();

    loadingScan.value = false;

    // show popup
    _showDialog(result);
  }

  // ============================================================
  // POPUP AUTO CLOSE (1 DETIK)
  // ============================================================

  void _showDialog(ScanResult result) {
    // Jika ada popup sedang tampil → tutup dulu
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    // Tampilkan popup baru
    Get.dialog(
      AlertDialog(
        title: Text(
          result.success ? "Absensi Berhasil" : "Gagal",
          style: TextStyle(
            color: result.success ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(result.message),
            if (result.student != null) ...[
              const SizedBox(height: 10),
              Text("Nama: ${result.student!.nama}"),
              Text("Kelas: ${result.student!.namaKelas}"),
            ],
          ],
        ),
      ),
      barrierDismissible: false, // agar popup tidak tertutup tangan pengguna
    );

    // Hilang otomatis setelah 1 detik
    Future.delayed(const Duration(seconds: 1), () {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    });
  }

  // ============================================================
  // CHANGE KELAS
  // ============================================================

  Future<void> changeClass(int value) async {
    selectedClassId.value = value;
    await loadDashboard();
    await loadLists();
  }
}
