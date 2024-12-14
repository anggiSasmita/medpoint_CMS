import 'supabase_config.dart';

Future<List<Map<String, dynamic>>> fetchDoctors() async {
  final response = await SupabaseConfig.client
      .from('doctor')  // Access the 'doctor' table
      .select('*')      // Select all columns
      .limit(100)       // Optionally, limit the number of rows
      .then((data) {
        return data;
      })
      .catchError((error) {
        throw Exception('Failed to load doctors: $error');
      });

  // Check for any error in the response (if needed)
  if (response.isEmpty) {
    throw Exception('Failed to load doctors: No data found.');
  }

  return List<Map<String, dynamic>>.from(response);
}
