import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_e_amal/l10n/app_localizations.dart';
import 'package:noor_e_amal/presentation/widgets/charts/donut_chart.dart';
import 'package:noor_e_amal/presentation/widgets/charts/progress_ring.dart';
import 'package:noor_e_amal/theme/app_theme.dart';

void main() {
  // NOTE: DB-backed screens (dashboard/namaz/nafl) are intentionally NOT
  // mounted here. Drift's `watch()` streams deadlock inside flutter_test's
  // fake-async zone, so those modules are covered by the DAO unit tests in
  // widget_test.dart instead. These tests verify the pure widgets.

  Widget harness(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('DonutChart renders slices and centre label', (tester) async {
    await tester.pumpWidget(
      harness(
        const DonutChart(
          slices: [
            DonutSlice(label: 'A', value: 3, color: Color(0xFF1F8F4E)),
            DonutSlice(label: 'B', value: 1, color: Color(0xFFD32F2F)),
          ],
          centerTop: '75%',
          centerBottom: 'Completion',
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('75%'), findsOneWidget);
    expect(find.text('Completion'), findsOneWidget);
  });

  testWidgets('ProgressRing shows value text and animates', (tester) async {
    await tester.pumpWidget(
      harness(
        const ProgressRing(
          progress: 0.5,
          centerTop: '12',
          centerBottom: '/24',
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('12'), findsOneWidget);
    expect(find.text('/24'), findsOneWidget);
  });
}
