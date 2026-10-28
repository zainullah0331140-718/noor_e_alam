import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/app_lock.dart';

/// Shows the PIN dialog used to set, change, remove or verify the private
/// Gheebat lock. Returns the entered PIN, or null when the dialog is dismissed.
Future<String?> showGheebatPinDialog(
  BuildContext context, {
  required String title,
  required String actionLabel,
  bool confirm = false,
  String? Function(String pin)? validate,
}) {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => _GheebatPinDialog(
      title: title,
      actionLabel: actionLabel,
      confirm: confirm,
      validate: validate,
    ),
  );
}

class _GheebatPinDialog extends StatefulWidget {
  final String title;
  final String actionLabel;
  final bool confirm;
  final String? Function(String pin)? validate;

  const _GheebatPinDialog({
    required this.title,
    required this.actionLabel,
    required this.confirm,
    this.validate,
  });

  @override
  State<_GheebatPinDialog> createState() => _GheebatPinDialogState();
}

class _GheebatPinDialogState extends State<_GheebatPinDialog> {
  final _pin = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _pin.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit(AppLocalizations l10n) {
    final pin = _pin.text.trim();
    if (!isValidPin(pin)) {
      setState(() => _error = l10n.gheebatPinInvalid);
      return;
    }
    if (widget.confirm && pin != _confirm.text.trim()) {
      setState(() => _error = l10n.gheebatPinMismatch);
      return;
    }
    final validation = widget.validate?.call(pin);
    if (validation != null) {
      setState(() => _error = validation);
      return;
    }
    Navigator.of(context).pop(pin);
  }

  Widget _pinField({
    required TextEditingController controller,
    required String label,
    required bool autofocus,
    bool submit = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      controller: controller,
      autofocus: autofocus,
      obscureText: _obscure,
      keyboardType: TextInputType.number,
      maxLength: 8,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        counterText: '',
        suffixIcon: IconButton(
          tooltip: label,
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
      onSubmitted: submit ? (_) => _submit(l10n) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pinField(
            controller: _pin,
            label: l10n.gheebatEnterPin,
            autofocus: true,
            submit: !widget.confirm,
          ),
          if (widget.confirm) ...[
            const SizedBox(height: 12),
            _pinField(
              controller: _confirm,
              label: l10n.gheebatConfirmPin,
              autofocus: false,
              submit: true,
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelWord),
        ),
        FilledButton(
          onPressed: () => _submit(l10n),
          child: Text(widget.actionLabel),
        ),
      ],
    );
  }
}
