import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_list_app/main.dart'; // Import the correct file that contains your main app widget.

void main() {
  testWidgets('DoctorListScreen displays a loading indicator initially', (WidgetTester tester) async {
    // Build the widget tree and trigger a frame
    await tester.pumpWidget(MaterialApp(home: DoctorListScreen()));

    // Verify that the loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DoctorListScreen displays doctor list when loaded', (WidgetTester tester) async {
    // You can mock your fetchDoctors() response if needed or trigger the loading manually
    await tester.pumpWidget(MaterialApp(home: DoctorListScreen()));

    // Wait for the screen to load and display the data
    await tester.pumpAndSettle();

    // Verify that the doctor list is shown (replace this with real data checks)
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(DoctorCard), findsWidgets);
  });
}
