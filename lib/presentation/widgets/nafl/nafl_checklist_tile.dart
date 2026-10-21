import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/numerals.dart';
import '../prayer_labels.dart';

/// One nafl checklist row: done toggle, rakats stepper, optional note and
/// a plain "Not done / نہیں کیا" marker when skipped.
class NaflChecklistTile extends StatelessWidget {
  final NaflType type;
  final String customName;
  final bool done;
  final int rakats;
  final String? note;
  final bool useEastern;
  final bool isCustom;
  final ValueChanged<bool> onDoneChanged;
  final ValueChanged<int> onRakatsChanged;
  final ValueChanged<String>? onNoteChanged;
  final VoidCallback? onDelete;

  const NaflChecklistTile({
    super.key,
    required this.type,
    required this.done,
    required this.rakats,
    required this.onDoneChanged,
    required this.onRakatsChanged,
    this.customName = '',
    this.note,
    this.useEastern = false,
    this.isCustom = false,
    this.onNoteChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final title = PrayerLabels.nafl(l10n, type, customName);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: done
            ? scheme.primaryContainer.withValues(alpha: 0.35)
            : scheme.surface,
        border: Border.all(
          color: done
              ? scheme.primary.withValues(alpha: 0.5)
              : scheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: done,
                shape: const CircleBorder(),
                onChanged: (v) {
                  HapticFeedback.selectionClick();
                  onDoneChanged(v ?? false);
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      done ? l10n.done : '${l10n.notDone} / ${l10n.notDone}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: done
                            ? scheme.primary
                            : scheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
              _RakatsStepper(
                rakats: rakats,
                useEastern: useEastern,
                onChanged: onRakatsChanged,
              ),
              if (isCustom && onDelete != null)
                IconButton(
                  tooltip: l10n.deleteWord,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 20),
                ),
            ],
          ),
          if (onNoteChanged != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
              child: TextFormField(
                initialValue: note,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.naflNoteLabel,
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.sticky_note_2_outlined,
                    size: 16,
                    color: scheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                onFieldSubmitted: onNoteChanged,
              ),
            ),
        ],
      ),
    );
  }
}

class _RakatsStepper extends StatelessWidget {
  final int rakats;
  final bool useEastern;
  final ValueChanged<int> onChanged;

  const _RakatsStepper({
    required this.rakats,
    required this.useEastern,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: rakats > 0
              ? () {
                  HapticFeedback.selectionClick();
                  onChanged(rakats - 1);
                }
              : null,
          icon: const Icon(Icons.remove_circle_outline, size: 20),
        ),
        Text(
          formatNum(rakats, useEastern),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {
            HapticFeedback.selectionClick();
            onChanged(rakats + 1);
          },
          icon: const Icon(Icons.add_circle_outline, size: 20),
        ),
      ],
    );
  }
}
