import 'package:flutter_test/flutter_test.dart';
import 'package:civicvoice/main.dart';

void main() {
  testWidgets('CivicVoice app launches and renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CivicVoiceApp());
    expect(find.text('CivicVoice'), findsOneWidget);

    // Settle the splash screen transition timer (1400ms)
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Verify it transitioned to Citizen Login
    expect(find.text('Citizen Login'), findsOneWidget);
  });
}
