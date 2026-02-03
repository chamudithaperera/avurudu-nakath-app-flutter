import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avurudu_nakath_app/features/splash/presentation/pages/splash_screen.dart';

void main() {
  testWidgets('Splash screen pumps correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(Image), findsOneWidget); // Sun image
  });
}
