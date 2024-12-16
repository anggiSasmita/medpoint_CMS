import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'supabase_config.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await SupabaseConfig.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DoctorListScreen(),
    );
  }
}

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      final data = await fetchDoctors();
      setState(() {
        doctors = data;
        filteredDoctors = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load doctors: $e';
      });
      print('Error fetching doctors: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      final response = await http.get(
        Uri.parse('https://gercqdrpnwbungwtmigf.supabase.co/rest/v1/doctor?select=*'),
        headers: {
          'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcmNxZHJwbndidW5nd3RtaWdmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMzc1MzYyMSwiZXhwIjoyMDQ5MzI5NjIxfQ.AqeZ9suMzEqT2MzBMR9Xe9abnXn2_CB3OQy2tV_nVV8',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcmNxZHJwbndidW5nd3RtaWdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3NTM2MjEsImV4cCI6MjA0OTMyOTYyMX0.hR0Ndvu6lMmGmQDww6_G5SFMfdghUUcc5mkZpwKwPn0',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('No doctors found in the response');
        }

        return data.map((doctor) {
          return {
            'name': doctor['name'] ?? 'Unknown Doctor',
            'specialization': doctor['specialization'] ?? 'Unknown Specialization',
            'contact': doctor['contact'] ?? 'No Contact Info',
          };
        }).toList();
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
      rethrow;
    }
  }

  void filterDoctors(String query) {
    setState(() {
      searchQuery = query;
      filteredDoctors = doctors
          .where((doctor) =>
              doctor['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/mediverse.png',
          height: 30,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF003366), Color(0xFF9A4D97), Color(0xFF6A1B9A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              // Handle menu actions
              print("Selected: $value");
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: "Settings", child: Text("Settings")),
                PopupMenuItem(value: "Profile", child: Text("Profile")),
                PopupMenuItem(value: "Schedule", child: Text("Schedule")),
                PopupMenuItem(value: "About", child: Text("About")),
                PopupMenuItem(value: "Logout", child: Text("Logout")),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: filterDoctors,
                    decoration: InputDecoration(
                      labelText: 'Find your doctor',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    backgroundColor: Colors.blue,
                  ),
                  child: Icon(Icons.search),
                ),
              ],
            ),
          ),
          // Doctor list section
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: filteredDoctors.length > 8
                            ? 8
                            : filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = filteredDoctors[index];
                          return DoctorCard(
                            name: doctor['name'],
                            specialization: doctor['specialization'],
                            contact: doctor['contact'],
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String contact;

  DoctorCard({
    required this.name,
    required this.specialization,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    // Construct the image path using the doctor's name or any identifier
    String imagePath = 'assets/images/${name.toLowerCase().replaceAll(' ', '_')}.png'; // Example based on name

    return Card(
      color: Colors.purple[50], // Set card color to light purple
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
              onBackgroundImageError: (_, __) => Image.asset('assets/images/default.png'),
            ),
            SizedBox(height: 8),
            Text(
            name,
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color.fromARGB(255, 42, 5, 87), // Dark purple color
                  ),
                 textAlign: TextAlign.center,
            ),
            Text(
              specialization,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              contact,
              style: TextStyle(fontSize: 12, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
