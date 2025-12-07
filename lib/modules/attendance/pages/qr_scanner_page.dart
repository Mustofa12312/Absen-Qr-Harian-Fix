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
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back, // KAMERA BELAKANG DEFAULT
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
      setState(() {
        isFrontCamera = !isFrontCamera;
      });
    } catch (e) {
      debugPrint("Gagal switch kamera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Scan QR"),
        backgroundColor: Colors.black,
        actions: [
          // ===============================
          // Tombol Switch Kamera
          // ===============================
          IconButton(
            tooltip: "Ganti Kamera",
            icon: Icon(
              isFrontCamera
                  ? Icons.camera_rear_rounded
                  : Icons.camera_front_rounded,
              color: Colors.white,
            ),
            onPressed: _switchCamera,
          ),

          // ===============================
          // Flash — hanya bekerja di kamera belakang
          // ===============================
          IconButton(
            tooltip: "Flash",
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: () async {
              if (!isFrontCamera) {
                await cam.toggleTorch();
              } else {
                Get.snackbar(
                  "Info",
                  "Flash hanya tersedia di kamera belakang",
                  colorText: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.5),
                );
              }
            },
          ),

          IconButton(
            tooltip: "Refresh kamera",
            icon: const Icon(Icons.refresh),
            onPressed: () => cam.start(),
          ),
        ],
      ),

      body: Stack(
        children: [
          MobileScanner(
            controller: cam,
            onDetect: (capture) async {
              if (locked) return;

              final qr = capture.barcodes.first.rawValue;
              if (qr == null) return;

              locked = true;

              await c.processScan(qr);

              // Scan berikutnya siap dalam 300 ms
              await Future.delayed(const Duration(milliseconds: 300));
              locked = false;
            },
          ),

          // FRAME / BORDER SCAN
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
          ),

          // TEXT PETUNJUK
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                "Arahkan QR ke dalam kotak",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
