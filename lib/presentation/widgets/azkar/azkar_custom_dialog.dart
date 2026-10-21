// Dialog to create a custom dhikr: name, Arabic text, target and reminder time.
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Result of the add-custom-dhikr dialog.
class AzkarCustomResult {
  final String name;
  final String arabicText;
  final int target;
  final String? reminderTime;

  const AzkarCustomResult({
    required this.name,
    required this.arabicText,
    required this.target,
    this.reminderTime,
  });
}

/// Prompts for a custom dhikr definition. Returns null on cancel.
Future<AzkarCustomResult?> showAzkarCustomDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final arabicController = TextEditingController();
  final targetController = TextEditingController(text: '33');
  final reminderController = TextEditingController();

  return showDialog<AzkarCustomResult>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.azkarAddCustom),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: l10n.azkarCustomName),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.azkarCustomName
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: arabicController,
                maxLines: 3,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(labelText: l10n.azkarCustomArabic),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: targetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.azkarCustomTarget),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null || n < 1) return l10n.azkarCustomTarget;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: reminderController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: l10n.azkarCustomReminder,
                  helperText: l10n.azkarCustomReminder,
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return null;
                  if (!RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(t)) {
                    return l10n.azkarCustomReminder;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancelWord),
        ),
        FilledButton(
          onPressed: () {
            if (!(formKey.currentState?.validate() ?? false)) return;
            final reminder = reminderController.text.trim();
            Navigator.pop(
              context,
              AzkarCustomResult(
                name: nameController.text.trim(),
                arabicText: arabicController.text.trim(),
                target: int.parse(targetController.text.trim()),
                reminderTime: reminder.isEmpty ? null : reminder,
              ),
            );
          },
          child: Text(l10n.saveWord),
        ),
      ],
    ),
  );
}
