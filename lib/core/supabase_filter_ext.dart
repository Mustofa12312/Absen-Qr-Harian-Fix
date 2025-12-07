import 'package:supabase_flutter/supabase_flutter.dart';

extension PostgrestFilterExt on PostgrestFilterBuilder {
  PostgrestFilterBuilder maybeEq(String column, dynamic value) {
    if (value == null) return this;
    return eq(column, value);
  }
}
