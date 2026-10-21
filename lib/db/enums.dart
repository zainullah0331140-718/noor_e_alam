/// Domain enums shared by every module.
///
/// Indices are persisted in SQLite via drift's `intEnum` — never reorder
/// existing values; only append new ones (and bump schema version).
library;

/// The six tracked prayers of the Namaz module.
enum NamazType {
  fajr,
  zuhr,
  asr,
  maghrib,
  isha,
  witr;

  /// The five obligatory prayers (Witr excluded) used for streaks.
  static const List<NamazType> fard = [
    NamazType.fajr,
    NamazType.zuhr,
    NamazType.asr,
    NamazType.maghrib,
    NamazType.isha,
  ];
}

/// Marked status of a prayer on a given day.
enum NamazStatus {
  /// Not marked yet (neither prayed nor consciously missed).
  none,
  /// Prayed with congregation (جماعت).
  jamaat,
  /// Prayed alone (تنہا).
  alone,
  /// Missed (رہ گئی) — automatically adds a qaza entry.
  missed;
}

/// Optional nafl prayers tracked by the Nafl module.
enum NaflType {
  tahajjud,
  ishraq,
  chasht, // Chasht / Duha
  awwabin,
  tahiyyatulWudu,
  tahiyyatulMasjid,
  sunnahMuakkadah,
  ghairMuakkadah,
  tasbeeh, // Salat-ul-Tasbeeh
  hajat, // Salat-ul-Hajat
  tawbah, // Salat-ul-Tawbah
  custom;

  /// The two nafl prayers that get their own streak counters.
  static const NaflType tahajjudType = NaflType.tahajjud;
  static const NaflType duhaType = NaflType.chasht;
}

/// Origin of a qaza record.
enum QazaSource {
  /// Automatically inserted when a prayer is marked missed.
  auto,
  /// Manually added by the user (e.g. old/legacy qaza).
  manual;
}

/// Unit used when logging a Tilawat (Quran recitation) entry.
///
/// Persisted via `intEnum` — append new units at the end only.
enum TilawatUnit {
  pages,
  ruku,
  para,
  minutes;

  /// Whether the amount is measured in time (minutes) rather than quantity.
  bool get isTime => this == TilawatUnit.minutes;
}

/// Built-in azkar tracked by the Azkar module.
///
/// Persisted as the enum `name` inside [AzkarEntries.dhikrKey]; custom user
/// dhikr use the `custom:<id>` key format instead. Append new values only.
enum DhikrType {
  morning,
  evening,
  tasbeehSubhan,
  tasbeehHamd,
  tasbeehAkbar,
  durood,
  istighfar,
  kalima3,
  lailaha,
  ayatulKursi;

  /// The five adhkar whose completion defines an "all adhkar done" day.
  static const List<DhikrType> daily = [
    DhikrType.morning,
    DhikrType.evening,
    DhikrType.tasbeehSubhan,
    DhikrType.tasbeehHamd,
    DhikrType.tasbeehAkbar,
  ];
}

/// Whether the user backbit on a given day.
///
/// Persisted via `intEnum` in [GheebatEntries] — append new values only.
enum GheebatStatus {
  /// The day was not checked in at all.
  notRecorded,
  /// Gheebat-free day (الحمدللہ).
  free,
  /// The user slipped and repented.
  slipped;

  bool get isRecorded => this != GheebatStatus.notRecorded;
}

/// Time-of-day bucket for a Muraqaba session.
enum MuraqabaTime {
  afterFajr,
  tahajjud,
  morning,
  afternoon,
  evening,
  night,
}

/// Category of a timetable task — drives colours and the time breakdown.
enum TaskCategory { ibadah, work, study, family, health, rest }

/// How often a timetable task repeats.
enum TaskRepeat {
  /// Only on [Tasks.anchorDate].
  once,
  /// Every day.
  daily,
  /// Monday–Friday.
  weekdays,
  /// Only the days selected in [Tasks.weekdaysMask].
  customDays,
}
