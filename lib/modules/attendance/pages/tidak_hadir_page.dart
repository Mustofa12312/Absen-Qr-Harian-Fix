import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';

class TidakHadirPage extends StatelessWidget {
  const TidakHadirPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AttendanceController>();

    return Scaffold(
      appBar: AppBar(title: Text("Tidak Hadir")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Obx(() {
              return DropdownButton<int>(
                value: c.selectedClassId.value,
                items: c.allClasses
                    .map(
                      (cls) => DropdownMenuItem(
                        value: cls.id,
                        child: Text(cls.namaKelas),
                      ),
                    )
                    .toList(),
                onChanged: (v) => c.changeClass(v!),
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              final data = c.tidakHadirList;

              if (data.isEmpty) {
                return Center(child: Text("Semua hadir 🎉"));
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final s = data[i];
                  return Card(
                    child: ListTile(
                      title: Text(s.nama),
                      subtitle: Text("Kelas: ${s.namaKelas}"),
                      trailing: Icon(Icons.close, color: Colors.red),
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
