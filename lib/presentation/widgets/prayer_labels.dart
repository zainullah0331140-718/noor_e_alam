import '../../db/enums.dart';
import '../../l10n/app_localizations.dart';

/// Maps domain enums to localized labels. Kept in one place so screens and
/// charts stay free of switch duplication.
class PrayerLabels {
  static String namaz(AppLocalizations l10n, NamazType type) {
    switch (type) {
      case NamazType.fajr:
        return l10n.prayerFajr;
      case NamazType.zuhr:
        return l10n.prayerZuhr;
      case NamazType.asr:
        return l10n.prayerAsr;
      case NamazType.maghrib:
        return l10n.prayerMaghrib;
      case NamazType.isha:
        return l10n.prayerIsha;
      case NamazType.witr:
        return l10n.prayerWitr;
    }
  }

  static String status(AppLocalizations l10n, NamazStatus status) {
    switch (status) {
      case NamazStatus.jamaat:
        return l10n.jamaat;
      case NamazStatus.alone:
        return l10n.alone;
      case NamazStatus.missed:
        return l10n.missed;
      case NamazStatus.none:
        return l10n.notMarked;
    }
  }

  static String nafl(AppLocalizations l10n, NaflType type, String customName) {
    switch (type) {
      case NaflType.tahajjud:
        return l10n.naflTahajjud;
      case NaflType.ishraq:
        return l10n.naflIshraq;
      case NaflType.chasht:
        return l10n.naflChasht;
      case NaflType.awwabin:
        return l10n.naflAwwabin;
      case NaflType.tahiyyatulWudu:
        return l10n.naflTahiyyatulWudu;
      case NaflType.tahiyyatulMasjid:
        return l10n.naflTahiyyatulMasjid;
      case NaflType.sunnahMuakkadah:
        return l10n.naflSunnahMuakkadah;
      case NaflType.ghairMuakkadah:
        return l10n.naflGhairMuakkadah;
      case NaflType.tasbeeh:
        return l10n.naflTasbeeh;
      case NaflType.hajat:
        return l10n.naflHajat;
      case NaflType.tawbah:
        return l10n.naflTawbah;
      case NaflType.custom:
        return customName.isEmpty ? l10n.naflCustom : customName;
    }
  }

  /// Fixed nafl types shown in the checklist (custom handled separately).
  static const List<NaflType> fixedNaflTypes = [
    NaflType.tahajjud,
    NaflType.ishraq,
    NaflType.chasht,
    NaflType.awwabin,
    NaflType.tahiyyatulWudu,
    NaflType.tahiyyatulMasjid,
    NaflType.sunnahMuakkadah,
    NaflType.ghairMuakkadah,
    NaflType.tasbeeh,
    NaflType.hajat,
    NaflType.tawbah,
  ];
}
