import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';
import 'hadir_page.dart';
import 'tidak_hadir_page.dart';
import 'qr_scanner_page.dart';
import '../../../core/app_colors.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final controller = Get.find<AttendanceController>();
  int index = 0;

  final pages = const [
    AttendanceDashboard(),
    QrScannerPage(),
    HadirPage(),
    TidakHadirPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "Scan"),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: "Hadir"),
          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            label: "Tidak Hadir",
          ),
        ],
      ),
    );
  }
}

class AttendanceDashboard extends StatelessWidget {
  const AttendanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AttendanceController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard Absensi",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _stat("Santri", c.totalSantri.value, Colors.blue),
                  _stat("Hadir", c.totalHadir.value, Colors.green),
                  _stat("Tidak", c.totalTidakHadir.value, Colors.red),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _stat(String title, int value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.2),
            child: Icon(Icons.circle, color: color),
          ),
          SizedBox(height: 10),
          Text(
            "$value",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: color,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }
}
