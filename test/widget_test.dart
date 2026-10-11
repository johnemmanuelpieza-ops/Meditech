import 'package:flutter_test/flutter_test.dart';

import 'package:meditech/main.dart';

void main() {
  testWidgets('Landing screen shows main content', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MediTech'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}