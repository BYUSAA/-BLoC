import 'package:flutter/material.dart';

class RecordsEmptyState extends StatelessWidget {
  const RecordsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 52),
            SizedBox(height: 12),
            Text(
              'No records yet. Add your first one.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
