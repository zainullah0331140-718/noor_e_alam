import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/ramadan_providers.dart';
import '../../../utils/numerals.dart';

/// Soft semantic colours for each Roza status.
class RozaColors {
  static const fasted = Color(0xFF1F8F4E);
  static const excused = Color(0xFFD9B75B);
  static const noExcuse = Color(0xFFD32F2F);
  static const notRecorded = Color(0xFF9E9E9E);

  static Color of(RozaStatus status, Color fallback) {
    switch (status) {
      case RozaStatus.fasted:
        return fasted;
      case RozaStatus.missedExcused:
        return excused;
      case RozaStatus.missedNoExcuse:
        return noExcuse;
      case RozaStatus.notRecorded:
        return fallback;
    }
  }
}

/// Resolves the localized status label for one [RozaStatus].
String rozaStatusLabel(AppLocalizations l10n, RozaStatus status) {
  switch (status) {
    case RozaStatus.fasted:
      return l10n.ramadanStatusFasted;
    case RozaStatus.missedExcused:
      return l10n.ramadanStatusMissedExcused;
    case RozaStatus.missedNoExcuse:
      return l10n.ramadanStatusMissedNoExcuse;
    case RozaStatus.notRecorded:
      return l10n.ramadanStatusNotRecorded;
  }
}

/// One tappable day cell in the 30-day Roza grid.
class RozaDayTile extends ConsumerWidget {
  final int seasonId;
  final int dayNumber;
  final RozaStatus status;
  final bool taraweeh;
  final bool tahajjud;
  final bool useEastern;

  const RozaDayTile({
    super.key,
    required this.seasonId,
    required this.dayNumber,
    required this.status,
    required this.taraweeh,
    required this.tahajjud,
    required this.useEastern,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final color = RozaColors.of(status, scheme.surfaceContainerHighest);
    final recorded = status != RozaStatus.notRecorded;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showRozaDaySheet(
        context: context,
        ref: ref,
        seasonId: seasonId,
        dayNumber: dayNumber,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: recorded
              ? color.withValues(alpha: 0.16)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: recorded ? color : scheme.outlineVariant,
            width: 1.2,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatNum(dayNumber, useEastern),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: recorded ? color : scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (taraweeh)
                  Icon(Icons.nightlight_round, size: 10, color: scheme.primary),
                if (tahajjud) ...[
                  const SizedBox(width: 2),
                  Icon(Icons.dark_mode, size: 10, color: scheme.tertiary),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Opens the bottom sheet for logging one Roza day (status, excuse, flags).
Future<void> showRozaDaySheet({
  required BuildContext context,
  required WidgetRef ref,
  required int seasonId,
  required int dayNumber,
  RozaStatus initialStatus = RozaStatus.notRecorded,
  RozaExcuse initialExcuse = RozaExcuse.none,
  bool taraweeh = false,
  bool tahajjud = false,
  bool qazaMadeUp = false,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return _RozaDaySheet(
        ref: ref,
        l10n: l10n,
        seasonId: seasonId,
        dayNumber: dayNumber,
        initialStatus: initialStatus,
        initialExcuse: initialExcuse,
        taraweeh: taraweeh,
        tahajjud: tahajjud,
        qazaMadeUp: qazaMadeUp,
      );
    },
  );
}

class _RozaDaySheet extends StatefulWidget {
  final WidgetRef ref;
  final AppLocalizations l10n;
  final int seasonId;
  final int dayNumber;
  final RozaStatus initialStatus;
  final RozaExcuse initialExcuse;
  final bool taraweeh;
  final bool tahajjud;
  final bool qazaMadeUp;

  const _RozaDaySheet({
    required this.ref,
    required this.l10n,
    required this.seasonId,
    required this.dayNumber,
    required this.initialStatus,
    required this.initialExcuse,
    required this.taraweeh,
    required this.tahajjud,
    required this.qazaMadeUp,
  });

  @override
  State<_RozaDaySheet> createState() => _RozaDaySheetState();
}

class _RozaDaySheetState extends State<_RozaDaySheet> {
  late RozaStatus _status;
  late RozaExcuse _excuse;
  late bool _taraweeh;
  late bool _tahajjud;
  late bool _qazaMadeUp;
  final Set<int> _updates = {};

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _excuse = widget.initialExcuse;
    _taraweeh = widget.taraweeh;
    _tahajjud = widget.tahajjud;
    _qazaMadeUp = widget.qazaMadeUp;
  }

  RamadanActions get _actions => widget.ref.read(ramadanActionsProvider);

  Future<void> _saveStatus() async {
    await _actions.setDayStatus(
      seasonId: widget.seasonId,
      dayNumber: widget.dayNumber,
      status: _status,
      excuse: _excuse,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final missing =
        _status == RozaStatus.missedExcused ||
        _status == RozaStatus.missedNoExcuse;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.ramadanDay(widget.dayNumber),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.ramadanExcuseTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in const [
                  RozaStatus.fasted,
                  RozaStatus.missedExcused,
                  RozaStatus.missedNoExcuse,
                  RozaStatus.notRecorded,
                ])
                  ChoiceChip(
                    label: Text(rozaStatusLabel(l10n, s)),
                    selected: _status == s,
                    onSelected: (_) async {
                      setState(() {
                        _status = s;
                        if (s != RozaStatus.missedExcused) {
                          _excuse = RozaExcuse.none;
                        }
                      });
                      await _saveStatus();
                    },
                  ),
              ],
            ),
            if (_status == RozaStatus.missedExcused) ...[
              const SizedBox(height: 16),
              Text(
                l10n.ramadanExcuseTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<RozaExcuse>(
                initialValue: _excuse == RozaExcuse.none
                    ? RozaExcuse.sickness
                    : _excuse,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  for (final e in const [
                    RozaExcuse.sickness,
                    RozaExcuse.travel,
                    RozaExcuse.shariExcuse,
                    RozaExcuse.pregnancyNursing,
                    RozaExcuse.oldAge,
                    RozaExcuse.other,
                  ])
                    DropdownMenuItem(
                      value: e,
                      child: Text(_excuseLabel(l10n, e)),
                    ),
                ],
                onChanged: (e) async {
                  if (e == null) return;
                  setState(() => _excuse = e);
                  await _saveStatus();
                },
              ),
            ],
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.ramadanTaraweehTitle),
              value: _taraweeh,
              onChanged: (v) async {
                setState(() => _taraweeh = v);
                await _actions.setTaraweeh(
                  seasonId: widget.seasonId,
                  dayNumber: widget.dayNumber,
                  value: v,
                );
                _updates.add(1);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.ramadanTahajjudTitle),
              value: _tahajjud,
              onChanged: (v) async {
                setState(() => _tahajjud = v);
                await _actions.setTahajjud(
                  seasonId: widget.seasonId,
                  dayNumber: widget.dayNumber,
                  value: v,
                );
                _updates.add(2);
              },
            ),
            if (missing)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.ramadanQazaMadeUp),
                value: _qazaMadeUp,
                onChanged: (v) async {
                  setState(() => _qazaMadeUp = v);
                  await _actions.setQazaMadeUp(
                    seasonId: widget.seasonId,
                    dayNumber: widget.dayNumber,
                    value: v,
                  );
                  _updates.add(3);
                },
              ),
          ],
        ),
      ),
    );
  }

  String _excuseLabel(AppLocalizations l10n, RozaExcuse excuse) {
    switch (excuse) {
      case RozaExcuse.sickness:
        return l10n.ramadanExcuseSickness;
      case RozaExcuse.travel:
        return l10n.ramadanExcuseTravel;
      case RozaExcuse.shariExcuse:
        return l10n.ramadanExcuseShari;
      case RozaExcuse.pregnancyNursing:
        return l10n.ramadanExcusePregnancy;
      case RozaExcuse.oldAge:
        return l10n.ramadanExcuseOldAge;
      case RozaExcuse.other:
        return l10n.ramadanExcuseOther;
      case RozaExcuse.none:
        return l10n.ramadanExcuseNone;
    }
  }
}
