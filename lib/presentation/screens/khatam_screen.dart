import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/khatam/khatam_history_list.dart';
import '../widgets/khatam/khatam_progress_card.dart';
import '../widgets/khatam/khatam_stats_section.dart';

/// Quran Khatam module: active cycle progress, stats and completion history.
class KhatamScreen extends ConsumerWidget {
  const KhatamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: const [
        KhatamProgressCard(),
        SizedBox(height: 16),
        KhatamStatsSection(),
        SizedBox(height: 16),
        KhatamHistoryList(),
      ],
    );
  }
}
