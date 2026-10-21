import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur')
  ];

  /// Application title shown in the AppBar and about section.
  ///
  /// In en, this message translates to:
  /// **'Ibadah Tracker'**
  String get appName;

  /// Short marketing tagline under the app name.
  ///
  /// In en, this message translates to:
  /// **'Your daily path to Allah'**
  String get appTagline;

  /// Name of the Dashboard module.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get moduleDashboard;

  /// Name of the Timetable module.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get moduleTimetable;

  /// Name of the five daily prayers module.
  ///
  /// In en, this message translates to:
  /// **'Namaz'**
  String get moduleNamaz;

  /// Name of the optional (nafl) prayers module.
  ///
  /// In en, this message translates to:
  /// **'Nafl'**
  String get moduleNafl;

  /// Name of the Quran recitation module.
  ///
  /// In en, this message translates to:
  /// **'Tilawat'**
  String get moduleTilawat;

  /// Name of the remembrance (azkar) module.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get moduleAzkar;

  /// Name of the backbiting watch module.
  ///
  /// In en, this message translates to:
  /// **'Gheebat'**
  String get moduleGheebat;

  /// Name of the meditation (muraqaba) module.
  ///
  /// In en, this message translates to:
  /// **'Muraqaba'**
  String get moduleMuraqaba;

  /// Name of the Quran khatam module.
  ///
  /// In en, this message translates to:
  /// **'Khatam'**
  String get moduleKhatam;

  /// Name of the Ramadan fasting module.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get moduleRamadan;

  /// Name of the reports/analytics module.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get moduleReports;

  /// Name of the settings module.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moduleSettings;

  /// Dropdown menu button in the AppBar listing every module.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Tooltip of the drawer button on phones.
  ///
  /// In en, this message translates to:
  /// **'Open navigation'**
  String get openDrawer;

  /// Title at the top of the navigation drawer/rail.
  ///
  /// In en, this message translates to:
  /// **'Ibadah Tracker'**
  String get navigationTitle;

  /// Small badge shown in the navigation panel.
  ///
  /// In en, this message translates to:
  /// **'Phase 1 — foundation'**
  String get phaseOneBanner;

  /// Arabic calligraphy shown on the splash screen (kept in Arabic for every locale).
  ///
  /// In en, this message translates to:
  /// **'بسم اللہ'**
  String get bismillah;

  /// Splash screen subtitle while the database loads.
  ///
  /// In en, this message translates to:
  /// **'Preparing your tracker…'**
  String get splashStarting;

  /// Greeting between 04:00 and 11:59.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// Greeting between 12:00 and 16:59.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// Greeting between 17:00 and 20:59.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// Greeting between 21:00 and 03:59.
  ///
  /// In en, this message translates to:
  /// **'Good night'**
  String get greetingNight;

  /// Motivational card quote (Urdu translation lives in app_ur.arb).
  ///
  /// In en, this message translates to:
  /// **'Strive to reach Allah. When Allah is found, everything is found.'**
  String get quote;

  /// Small caption above the quote.
  ///
  /// In en, this message translates to:
  /// **'Motivation of the day'**
  String get quoteBy;

  /// Dashboard range: current day.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get rangeToday;

  /// Dashboard range: current calendar month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get rangeMonth;

  /// Dashboard range: current calendar year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get rangeYear;

  /// Completed portion of a statistic.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Remaining portion of a statistic (Urdu: نہیں کیا).
  ///
  /// In en, this message translates to:
  /// **'Not done'**
  String get notDone;

  /// Shown when a module has no data in the selected range.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noData;

  /// Percentage completion label inside donut charts.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completion;

  /// Consecutive days with all five prayers completed.
  ///
  /// In en, this message translates to:
  /// **'Prayer streak'**
  String get streak;

  /// Streak value, e.g. '12 days'.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String streakValue(int count);

  /// Supporting text under the streak counter.
  ///
  /// In en, this message translates to:
  /// **'Keep the chain alive'**
  String get streakHint;

  /// Title of the weekly bar chart.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get weeklyTitle;

  /// Subtitle of the weekly bar chart.
  ///
  /// In en, this message translates to:
  /// **'Daily completion score'**
  String get weeklySubtitle;

  /// Title of the 12-month bar chart.
  ///
  /// In en, this message translates to:
  /// **'Monthly breakdown'**
  String get monthlyTitle;

  /// Title of the donut chart grid.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTitle;

  /// Donut card: five daily prayers.
  ///
  /// In en, this message translates to:
  /// **'Namaz'**
  String get statPrayers;

  /// Donut card: optional prayers.
  ///
  /// In en, this message translates to:
  /// **'Nafl'**
  String get statNafl;

  /// Donut card: Quran recitation.
  ///
  /// In en, this message translates to:
  /// **'Tilawat'**
  String get statTilawat;

  /// Donut card: remembrances.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get statAzkar;

  /// Donut card: days without backbiting.
  ///
  /// In en, this message translates to:
  /// **'Gheebat-free'**
  String get statGheebatFree;

  /// Donut card: meditation.
  ///
  /// In en, this message translates to:
  /// **'Muraqaba'**
  String get statMuraqaba;

  /// Donut card: Quran completion plans.
  ///
  /// In en, this message translates to:
  /// **'Khatam'**
  String get statKhatam;

  /// Donut card: Ramadan fasts.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get statRamadan;

  /// Namaz card detail line.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} prayers'**
  String detailPrayers(int done, int total);

  /// Nafl card detail line.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} rakats'**
  String detailRakats(int done, int total);

  /// Tilawat card detail line.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} pages'**
  String detailPages(int done, int total);

  /// Generic card detail line (Azkar, Muraqaba, Khatam, Ramadan).
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String detailCounts(int done, int total);

  /// Gheebat-free card detail line.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} days'**
  String detailDays(int done, int total);

  /// Muraqaba minutes detail (kept for later phases).
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} min'**
  String detailMinutes(int done, int total);

  /// Tilawat card secondary line.
  ///
  /// In en, this message translates to:
  /// **'{pages} pages · {minutes} min · Para {para}'**
  String subTilawat(int pages, int minutes, int para);

  /// Namaz card secondary line.
  ///
  /// In en, this message translates to:
  /// **'{jamaat} Jamaat · {alone} alone · {missed} missed'**
  String subPrayers(int jamaat, int alone, int missed);

  /// Prayer status: prayed with congregation.
  ///
  /// In en, this message translates to:
  /// **'Jamaat'**
  String get jamaat;

  /// Prayer status: prayed alone.
  ///
  /// In en, this message translates to:
  /// **'Alone'**
  String get alone;

  /// Prayer status: missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// First takbeer of the prayer.
  ///
  /// In en, this message translates to:
  /// **'Takbeer Ula'**
  String get takbeerUla;

  /// Settings section header.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// Language selection tile.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Theme selection tile.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// Light theme option.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Follow system theme option.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Digit style selection tile.
  ///
  /// In en, this message translates to:
  /// **'Numerals'**
  String get settingsNumerals;

  /// Latin digits option.
  ///
  /// In en, this message translates to:
  /// **'Western (1, 2, 3)'**
  String get numeralsWestern;

  /// Eastern Arabic/Urdu digits option.
  ///
  /// In en, this message translates to:
  /// **'Urdu (۱, ۲, ۳)'**
  String get numeralsEastern;

  /// English language option.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Urdu language option (written in Urdu script).
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get languageUrdu;

  /// About section header.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// Version/phase line in settings.
  ///
  /// In en, this message translates to:
  /// **'Ibadah Tracker · Phase 1 foundation'**
  String get settingsAboutValue;

  /// Snackbar shown after a setting changes.
  ///
  /// In en, this message translates to:
  /// **'Preference saved'**
  String get settingsSaved;

  /// Placeholder screen title.
  ///
  /// In en, this message translates to:
  /// **'Coming in Phase 2'**
  String get comingSoonTitle;

  /// Placeholder screen body text.
  ///
  /// In en, this message translates to:
  /// **'This module is scheduled for the next phase. Theme, database, navigation and localization are already in place.'**
  String get comingSoonBody;

  /// Button on placeholder screens.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get backToDashboard;

  /// Navigation badge after Phase 2.
  ///
  /// In en, this message translates to:
  /// **'Phase 2 — Namaz & Nafl'**
  String get phaseTwoBanner;

  /// Prayer name.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// Prayer name.
  ///
  /// In en, this message translates to:
  /// **'Zuhr'**
  String get prayerZuhr;

  /// Prayer name.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// Prayer name.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// Prayer name.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// Prayer name.
  ///
  /// In en, this message translates to:
  /// **'Witr'**
  String get prayerWitr;

  /// Summary: prayers not yet marked.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// A prayer with no status yet.
  ///
  /// In en, this message translates to:
  /// **'Not marked'**
  String get notMarked;

  /// Shown when every prayer of the day has a status.
  ///
  /// In en, this message translates to:
  /// **'All six prayers marked'**
  String get dayComplete;

  /// Live daily summary bar text.
  ///
  /// In en, this message translates to:
  /// **'{jamaat} Jamaat · {alone} Alone · {missed} Missed · {remaining} Remaining'**
  String summaryLine(int jamaat, int alone, int missed, int remaining);

  /// Joined the prayer after it started.
  ///
  /// In en, this message translates to:
  /// **'Masbooq'**
  String get masbooq;

  /// Prayed at the masjid toggle.
  ///
  /// In en, this message translates to:
  /// **'Masjid'**
  String get prayedAtMasjid;

  /// Prayed at home (default).
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get prayedAtHome;

  /// Date selector: previous arrow tooltip.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get previousDay;

  /// Date selector: next arrow tooltip.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get nextDay;

  /// Open the calendar picker.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get pickDate;

  /// Namaz screen tab.
  ///
  /// In en, this message translates to:
  /// **'Qaza'**
  String get tabQaza;

  /// Consecutive complete days so far.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get currentStreak;

  /// Longest run of consecutive complete days.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get bestStreak;

  /// Per-prayer analysis heading.
  ///
  /// In en, this message translates to:
  /// **'Most missed prayer'**
  String get mostMissedTitle;

  /// One line of the per-prayer missed analysis.
  ///
  /// In en, this message translates to:
  /// **'{prayer}: {count} missed'**
  String mostMissedValue(String prayer, int count);

  /// Label beside the jamaat percentage.
  ///
  /// In en, this message translates to:
  /// **'Jamaat'**
  String get jamaatPercentLabel;

  /// Year view totals header.
  ///
  /// In en, this message translates to:
  /// **'Totals'**
  String get yearTotalsLabel;

  /// Hint under the calendar heatmap.
  ///
  /// In en, this message translates to:
  /// **'Tap a date to view or edit its prayers'**
  String get tapDateToEdit;

  /// Bottom-sheet title when editing one day from the heatmap.
  ///
  /// In en, this message translates to:
  /// **'Prayers on {date}'**
  String editDayTitle(String date);

  /// Qaza tab title.
  ///
  /// In en, this message translates to:
  /// **'Qaza manager'**
  String get qazaManager;

  /// Counters of not-yet-made-up qaza.
  ///
  /// In en, this message translates to:
  /// **'Pending qaza'**
  String get qazaPendingTitle;

  /// Button to add old/legacy qaza.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get qazaAddManual;

  /// Decreases the pending counter.
  ///
  /// In en, this message translates to:
  /// **'Mark as made up'**
  String get qazaMarkMadeUp;

  /// Log of made-up qaza.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get qazaHistoryTitle;

  /// Empty state of the pending list.
  ///
  /// In en, this message translates to:
  /// **'No pending qaza — Alhamdulillah'**
  String get qazaNoPending;

  /// Dialog title for manual qaza.
  ///
  /// In en, this message translates to:
  /// **'Add old qaza'**
  String get qazaAddDialogTitle;

  /// Rakats field in the qaza dialog.
  ///
  /// In en, this message translates to:
  /// **'Rakats'**
  String get qazaRakatsLabel;

  /// Snackbar after manual add.
  ///
  /// In en, this message translates to:
  /// **'Qaza added'**
  String get qazaAdded;

  /// Snackbar after clearing qaza.
  ///
  /// In en, this message translates to:
  /// **'Marked as made up'**
  String get qazaCleared;

  /// Row subtitle for auto qaza entries.
  ///
  /// In en, this message translates to:
  /// **'Auto-added (missed prayer)'**
  String get qazaAutoNote;

  /// Suffix on pending counters.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get pendingWord;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud'**
  String get naflTahajjud;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Ishraq'**
  String get naflIshraq;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Chasht / Duha'**
  String get naflChasht;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Awwabin'**
  String get naflAwwabin;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Tahiyyatul Wudu'**
  String get naflTahiyyatulWudu;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Tahiyyatul Masjid'**
  String get naflTahiyyatulMasjid;

  /// Nafl prayer name (before/after fard).
  ///
  /// In en, this message translates to:
  /// **'Sunnah Muakkadah'**
  String get naflSunnahMuakkadah;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Ghair Muakkadah'**
  String get naflGhairMuakkadah;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Salat-ul-Tasbeeh'**
  String get naflTasbeeh;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Salat-ul-Hajat'**
  String get naflHajat;

  /// Nafl prayer name.
  ///
  /// In en, this message translates to:
  /// **'Salat-ul-Tawbah'**
  String get naflTawbah;

  /// Category label for user-added nafls.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get naflCustom;

  /// Button that opens the custom nafl dialog.
  ///
  /// In en, this message translates to:
  /// **'Add custom nafl'**
  String get naflAddCustom;

  /// Custom nafl name field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get naflCustomName;

  /// Rakats stepper label.
  ///
  /// In en, this message translates to:
  /// **'Rakats'**
  String get naflRakatsLabel;

  /// Optional note field.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get naflNoteLabel;

  /// Nafl daily rakats goal ring label.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get naflGoal;

  /// Consecutive days with Tahajjud.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud streak'**
  String get streakTahajjud;

  /// Consecutive days with Chasht/Duha.
  ///
  /// In en, this message translates to:
  /// **'Duha streak'**
  String get streakDuha;

  /// Stats: days with at least one nafl.
  ///
  /// In en, this message translates to:
  /// **'Days performed'**
  String get daysPerformedLabel;

  /// Delete a custom nafl row.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteWord;

  /// Rakats caption.
  ///
  /// In en, this message translates to:
  /// **'{count} rakats'**
  String rakatsCount(int count);

  /// Settings section header.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get settingsPrayerTimes;

  /// City used for adhan prayer times.
  ///
  /// In en, this message translates to:
  /// **'Calculation location'**
  String get settingsLocation;

  /// Nafl goal ring target.
  ///
  /// In en, this message translates to:
  /// **'Daily nafl goal (rakats)'**
  String get settingsNaflGoal;

  /// Navigation badge after Phase 3.
  ///
  /// In en, this message translates to:
  /// **'Phase 3 — Tilawat, Azkar & Khatam'**
  String get phaseThreeBanner;

  /// Generic add button.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addWord;

  /// Generic save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveWord;

  /// Generic cancel button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelWord;

  /// Generic close button.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeWord;

  /// Counter progress, e.g. '12 of 33'.
  ///
  /// In en, this message translates to:
  /// **'{count} of {target}'**
  String countOfTarget(int count, int target);

  /// Settings section header.
  ///
  /// In en, this message translates to:
  /// **'Tilawat & Khatam'**
  String get settingsTilawatSection;

  /// Unit used when logging recitation.
  ///
  /// In en, this message translates to:
  /// **'Recitation unit'**
  String get settingsTilawatUnit;

  /// Daily recitation goal.
  ///
  /// In en, this message translates to:
  /// **'Daily tilawat goal'**
  String get settingsTilawatGoal;

  /// Khatams to complete per year.
  ///
  /// In en, this message translates to:
  /// **'Yearly khatam goal'**
  String get settingsKhatamGoal;

  /// Tilawat unit: pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get unitPages;

  /// Tilawat unit: ruku.
  ///
  /// In en, this message translates to:
  /// **'Ruku'**
  String get unitRuku;

  /// Tilawat unit: para.
  ///
  /// In en, this message translates to:
  /// **'Para'**
  String get unitPara;

  /// Tilawat unit: minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get unitMinutes;

  /// Card title for adding a recitation entry.
  ///
  /// In en, this message translates to:
  /// **'Log recitation'**
  String get tilawatLogTitle;

  /// Button to save a recitation entry.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get tilawatAddEntry;

  /// Amount field in the entry form.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get tilawatAmountLabel;

  /// Unit dropdown label.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get tilawatUnitLabel;

  /// List of the day's recitation entries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get tilawatEntriesTitle;

  /// Daily goal ring label.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get tilawatGoalTitle;

  /// Goal progress caption.
  ///
  /// In en, this message translates to:
  /// **'{done} of {goal}'**
  String tilawatGoalProgress(int done, int goal);

  /// Reading position card.
  ///
  /// In en, this message translates to:
  /// **'Current position'**
  String get tilawatPositionTitle;

  /// Current para field.
  ///
  /// In en, this message translates to:
  /// **'Para'**
  String get tilawatParaLabel;

  /// Current surah field.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get tilawatSurahLabel;

  /// Current page field.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get tilawatPageLabel;

  /// Button showing the saved position.
  ///
  /// In en, this message translates to:
  /// **'Continue from where I stopped'**
  String get tilawatContinue;

  /// Saves the reading position.
  ///
  /// In en, this message translates to:
  /// **'Update position'**
  String get tilawatUpdatePosition;

  /// Snackbar after saving position.
  ///
  /// In en, this message translates to:
  /// **'Position updated'**
  String get tilawatPositionSaved;

  /// Snackbar after deleting an entry.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get tilawatEntryDeleted;

  /// Validation message.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get tilawatAmountInvalid;

  /// Stats: pages recorded.
  ///
  /// In en, this message translates to:
  /// **'Total pages'**
  String get tilawatTotalPages;

  /// Stats: minutes recorded.
  ///
  /// In en, this message translates to:
  /// **'Total minutes'**
  String get tilawatTotalMinutes;

  /// Stats: days with recitation.
  ///
  /// In en, this message translates to:
  /// **'Days recited'**
  String get tilawatDaysRecited;

  /// Stats: average amount per day.
  ///
  /// In en, this message translates to:
  /// **'Average per day'**
  String get tilawatAveragePerDay;

  /// Donut chart: goal met days.
  ///
  /// In en, this message translates to:
  /// **'Goal achieved'**
  String get tilawatGoalAchievement;

  /// Consecutive days with recitation.
  ///
  /// In en, this message translates to:
  /// **'Tilawat streak'**
  String get tilawatStreak;

  /// Month heatmap title.
  ///
  /// In en, this message translates to:
  /// **'Recitation calendar'**
  String get tilawatCalendarTitle;

  /// Days where the daily goal was met.
  ///
  /// In en, this message translates to:
  /// **'Goal days'**
  String get tilawatGoalDays;

  /// Built-in dhikr: morning set.
  ///
  /// In en, this message translates to:
  /// **'Morning adhkar'**
  String get azkarMorning;

  /// Built-in dhikr: evening set.
  ///
  /// In en, this message translates to:
  /// **'Evening adhkar'**
  String get azkarEvening;

  /// After-prayer tasbeeh.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah (33)'**
  String get azkarTasbeehSubhan;

  /// After-prayer tasbeeh.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah (33)'**
  String get azkarTasbeehHamd;

  /// After-prayer tasbeeh.
  ///
  /// In en, this message translates to:
  /// **'Allahu Akbar (34)'**
  String get azkarTasbeehAkbar;

  /// Built-in dhikr.
  ///
  /// In en, this message translates to:
  /// **'Durood Shareef'**
  String get azkarDurood;

  /// Built-in dhikr.
  ///
  /// In en, this message translates to:
  /// **'Istighfar'**
  String get azkarIstighfar;

  /// Built-in dhikr.
  ///
  /// In en, this message translates to:
  /// **'3rd Kalima'**
  String get azkarKalima3;

  /// Built-in dhikr.
  ///
  /// In en, this message translates to:
  /// **'La ilaha illallah'**
  String get azkarLailaha;

  /// Built-in dhikr.
  ///
  /// In en, this message translates to:
  /// **'Ayat-ul-Kursi'**
  String get azkarAyatulKursi;

  /// User-defined dhikr section.
  ///
  /// In en, this message translates to:
  /// **'Custom dhikr'**
  String get azkarCustomTitle;

  /// Opens the custom dhikr dialog.
  ///
  /// In en, this message translates to:
  /// **'Add custom dhikr'**
  String get azkarAddCustom;

  /// Custom dhikr name field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get azkarCustomName;

  /// Custom dhikr Arabic text field.
  ///
  /// In en, this message translates to:
  /// **'Arabic text'**
  String get azkarCustomArabic;

  /// Custom dhikr target field.
  ///
  /// In en, this message translates to:
  /// **'Target count'**
  String get azkarCustomTarget;

  /// Optional reminder time field.
  ///
  /// In en, this message translates to:
  /// **'Reminder time (HH:mm)'**
  String get azkarCustomReminder;

  /// Target caption.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get azkarTargetLabel;

  /// Count caption.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get azkarCountLabel;

  /// Full-screen counter title.
  ///
  /// In en, this message translates to:
  /// **'Tasbeeh counter'**
  String get azkarCounterTitle;

  /// Hint under the large counter button.
  ///
  /// In en, this message translates to:
  /// **'Tap to count'**
  String get azkarTapToCount;

  /// Counter reset button.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get azkarReset;

  /// Counter undo button.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get azkarUndo;

  /// Shown when the target count is hit.
  ///
  /// In en, this message translates to:
  /// **'Target reached — MashaAllah'**
  String get azkarTargetReached;

  /// Wakelock toggle on the counter screen.
  ///
  /// In en, this message translates to:
  /// **'Keep screen awake'**
  String get azkarKeepAwake;

  /// Optional click sound on each count.
  ///
  /// In en, this message translates to:
  /// **'Tap sound'**
  String get azkarSound;

  /// Shown when every daily dhikr is complete.
  ///
  /// In en, this message translates to:
  /// **'All daily adhkar complete'**
  String get azkarAllDone;

  /// Donut chart title.
  ///
  /// In en, this message translates to:
  /// **'Per-dhikr counts'**
  String get azkarPieTitle;

  /// Snackbar after deleting a custom dhikr.
  ///
  /// In en, this message translates to:
  /// **'Custom dhikr removed'**
  String get azkarDeleted;

  /// Snackbar after resetting the day.
  ///
  /// In en, this message translates to:
  /// **'Counters reset'**
  String get azkarResetDone;

  /// Snackbar after undo.
  ///
  /// In en, this message translates to:
  /// **'Last count undone'**
  String get azkarUndoDone;

  /// Consecutive days with all daily adhkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar streak'**
  String get azkarStreak;

  /// Starts a fresh khatam cycle.
  ///
  /// In en, this message translates to:
  /// **'Start new khatam'**
  String get khatamStart;

  /// Marks the active khatam complete.
  ///
  /// In en, this message translates to:
  /// **'Complete khatam'**
  String get khatamComplete;

  /// Active khatam card title.
  ///
  /// In en, this message translates to:
  /// **'Current khatam'**
  String get khatamActiveTitle;

  /// Empty state when no khatam is running.
  ///
  /// In en, this message translates to:
  /// **'No active khatam'**
  String get khatamNoActive;

  /// Khatam progress heading.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get khatamProgressTitle;

  /// Para checklist progress.
  ///
  /// In en, this message translates to:
  /// **'{done} of 30 paras'**
  String khatamParasDone(int done);

  /// Para checklist tile label.
  ///
  /// In en, this message translates to:
  /// **'Para {number}'**
  String khatamPara(int number);

  /// Marks paras up to the reading position.
  ///
  /// In en, this message translates to:
  /// **'Sync with Tilawat position'**
  String get khatamSyncPosition;

  /// Snackbar after starting.
  ///
  /// In en, this message translates to:
  /// **'Khatam started'**
  String get khatamStarted;

  /// Snackbar after completing.
  ///
  /// In en, this message translates to:
  /// **'Khatam completed — may Allah accept'**
  String get khatamCompletedSnack;

  /// Congratulations dialog title.
  ///
  /// In en, this message translates to:
  /// **'MashaAllah! Khatam complete'**
  String get khatamCongratsTitle;

  /// Dua shown after completing a khatam.
  ///
  /// In en, this message translates to:
  /// **'May Allah accept your recitation and grant you its blessings.'**
  String get khatamDua;

  /// Duration of a khatam.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String khatamDaysTaken(int days);

  /// History list heading.
  ///
  /// In en, this message translates to:
  /// **'Khatam history'**
  String get khatamHistoryTitle;

  /// All-time khatam count.
  ///
  /// In en, this message translates to:
  /// **'Total khatams'**
  String get khatamTotal;

  /// Khatams completed this year.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get khatamThisYear;

  /// All-time khatam total.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get khatamAllTime;

  /// Yearly khatam goal caption.
  ///
  /// In en, this message translates to:
  /// **'Yearly goal'**
  String get khatamYearGoal;

  /// Yearly bar chart title.
  ///
  /// In en, this message translates to:
  /// **'Khatams per year'**
  String get khatamYearlyTitle;

  /// History: start date.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get khatamStartDate;

  /// History: completion date.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get khatamEndDate;

  /// History: active khatam badge.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get khatamInProgress;

  /// Yearly goal progress caption.
  ///
  /// In en, this message translates to:
  /// **'{done} of {goal} this year'**
  String khatamGoalProgress(int done, int goal);

  /// Empty history state.
  ///
  /// In en, this message translates to:
  /// **'No completed khatams yet'**
  String get khatamNoHistory;

  /// No description provided for @phaseFourBanner.
  ///
  /// In en, this message translates to:
  /// **'Phase 4 · Gheebat, Muraqaba & Timetable are now live'**
  String get phaseFourBanner;

  /// No description provided for @gheebatIntro.
  ///
  /// In en, this message translates to:
  /// **'A private daily check-in to protect the tongue. Only totals are shown on the dashboard.'**
  String get gheebatIntro;

  /// No description provided for @gheebatTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-in'**
  String get gheebatTodayTitle;

  /// No description provided for @gheebatFree.
  ///
  /// In en, this message translates to:
  /// **'Gheebat-free'**
  String get gheebatFree;

  /// No description provided for @gheebatFreeHint.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah, I protected my tongue today'**
  String get gheebatFreeHint;

  /// No description provided for @gheebatSlipped.
  ///
  /// In en, this message translates to:
  /// **'I slipped'**
  String get gheebatSlipped;

  /// No description provided for @gheebatSlippedHint.
  ///
  /// In en, this message translates to:
  /// **'I backbit and seek forgiveness'**
  String get gheebatSlippedHint;

  /// No description provided for @gheebatNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get gheebatNotRecorded;

  /// No description provided for @gheebatIstighfarTitle.
  ///
  /// In en, this message translates to:
  /// **'Istighfar counter'**
  String get gheebatIstighfarTitle;

  /// No description provided for @gheebatIstighfarHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to repeat أستغفر الله'**
  String get gheebatIstighfarHint;

  /// No description provided for @gheebatNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Private note'**
  String get gheebatNoteTitle;

  /// No description provided for @gheebatNoteHint.
  ///
  /// In en, this message translates to:
  /// **'What triggered it? What will you do differently?'**
  String get gheebatNoteHint;

  /// No description provided for @gheebatNoteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get gheebatNoteSaved;

  /// No description provided for @gheebatReset.
  ///
  /// In en, this message translates to:
  /// **'Clear this day'**
  String get gheebatReset;

  /// No description provided for @gheebatResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear today\'s Gheebat record?'**
  String get gheebatResetConfirm;

  /// No description provided for @gheebatFreeDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Free days'**
  String get gheebatFreeDaysLabel;

  /// No description provided for @gheebatSlippedDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Slipped days'**
  String get gheebatSlippedDaysLabel;

  /// No description provided for @gheebatRecordedDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days checked in'**
  String get gheebatRecordedDaysLabel;

  /// No description provided for @gheebatFreePercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Free-day rate'**
  String get gheebatFreePercentLabel;

  /// No description provided for @gheebatCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get gheebatCalendarTitle;

  /// No description provided for @gheebatYearChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Free days by month'**
  String get gheebatYearChartTitle;

  /// No description provided for @gheebatReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening reminder'**
  String get gheebatReminderTitle;

  /// No description provided for @gheebatReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Do not forget to check in before sleeping.'**
  String get gheebatReminderBody;

  /// No description provided for @gheebatLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Private PIN lock'**
  String get gheebatLockTitle;

  /// No description provided for @gheebatLockBody.
  ///
  /// In en, this message translates to:
  /// **'Protect your notes with a 4–8 digit PIN. Notes stay hidden until unlocked.'**
  String get gheebatLockBody;

  /// No description provided for @gheebatSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get gheebatSetPin;

  /// No description provided for @gheebatChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get gheebatChangePin;

  /// No description provided for @gheebatRemovePin.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get gheebatRemovePin;

  /// No description provided for @gheebatEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get gheebatEnterPin;

  /// No description provided for @gheebatConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get gheebatConfirmPin;

  /// No description provided for @gheebatPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get gheebatPinMismatch;

  /// No description provided for @gheebatWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get gheebatWrongPin;

  /// No description provided for @gheebatPinInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use 4–8 digits'**
  String get gheebatPinInvalid;

  /// No description provided for @gheebatPinSet.
  ///
  /// In en, this message translates to:
  /// **'PIN enabled'**
  String get gheebatPinSet;

  /// No description provided for @gheebatPinRemoved.
  ///
  /// In en, this message translates to:
  /// **'PIN removed'**
  String get gheebatPinRemoved;

  /// No description provided for @gheebatUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get gheebatUnlock;

  /// No description provided for @gheebatLockNow.
  ///
  /// In en, this message translates to:
  /// **'Lock now'**
  String get gheebatLockNow;

  /// No description provided for @gheebatLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes are locked'**
  String get gheebatLockedTitle;

  /// No description provided for @gheebatLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock to see your private reflections.'**
  String get gheebatLockedBody;

  /// No description provided for @muraqabaIntro.
  ///
  /// In en, this message translates to:
  /// **'Sit quietly, breathe gently and bring the heart back to Allah.'**
  String get muraqabaIntro;

  /// No description provided for @muraqabaTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiet timer'**
  String get muraqabaTimerTitle;

  /// No description provided for @muraqabaStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get muraqabaStart;

  /// No description provided for @muraqabaPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get muraqabaPause;

  /// No description provided for @muraqabaResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get muraqabaResume;

  /// No description provided for @muraqabaFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish & save'**
  String get muraqabaFinish;

  /// No description provided for @muraqabaResetTimer.
  ///
  /// In en, this message translates to:
  /// **'Reset timer'**
  String get muraqabaResetTimer;

  /// No description provided for @muraqabaPresetLabel.
  ///
  /// In en, this message translates to:
  /// **'Quick length'**
  String get muraqabaPresetLabel;

  /// No description provided for @muraqabaCustomMinutes.
  ///
  /// In en, this message translates to:
  /// **'Custom minutes'**
  String get muraqabaCustomMinutes;

  /// Duration chip on the Muraqaba timer.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String muraqabaDuration(int minutes);

  /// No description provided for @muraqabaSessionSaved.
  ///
  /// In en, this message translates to:
  /// **'Session saved'**
  String get muraqabaSessionSaved;

  /// No description provided for @muraqabaTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time of day'**
  String get muraqabaTimeLabel;

  /// No description provided for @muraqabaTimeAfterFajr.
  ///
  /// In en, this message translates to:
  /// **'After Fajr'**
  String get muraqabaTimeAfterFajr;

  /// No description provided for @muraqabaTimeTahajjud.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud'**
  String get muraqabaTimeTahajjud;

  /// No description provided for @muraqabaTimeMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get muraqabaTimeMorning;

  /// No description provided for @muraqabaTimeAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get muraqabaTimeAfternoon;

  /// No description provided for @muraqabaTimeEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get muraqabaTimeEvening;

  /// No description provided for @muraqabaTimeNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get muraqabaTimeNight;

  /// No description provided for @muraqabaLogManual.
  ///
  /// In en, this message translates to:
  /// **'Log a session'**
  String get muraqabaLogManual;

  /// No description provided for @muraqabaSessionNote.
  ///
  /// In en, this message translates to:
  /// **'Session note (optional)'**
  String get muraqabaSessionNote;

  /// No description provided for @muraqabaSourceTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get muraqabaSourceTimer;

  /// No description provided for @muraqabaSourceManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get muraqabaSourceManual;

  /// No description provided for @muraqabaTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s sessions'**
  String get muraqabaTodayTitle;

  /// No description provided for @muraqabaTodayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No session yet today'**
  String get muraqabaTodayEmpty;

  /// No description provided for @muraqabaPracticeToday.
  ///
  /// In en, this message translates to:
  /// **'Practised today'**
  String get muraqabaPracticeToday;

  /// No description provided for @muraqabaNoPracticeToday.
  ///
  /// In en, this message translates to:
  /// **'Not practised yet'**
  String get muraqabaNoPracticeToday;

  /// No description provided for @muraqabaTotalMinutes.
  ///
  /// In en, this message translates to:
  /// **'Total minutes'**
  String get muraqabaTotalMinutes;

  /// No description provided for @muraqabaSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get muraqabaSessionsLabel;

  /// No description provided for @muraqabaDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days practised'**
  String get muraqabaDaysLabel;

  /// No description provided for @muraqabaAverageLabel.
  ///
  /// In en, this message translates to:
  /// **'Average session'**
  String get muraqabaAverageLabel;

  /// No description provided for @muraqabaYearChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Minutes by month'**
  String get muraqabaYearChartTitle;

  /// No description provided for @muraqabaHeatmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice calendar'**
  String get muraqabaHeatmapTitle;

  /// No description provided for @muraqabaGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'A simple way to begin'**
  String get muraqabaGuideTitle;

  /// No description provided for @muraqabaGuideBody.
  ///
  /// In en, this message translates to:
  /// **'1. Sit comfortably and relax your shoulders.\n2. Recite istighfar a few times.\n3. Watch your breath and return the heart to Allah whenever it wanders.\n4. End with a short dua.'**
  String get muraqabaGuideBody;

  /// No description provided for @timetableTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s schedule'**
  String get timetableTodayTitle;

  /// No description provided for @timetableAddTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get timetableAddTask;

  /// No description provided for @timetableEditTask.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get timetableEditTask;

  /// No description provided for @timetableNoTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks for this day'**
  String get timetableNoTasks;

  /// No description provided for @timetableNoTasksHint.
  ///
  /// In en, this message translates to:
  /// **'Add a task or start from a template.'**
  String get timetableNoTasksHint;

  /// No description provided for @timetableTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get timetableTaskTitle;

  /// No description provided for @timetableCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get timetableCategoryLabel;

  /// No description provided for @timetableStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get timetableStartTime;

  /// No description provided for @timetableEndTime.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get timetableEndTime;

  /// No description provided for @timetableRepeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get timetableRepeatLabel;

  /// No description provided for @timetableReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get timetableReminderLabel;

  /// No description provided for @timetableReminderNone.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get timetableReminderNone;

  /// No description provided for @timetableNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get timetableNoteLabel;

  /// No description provided for @timetableIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get timetableIconLabel;

  /// No description provided for @timetableColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get timetableColorLabel;

  /// No description provided for @timetableTaskSaved.
  ///
  /// In en, this message translates to:
  /// **'Task saved'**
  String get timetableTaskSaved;

  /// No description provided for @timetableTaskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get timetableTaskDeleted;

  /// No description provided for @timetableDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this task and its history?'**
  String get timetableDeleteConfirm;

  /// No description provided for @timetableTemplates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get timetableTemplates;

  /// No description provided for @timetableTemplatesBody.
  ///
  /// In en, this message translates to:
  /// **'Add a ready-made routine, then adjust it freely.'**
  String get timetableTemplatesBody;

  /// No description provided for @timetableApply.
  ///
  /// In en, this message translates to:
  /// **'Use template'**
  String get timetableApply;

  /// No description provided for @timetableTemplateApplied.
  ///
  /// In en, this message translates to:
  /// **'Template added'**
  String get timetableTemplateApplied;

  /// Total scheduled time caption.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min scheduled'**
  String timetableScheduledMinutes(int minutes);

  /// Completed task occurrences.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String timetableDoneOf(int done, int total);

  /// Completion percentage.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String timetableCompletion(int percent);

  /// No description provided for @timetableNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get timetableNow;

  /// No description provided for @timetableResizeHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the bottom edge to change the duration'**
  String get timetableResizeHint;

  /// No description provided for @timetableTodaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s timetable'**
  String get timetableTodaySchedule;

  /// No description provided for @repeatOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get repeatOnce;

  /// No description provided for @repeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get repeatDaily;

  /// No description provided for @repeatWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get repeatWeekdays;

  /// No description provided for @repeatCustomDays.
  ///
  /// In en, this message translates to:
  /// **'Selected days'**
  String get repeatCustomDays;

  /// No description provided for @repeatPickDays.
  ///
  /// In en, this message translates to:
  /// **'Repeat on'**
  String get repeatPickDays;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @taskCategoryIbadah.
  ///
  /// In en, this message translates to:
  /// **'Ibadah'**
  String get taskCategoryIbadah;

  /// No description provided for @taskCategoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get taskCategoryWork;

  /// No description provided for @taskCategoryStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get taskCategoryStudy;

  /// No description provided for @taskCategoryFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get taskCategoryFamily;

  /// No description provided for @taskCategoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get taskCategoryHealth;

  /// No description provided for @taskCategoryRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get taskCategoryRest;

  /// No description provided for @tplIbadahDay.
  ///
  /// In en, this message translates to:
  /// **'Balanced ibadah day'**
  String get tplIbadahDay;

  /// No description provided for @tplIbadahDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Five prayers, Quran, adhkar, work and family.'**
  String get tplIbadahDayDesc;

  /// No description provided for @tplStudentDay.
  ///
  /// In en, this message translates to:
  /// **'Student study day'**
  String get tplStudentDay;

  /// No description provided for @tplStudentDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud, study blocks and revision.'**
  String get tplStudentDayDesc;

  /// No description provided for @tplFamilyDay.
  ///
  /// In en, this message translates to:
  /// **'Family weekend'**
  String get tplFamilyDay;

  /// No description provided for @tplFamilyDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Exercise, meals, family time and rest.'**
  String get tplFamilyDayDesc;

  /// No description provided for @taskTplFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr salah'**
  String get taskTplFajr;

  /// No description provided for @taskTplQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran recitation'**
  String get taskTplQuran;

  /// No description provided for @taskTplAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Morning adhkar'**
  String get taskTplAdhkar;

  /// No description provided for @taskTplWork.
  ///
  /// In en, this message translates to:
  /// **'Work block'**
  String get taskTplWork;

  /// No description provided for @taskTplFamily.
  ///
  /// In en, this message translates to:
  /// **'Family time'**
  String get taskTplFamily;

  /// No description provided for @taskTplIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha salah'**
  String get taskTplIsha;

  /// No description provided for @taskTplTahajjud.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud'**
  String get taskTplTahajjud;

  /// No description provided for @taskTplStudy.
  ///
  /// In en, this message translates to:
  /// **'Study block'**
  String get taskTplStudy;

  /// No description provided for @taskTplRevision.
  ///
  /// In en, this message translates to:
  /// **'Revision'**
  String get taskTplRevision;

  /// No description provided for @taskTplExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get taskTplExercise;

  /// No description provided for @taskTplBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get taskTplBreakfast;

  /// No description provided for @taskTplRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get taskTplRest;

  /// No description provided for @taskTplDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get taskTplDinner;

  /// No description provided for @taskTplSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get taskTplSleep;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ur': return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
