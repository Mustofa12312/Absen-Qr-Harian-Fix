class DateHelper {
  /// Mengambil awal hari (00:00) dari tanggal sekarang
  static DateTime startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Mengubah ke format ISO (untuk query Supabase)
  static String toIso(DateTime date) {
    return date.toIso8601String();
  }

  /// Apakah dua tanggal berada pada hari yang sama
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
