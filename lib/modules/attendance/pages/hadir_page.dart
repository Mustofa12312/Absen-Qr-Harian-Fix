import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';

class HadirPage extends StatelessWidget {
  const HadirPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AttendanceController>();

    return Scaffold(
      backgroundColor: Colors.transparent, // supaya background app terlihat

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Daftar Hadir",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          // =========================================================
          //             GLASSMORPHIC DROPDOWN FILTER
          // =========================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              final sorted = c.allClasses.toList()
                ..sort((a, b) => a.id.compareTo(b.id));

              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(.35)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: c.selectedClassId.value,
                        isExpanded: true,
                        dropdownColor: Colors.white.withOpacity(0.85),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        items: sorted.map((cls) {
                          return DropdownMenuItem(
                            value: cls.id,
                            child: Text(
                              cls.namaKelas,
                              style: const TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) => c.changeClass(v!),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // =========================================================
          //            LIST HADIR — GLASS FLOATING CARD
          // =========================================================
          Expanded(
            child: Obx(() {
              final data = c.hadirList;

              if (data.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada yang hadir.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final s = data[i];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.23),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.30),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.green.withOpacity(.18),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.green,
                                  size: 26,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.nama,
                                      softWrap: true, // auto wrap nama panjang
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Kelas: ${s.namaKelas}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
