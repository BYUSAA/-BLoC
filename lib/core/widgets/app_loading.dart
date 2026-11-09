import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.label = 'Loading',
    this.compact = false,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox.square(
      dimension: compact ? 20 : 28,
      child: const CircularProgressIndicator(strokeWidth: 2.5),
    );

    if (compact) {
      return Semantics(
        label: label,
        child: indicator,
      );
    }

    return Center(
      child: Semantics(
        label: label,
        liveRegion: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            indicator,
            const SizedBox(height: 12),
            Text(label),
          ],
        ),
      ),
    );
  }
}
