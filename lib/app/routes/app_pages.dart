import 'package:get/get.dart';
import '../../modules/attendance/pages/attendance_page.dart';
import '../../modules/attendance/pages/qr_scanner_page.dart';
import '../../modules/attendance/pages/hadir_page.dart';
import '../../modules/attendance/pages/tidak_hadir_page.dart';
import '../bindings/initial_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.attendance,
      page: () => const AttendancePage(),
      binding: InitialBinding(),
    ),
    GetPage(name: AppRoutes.qrScanner, page: () => const QrScannerPage()),
    GetPage(name: AppRoutes.hadir, page: () => const HadirPage()),
    GetPage(name: AppRoutes.tidakHadir, page: () => const TidakHadirPage()),
  ];
}
