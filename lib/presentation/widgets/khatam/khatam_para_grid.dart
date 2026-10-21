import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/khatam_providers.dart';
import '../../../utils/numerals.dart';

/// 30-cell para checklist for one khatam cycle; tap toggles done state.
class KhatamParaGrid extends ConsumerWidget {
  final int khatamId;
  final Set<int> done;

  const KhatamParaGrid({super.key, required this.khatamId, required this.done});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final useEastern = ref.watch(numeralsProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 360 ? 5 : 6;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.1,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            final para = index + 1;
            final isDone = done.contains(para);
            return Semantics(
              label: l10n.khatamPara(para),
              button: true,
              selected: isDone,
              child: Tooltip(
                message: l10n.khatamPara(para),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => ref
                      .read(khatamActionsProvider)
                      .setParaDone(
                        khatamId,
                        para,
                        done: !isDone,
                        day: DateTime.now(),
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDone
                          ? scheme.primary
                          : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: isDone
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatNum(para, useEastern),
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: scheme.onPrimary,
                                    ),
                              ),
                              Icon(
                                Icons.check,
                                size: 14,
                                color: scheme.onPrimary,
                              ),
                            ],
                          )
                        : Text(
                            formatNum(para, useEastern),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
