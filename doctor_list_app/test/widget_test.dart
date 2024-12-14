import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_list_app/main.dart'; // Importing the main file

void main() {
  testWidgets('Doctor List Smoke Test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Use MyApp instead of DoctorApp

    // Add test code to verify the UI as needed
    // For example, checking if the title is present
    expect(find.text('800 DOCTOR'), findsOneWidget);
  });
}
