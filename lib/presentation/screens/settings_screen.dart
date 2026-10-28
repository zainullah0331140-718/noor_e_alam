import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/khatam_providers.dart';
import '../../providers/lock_providers.dart';
import '../../providers/settings_providers.dart';
import '../../providers/tilawat_providers.dart';
import '../../services/notification_service.dart';
import '../../utils/numerals.dart';
import '../widgets/gheebat/gheebat_pin_dialog.dart';

/// Settings: appearance, language, numerals, prayer-times location, the
/// nafl daily goal, notifications and JSON backup / restore. All values
/// persist through the Phase 1 providers.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  /// Asks for the notification permission and reports a refusal to the user.
  /// Returns whether reminders may be scheduled.
  Future<bool> _ensureNotificationPermission(AppLocalizations l10n) async {
    final granted = await NotificationService.instance.requestPermission();
    if (!granted && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsNotificationsDenied)));
    }
    return granted;
  }

  Future<void> _runBackup(
    WidgetRef ref,
    ScaffoldMessengerState messenger,
    AppLocalizations l10n,
    Future<void> Function() action,
  ) async {
    setState(() => _busy = true);
    try {
      await action();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.settingsBackupExported)));
    } catch (_) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.settingsBackupError)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportBackup() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    await _runBackup(ref, messenger, l10n, () async {
      final result = await ref.read(backupServiceProvider).exportToFile();
      if (!result.success) throw Exception(result.error);
    });
  }

  Future<void> _importBackup() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.restoreConfirmTitle),
        content: Text(l10n.settingsBackupImportConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelWord),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.restoreWord),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    final bytes = picked?.files.single.bytes;
    if (bytes == null) return;

    setState(() => _busy = true);
    try {
      final result = await ref
          .read(backupServiceProvider)
          .restoreFromBytes(bytes);
      if (!result.success) throw Exception(result.error);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.settingsBackupImported)));
    } catch (_) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.settingsBackupError)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setPin() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final pin = await showGheebatPinDialog(
      context,
      title: l10n.gheebatSetPin,
      actionLabel: l10n.gheebatSetPin,
      confirm: true,
    );
    if (pin == null) return;
    await ref.read(appLockProvider.notifier).setPin(pin);
    if (!mounted) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.gheebatPinSet)));
  }

  Future<void> _changePin() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final lock = ref.read(appLockProvider.notifier);
    final current = await showGheebatPinDialog(
      context,
      title: l10n.gheebatChangePin,
      actionLabel: l10n.gheebatUnlock,
      validate: (pin) => lock.verify(pin) ? null : l10n.gheebatWrongPin,
    );
    if (current == null || !mounted) return;

    final pin = await showGheebatPinDialog(
      context,
      title: l10n.gheebatSetPin,
      actionLabel: l10n.gheebatSetPin,
      confirm: true,
    );
    if (pin == null) return;
    await ref.read(appLockProvider.notifier).setPin(pin);
    if (!mounted) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.gheebatPinSet)));
  }

  Future<void> _removePin() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final lock = ref.read(appLockProvider.notifier);
    final pin = await showGheebatPinDialog(
      context,
      title: l10n.gheebatRemovePin,
      actionLabel: l10n.gheebatRemovePin,
      validate: (pin) => lock.verify(pin) ? null : l10n.gheebatWrongPin,
    );
    if (pin == null) return;
    final removed = await ref.read(appLockProvider.notifier).removePin(pin);
    if (!mounted) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            removed ? l10n.gheebatPinRemoved : l10n.gheebatWrongPin,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final numerals = ref.watch(numeralsProvider);
    final loc = ref.watch(locationProvider);
    final goal = ref.watch(naflGoalProvider);
    final tilawatUnit = ref.watch(tilawatUnitProvider);
    final tilawatGoal = ref.watch(tilawatGoalProvider);
    final khatamGoal = ref.watch(khatamGoalProvider);
    final notif = ref.watch(notificationPrefsProvider);
    final lock = ref.watch(appLockProvider);

    void saved() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
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
              DropdownMenuItem(value: false, child: Text(l10n.numeralsWestern)),
              DropdownMenuItem(value: true, child: Text(l10n.numeralsEastern)),
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
          icon: Icons.calculate_outlined,
          title: l10n.settingsPrayerMethod,
          trailing: SizedBox(
            width: 170,
            child: DropdownButton<String>(
              value: ref.watch(prayerMethodProvider).id,
              isExpanded: true,
              alignment: AlignmentDirectional.centerEnd,
              underline: const SizedBox.shrink(),
              items: [
                for (final option in PrayerMethodOption.options)
                  DropdownMenuItem(
                    value: option.id,
                    child: Text(option.label, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) {
                if (v == null) return;
                ref
                    .read(prayerMethodProvider.notifier)
                    .set(PrayerMethodOption.byId(v));
                saved();
              },
            ),
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
                onPressed: () =>
                    ref.read(naflGoalProvider.notifier).set(goal + 2),
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
                onPressed: () =>
                    ref.read(tilawatGoalProvider.notifier).set(tilawatGoal + 1),
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
                onPressed: () =>
                    ref.read(khatamGoalProvider.notifier).set(khatamGoal + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _SectionHeader(l10n.settingsNotificationsTitle),
        SwitchListTile(
          secondary: const Icon(Icons.notifications_active_outlined),
          title: Text(l10n.settingsNotificationsPrayer),
          subtitle: Text(l10n.settingsNotificationsPrayerBody),
          value: notif.prayer,
          onChanged: (v) async {
            if (v && !await _ensureNotificationPermission(l10n)) return;
            await ref.read(notificationPrefsProvider.notifier).setPrayer(v);
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.nightlight_outlined),
          title: Text(l10n.settingsNotificationsRoza),
          subtitle: Text(l10n.settingsNotificationsRozaBody),
          value: notif.roza,
          onChanged: (v) async {
            if (v && !await _ensureNotificationPermission(l10n)) return;
            await ref.read(notificationPrefsProvider.notifier).setRoza(v);
          },
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.notification_add_outlined),
            title: Text(l10n.settingsNotificationsTest),
            onTap: () async {
              await NotificationService.instance.showTest();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsNotificationsTestSent)),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _SectionHeader(l10n.gheebatLockTitle),
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              lock.enabled ? Icons.lock_outline : Icons.lock_open_outlined,
            ),
            title: Text(l10n.gheebatLockTitle),
            subtitle: Text(l10n.gheebatLockBody),
            trailing: lock.enabled
                ? TextButton(
                    onPressed: _changePin,
                    child: Text(l10n.gheebatChangePin),
                  )
                : FilledButton.tonal(
                    onPressed: _setPin,
                    child: Text(l10n.gheebatSetPin),
                  ),
          ),
        ),
        if (lock.enabled) ...[
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.lock_clock_outlined),
              title: Text(l10n.gheebatLockNow),
              onTap: () {
                ref.read(appUnlockedProvider.notifier).lock();
                saved();
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                Icons.lock_reset,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(l10n.gheebatRemovePin),
              onTap: _removePin,
            ),
          ),
        ],
        const SizedBox(height: 8),
        _SectionHeader(l10n.settingsBackupTitle),
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.upload_file_outlined),
            title: Text(l10n.settingsBackupExport),
            onTap: _busy ? null : _exportBackup,
          ),
        ),
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: Text(l10n.settingsBackupImport),
            onTap: _busy ? null : _importBackup,
          ),
        ),
        if (_busy)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
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
            subtitle: Text(l10n.phaseFourBanner),
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
