import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../screens/azkar_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/gheebat_screen.dart';
import '../screens/khatam_screen.dart';
import '../screens/muraqaba_screen.dart';
import '../screens/nafl_screen.dart';
import '../screens/namaz_screen.dart';
import '../screens/ramadan_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/tilawat_screen.dart';
import '../screens/timetable_screen.dart';

/// A top-level destination in the navigation shell.
class _Destination {
  final String Function(AppLocalizations) label;
  final IconData icon;
  final Widget Function() build;
  const _Destination(this.label, this.icon, this.build);
}

/// Responsive app shell: NavigationDrawer on phones, NavigationRail on
/// wider layouts. Also exposes an overflow menu listing every future module.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  static final _destinations = <_Destination>[
    _Destination(
      (l) => l.moduleDashboard,
      Icons.dashboard_outlined,
      () => const DashboardScreen(),
    ),
    _Destination(
      (l) => l.moduleNamaz,
      Icons.mosque_outlined,
      () => const NamazScreen(),
    ),
    _Destination(
      (l) => l.moduleNafl,
      Icons.auto_awesome_outlined,
      () => const NaflScreen(),
    ),
    _Destination(
      (l) => l.moduleTilawat,
      Icons.menu_book_outlined,
      () => const TilawatScreen(),
    ),
    _Destination(
      (l) => l.moduleAzkar,
      Icons.radio_button_checked,
      () => const AzkarScreen(),
    ),
    _Destination(
      (l) => l.moduleKhatam,
      Icons.bookmark_added_outlined,
      () => const KhatamScreen(),
    ),
    _Destination(
      (l) => l.moduleGheebat,
      Icons.record_voice_over_outlined,
      () => const GheebatScreen(),
    ),
    _Destination(
      (l) => l.moduleMuraqaba,
      Icons.spa_outlined,
      () => const MuraqabaScreen(),
    ),
    _Destination(
      (l) => l.moduleTimetable,
      Icons.checklist_outlined,
      () => const TimetableScreen(),
    ),
    _Destination(
      (l) => l.moduleRamadan,
      Icons.nightlight_outlined,
      () => const RamadanScreen(),
    ),
    _Destination(
      (l) => l.moduleReports,
      Icons.picture_as_pdf_outlined,
      () => const ReportsScreen(),
    ),
    _Destination(
      (l) => l.moduleSettings,
      Icons.settings_outlined,
      () => const SettingsScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wide = MediaQuery.sizeOf(context).width >= 900;

    final body = IndexedStack(
      index: _index,
      children: [
        for (final d in _destinations) d.build(),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_destinations[_index].label(l10n)),
      ),
      drawer: wide
          ? null
          : NavigationDrawer(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              children: [
                _drawerHeader(context, l10n),
                for (final d in _destinations)
                  NavigationDrawerDestination(
                    icon: Icon(d.icon),
                    label: Text(d.label(l10n)),
                  ),
              ],
            ),
      body: wide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  labelType: NavigationRailLabelType.all,
                  // Eleven destinations do not fit a short window; scroll the
                  // group instead of overflowing the rail.
                  scrollable: true,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Icon(
                      Icons.nightlight_round,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  destinations: [
                    for (final d in _destinations)
                      NavigationRailDestination(
                        icon: Icon(d.icon),
                        label: Text(d.label(l10n)),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            )
          : body,
    );
  }

  Widget _drawerHeader(BuildContext context, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.navigationTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(l10n.phaseFourBanner,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
