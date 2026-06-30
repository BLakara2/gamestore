import 'package:flutter_test/flutter_test.dart';
import 'package:gamestore/main.dart';

void main() {
  testWidgets('App shows profile page first', (WidgetTester tester) async {
    await tester.pumpWidget(const DateApp());
    expect(find.text('Nom Facebook'), findsOneWidget);
    expect(find.text('Date de naissance'), findsOneWidget);
  });
}
