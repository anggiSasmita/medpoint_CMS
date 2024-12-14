import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'supabase_config.dart'; // Pastikan untuk mengimpor SupabaseConfig

Future<void> main() async {
  // Load .env file
  await dotenv.load(fileName: ".env");

  // Inisialisasi Supabase
  await SupabaseConfig.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final supabaseApiKey = dotenv.env['SUPABASE_API_KEY']!;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Supabase Example')),
        body: Center(
          child: Text('URL: $supabaseUrl\nKey: $supabaseApiKey'),
        ),
      ),
    );
  }
}
