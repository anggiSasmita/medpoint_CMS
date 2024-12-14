import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Map<String, dynamic>> doctors = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  // Function to fetch doctor data from the API
  Future<void> loadDoctors() async {
    try {
      final data = await fetchDoctors();
      setState(() {
        doctors = data;
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

  // Fetch doctors from the API
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      final response = await http.get(
        Uri.parse('https://gercqdrpnwbungwtmigf.supabase.co/rest/v1/doctors?select=*'),
        headers: {
          'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcmNxZHJwbndidW5nd3RtaWdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3NTM2MjEsImV4cCI6MjA0OTMyOTYyMX0.hR0Ndvu6lMmGmQDww6_G5SFMfdghUUcc5mkZpwKwPn0',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcmNxZHJwbndidW5nd3RtaWdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3NTM2MjEsImV4cCI6MjA0OTMyOTYyMX0.hR0Ndvu6lMmGmQDww6_G5SFMfdghUUcc5mkZpwKwPn0', // Replace with your Supabase anon key
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Data fetched: $data');
        
        // Check if we received valid data
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        backgroundColor: Colors.blue[950],
        title: Text(
          '800 DOCTOR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 16)))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return DoctorCard(
                      name: doctor['name'],
                      specialization: doctor['specialization'],
                      contact: doctor['contact'],  // Display contact info
                    );
                  },
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
    return Card(
      color: Colors.blue[950],
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Add an avatar or placeholder image (optional)
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    specialization,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    contact,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
