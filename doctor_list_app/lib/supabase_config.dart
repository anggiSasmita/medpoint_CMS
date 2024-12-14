import 'package:supabase_flutter/supabase_flutter.dart';

// Set up your Supabase URL and anon key here
class SupabaseConfig {
  static final client = Supabase.instance.client;
  
  // You should initialize Supabase somewhere in your app, for example in main.dart.
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://gercqdrpnwbungwtmigf.supabase.co', // Your Supabase URL
      anonKey: 'yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcmNxZHJwbndidW5nd3RtaWdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3NTM2MjEsImV4cCI6MjA0OTMyOTYyMX0.hR0Ndvu6lMmGmQDww6_G5SFMfdghUUcc5mkZpwKwPn0', // Your Supabase anon key
    );
  }
}
