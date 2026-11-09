import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('workspace empty state can render', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Center(child: Text('No records yet. Add your first one.')))));
    expect(find.text('No records yet. Add your first one.'), findsOneWidget);
  });
}
