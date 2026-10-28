import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:noor_e_amal/db/app_database.dart';
import 'package:noor_e_amal/l10n/app_localizations.dart';
import 'package:noor_e_amal/presentation/screens/reports_screen.dart';
import 'package:noor_e_amal/providers/app_providers.dart';
import 'package:noor_e_amal/providers/report_bundle_providers.dart';
import 'package:noor_e_amal/theme/app_theme.dart';
import 'package:noor_e_amal/utils/date_utils_ext.dart';
import 'package:noor_e_amal/utils/streak_utils.dart';

ReportBundle _bundle() => ReportBundle(
  range: const DateRange(startYmd: '2026-10-01', endYmd: '2026-10-31'),
  rangeLabel: '2026-10',
  generatedAt: DateTime(2026, 10, 22),
  rows: const [
    ReportRow(
      key: 'namaz',
      labelEn: 'Namaz (5 Fard + Witr)',
      labelUr: 'نماز (پانچ فرض + وتر)',
      done: 120,
      total: 186,
    ),
    ReportRow(
      key: 'nafl',
      labelEn: 'Nafl (rakats)',
      labelUr: 'نفل (رکعتیں)',
      done: 18,
      total: 18,
    ),
    ReportRow(
      key: 'tilawat',
      labelEn: 'Tilawat (pages)',
      labelUr: 'تلاوت (صفحات)',
      done: 6,
      total: 248,
    ),
    ReportRow(
      key: 'azkar',
      labelEn: 'Azkar',
      labelUr: 'اذکار',
      done: 5,
      total: 7006,
    ),
    ReportRow(
      key: 'gheebat',
      labelEn: 'Gheebat-free days',
      labelUr: 'غیبت سے پاک دن',
      done: 3,
      total: 3,
    ),
    ReportRow(
      key: 'muraqaba',
      labelEn: 'Muraqaba (minutes)',
      labelUr: 'مراقبہ (منٹ)',
      done: 15,
      total: 30,
    ),
    ReportRow(
      key: 'khatam',
      labelEn: 'Quran khatam',
      labelUr: 'ختمِ قرآن',
      done: 1,
      total: 1,
    ),
    ReportRow(
      key: 'ramadan',
      labelEn: 'Ramadan fasts',
      labelUr: 'رمضان کے روزے',
      done: 0,
      total: 30,
    ),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('report anchor', () {
    test('shifts by the selected period', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(reportAnchorProvider.notifier);
      DateTime anchor() => container.read(reportAnchorProvider);

      notifier.set(DateTime(2026, 1, 31));
      notifier.shiftPeriod(ReportPeriod.day, 1);
      expect(anchor(), DateTime(2026, 2, 1));

      notifier.set(DateTime(2026, 1, 31));
      notifier.shiftPeriod(ReportPeriod.month, 1);
      expect(anchor(), DateTime(2026, 2, 28));

      notifier.set(DateTime(2026, 1, 31));
      notifier.shiftPeriod(ReportPeriod.year, 1);
      expect(anchor(), DateTime(2027, 1, 31));

      notifier.set(DateTime(2026, 1, 31));
      notifier.shiftPeriod(ReportPeriod.month, -1);
      expect(anchor(), DateTime(2025, 12, 31));
    });

    test('leap day clamps when shifting a year back', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(reportAnchorProvider.notifier);

      notifier.set(DateTime(2028, 2, 29));
      notifier.shiftPeriod(ReportPeriod.year, -1);
      expect(container.read(reportAnchorProvider), DateTime(2027, 2, 28));
    });
  });

  group('report bundle', () {
    test('current month is reported to date, not into the future', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [
          dbProvider.overrideWithValue(db),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(db.close);

      final bundle = await container.read(reportBundleProvider.future);
      final now = DateTime.now();
      final elapsedDays = daysInRange(
        DateUtilsExt.ymd(DateTime(now.year, now.month, 1)),
        DateUtilsExt.ymd(now),
      );

      expect(bundle.range.endYmd, DateUtilsExt.ymd(now));
      expect(bundle.rows.first.total, elapsedDays * 6);
    });
  });

  group('reports screen layout', () {
    for (final locale in ['en', 'ur']) {
      testWidgets('fits a 320dp phone without overflow ($locale)', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(960, 2000);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.reset);

        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPrefsProvider.overrideWithValue(prefs),
              reportBundleProvider.overrideWith((ref) async => _bundle()),
            ],
            child: MaterialApp(
              locale: Locale(locale),
              theme: AppTheme.light(),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const Scaffold(body: ReportsScreen()),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(ReportsScreen), findsOneWidget);
        expect(find.text(locale == 'ur' ? 'اذکار' : 'Azkar'), findsWidgets);
      });
    }
  });
}
