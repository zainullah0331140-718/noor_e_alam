/// Static catalogue of the built-in adhkar with their default target counts.
///
/// Keys are persisted in [AzkarEntries.dhikrKey]. Custom dhikr use the
/// `custom:<id>` key format and are stored in the `CustomDhikrs` table.
library;

import '../db/enums.dart';

/// One built-in dhikr definition.
class AzkarCatalogItem {
  /// Persisted key (the [DhikrType] name).
  final String key;

  /// The matching enum value.
  final DhikrType type;

  /// Default target count for one day.
  final int defaultTarget;

  /// Whether this dhikr counts towards the "all daily adhkar" streak.
  final bool isDaily;

  const AzkarCatalogItem({
    required this.key,
    required this.type,
    required this.defaultTarget,
    this.isDaily = false,
  });
}

/// The built-in adhkar list shown on the Azkar screen (fixed order).
const List<AzkarCatalogItem> azkarCatalog = [
  AzkarCatalogItem(
    key: 'morning',
    type: DhikrType.morning,
    defaultTarget: 1,
    isDaily: true,
  ),
  AzkarCatalogItem(
    key: 'evening',
    type: DhikrType.evening,
    defaultTarget: 1,
    isDaily: true,
  ),
  AzkarCatalogItem(
    key: 'tasbeehSubhan',
    type: DhikrType.tasbeehSubhan,
    defaultTarget: 33,
    isDaily: true,
  ),
  AzkarCatalogItem(
    key: 'tasbeehHamd',
    type: DhikrType.tasbeehHamd,
    defaultTarget: 33,
    isDaily: true,
  ),
  AzkarCatalogItem(
    key: 'tasbeehAkbar',
    type: DhikrType.tasbeehAkbar,
    defaultTarget: 34,
    isDaily: true,
  ),
  AzkarCatalogItem(
    key: 'durood',
    type: DhikrType.durood,
    defaultTarget: 10,
  ),
  AzkarCatalogItem(
    key: 'istighfar',
    type: DhikrType.istighfar,
    defaultTarget: 100,
  ),
  AzkarCatalogItem(
    key: 'kalima3',
    type: DhikrType.kalima3,
    defaultTarget: 3,
  ),
  AzkarCatalogItem(
    key: 'lailaha',
    type: DhikrType.lailaha,
    defaultTarget: 10,
  ),
  AzkarCatalogItem(
    key: 'ayatulKursi',
    type: DhikrType.ayatulKursi,
    defaultTarget: 1,
  ),
];

/// Keys of the daily adhkar used by the streak calculator.
final List<String> dailyAzkarKeys = [
  for (final item in azkarCatalog)
    if (item.isDaily) item.key,
];

/// Builds the persisted key for a custom dhikr row.
String customDhikrKey(int id) => 'custom:$id';
