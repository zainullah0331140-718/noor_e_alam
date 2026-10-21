import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:noor_e_amal/db/app_database.dart';
import 'package:noor_e_amal/db/enums.dart';
import 'package:noor_e_amal/db/seed_service.dart';
import 'package:noor_e_amal/utils/date_utils_ext.dart';
import 'package:noor_e_amal/l10n/app_localizations.dart';
import 'package:noor_e_amal/presentation/widgets/charts/donut_chart.dart';
import 'package:noor_e_amal/presentation/widgets/charts/progress_ring.dart';
import 'package:noor_e_amal/presentation/widgets/namaz/daily_summary_bar.dart';
import 'package:noor_e_amal/theme/app_theme.dart';

/// Widget + data-layer tests for Phase 2 (Namaz & Nafl).
///
/// NOTE: the full HomeShell mounts drift `watch()` streams via the
/// dashboard. Under flutter_test's fake-async clock those streams do not
/// settle and the pump loop hangs, so the shell/screens are verified by
/// running the app. Here we cover pure widgets + the DAO data layer.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget harness(Widget child) => MaterialApp(
    theme: AppTheme.light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('Localization resolves Phase 2 prayer + nafl labels', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      harness(
        Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return Text(l10n.prayerFajr);
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Fajr'), findsOneWidget);
    expect(l10n.prayerWitr, 'Witr');
    expect(l10n.naflTahajjud, 'Tahajjud');
    expect(l10n.tabQaza, 'Qaza');
    expect(
      l10n.summaryLine(1, 2, 3, 4),
      '1 Jamaat · 2 Alone · 3 Missed · 4 Remaining',
    );
  });

  testWidgets('DonutChart renders its centre label', (tester) async {
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

  testWidgets('DailySummaryBar renders the four J/A/M/R legend rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        const DailySummaryBar(jamaat: 3, alone: 1, missed: 1, remaining: 1),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byType(DonutChart), findsOneWidget);
    expect(find.text('Jamaat'), findsWidgets);
    expect(find.text('Alone'), findsWidgets);
    expect(find.text('Missed'), findsWidgets);
    expect(find.text('Remaining'), findsWidgets);
  });

  testWidgets('ProgressRing renders its centre labels', (tester) async {
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

  test('Namaz DAO auto-creates and clears qaza rows', () async {
    final dao = db.namazDao;
    const ymd = '2026-01-01';

    await dao.upsertStatus(
      date: ymd,
      prayer: NamazType.fajr,
      status: NamazStatus.missed,
    );
    var pending = await db.qazaDao.watchPendingCounts().first;
    expect(pending[NamazType.fajr], 1);

    // Marking it prayed later voids the auto qaza.
    await dao.upsertStatus(
      date: ymd,
      prayer: NamazType.fajr,
      status: NamazStatus.jamaat,
      atMasjid: true,
    );
    pending = await db.qazaDao.watchPendingCounts().first;
    expect(pending[NamazType.fajr], 0);
  });

  test('Namaz range counts tally jamaat/alone/missed', () async {
    const ymd = '2026-02-02';
    await db.namazDao.upsertStatus(
      date: ymd,
      prayer: NamazType.fajr,
      status: NamazStatus.jamaat,
    );
    await db.namazDao.upsertStatus(
      date: ymd,
      prayer: NamazType.zuhr,
      status: NamazStatus.alone,
    );
    await db.namazDao.upsertStatus(
      date: ymd,
      prayer: NamazType.asr,
      status: NamazStatus.missed,
    );
    final counts = await db.namazDao.getDay(ymd);
    expect(counts.length, 3);
  });

  test('Nafl DAO stores fixed + custom rows and totals rakats', () async {
    const ymd = '2026-03-03';
    await db.naflDao.upsertFixed(
      date: ymd,
      type: NaflType.tahajjud,
      done: true,
      rakats: 2,
    );
    await db.naflDao.upsertCustom(
      date: ymd,
      name: 'Salat-e-KanZ',
      done: true,
      rakats: 4,
    );
    final rows = await db.naflDao.watchDay(ymd).first;
    expect(rows.length, 2);

    final totals = await db.naflDao.rangeTotals(
      DateRangeShim(ymd, ymd).toRange(),
    );
    expect(totals.rakats, 6);
  });

  test('Seed service fills the DB once and is idempotent', () async {
    await db.seedIfEmptyForTesting();
    final first = await db.select(db.namazEntries).get();
    expect(first, isNotEmpty);

    await db.seedIfEmptyForTesting();
    final second = await db.select(db.namazEntries).get();
    expect(second.length, first.length);
  });
}

/// Inclusive single-day range helper for tests.
class DateRangeShim {
  final String start;
  final String end;
  const DateRangeShim(this.start, this.end);
  DateRange toRange() => DateRange(startYmd: start, endYmd: end);
}

/// Test-only conveniences that keep the seed helper off the production API.
extension _TestDbExt on AppDatabase {
  Future<void> seedIfEmptyForTesting() => SeedService(this).seedIfEmpty();
}
