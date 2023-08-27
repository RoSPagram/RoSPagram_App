import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

void initSupabase() async {
  await Supabase.initialize(
    url: '',
    anonKey: '',
  );
}

