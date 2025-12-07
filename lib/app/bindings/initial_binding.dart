import 'package:get/get.dart';
import '../../modules/attendance/controllers/attendance_controller.dart';
import '../../data/services/supabase_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SupabaseService>(SupabaseService(), permanent: true);
    Get.put<AttendanceController>(AttendanceController(), permanent: true);
  }
}