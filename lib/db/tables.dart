import 'package:drift/drift.dart';

import 'enums.dart';

/// One row per prayer per day: status + optional sunnah flags.
///
/// Primary key = (date, prayer) so a prayer can only appear once per day.
class NamazEntries extends Table {
  /// `yyyy-MM-dd` (see DateUtilsExt.ymd) — stored as text for easy
  /// string range queries and timezone-safe comparisons.
  TextColumn get date => text()();

  IntColumn get prayer => intEnum<NamazType>()();

  IntColumn get status => intEnum<NamazStatus>()
      .withDefault(const Constant(0))();

  /// Takbeer-e-Ula caught (تکبیر اولیٰ) — optional sunnah flag.
  BoolColumn get takbeerUla => boolean().withDefault(const Constant(false))();

  /// Joined the prayer after it started (مسبوق) — optional flag.
  BoolColumn get masbooq => boolean().withDefault(const Constant(false))();

  /// True = prayed at masjid, false = prayed at home.
  BoolColumn get atMasjid => boolean().withDefault(const Constant(false))();

  /// Last modification timestamp — used by seed and conflict checks.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {date, prayer};
}

/// A single nafl prayer record for a day (fixed type or custom).
///
/// Primary key = (date, naflType, customName). Fixed types always store
/// customName = ''; custom nafls store the user-provided name, which also
/// acts as the uniqueness key.
class NaflEntries extends Table {
  /// `yyyy-MM-dd`.
  TextColumn get date => text()();

  IntColumn get naflType => intEnum<NaflType>()();

  /// User-provided name for [NaflType.custom]; '' for fixed types.
  TextColumn get customName => text().withDefault(const Constant(''))();

  /// Rakats performed (stepper value).
  IntColumn get rakats => integer().withDefault(const Constant(0))();

  /// Done / not-done toggle.
  BoolColumn get done => boolean().withDefault(const Constant(false))();

  /// Optional free-text note.
  TextColumn get note => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {date, naflType, customName};
}

/// Qaza (missed prayer) ledger.
///
/// Auto rows are inserted when a prayer is marked missed and deleted if it
/// is later marked prayed; manual rows are user-added history. Marking a
/// row made-up flips [isMadeUp] and stamps [madeUpDate] (rows are never
/// deleted, so the history log survives).
///
/// `id` is an explicit auto-increment primary key.
class QazaRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get prayer => intEnum<NamazType>()();

  IntColumn get rakats => integer().withDefault(const Constant(1))();

  /// Day the qaza was logged (`yyyy-MM-dd`).
  TextColumn get logDate => text()();

  /// 'auto' | 'manual' — see QazaSource.
  TextColumn get source => text().withDefault(const Constant('auto'))();

  /// Optional user note.
  TextColumn get note => text().nullable()();

  BoolColumn get isMadeUp => boolean().withDefault(const Constant(false))();

  /// Day the qaza was made up (`yyyy-MM-dd`), null while pending.
  TextColumn get madeUpDate => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// A single Tilawat (Quran recitation) log entry.
///
/// Multiple rows per day are allowed (e.g. after Fajr and after Isha), each
/// with its own unit and amount. `id` is an explicit auto-increment key.
class TilawatEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// `yyyy-MM-dd`.
  TextColumn get date => text()();

  /// Unit the [amount] is measured in (pages / ruku / para / minutes).
  IntColumn get unit => intEnum<TilawatUnit>()();

  /// Quantity for the chosen [unit].
  IntColumn get amount => integer().withDefault(const Constant(0))();

  /// Optional free-text note (e.g. "after Fajr").
  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// The user's current reading position — a single row (id == 1).
///
/// Used by the "Continue from where I stopped" card and auto-linking to the
/// active Quran khatam.
class TilawatPositions extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Current para (1..30).
  IntColumn get para => integer().withDefault(const Constant(1))();

  /// Current surah name (free text).
  TextColumn get surah => text().withDefault(const Constant(''))();

  /// Current page number.
  IntColumn get page => integer().withDefault(const Constant(1))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// User-defined dhikr (unlimited). Built-in adhkar live in code.
class CustomDhikrs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Display name (English/Urdu as entered).
  TextColumn get name => text()();

  /// Optional Arabic text shown in the counter screen.
  TextColumn get arabicText => text().withDefault(const Constant(''))();

  /// Target count for one day.
  IntColumn get target => integer().withDefault(const Constant(33))();

  /// Optional reminder time as `HH:mm`.
  TextColumn get reminderTime => text().nullable()();

  /// Hidden customs are kept in history but not shown on the checklist.
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Per-day count for one dhikr.
///
/// [dhikrKey] is either a [DhikrType] name (`morning`, `tasbeehSubhan`, …) or
/// `custom:<id>` for user-defined dhikr. Target is snapshotted so historical
/// completion percentages stay stable if a target is later edited.
class AzkarEntries extends Table {
  /// `yyyy-MM-dd`.
  TextColumn get date => text()();

  TextColumn get dhikrKey => text()();

  IntColumn get count => integer().withDefault(const Constant(0))();

  IntColumn get target => integer().withDefault(const Constant(1))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {date, dhikrKey};
}

/// One Quran khatam cycle.
///
/// A khatam is "active" while [endDate] is null. Completing it stamps the end
/// date; rows are never deleted so the history list survives.
class Khatams extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// `yyyy-MM-dd` the khatam was started.
  TextColumn get startDate => text()();

  /// `yyyy-MM-dd` the khatam was completed, null while active.
  TextColumn get endDate => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Per-para completion inside a [Khatams] cycle (30 paras each).
class KhatamParas extends Table {
  IntColumn get khatamId =>
      integer().references(Khatams, #id, onDelete: KeyAction.cascade)();

  /// Para number, 1..30.
  IntColumn get para => integer()();

  BoolColumn get done => boolean().withDefault(const Constant(false))();

  /// `yyyy-MM-dd` the para was completed, null while pending.
  TextColumn get doneDate => text().nullable()();

  @override
  Set<Column> get primaryKey => {khatamId, para};
}

/// One day's Gheebat (backbiting) check-in.
///
/// Primary key = [date], so each day has at most one row. Notes are private
/// and only shown after the optional PIN lock is unlocked.
class GheebatEntries extends Table {
  /// `yyyy-MM-dd`.
  TextColumn get date => text()();

  IntColumn get status => intEnum<GheebatStatus>()
      .withDefault(const Constant(0))();

  /// Short private reflection (never required).
  TextColumn get note => text().nullable()();

  /// Istighfar repetitions logged on this day.
  IntColumn get istighfarCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {date};
}

/// One completed Muraqaba (meditation) session.
///
/// A day "has practice" when at least one session exists. Multiple sessions
/// per day are supported; the timer and the manual logger both insert rows.
class MuraqabaSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// `yyyy-MM-dd`.
  TextColumn get date => text()();

  IntColumn get minutes => integer().withDefault(const Constant(0))();

  IntColumn get timeOfDay => intEnum<MuraqabaTime>()
      .withDefault(const Constant(0))();

  /// Optional short note for the session.
  TextColumn get note => text().nullable()();

  /// `timer` or `manual` — how the session was recorded.
  TextColumn get source => text().withDefault(const Constant('manual'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// A repeating (or one-time) timetable task definition.
///
/// Occurrences are derived from [repeat], [weekdaysMask] and [anchorDate];
/// per-day completion is stored in [TaskCompletions]. Times are minutes from
/// midnight so comparisons and drag-resize maths stay integer-only.
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  IntColumn get category => intEnum<TaskCategory>()
      .withDefault(const Constant(0))();

  /// Key into the curated icon map (tree-shake-safe).
  TextColumn get iconKey => text().withDefault(const Constant('task'))();

  /// ARGB colour used by the timeline block.
  IntColumn get colorValue =>
      integer().withDefault(const Constant(0xFF1F8F4E))();

  /// Start time as minutes from midnight (0..1439).
  IntColumn get startMinutes => integer().withDefault(const Constant(0))();

  /// End time as minutes from midnight (1..1440).
  IntColumn get endMinutes => integer().withDefault(const Constant(60))();

  IntColumn get repeat => intEnum<TaskRepeat>()
      .withDefault(const Constant(1))();

  /// Bit 0 = Monday … bit 6 = Sunday. Used by [TaskRepeat.customDays] and
  /// [TaskRepeat.weekdays] (the latter also checks the mask).
  IntColumn get weekdaysMask => integer().withDefault(const Constant(127))();

  /// First day the task may occur (`yyyy-MM-dd`); for one-time tasks this is
  /// also the only day it occurs.
  TextColumn get anchorDate => text()();

  /// Optional reminder time as minutes from midnight.
  IntColumn get reminderMinutes => integer().nullable()();

  TextColumn get note => text().nullable()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Done / not-done mark for one task occurrence on one day.
///
/// Primary key = (taskId, date). Deleting the task cascades here.
class TaskCompletions extends Table {
  IntColumn get taskId =>
      integer().references(Tasks, #id, onDelete: KeyAction.cascade)();

  /// `yyyy-MM-dd`.
  TextColumn get date => text()();

  BoolColumn get done => boolean().withDefault(const Constant(true))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {taskId, date};
}
