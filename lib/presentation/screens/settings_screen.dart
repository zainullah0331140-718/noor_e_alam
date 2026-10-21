import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/khatam_providers.dart';
import '../../providers/settings_providers.dart';
import '../../providers/tilawat_providers.dart';
import '../../utils/numerals.dart';

/// Settings: appearance, language, numerals, prayer-times location and the
/// nafl daily goal. All values persist through the Phase 1 providers.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final numerals = ref.watch(numeralsProvider);
    final loc = ref.watch(locationProvider);
    final goal = ref.watch(naflGoalProvider);
    final tilawatUnit = ref.watch(tilawatUnitProvider);
    final tilawatGoal = ref.watch(tilawatGoalProvider);
    final khatamGoal = ref.watch(khatamGoalProvider);

    void saved() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsSaved)),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        _SectionHeader(l10n.settingsGeneral),
        _Tile(
          icon: Icons.translate,
          title: l10n.settingsLanguage,
          trailing: DropdownButton<String>(
            value: locale?.languageCode ?? 'system',
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(value: 'system', child: Text(l10n.themeSystem)),
              DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
              DropdownMenuItem(value: 'ur', child: Text(l10n.languageUrdu)),
            ],
            onChanged: (v) {
              ref
                  .read(localeProvider.notifier)
                  .setLocale(v == 'system' ? null : v);
              saved();
            },
          ),
        ),
        _Tile(
          icon: Icons.palette_outlined,
          title: l10n.settingsAppearance,
          trailing: DropdownButton<ThemeMode>(
            value: themeMode,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(l10n.themeSystem),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(l10n.themeLight),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(l10n.themeDark),
              ),
            ],
            onChanged: (v) {
              if (v != null) {
                ref.read(themeModeProvider.notifier).set(v);
                saved();
              }
            },
          ),
        ),
        _Tile(
          icon: Icons.numbers,
          title: l10n.settingsNumerals,
          trailing: DropdownButton<bool>(
            value: numerals,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(
                value: false,
                child: Text(l10n.numeralsWestern),
              ),
              DropdownMenuItem(
                value: true,
                child: Text(l10n.numeralsEastern),
              ),
            ],
            onChanged: (v) {
              if (v != null) {
                ref.read(numeralsProvider.notifier).set(v);
                saved();
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        _SectionHeader(l10n.settingsPrayerTimes),
        _Tile(
          icon: Icons.location_on_outlined,
          title: l10n.settingsLocation,
          trailing: DropdownButton<String>(
            value: loc.name,
            underline: const SizedBox.shrink(),
            items: [
              for (final c in PrayerLocation.cities)
                DropdownMenuItem(value: c.name, child: Text(c.name)),
            ],
            onChanged: (v) {
              final city = PrayerLocation.cities.firstWhere(
                (c) => c.name == v,
                orElse: () => loc,
              );
              ref.read(locationProvider.notifier).set(city);
              saved();
            },
          ),
        ),
        _Tile(
          icon: Icons.flag_outlined,
          title: l10n.settingsNaflGoal,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: goal > 2
                    ? () => ref.read(naflGoalProvider.notifier).set(goal - 2)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                formatNum(goal, numerals),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: () => ref.read(naflGoalProvider.notifier).set(goal + 2),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _SectionHeader(l10n.settingsTilawatSection),
        _Tile(
          icon: Icons.straighten,
          title: l10n.settingsTilawatUnit,
          trailing: DropdownButton<TilawatUnit>(
            value: tilawatUnit,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(
                value: TilawatUnit.pages,
                child: Text(l10n.unitPages),
              ),
              DropdownMenuItem(
                value: TilawatUnit.ruku,
                child: Text(l10n.unitRuku),
              ),
              DropdownMenuItem(
                value: TilawatUnit.para,
                child: Text(l10n.unitPara),
              ),
              DropdownMenuItem(
                value: TilawatUnit.minutes,
                child: Text(l10n.unitMinutes),
              ),
            ],
            onChanged: (v) {
              if (v != null) {
                ref.read(tilawatUnitProvider.notifier).set(v);
                saved();
              }
            },
          ),
        ),
        _Tile(
          icon: Icons.flag_outlined,
          title: l10n.settingsTilawatGoal,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: tilawatGoal > 1
                    ? () => ref
                          .read(tilawatGoalProvider.notifier)
                          .set(tilawatGoal - 1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                formatNum(tilawatGoal, numerals),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: () => ref
                    .read(tilawatGoalProvider.notifier)
                    .set(tilawatGoal + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
        _Tile(
          icon: Icons.menu_book,
          title: l10n.settingsKhatamGoal,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: khatamGoal > 1
                    ? () => ref
                          .read(khatamGoalProvider.notifier)
                          .set(khatamGoal - 1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                formatNum(khatamGoal, numerals),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                onPressed: () => ref
                    .read(khatamGoalProvider.notifier)
                    .set(khatamGoal + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _SectionHeader(l10n.settingsAbout),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(l10n.appName),
            subtitle: Text(l10n.phaseThreeBanner),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  const _Tile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing,
      ),
    );
  }
}
