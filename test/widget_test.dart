import 'package:flutter_test/flutter_test.dart';
import 'package:pemmob/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    await tester.pumpWidget(const PemmobApp());
    expect(find.text('Pemrograman Mobile (CR002)'), findsOneWidget);
  });
}
