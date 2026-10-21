import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../screens/azkar_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/khatam_screen.dart';
import '../screens/nafl_screen.dart';
import '../screens/namaz_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/tilawat_screen.dart';
import '../widgets/module_placeholder.dart';

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
      (l) => l.moduleSettings,
      Icons.settings_outlined,
      () => const SettingsScreen(),
    ),
  ];

  /// Remaining modules (Phase 4+) exposed via the app-bar overflow menu.
  static final _futureMenu = <String Function(AppLocalizations)>[
    (l) => l.moduleTimetable,
    (l) => l.moduleGheebat,
    (l) => l.moduleMuraqaba,
    (l) => l.moduleRamadan,
    (l) => l.moduleReports,
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
        actions: [
          PopupMenuButton<int>(
            tooltip: l10n.menu,
            icon: const Icon(Icons.apps),
            onSelected: (i) {
              if (i < _destinations.length) {
                setState(() => _index = i);
              } else {
                _showComingSoon(
                  context,
                  _futureMenu[i - _destinations.length](l10n),
                );
              }
            },
            itemBuilder: (context) => [
              for (var i = 0; i < _destinations.length; i++)
                PopupMenuItem(
                  value: i,
                  child: Row(
                    children: [
                      Icon(_destinations[i].icon, size: 18),
                      const SizedBox(width: 10),
                      Text(_destinations[i].label(l10n)),
                    ],
                  ),
                ),
              const PopupMenuDivider(),
              for (var i = 0; i < _futureMenu.length; i++)
                PopupMenuItem(
                  value: _destinations.length + i,
                  child: Text(_futureMenu[i](l10n)),
                ),
            ],
          ),
        ],
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
          Text(l10n.phaseThreeBanner,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: ModulePlaceholder(title: title),
        ),
      ),
    );
  }
}
