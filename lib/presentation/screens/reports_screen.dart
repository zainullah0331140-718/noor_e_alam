// Reports & Print module: assemble a bilingual snapshot of every module,
// then generate / preview / share a PDF report.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/report_bundle_providers.dart';
import '../../reports/pdf_report_service.dart';
import '../../utils/numerals.dart';

/// Reports & Print screen (module 11).
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  final _service = PdfReportService();
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.reportsSaved)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.reportsFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final useEastern = ref.watch(numeralsProvider);
    final urdu = Localizations.localeOf(context).languageCode == 'ur';
    final period = ref.watch(reportPeriodProvider);
    final anchor = ref.watch(reportAnchorProvider);
    final selection = ref.watch(reportSelectionProvider);
    final bundleAsync = ref.watch(reportBundleProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          color: scheme.primaryContainer.withValues(alpha: 0.45),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf_outlined, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.reportsIntro,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Period selector.
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reportsRangeTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                SegmentedButton<ReportPeriod>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: ReportPeriod.day,
                      label: Text(l10n.reportsDayRange),
                    ),
                    ButtonSegment(
                      value: ReportPeriod.month,
                      label: Text(l10n.reportsMonthRange),
                    ),
                    ButtonSegment(
                      value: ReportPeriod.year,
                      label: Text(l10n.reportsYearRange),
                    ),
                  ],
                  selected: {period},
                  onSelectionChanged: (s) =>
                      ref.read(reportPeriodProvider.notifier).set(s.first),
                ),
                const SizedBox(height: 10),
                _AnchorBar(
                  period: period,
                  anchor: anchor,
                  useEastern: useEastern,
                  onShift: (delta) => ref
                      .read(reportAnchorProvider.notifier)
                      .shiftPeriod(period, delta),
                  onPick: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: anchor,
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      ref.read(reportAnchorProvider.notifier).set(picked);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Module selection.
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.reportsModulesTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          ref.read(reportSelectionProvider.notifier).all(),
                      child: Text(l10n.reportsIncludeAll),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final row in bundleAsync.value?.rows ?? const [])
                      FilterChip(
                        label: Text(urdu ? row.labelUr : row.labelEn),
                        selected: selection.contains(row.key),
                        onSelected: (_) => ref
                            .read(reportSelectionProvider.notifier)
                            .toggle(row.key),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Preview + actions.
        bundleAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('$e'),
            ),
          ),
          data: (bundle) {
            final rows = bundle.selected(selection.toList());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.reportsSummaryTable,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 10),
                        for (final row in rows)
                          _PreviewRow(
                            row: row,
                            label: urdu ? row.labelUr : row.labelEn,
                            useEastern: useEastern,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _busy
                            ? null
                            : () => _run(() => _service.shareReport(
                                  bundle: bundle,
                                  rows: rows,
                                  l10n: l10n,
                                )),
                        icon: const Icon(Icons.download_outlined),
                        label: Text(l10n.reportsGenerate),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: _busy
                            ? null
                            : () => _run(() => _service.printReport(
                                  bundle: bundle,
                                  rows: rows,
                                  l10n: l10n,
                                )),
                        icon: const Icon(Icons.print_outlined),
                        label: Text(l10n.reportsPreview),
                      ),
                    ),
                  ],
                ),
                if (_busy) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AnchorBar extends StatelessWidget {
  final ReportPeriod period;
  final DateTime anchor;
  final bool useEastern;
  final ValueChanged<int> onShift;
  final VoidCallback onPick;

  const _AnchorBar({
    required this.period,
    required this.anchor,
    required this.useEastern,
    required this.onShift,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final paddedMonth = anchor.month.toString().padLeft(2, '0');
    final monthText = useEastern ? toEastern(paddedMonth) : paddedMonth;
    final label = switch (period) {
      ReportPeriod.day =>
        '${formatNum(anchor.day, useEastern)}/'
            '${formatNum(anchor.month, useEastern)}/'
            '${formatNum(anchor.year, useEastern)}',
      ReportPeriod.month =>
        '${formatNum(anchor.year, useEastern)}-$monthText',
      ReportPeriod.year => formatNum(anchor.year, useEastern),
    };
    return Row(
      children: [
        IconButton(
          onPressed: () => onShift(-1),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: InkWell(
            onTap: onPick,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () => onShift(1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final ReportRow row;
  final String label;
  final bool useEastern;
  const _PreviewRow({
    required this.row,
    required this.label,
    required this.useEastern,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                '${formatNum(row.done, useEastern)} / '
                '${formatNum(row.total, useEastern)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 42,
                child: Text(
                  '${row.percent}%',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: row.percent / 100,
              minHeight: 6,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}
