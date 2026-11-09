import 'package:bloc_assignment_app/features/records/presentation/widgets/records_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('records empty state explains the next action', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: RecordsEmptyState()),
      ),
    );

    expect(
      find.text('No records yet. Add your first one.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });
}
