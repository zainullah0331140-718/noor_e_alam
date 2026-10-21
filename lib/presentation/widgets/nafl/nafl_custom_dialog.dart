import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Result of the "add custom nafl" dialog.
class CustomNaflInput {
  final String name;
  final int rakats;
  const CustomNaflInput({required this.name, required this.rakats});
}

/// Prompts for a custom nafl name + rakats count. Returns null on cancel.
Future<CustomNaflInput?> showNaflCustomDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController();
  var rakats = 2;

  return showDialog<CustomNaflInput>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(l10n.naflAddCustom),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.naflCustomName),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text(l10n.naflRakatsLabel)),
                IconButton(
                  onPressed: rakats > 1 ? () => setState(() => rakats--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$rakats',
                    style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  onPressed: () => setState(() => rakats++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.notDone),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(
                context,
                CustomNaflInput(name: name, rakats: rakats),
              );
            },
            child: Text(l10n.naflAddCustom),
          ),
        ],
      ),
    ),
  );
}
