import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  int index = 0;

  final pages = const [
    AttendanceDashboard(),
    QrScannerPage(),
    HadirPage(),
    TidakHadirPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_app.png"),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: pages[index],
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BottomNavigationBar(
              backgroundColor: Colors.white.withOpacity(0.95),
              elevation: 10,
              type: BottomNavigationBarType.fixed,
              currentIndex: index,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.black54,
              onTap: (i) => setState(() => index = i),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_rounded),
                  label: "Scan",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_rounded),
                  label: "Hadir",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.cancel_rounded),
                  label: "Tidak",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================================================================
//                             DASHBOARD
// ===================================================================

class AttendanceDashboard extends StatelessWidget {
  const AttendanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AttendanceController>();

    final now = DateTime.now();
    final hari = DateFormat('EEEE', 'id_ID').format(now);
    final tanggal = DateFormat('d MMMM yyyy', 'id_ID').format(now);

    return SafeArea(
      child: Container(
        color: Colors
            .transparent, // <---- WAJIB AGAR BACKGROUND GAMBAR TIDAK TERTUTUP

        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),

                const Text(
                  "Absensi Sholat",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "$hari, $tanggal",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statCard("Siswa", c.totalSantri.value, Colors.blue),
                    _statCard("Hadir", c.totalHadir.value, Colors.green),
                    _statCard("Tidak", c.totalTidakHadir.value, Colors.red),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _statCard(String title, int value, Color color) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.82, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(.15),
              child: Icon(Icons.circle, color: color, size: 16),
            ),

            const SizedBox(height: 10),

            Text(
              "$value",
              style: TextStyle(
                fontSize: 22,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
