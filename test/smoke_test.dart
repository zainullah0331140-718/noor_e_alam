import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:noor_e_amal/db/daos/namaz_dao.dart';
import 'package:noor_e_amal/l10n/app_localizations.dart';
import 'package:noor_e_amal/presentation/screens/dashboard_screen.dart';
import 'package:noor_e_amal/providers/app_providers.dart';
import 'package:noor_e_amal/providers/dashboard_providers.dart';
import 'package:noor_e_amal/providers/nafl_providers.dart';
import 'package:noor_e_amal/providers/namaz_providers.dart';
import 'package:noor_e_amal/theme/app_theme.dart';

/// Dashboard smoke test.
///
/// Drift `watch()` streams and native futures never settle under
/// flutter_test's fake-async clock, so every DB-backed provider the
/// dashboard reads is overridden with fixed data instead of mounting a
/// live in-memory database. This keeps the test fast and deterministic
/// while still verifying the dashboard's widget tree wires up correctly.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('dashboard smoke', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          dashboardProvider.overrideWith(
            (ref) async => const DashboardData(
              range: DashboardRange.today,
              prayers: DashboardStat(
                done: 4,
                total: 6,
                jamaat: 3,
                alone: 1,
                missed: 1,
              ),
              nafl: DashboardStat(done: 18, total: 24),
              tilawat: DashboardStat(done: 6, total: 8),
              azkar: DashboardStat(done: 5, total: 8),
              khatam: DashboardStat(done: 1, total: 2),
              gheebat: DashboardStat(done: 5, total: 7),
              muraqaba: DashboardStat(done: 30, total: 70),
              ramadan: DashboardStat(done: 12, total: 30),
              currentStreak: 5,
              bestStreak: 12,
              naflTodayRakats: 18,
            ),
          ),
          naflDayRakatsProvider.overrideWith(
            (ref, date) => const AsyncData(18),
          ),
          namazMonthProvider.overrideWith(
            (ref, month) async => {
              for (var i = 1; i <= 7; i++)
                '2026-10-${i.toString().padLeft(2, '0')}':
                    const NamazRangeCounts(
                      jamaat: 5,
                      alone: 1,
                      missed: 0,
                      none: 0,
                    ),
            },
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: DashboardScreen()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(DashboardScreen), findsOneWidget);
  });
}
