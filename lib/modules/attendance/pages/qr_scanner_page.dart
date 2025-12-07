import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/attendance_controller.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final c = Get.find<AttendanceController>();

  final MobileScannerController cam = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool locked = false;
  bool isFrontCamera = false;

  @override
  void dispose() {
    cam.dispose();
    super.dispose();
  }

  Future<void> _switchCamera() async {
    try {
      await cam.switchCamera();
      setState(() => isFrontCamera = !isFrontCamera);
    } catch (e) {
      debugPrint("Gagal switch kamera: $e");
    }
  }

  // POPUP CEPAT
  void _showPopup(bool success, String message) {
    if (Get.isDialogOpen == true) Get.back();

    Get.dialog(
      Center(
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
                size: 55,
              ),
              const SizedBox(height: 10),
              Text(
                success ? "Berhasil" : "Gagal",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      if (Get.isDialogOpen == true) Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Scan QR", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFrontCamera
                  ? Icons.camera_rear_rounded
                  : Icons.camera_front_rounded,
              color: Colors.white,
            ),
            onPressed: _switchCamera,
          ),
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: () {
              if (!isFrontCamera) {
                cam.toggleTorch();
              } else {
                Get.snackbar(
                  "Info",
                  "Flash hanya kamera belakang",
                  colorText: Colors.white,
                  backgroundColor: Colors.black54,
                );
              }
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          MobileScanner(
            controller: cam,
            onDetect: (capture) async {
              final qr = capture.barcodes.first.rawValue;
              if (qr == null) return;

              if (locked) return; // cegah double scan
              locked = true;

              // proses scan
              await c.processScan(qr);

              // popup
              _showPopup(c.lastSuccess.value, c.lastMessage.value);

              // delay sangat singkat
              await Future.delayed(const Duration(milliseconds: 300));
              locked = false;
            },
          ),

          // FRAME
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70, width: 2),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              "Arahkan QR ke kotak",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(.85),
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
