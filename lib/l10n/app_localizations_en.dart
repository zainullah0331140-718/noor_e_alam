// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Ibadah Tracker';

  @override
  String get appTagline => 'Your daily path to Allah';

  @override
  String get moduleDashboard => 'Dashboard';

  @override
  String get moduleTimetable => 'Timetable';

  @override
  String get moduleNamaz => 'Namaz';

  @override
  String get moduleNafl => 'Nafl';

  @override
  String get moduleTilawat => 'Tilawat';

  @override
  String get moduleAzkar => 'Azkar';

  @override
  String get moduleGheebat => 'Gheebat';

  @override
  String get moduleMuraqaba => 'Muraqaba';

  @override
  String get moduleKhatam => 'Khatam';

  @override
  String get moduleRamadan => 'Ramadan';

  @override
  String get moduleReports => 'Reports';

  @override
  String get moduleSettings => 'Settings';

  @override
  String get menu => 'Menu';

  @override
  String get openDrawer => 'Open navigation';

  @override
  String get navigationTitle => 'Ibadah Tracker';

  @override
  String get phaseOneBanner => 'Phase 1 — foundation';

  @override
  String get bismillah => 'بسم اللہ';

  @override
  String get splashStarting => 'Preparing your tracker…';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get greetingNight => 'Good night';

  @override
  String get quote => 'Strive to reach Allah. When Allah is found, everything is found.';

  @override
  String get quoteBy => 'Motivation of the day';

  @override
  String get rangeToday => 'Today';

  @override
  String get rangeMonth => 'Month';

  @override
  String get rangeYear => 'Year';

  @override
  String get done => 'Done';

  @override
  String get notDone => 'Not done';

  @override
  String get noData => 'No entries yet';

  @override
  String get completion => 'Completion';

  @override
  String get streak => 'Prayer streak';

  @override
  String streakValue(int count) {
    return '$count days';
  }

  @override
  String get streakHint => 'Keep the chain alive';

  @override
  String get weeklyTitle => 'Last 7 days';

  @override
  String get weeklySubtitle => 'Daily completion score';

  @override
  String get monthlyTitle => 'Monthly breakdown';

  @override
  String get overviewTitle => 'Overview';

  @override
  String get statPrayers => 'Namaz';

  @override
  String get statNafl => 'Nafl';

  @override
  String get statTilawat => 'Tilawat';

  @override
  String get statAzkar => 'Azkar';

  @override
  String get statGheebatFree => 'Gheebat-free';

  @override
  String get statMuraqaba => 'Muraqaba';

  @override
  String get statKhatam => 'Khatam';

  @override
  String get statRamadan => 'Ramadan';

  @override
  String detailPrayers(int done, int total) {
    return '$done of $total prayers';
  }

  @override
  String detailRakats(int done, int total) {
    return '$done of $total rakats';
  }

  @override
  String detailPages(int done, int total) {
    return '$done of $total pages';
  }

  @override
  String detailCounts(int done, int total) {
    return '$done of $total';
  }

  @override
  String detailDays(int done, int total) {
    return '$done of $total days';
  }

  @override
  String detailMinutes(int done, int total) {
    return '$done of $total min';
  }

  @override
  String subTilawat(int pages, int minutes, int para) {
    return '$pages pages · $minutes min · Para $para';
  }

  @override
  String subPrayers(int jamaat, int alone, int missed) {
    return '$jamaat Jamaat · $alone alone · $missed missed';
  }

  @override
  String get jamaat => 'Jamaat';

  @override
  String get alone => 'Alone';

  @override
  String get missed => 'Missed';

  @override
  String get takbeerUla => 'Takbeer Ula';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get settingsNumerals => 'Numerals';

  @override
  String get numeralsWestern => 'Western (1, 2, 3)';

  @override
  String get numeralsEastern => 'Urdu (۱, ۲, ۳)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutValue => 'Ibadah Tracker · Phase 1 foundation';

  @override
  String get settingsSaved => 'Preference saved';

  @override
  String get comingSoonTitle => 'Coming in Phase 2';

  @override
  String get comingSoonBody => 'This module is scheduled for the next phase. Theme, database, navigation and localization are already in place.';

  @override
  String get backToDashboard => 'Go to Dashboard';

  @override
  String get phaseTwoBanner => 'Phase 2 — Namaz & Nafl';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerZuhr => 'Zuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerWitr => 'Witr';

  @override
  String get remaining => 'Remaining';

  @override
  String get notMarked => 'Not marked';

  @override
  String get dayComplete => 'All six prayers marked';

  @override
  String summaryLine(int jamaat, int alone, int missed, int remaining) {
    return '$jamaat Jamaat · $alone Alone · $missed Missed · $remaining Remaining';
  }

  @override
  String get masbooq => 'Masbooq';

  @override
  String get prayedAtMasjid => 'Masjid';

  @override
  String get prayedAtHome => 'Home';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get pickDate => 'Pick a date';

  @override
  String get tabQaza => 'Qaza';

  @override
  String get currentStreak => 'Current streak';

  @override
  String get bestStreak => 'Best streak';

  @override
  String get mostMissedTitle => 'Most missed prayer';

  @override
  String mostMissedValue(String prayer, int count) {
    return '$prayer: $count missed';
  }

  @override
  String get jamaatPercentLabel => 'Jamaat';

  @override
  String get yearTotalsLabel => 'Totals';

  @override
  String get tapDateToEdit => 'Tap a date to view or edit its prayers';

  @override
  String editDayTitle(String date) {
    return 'Prayers on $date';
  }

  @override
  String get qazaManager => 'Qaza manager';

  @override
  String get qazaPendingTitle => 'Pending qaza';

  @override
  String get qazaAddManual => 'Add manually';

  @override
  String get qazaMarkMadeUp => 'Mark as made up';

  @override
  String get qazaHistoryTitle => 'History';

  @override
  String get qazaNoPending => 'No pending qaza — Alhamdulillah';

  @override
  String get qazaAddDialogTitle => 'Add old qaza';

  @override
  String get qazaRakatsLabel => 'Rakats';

  @override
  String get qazaAdded => 'Qaza added';

  @override
  String get qazaCleared => 'Marked as made up';

  @override
  String get qazaAutoNote => 'Auto-added (missed prayer)';

  @override
  String get pendingWord => 'pending';

  @override
  String get naflTahajjud => 'Tahajjud';

  @override
  String get naflIshraq => 'Ishraq';

  @override
  String get naflChasht => 'Chasht / Duha';

  @override
  String get naflAwwabin => 'Awwabin';

  @override
  String get naflTahiyyatulWudu => 'Tahiyyatul Wudu';

  @override
  String get naflTahiyyatulMasjid => 'Tahiyyatul Masjid';

  @override
  String get naflSunnahMuakkadah => 'Sunnah Muakkadah';

  @override
  String get naflGhairMuakkadah => 'Ghair Muakkadah';

  @override
  String get naflTasbeeh => 'Salat-ul-Tasbeeh';

  @override
  String get naflHajat => 'Salat-ul-Hajat';

  @override
  String get naflTawbah => 'Salat-ul-Tawbah';

  @override
  String get naflCustom => 'Custom';

  @override
  String get naflAddCustom => 'Add custom nafl';

  @override
  String get naflCustomName => 'Name';

  @override
  String get naflRakatsLabel => 'Rakats';

  @override
  String get naflNoteLabel => 'Note';

  @override
  String get naflGoal => 'Daily goal';

  @override
  String get streakTahajjud => 'Tahajjud streak';

  @override
  String get streakDuha => 'Duha streak';

  @override
  String get daysPerformedLabel => 'Days performed';

  @override
  String get deleteWord => 'Delete';

  @override
  String rakatsCount(int count) {
    return '$count rakats';
  }

  @override
  String get settingsPrayerTimes => 'Prayer times';

  @override
  String get settingsLocation => 'Calculation location';

  @override
  String get settingsNaflGoal => 'Daily nafl goal (rakats)';

  @override
  String get phaseThreeBanner => 'Phase 3 — Tilawat, Azkar & Khatam';

  @override
  String get addWord => 'Add';

  @override
  String get saveWord => 'Save';

  @override
  String get cancelWord => 'Cancel';

  @override
  String get closeWord => 'Close';

  @override
  String countOfTarget(int count, int target) {
    return '$count of $target';
  }

  @override
  String get settingsTilawatSection => 'Tilawat & Khatam';

  @override
  String get settingsTilawatUnit => 'Recitation unit';

  @override
  String get settingsTilawatGoal => 'Daily tilawat goal';

  @override
  String get settingsKhatamGoal => 'Yearly khatam goal';

  @override
  String get unitPages => 'Pages';

  @override
  String get unitRuku => 'Ruku';

  @override
  String get unitPara => 'Para';

  @override
  String get unitMinutes => 'Minutes';

  @override
  String get tilawatLogTitle => 'Log recitation';

  @override
  String get tilawatAddEntry => 'Add entry';

  @override
  String get tilawatAmountLabel => 'Amount';

  @override
  String get tilawatUnitLabel => 'Unit';

  @override
  String get tilawatEntriesTitle => 'Entries';

  @override
  String get tilawatGoalTitle => 'Daily goal';

  @override
  String tilawatGoalProgress(int done, int goal) {
    return '$done of $goal';
  }

  @override
  String get tilawatPositionTitle => 'Current position';

  @override
  String get tilawatParaLabel => 'Para';

  @override
  String get tilawatSurahLabel => 'Surah';

  @override
  String get tilawatPageLabel => 'Page';

  @override
  String get tilawatContinue => 'Continue from where I stopped';

  @override
  String get tilawatUpdatePosition => 'Update position';

  @override
  String get tilawatPositionSaved => 'Position updated';

  @override
  String get tilawatEntryDeleted => 'Entry deleted';

  @override
  String get tilawatAmountInvalid => 'Enter a valid amount';

  @override
  String get tilawatTotalPages => 'Total pages';

  @override
  String get tilawatTotalMinutes => 'Total minutes';

  @override
  String get tilawatDaysRecited => 'Days recited';

  @override
  String get tilawatAveragePerDay => 'Average per day';

  @override
  String get tilawatGoalAchievement => 'Goal achieved';

  @override
  String get tilawatStreak => 'Tilawat streak';

  @override
  String get tilawatCalendarTitle => 'Recitation calendar';

  @override
  String get tilawatGoalDays => 'Goal days';

  @override
  String get azkarMorning => 'Morning adhkar';

  @override
  String get azkarEvening => 'Evening adhkar';

  @override
  String get azkarTasbeehSubhan => 'SubhanAllah (33)';

  @override
  String get azkarTasbeehHamd => 'Alhamdulillah (33)';

  @override
  String get azkarTasbeehAkbar => 'Allahu Akbar (34)';

  @override
  String get azkarDurood => 'Durood Shareef';

  @override
  String get azkarIstighfar => 'Istighfar';

  @override
  String get azkarKalima3 => '3rd Kalima';

  @override
  String get azkarLailaha => 'La ilaha illallah';

  @override
  String get azkarAyatulKursi => 'Ayat-ul-Kursi';

  @override
  String get azkarCustomTitle => 'Custom dhikr';

  @override
  String get azkarAddCustom => 'Add custom dhikr';

  @override
  String get azkarCustomName => 'Name';

  @override
  String get azkarCustomArabic => 'Arabic text';

  @override
  String get azkarCustomTarget => 'Target count';

  @override
  String get azkarCustomReminder => 'Reminder time (HH:mm)';

  @override
  String get azkarTargetLabel => 'Target';

  @override
  String get azkarCountLabel => 'Count';

  @override
  String get azkarCounterTitle => 'Tasbeeh counter';

  @override
  String get azkarTapToCount => 'Tap to count';

  @override
  String get azkarReset => 'Reset';

  @override
  String get azkarUndo => 'Undo';

  @override
  String get azkarTargetReached => 'Target reached — MashaAllah';

  @override
  String get azkarKeepAwake => 'Keep screen awake';

  @override
  String get azkarSound => 'Tap sound';

  @override
  String get azkarAllDone => 'All daily adhkar complete';

  @override
  String get azkarPieTitle => 'Per-dhikr counts';

  @override
  String get azkarDeleted => 'Custom dhikr removed';

  @override
  String get azkarResetDone => 'Counters reset';

  @override
  String get azkarUndoDone => 'Last count undone';

  @override
  String get azkarStreak => 'Azkar streak';

  @override
  String get khatamStart => 'Start new khatam';

  @override
  String get khatamComplete => 'Complete khatam';

  @override
  String get khatamActiveTitle => 'Current khatam';

  @override
  String get khatamNoActive => 'No active khatam';

  @override
  String get khatamProgressTitle => 'Progress';

  @override
  String khatamParasDone(int done) {
    return '$done of 30 paras';
  }

  @override
  String khatamPara(int number) {
    return 'Para $number';
  }

  @override
  String get khatamSyncPosition => 'Sync with Tilawat position';

  @override
  String get khatamStarted => 'Khatam started';

  @override
  String get khatamCompletedSnack => 'Khatam completed — may Allah accept';

  @override
  String get khatamCongratsTitle => 'MashaAllah! Khatam complete';

  @override
  String get khatamDua => 'May Allah accept your recitation and grant you its blessings.';

  @override
  String khatamDaysTaken(int days) {
    return '$days days';
  }

  @override
  String get khatamHistoryTitle => 'Khatam history';

  @override
  String get khatamTotal => 'Total khatams';

  @override
  String get khatamThisYear => 'This year';

  @override
  String get khatamAllTime => 'All time';

  @override
  String get khatamYearGoal => 'Yearly goal';

  @override
  String get khatamYearlyTitle => 'Khatams per year';

  @override
  String get khatamStartDate => 'Started';

  @override
  String get khatamEndDate => 'Completed';

  @override
  String get khatamInProgress => 'In progress';

  @override
  String khatamGoalProgress(int done, int goal) {
    return '$done of $goal this year';
  }

  @override
  String get khatamNoHistory => 'No completed khatams yet';

  @override
  String get phaseFourBanner => 'Phase 4 · Gheebat, Muraqaba & Timetable are now live';

  @override
  String get gheebatIntro => 'A private daily check-in to protect the tongue. Only totals are shown on the dashboard.';

  @override
  String get gheebatTodayTitle => 'Today\'s check-in';

  @override
  String get gheebatFree => 'Gheebat-free';

  @override
  String get gheebatFreeHint => 'Alhamdulillah, I protected my tongue today';

  @override
  String get gheebatSlipped => 'I slipped';

  @override
  String get gheebatSlippedHint => 'I backbit and seek forgiveness';

  @override
  String get gheebatNotRecorded => 'Not recorded';

  @override
  String get gheebatIstighfarTitle => 'Istighfar counter';

  @override
  String get gheebatIstighfarHint => 'Tap to repeat أستغفر الله';

  @override
  String get gheebatNoteTitle => 'Private note';

  @override
  String get gheebatNoteHint => 'What triggered it? What will you do differently?';

  @override
  String get gheebatNoteSaved => 'Note saved';

  @override
  String get gheebatReset => 'Clear this day';

  @override
  String get gheebatResetConfirm => 'Clear today\'s Gheebat record?';

  @override
  String get gheebatFreeDaysLabel => 'Free days';

  @override
  String get gheebatSlippedDaysLabel => 'Slipped days';

  @override
  String get gheebatRecordedDaysLabel => 'Days checked in';

  @override
  String get gheebatFreePercentLabel => 'Free-day rate';

  @override
  String get gheebatCalendarTitle => 'This month';

  @override
  String get gheebatYearChartTitle => 'Free days by month';

  @override
  String get gheebatReminderTitle => 'Evening reminder';

  @override
  String get gheebatReminderBody => 'Do not forget to check in before sleeping.';

  @override
  String get gheebatLockTitle => 'Private PIN lock';

  @override
  String get gheebatLockBody => 'Protect your notes with a 4–8 digit PIN. Notes stay hidden until unlocked.';

  @override
  String get gheebatSetPin => 'Set PIN';

  @override
  String get gheebatChangePin => 'Change PIN';

  @override
  String get gheebatRemovePin => 'Remove PIN';

  @override
  String get gheebatEnterPin => 'Enter PIN';

  @override
  String get gheebatConfirmPin => 'Confirm PIN';

  @override
  String get gheebatPinMismatch => 'PINs do not match';

  @override
  String get gheebatWrongPin => 'Incorrect PIN';

  @override
  String get gheebatPinInvalid => 'Use 4–8 digits';

  @override
  String get gheebatPinSet => 'PIN enabled';

  @override
  String get gheebatPinRemoved => 'PIN removed';

  @override
  String get gheebatUnlock => 'Unlock';

  @override
  String get gheebatLockNow => 'Lock now';

  @override
  String get gheebatLockedTitle => 'Notes are locked';

  @override
  String get gheebatLockedBody => 'Unlock to see your private reflections.';

  @override
  String get muraqabaIntro => 'Sit quietly, breathe gently and bring the heart back to Allah.';

  @override
  String get muraqabaTimerTitle => 'Quiet timer';

  @override
  String get muraqabaStart => 'Start';

  @override
  String get muraqabaPause => 'Pause';

  @override
  String get muraqabaResume => 'Resume';

  @override
  String get muraqabaFinish => 'Finish & save';

  @override
  String get muraqabaResetTimer => 'Reset timer';

  @override
  String get muraqabaPresetLabel => 'Quick length';

  @override
  String get muraqabaCustomMinutes => 'Custom minutes';

  @override
  String muraqabaDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String get muraqabaSessionSaved => 'Session saved';

  @override
  String get muraqabaTimeLabel => 'Time of day';

  @override
  String get muraqabaTimeAfterFajr => 'After Fajr';

  @override
  String get muraqabaTimeTahajjud => 'Tahajjud';

  @override
  String get muraqabaTimeMorning => 'Morning';

  @override
  String get muraqabaTimeAfternoon => 'Afternoon';

  @override
  String get muraqabaTimeEvening => 'Evening';

  @override
  String get muraqabaTimeNight => 'Night';

  @override
  String get muraqabaLogManual => 'Log a session';

  @override
  String get muraqabaSessionNote => 'Session note (optional)';

  @override
  String get muraqabaSourceTimer => 'Timer';

  @override
  String get muraqabaSourceManual => 'Manual';

  @override
  String get muraqabaTodayTitle => 'Today\'s sessions';

  @override
  String get muraqabaTodayEmpty => 'No session yet today';

  @override
  String get muraqabaPracticeToday => 'Practised today';

  @override
  String get muraqabaNoPracticeToday => 'Not practised yet';

  @override
  String get muraqabaTotalMinutes => 'Total minutes';

  @override
  String get muraqabaSessionsLabel => 'Sessions';

  @override
  String get muraqabaDaysLabel => 'Days practised';

  @override
  String get muraqabaAverageLabel => 'Average session';

  @override
  String get muraqabaYearChartTitle => 'Minutes by month';

  @override
  String get muraqabaHeatmapTitle => 'Practice calendar';

  @override
  String get muraqabaGuideTitle => 'A simple way to begin';

  @override
  String get muraqabaGuideBody => '1. Sit comfortably and relax your shoulders.\n2. Recite istighfar a few times.\n3. Watch your breath and return the heart to Allah whenever it wanders.\n4. End with a short dua.';

  @override
  String get timetableTodayTitle => 'Today\'s schedule';

  @override
  String get timetableAddTask => 'Add task';

  @override
  String get timetableEditTask => 'Edit task';

  @override
  String get timetableNoTasks => 'No tasks for this day';

  @override
  String get timetableNoTasksHint => 'Add a task or start from a template.';

  @override
  String get timetableTaskTitle => 'Task title';

  @override
  String get timetableCategoryLabel => 'Category';

  @override
  String get timetableStartTime => 'Start';

  @override
  String get timetableEndTime => 'End';

  @override
  String get timetableRepeatLabel => 'Repeat';

  @override
  String get timetableReminderLabel => 'Reminder';

  @override
  String get timetableReminderNone => 'No reminder';

  @override
  String get timetableNoteLabel => 'Note (optional)';

  @override
  String get timetableIconLabel => 'Icon';

  @override
  String get timetableColorLabel => 'Colour';

  @override
  String get timetableTaskSaved => 'Task saved';

  @override
  String get timetableTaskDeleted => 'Task deleted';

  @override
  String get timetableDeleteConfirm => 'Delete this task and its history?';

  @override
  String get timetableTemplates => 'Templates';

  @override
  String get timetableTemplatesBody => 'Add a ready-made routine, then adjust it freely.';

  @override
  String get timetableApply => 'Use template';

  @override
  String get timetableTemplateApplied => 'Template added';

  @override
  String timetableScheduledMinutes(int minutes) {
    return '$minutes min scheduled';
  }

  @override
  String timetableDoneOf(int done, int total) {
    return '$done of $total done';
  }

  @override
  String timetableCompletion(int percent) {
    return '$percent% complete';
  }

  @override
  String get timetableNow => 'Now';

  @override
  String get timetableResizeHint => 'Drag the bottom edge to change the duration';

  @override
  String get timetableTodaySchedule => 'Today\'s timetable';

  @override
  String get repeatOnce => 'Once';

  @override
  String get repeatDaily => 'Every day';

  @override
  String get repeatWeekdays => 'Weekdays';

  @override
  String get repeatCustomDays => 'Selected days';

  @override
  String get repeatPickDays => 'Repeat on';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get taskCategoryIbadah => 'Ibadah';

  @override
  String get taskCategoryWork => 'Work';

  @override
  String get taskCategoryStudy => 'Study';

  @override
  String get taskCategoryFamily => 'Family';

  @override
  String get taskCategoryHealth => 'Health';

  @override
  String get taskCategoryRest => 'Rest';

  @override
  String get tplIbadahDay => 'Balanced ibadah day';

  @override
  String get tplIbadahDayDesc => 'Five prayers, Quran, adhkar, work and family.';

  @override
  String get tplStudentDay => 'Student study day';

  @override
  String get tplStudentDayDesc => 'Tahajjud, study blocks and revision.';

  @override
  String get tplFamilyDay => 'Family weekend';

  @override
  String get tplFamilyDayDesc => 'Exercise, meals, family time and rest.';

  @override
  String get taskTplFajr => 'Fajr salah';

  @override
  String get taskTplQuran => 'Quran recitation';

  @override
  String get taskTplAdhkar => 'Morning adhkar';

  @override
  String get taskTplWork => 'Work block';

  @override
  String get taskTplFamily => 'Family time';

  @override
  String get taskTplIsha => 'Isha salah';

  @override
  String get taskTplTahajjud => 'Tahajjud';

  @override
  String get taskTplStudy => 'Study block';

  @override
  String get taskTplRevision => 'Revision';

  @override
  String get taskTplExercise => 'Exercise';

  @override
  String get taskTplBreakfast => 'Breakfast';

  @override
  String get taskTplRest => 'Rest';

  @override
  String get taskTplDinner => 'Dinner';

  @override
  String get taskTplSleep => 'Sleep';
}
