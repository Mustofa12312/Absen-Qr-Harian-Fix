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
  // Repositories
  final studentRepo = StudentRepository();
  final attendanceRepo = AttendanceRepository();
  final classRepo = ClassRepository();

  // Usecases
  late final ScanQrUsecase scanQr;
  late final GetDashboardStatsUsecase dashboard;
  late final FilterByClassUsecase filterClass;

  // Observables
  final scannedStudent = Rx<Student?>(null);
  final loadingScan = false.obs;

  // Dashboard values
  final totalSantri = 0.obs;
  final totalHadir = 0.obs;
  final totalTidakHadir = 0.obs;

  // Classes
  final allClasses = <ClassModel>[].obs;
  final selectedClassId = 0.obs;

  // Lists
  final hadirList = <Student>[].obs;
  final tidakHadirList = <Student>[].obs;

  // Scan result popup
  final lastSuccess = false.obs;
  final lastMessage = "".obs;

  // Init
  @override
  void onInit() {
    super.onInit();

    scanQr = ScanQrUsecase(studentRepo, attendanceRepo);
    dashboard = GetDashboardStatsUsecase(studentRepo, attendanceRepo);
    filterClass = FilterByClassUsecase(studentRepo);

    loadInitialData();
  }

  // =====================================================
  // INITIAL LOAD
  // =====================================================
  Future<void> loadInitialData() async {
    await loadClasses();
    await loadDashboard();
    await loadLists();
  }

  // =====================================================
  // LOAD CLASSES
  // =====================================================
  Future<void> loadClasses() async {
    final data = await classRepo.getAll();
    allClasses.assignAll([ClassModel(id: 0, namaKelas: "Semua"), ...data]);
  }

  // =====================================================
  // DASHBOARD
  // =====================================================
  Future<void> loadDashboard() async {
    final stats = await dashboard.load(
      classId: selectedClassId.value == 0 ? null : selectedClassId.value,
    );

    totalSantri.value = stats.totalSantri;
    totalHadir.value = stats.totalHadir;
    totalTidakHadir.value = stats.totalTidakHadir;
  }

  // =====================================================
  // LOAD STUDENT LISTS
  // =====================================================
  Future<void> loadLists() async {
    final cid = selectedClassId.value == 0 ? null : selectedClassId.value;

    final all = await studentRepo.getAll(classId: cid);
    final hadir = await attendanceRepo.getTodayAttendances(classId: cid);

    final hadirIds = hadir.map((e) => e.studentId).toSet();

    hadirList.assignAll(all.where((s) => hadirIds.contains(s.id)).toList());
    tidakHadirList.assignAll(
      all.where((s) => !hadirIds.contains(s.id)).toList(),
    );
  }

  // =====================================================
  // QR SCAN PROCESS
  // =====================================================
  Future<void> processScan(String qr) async {
    loadingScan.value = true;

    final result = await scanQr.execute(qr);

    lastSuccess.value = result.success;
    lastMessage.value = result.message;
    scannedStudent.value = result.student;

    await loadDashboard();
    await loadLists();

    loadingScan.value = false;

    _showDialog(result);
  }

  // =====================================================
  // POPUP AUTO CLOSE
  // =====================================================
  void _showDialog(ScanResult result) {
    if (Get.isDialogOpen == true) Get.back();

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
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (Get.isDialogOpen == true) Get.back();
    });
  }

  // =====================================================
  // CHANGE CLASS FILTER
  // =====================================================
  Future<void> changeClass(int value) async {
    selectedClassId.value = value;
    await loadDashboard();
    await loadLists();
  }
}
