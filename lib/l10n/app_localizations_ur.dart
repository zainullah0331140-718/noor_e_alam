// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'عبادت ٹریکر';

  @override
  String get appTagline => 'اللہ کی طرف آپ کا روزانہ راستہ';

  @override
  String get moduleDashboard => 'ڈیش بورڈ';

  @override
  String get moduleTimetable => 'ٹائم ٹیبل';

  @override
  String get moduleNamaz => 'نماز';

  @override
  String get moduleNafl => 'نفل';

  @override
  String get moduleTilawat => 'تلاوت';

  @override
  String get moduleAzkar => 'اذکار';

  @override
  String get moduleGheebat => 'غیبت';

  @override
  String get moduleMuraqaba => 'مراقبہ';

  @override
  String get moduleKhatam => 'ختم';

  @override
  String get moduleRamadan => 'رمضان';

  @override
  String get moduleReports => 'رپورٹس';

  @override
  String get moduleSettings => 'سیٹنگز';

  @override
  String get menu => 'مینو';

  @override
  String get openDrawer => 'نیویگیشن کھولیں';

  @override
  String get navigationTitle => 'عبادت ٹریکر';

  @override
  String get phaseOneBanner => 'مرحلہ ۱ — بنیاد';

  @override
  String get bismillah => 'بسم اللہ';

  @override
  String get splashStarting => 'آپ کا ٹریکر تیار ہو رہا ہے…';

  @override
  String get greetingMorning => 'صبح بخیر';

  @override
  String get greetingAfternoon => 'دوپہر بخیر';

  @override
  String get greetingEvening => 'شام بخیر';

  @override
  String get greetingNight => 'شب بخیر';

  @override
  String get quote => 'کوشش کریں کہ اللہ مل جائے، جب اللہ مل جائے تو سب کچھ مل جاتا ہے';

  @override
  String get quoteBy => 'آج کا حوصلہ';

  @override
  String get rangeToday => 'آج';

  @override
  String get rangeMonth => 'مہینہ';

  @override
  String get rangeYear => 'سال';

  @override
  String get done => 'کیا';

  @override
  String get notDone => 'نہیں کیا';

  @override
  String get noData => 'ابھی کوئی اندراج نہیں';

  @override
  String get completion => 'تکمیل';

  @override
  String get streak => 'نماز کا سلسلہ';

  @override
  String streakValue(int count) {
    return '$count دن';
  }

  @override
  String get streakHint => 'سلسلہ برقرار رکھیں';

  @override
  String get weeklyTitle => 'گزشتہ ۷ دن';

  @override
  String get weeklySubtitle => 'روزانہ تکمیل کا اسکور';

  @override
  String get monthlyTitle => 'ماہانہ تجزیہ';

  @override
  String get overviewTitle => 'مجموعی جائزہ';

  @override
  String get statPrayers => 'نماز';

  @override
  String get statNafl => 'نفل';

  @override
  String get statTilawat => 'تلاوت';

  @override
  String get statAzkar => 'اذکار';

  @override
  String get statGheebatFree => 'غیبت سے پاک';

  @override
  String get statMuraqaba => 'مراقبہ';

  @override
  String get statKhatam => 'ختم';

  @override
  String get statRamadan => 'رمضان';

  @override
  String detailPrayers(int done, int total) {
    return '$total میں سے $done نمازیں';
  }

  @override
  String detailRakats(int done, int total) {
    return '$total میں سے $done رکعتیں';
  }

  @override
  String detailPages(int done, int total) {
    return '$total میں سے $done صفحات';
  }

  @override
  String detailCounts(int done, int total) {
    return '$total میں سے $done';
  }

  @override
  String detailDays(int done, int total) {
    return '$total میں سے $done دن';
  }

  @override
  String detailMinutes(int done, int total) {
    return '$total میں سے $done منٹ';
  }

  @override
  String subTilawat(int pages, int minutes, int para) {
    return '$pages صفحات · $minutes منٹ · پارہ $para';
  }

  @override
  String subPrayers(int jamaat, int alone, int missed) {
    return '$jamaat جماعت · $alone تنہا · $missed چھوڑی';
  }

  @override
  String get jamaat => 'جماعت';

  @override
  String get alone => 'تنہا';

  @override
  String get missed => 'چھوڑی';

  @override
  String get takbeerUla => 'تکبیر اولیٰ';

  @override
  String get settingsGeneral => 'عمومی';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsAppearance => 'ظاہری وضع';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تاریک';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get settingsNumerals => 'ہندسے';

  @override
  String get numeralsWestern => 'غربی (1, 2, 3)';

  @override
  String get numeralsEastern => 'اردو (۱, ۲, ۳)';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get settingsAbout => 'تعارف';

  @override
  String get settingsAboutValue => 'عبادت ٹریکر · مرحلہ ۱ بنیاد';

  @override
  String get settingsSaved => 'ترجیح محفوظ ہو گئی';

  @override
  String get comingSoonTitle => 'مرحلہ ۲ میں آئے گا';

  @override
  String get comingSoonBody => 'یہ موڈیل اگلے مرحلے کے لیے مخصوص ہے۔ تھیم، ڈیٹابیس، نیویگیشن اور زبان کی سہولت پہلے سے موجود ہیں۔';

  @override
  String get backToDashboard => 'ڈیش بورڈ پر جائیں';

  @override
  String get phaseTwoBanner => 'مرحلہ ۲ — نماز و نفل';

  @override
  String get prayerFajr => 'فجر';

  @override
  String get prayerZuhr => 'ظہر';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشاء';

  @override
  String get prayerWitr => 'ویتر';

  @override
  String get remaining => 'باقی';

  @override
  String get notMarked => 'نشان نہیں لگا';

  @override
  String get dayComplete => 'چھوں نمازیں نشان لگ گئیں';

  @override
  String summaryLine(int jamaat, int alone, int missed, int remaining) {
    return '$jamaat جماعت · $alone تنہا · $missed چھوڑی · $remaining باقی';
  }

  @override
  String get masbooq => 'مسبوق';

  @override
  String get prayedAtMasjid => 'مسجد';

  @override
  String get prayedAtHome => 'گھر';

  @override
  String get previousDay => 'پچھلا دن';

  @override
  String get nextDay => 'اگلا دن';

  @override
  String get pickDate => 'تاریخ منتخب کریں';

  @override
  String get tabQaza => 'قضا';

  @override
  String get currentStreak => 'موجودہ سلسلہ';

  @override
  String get bestStreak => 'بہترین سلسلہ';

  @override
  String get mostMissedTitle => 'سب سے زیادہ چھوڑی نماز';

  @override
  String mostMissedValue(String prayer, int count) {
    return '$prayer: $count چھوڑی';
  }

  @override
  String get jamaatPercentLabel => 'جماعت';

  @override
  String get yearTotalsLabel => 'مجموعی حساب';

  @override
  String get tapDateToEdit => 'نماز دیکھنے یا تبدیل کرنے کے لیے تاریخ پر ٹیپ کریں';

  @override
  String editDayTitle(String date) {
    return '$date کی نمازیں';
  }

  @override
  String get qazaManager => 'قضا کا انتظام';

  @override
  String get qazaPendingTitle => 'بقایا قضا';

  @override
  String get qazaAddManual => 'دستی شامل کریں';

  @override
  String get qazaMarkMadeUp => 'ادا شدہ نشان زد کریں';

  @override
  String get qazaHistoryTitle => 'تاریخچہ';

  @override
  String get qazaNoPending => 'کوئی بقایا قضا نہیں — الحمدللہ';

  @override
  String get qazaAddDialogTitle => 'پرانی قضا شامل کریں';

  @override
  String get qazaRakatsLabel => 'رکعتیں';

  @override
  String get qazaAdded => 'قضا شامل ہو گئی';

  @override
  String get qazaCleared => 'ادا شدہ نشان زد کر دیا گیا';

  @override
  String get qazaAutoNote => 'خودکار (نماز چھوڑی)';

  @override
  String get pendingWord => 'بقایا';

  @override
  String get naflTahajjud => 'تہجد';

  @override
  String get naflIshraq => 'اشراق';

  @override
  String get naflChasht => 'چاشت / ضحا';

  @override
  String get naflAwwabin => 'عوابین';

  @override
  String get naflTahiyyatulWudu => 'تحیۃ الوضو';

  @override
  String get naflTahiyyatulMasjid => 'تحیۃ المسجد';

  @override
  String get naflSunnahMuakkadah => 'سنّتِ مکدّہ';

  @override
  String get naflGhairMuakkadah => 'غیرِ مکدّہ';

  @override
  String get naflTasbeeh => 'صلوۃ التسبیح';

  @override
  String get naflHajat => 'صلوۃ الحاجت';

  @override
  String get naflTawbah => 'صلوۃ التوبہ';

  @override
  String get naflCustom => 'دیگر نفل';

  @override
  String get naflAddCustom => 'نفل شامل کریں';

  @override
  String get naflCustomName => 'نام';

  @override
  String get naflRakatsLabel => 'رکعتیں';

  @override
  String get naflNoteLabel => 'نوٹ';

  @override
  String get naflGoal => 'روزانہ ہدف';

  @override
  String get streakTahajjud => 'تہجد کا سلسلہ';

  @override
  String get streakDuha => 'ضحا کا سلسلہ';

  @override
  String get daysPerformedLabel => 'ادا کردہ دن';

  @override
  String get deleteWord => 'حذف کریں';

  @override
  String rakatsCount(int count) {
    return '$count رکعتیں';
  }

  @override
  String get settingsPrayerTimes => 'نماز کے اوقات';

  @override
  String get settingsLocation => 'حساب کا مقام';

  @override
  String get settingsNaflGoal => 'روزانہ نفل کا ہدف (رکعتیں)';

  @override
  String get phaseThreeBanner => 'تیسرا مرحلہ — تلاوت، اذکار اور ختمِ قرآن';

  @override
  String get addWord => 'شامل کریں';

  @override
  String get saveWord => 'محفوظ کریں';

  @override
  String get cancelWord => 'منسوخ کریں';

  @override
  String get closeWord => 'بند کریں';

  @override
  String countOfTarget(int count, int target) {
    return '$count از $target';
  }

  @override
  String get settingsTilawatSection => 'تلاوت اور ختمِ قرآن';

  @override
  String get settingsTilawatUnit => 'تلاوت کی اکائی';

  @override
  String get settingsTilawatGoal => 'روزانہ تلاوت کا ہدف';

  @override
  String get settingsKhatamGoal => 'سالانہ ختمِ قرآن کا ہدف';

  @override
  String get unitPages => 'صفحات';

  @override
  String get unitRuku => 'رکوع';

  @override
  String get unitPara => 'پارہ';

  @override
  String get unitMinutes => 'منٹ';

  @override
  String get tilawatLogTitle => 'تلاوت درج کریں';

  @override
  String get tilawatAddEntry => 'اندراج شامل کریں';

  @override
  String get tilawatAmountLabel => 'مقدار';

  @override
  String get tilawatUnitLabel => 'اکائی';

  @override
  String get tilawatEntriesTitle => 'اندراجات';

  @override
  String get tilawatGoalTitle => 'روزانہ ہدف';

  @override
  String tilawatGoalProgress(int done, int goal) {
    return '$done از $goal';
  }

  @override
  String get tilawatPositionTitle => 'موجودہ مقام';

  @override
  String get tilawatParaLabel => 'پارہ';

  @override
  String get tilawatSurahLabel => 'سورہ';

  @override
  String get tilawatPageLabel => 'صفحہ';

  @override
  String get tilawatContinue => 'جہاں سے رکا تھا وہیں سے جاری رکھیں';

  @override
  String get tilawatUpdatePosition => 'مقام اپ ڈیٹ کریں';

  @override
  String get tilawatPositionSaved => 'مقام اپ ڈیٹ ہو گیا';

  @override
  String get tilawatEntryDeleted => 'اندراج حذف ہو گیا';

  @override
  String get tilawatAmountInvalid => 'درست مقدار درج کریں';

  @override
  String get tilawatTotalPages => 'کل صفحات';

  @override
  String get tilawatTotalMinutes => 'کل منٹ';

  @override
  String get tilawatDaysRecited => 'تلاوت کے دن';

  @override
  String get tilawatAveragePerDay => 'روزانہ اوسط';

  @override
  String get tilawatGoalAchievement => 'ہدف پورا ہوا';

  @override
  String get tilawatStreak => 'تلاوت کا تسلسل';

  @override
  String get tilawatCalendarTitle => 'تلاوت کیلنڈر';

  @override
  String get tilawatGoalDays => 'ہدف والے دن';

  @override
  String get azkarMorning => 'صبح کے اذکار';

  @override
  String get azkarEvening => 'شام کے اذکار';

  @override
  String get azkarTasbeehSubhan => 'سبحان اللہ (۳۳)';

  @override
  String get azkarTasbeehHamd => 'الحمد للہ (۳۳)';

  @override
  String get azkarTasbeehAkbar => 'اللہ اکبر (۳۴)';

  @override
  String get azkarDurood => 'درود شریف';

  @override
  String get azkarIstighfar => 'استغفار';

  @override
  String get azkarKalima3 => 'تیسرا کلمہ';

  @override
  String get azkarLailaha => 'لا الہ الا اللہ';

  @override
  String get azkarAyatulKursi => 'آیت الکرسی';

  @override
  String get azkarCustomTitle => 'اپنے اذکار';

  @override
  String get azkarAddCustom => 'اپنا ذکر شامل کریں';

  @override
  String get azkarCustomName => 'نام';

  @override
  String get azkarCustomArabic => 'عربی متن';

  @override
  String get azkarCustomTarget => 'ہدف تعداد';

  @override
  String get azkarCustomReminder => 'یاد دہانی کا وقت (HH:mm)';

  @override
  String get azkarTargetLabel => 'ہدف';

  @override
  String get azkarCountLabel => 'تعداد';

  @override
  String get azkarCounterTitle => 'تسبیح کاؤنٹر';

  @override
  String get azkarTapToCount => 'گننے کے لیے دبائیں';

  @override
  String get azkarReset => 'ری سیٹ';

  @override
  String get azkarUndo => 'واپس کریں';

  @override
  String get azkarTargetReached => 'ہدف مکمل — ماشاءاللہ';

  @override
  String get azkarKeepAwake => 'اسکرین روشن رکھیں';

  @override
  String get azkarSound => 'ٹیپ کی آواز';

  @override
  String get azkarAllDone => 'تمام روزانہ اذکار مکمل';

  @override
  String get azkarPieTitle => 'ہر ذکر کی تعداد';

  @override
  String get azkarDeleted => 'اپنا ذکر حذف ہو گیا';

  @override
  String get azkarResetDone => 'کاؤنٹر ری سیٹ ہو گئے';

  @override
  String get azkarUndoDone => 'آخری گنتی واپس';

  @override
  String get azkarStreak => 'اذکار کا تسلسل';

  @override
  String get khatamStart => 'نیا ختمِ قرآن شروع کریں';

  @override
  String get khatamComplete => 'ختمِ قرآن مکمل کریں';

  @override
  String get khatamActiveTitle => 'موجودہ ختمِ قرآن';

  @override
  String get khatamNoActive => 'کوئی فعال ختمِ قرآن نہیں';

  @override
  String get khatamProgressTitle => 'پیش رفت';

  @override
  String khatamParasDone(int done) {
    return '$done از ۳۰ پارے';
  }

  @override
  String khatamPara(int number) {
    return 'پارہ $number';
  }

  @override
  String get khatamSyncPosition => 'تلاوت کے مقام سے ہم آہنگ کریں';

  @override
  String get khatamStarted => 'ختمِ قرآن شروع ہو گیا';

  @override
  String get khatamCompletedSnack => 'ختمِ قرآن مکمل — اللہ قبول فرمائے';

  @override
  String get khatamCongratsTitle => 'ماشاءاللہ! ختمِ قرآن مکمل';

  @override
  String get khatamDua => 'اللہ آپ کی تلاوت قبول فرمائے اور اس کی برکتیں عطا فرمائے۔';

  @override
  String khatamDaysTaken(int days) {
    return '$days دن';
  }

  @override
  String get khatamHistoryTitle => 'ختمِ قرآن کی تاریخ';

  @override
  String get khatamTotal => 'کل ختم';

  @override
  String get khatamThisYear => 'اس سال';

  @override
  String get khatamAllTime => 'اب تک';

  @override
  String get khatamYearGoal => 'سالانہ ہدف';

  @override
  String get khatamYearlyTitle => 'سال بہ سال ختم';

  @override
  String get khatamStartDate => 'شروع';

  @override
  String get khatamEndDate => 'مکمل';

  @override
  String get khatamInProgress => 'جاری';

  @override
  String khatamGoalProgress(int done, int goal) {
    return '$done از $goal اس سال';
  }

  @override
  String get khatamNoHistory => 'ابھی کوئی ختم مکمل نہیں ہوا';

  @override
  String get phaseFourBanner => 'مرحلہ ۴ · غیبت، مراقبہ اور ٹائم ٹیبل اب دستیاب ہیں';

  @override
  String get gheebatIntro => 'زبان کی حفاظت کے لیے روزانہ کی نجی جانچ۔ ڈیش بورڈ پر صرف اعداد و شمار دکھائے جاتے ہیں۔';

  @override
  String get gheebatTodayTitle => 'آج کی جانچ';

  @override
  String get gheebatFree => 'غیبت سے پاک';

  @override
  String get gheebatFreeHint => 'الحمدللہ، آج میں نے اپنی زبان کی حفاظت کی';

  @override
  String get gheebatSlipped => 'میں چوک گیا';

  @override
  String get gheebatSlippedHint => 'میں نے غیبت کی اور معافی مانگتا ہوں';

  @override
  String get gheebatNotRecorded => 'درج نہیں';

  @override
  String get gheebatIstighfarTitle => 'استغفار کاؤنٹر';

  @override
  String get gheebatIstighfarHint => 'أستغفر الله دہرانے کے لیے دبائیں';

  @override
  String get gheebatNoteTitle => 'نجی نوٹ';

  @override
  String get gheebatNoteHint => 'کیا وجہ بنی؟ آئندہ کیا مختلف کریں گے؟';

  @override
  String get gheebatNoteSaved => 'نوٹ محفوظ ہو گیا';

  @override
  String get gheebatReset => 'یہ دن صاف کریں';

  @override
  String get gheebatResetConfirm => 'کیا آج کا غیبت ریکارڈ صاف کریں؟';

  @override
  String get gheebatFreeDaysLabel => 'پاک دن';

  @override
  String get gheebatSlippedDaysLabel => 'چوک کے دن';

  @override
  String get gheebatRecordedDaysLabel => 'جانچ کے دن';

  @override
  String get gheebatFreePercentLabel => 'پاک دنوں کی شرح';

  @override
  String get gheebatCalendarTitle => 'اس ماہ';

  @override
  String get gheebatYearChartTitle => 'ماہ کے حساب سے پاک دن';

  @override
  String get gheebatReminderTitle => 'شام کی یاد دہانی';

  @override
  String get gheebatReminderBody => 'سونے سے پہلے اپنی جانچ ضرور کریں۔';

  @override
  String get gheebatLockTitle => 'نجی پن لاک';

  @override
  String get gheebatLockBody => 'اپنے نوٹس کو ۴ سے ۸ ہندسوں کے پن سے محفوظ کریں۔ کھولنے تک نوٹس چھپے رہیں گے۔';

  @override
  String get gheebatSetPin => 'پن مقرر کریں';

  @override
  String get gheebatChangePin => 'پن تبدیل کریں';

  @override
  String get gheebatRemovePin => 'پن ہٹائیں';

  @override
  String get gheebatEnterPin => 'پن درج کریں';

  @override
  String get gheebatConfirmPin => 'پن کی تصدیق کریں';

  @override
  String get gheebatPinMismatch => 'پن مماثل نہیں';

  @override
  String get gheebatWrongPin => 'غلط پن';

  @override
  String get gheebatPinInvalid => '۴ سے ۸ ہندسے استعمال کریں';

  @override
  String get gheebatPinSet => 'پن فعال ہو گیا';

  @override
  String get gheebatPinRemoved => 'پن ہٹا دیا گیا';

  @override
  String get gheebatUnlock => 'کھولیں';

  @override
  String get gheebatLockNow => 'ابھی لاک کریں';

  @override
  String get gheebatLockedTitle => 'نوٹس لاک ہیں';

  @override
  String get gheebatLockedBody => 'اپنے نجی خیالات دیکھنے کے لیے کھولیں۔';

  @override
  String get muraqabaIntro => 'خاموش بیٹھیں، آرام سے سانس لیں اور دل کو اللہ کی طرف واپس لائیں۔';

  @override
  String get muraqabaTimerTitle => 'خاموش ٹائمر';

  @override
  String get muraqabaStart => 'شروع کریں';

  @override
  String get muraqabaPause => 'روکیں';

  @override
  String get muraqabaResume => 'جاری رکھیں';

  @override
  String get muraqabaFinish => 'مکمل کریں اور محفوظ کریں';

  @override
  String get muraqabaResetTimer => 'ٹائمر ری سیٹ کریں';

  @override
  String get muraqabaPresetLabel => 'جلدی مدت';

  @override
  String get muraqabaCustomMinutes => 'اپنی مدت (منٹ)';

  @override
  String muraqabaDuration(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String get muraqabaSessionSaved => 'سیشن محفوظ ہو گیا';

  @override
  String get muraqabaTimeLabel => 'دن کا وقت';

  @override
  String get muraqabaTimeAfterFajr => 'فجر کے بعد';

  @override
  String get muraqabaTimeTahajjud => 'تہجد';

  @override
  String get muraqabaTimeMorning => 'صبح';

  @override
  String get muraqabaTimeAfternoon => 'دوپہر';

  @override
  String get muraqabaTimeEvening => 'شام';

  @override
  String get muraqabaTimeNight => 'رات';

  @override
  String get muraqabaLogManual => 'سیشن درج کریں';

  @override
  String get muraqabaSessionNote => 'سیشن نوٹ (اختیاری)';

  @override
  String get muraqabaSourceTimer => 'ٹائمر';

  @override
  String get muraqabaSourceManual => 'دستی';

  @override
  String get muraqabaTodayTitle => 'آج کے سیشن';

  @override
  String get muraqabaTodayEmpty => 'آج ابھی کوئی سیشن نہیں';

  @override
  String get muraqabaPracticeToday => 'آج عمل ہوا';

  @override
  String get muraqabaNoPracticeToday => 'آج ابھی عمل نہیں ہوا';

  @override
  String get muraqabaTotalMinutes => 'کل منٹ';

  @override
  String get muraqabaSessionsLabel => 'سیشن';

  @override
  String get muraqabaDaysLabel => 'عمل کے دن';

  @override
  String get muraqabaAverageLabel => 'اوسط سیشن';

  @override
  String get muraqabaYearChartTitle => 'ماہ کے حساب سے منٹ';

  @override
  String get muraqabaHeatmapTitle => 'عمل کا کیلنڈر';

  @override
  String get muraqabaGuideTitle => 'آغاز کا آسان طریقہ';

  @override
  String get muraqabaGuideBody => '۱۔ آرام سے بیٹھیں اور کندھے ڈھیلے کریں۔\n۲۔ چند بار استغفار پڑھیں۔\n۳۔ سانس پر توجہ رکھیں اور جب دل بھٹکے تو اسے اللہ کی طرف لوٹائیں۔\n۴۔ مختصر دعا کے ساتھ اختتام کریں۔';

  @override
  String get timetableTodayTitle => 'آج کا شیڈول';

  @override
  String get timetableAddTask => 'کام شامل کریں';

  @override
  String get timetableEditTask => 'کام میں تبدیلی';

  @override
  String get timetableNoTasks => 'اس دن کوئی کام نہیں';

  @override
  String get timetableNoTasksHint => 'کوئی کام شامل کریں یا ٹیمپلیٹ سے شروع کریں۔';

  @override
  String get timetableTaskTitle => 'کام کا عنوان';

  @override
  String get timetableCategoryLabel => 'قسم';

  @override
  String get timetableStartTime => 'آغاز';

  @override
  String get timetableEndTime => 'اختتام';

  @override
  String get timetableRepeatLabel => 'تکرار';

  @override
  String get timetableReminderLabel => 'یاد دہانی';

  @override
  String get timetableReminderNone => 'کوئی یاد دہانی نہیں';

  @override
  String get timetableNoteLabel => 'نوٹ (اختیاری)';

  @override
  String get timetableIconLabel => 'آئیکن';

  @override
  String get timetableColorLabel => 'رنگ';

  @override
  String get timetableTaskSaved => 'کام محفوظ ہو گیا';

  @override
  String get timetableTaskDeleted => 'کام حذف ہو گیا';

  @override
  String get timetableDeleteConfirm => 'کیا یہ کام اور اس کی تاریخ حذف کریں؟';

  @override
  String get timetableTemplates => 'ٹیمپلیٹس';

  @override
  String get timetableTemplatesBody => 'تیار معمول شامل کریں، پھر اپنی مرضی سے بدلیں۔';

  @override
  String get timetableApply => 'ٹیمپلیٹ استعمال کریں';

  @override
  String get timetableTemplateApplied => 'ٹیمپلیٹ شامل ہو گیا';

  @override
  String timetableScheduledMinutes(int minutes) {
    return '$minutes منٹ مقرر';
  }

  @override
  String timetableDoneOf(int done, int total) {
    return '$total میں سے $done مکمل';
  }

  @override
  String timetableCompletion(int percent) {
    return '$percent٪ مکمل';
  }

  @override
  String get timetableNow => 'ابھی';

  @override
  String get timetableResizeHint => 'مدت بدلنے کے لیے نیچے کا کنارہ کھینچیں';

  @override
  String get timetableTodaySchedule => 'آج کا ٹائم ٹیبل';

  @override
  String get repeatOnce => 'ایک بار';

  @override
  String get repeatDaily => 'روزانہ';

  @override
  String get repeatWeekdays => 'ہفتے کے دن';

  @override
  String get repeatCustomDays => 'منتخب دن';

  @override
  String get repeatPickDays => 'تکرار کے دن';

  @override
  String get weekdayMon => 'پیر';

  @override
  String get weekdayTue => 'منگل';

  @override
  String get weekdayWed => 'بدھ';

  @override
  String get weekdayThu => 'جمعرات';

  @override
  String get weekdayFri => 'جمعہ';

  @override
  String get weekdaySat => 'ہفتہ';

  @override
  String get weekdaySun => 'اتوار';

  @override
  String get taskCategoryIbadah => 'عبادت';

  @override
  String get taskCategoryWork => 'کام';

  @override
  String get taskCategoryStudy => 'تعلیم';

  @override
  String get taskCategoryFamily => 'خاندان';

  @override
  String get taskCategoryHealth => 'صحت';

  @override
  String get taskCategoryRest => 'آرام';

  @override
  String get tplIbadahDay => 'متوازن عبادت کا دن';

  @override
  String get tplIbadahDayDesc => 'پانچ نمازیں، قرآن، اذکار، کام اور خاندان۔';

  @override
  String get tplStudentDay => 'طالب علم کا دن';

  @override
  String get tplStudentDayDesc => 'تہجد، مطالعے کے وقفے اور دہرائی۔';

  @override
  String get tplFamilyDay => 'خاندانی چھٹی';

  @override
  String get tplFamilyDayDesc => 'ورزش، کھانا، خاندان اور آرام۔';

  @override
  String get taskTplFajr => 'نماز فجر';

  @override
  String get taskTplQuran => 'تلاوت قرآن';

  @override
  String get taskTplAdhkar => 'صبح کے اذکار';

  @override
  String get taskTplWork => 'کام کا وقفہ';

  @override
  String get taskTplFamily => 'خاندان کا وقت';

  @override
  String get taskTplIsha => 'نماز عشاء';

  @override
  String get taskTplTahajjud => 'تہجد';

  @override
  String get taskTplStudy => 'مطالعہ';

  @override
  String get taskTplRevision => 'دہرائی';

  @override
  String get taskTplExercise => 'ورزش';

  @override
  String get taskTplBreakfast => 'ناشتہ';

  @override
  String get taskTplRest => 'آرام';

  @override
  String get taskTplDinner => 'رات کا کھانا';

  @override
  String get taskTplSleep => 'نیند';
}
