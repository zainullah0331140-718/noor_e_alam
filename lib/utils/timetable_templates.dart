import 'package:flutter/material.dart';

import '../db/enums.dart';
import '../l10n/app_localizations.dart';
import 'timetable_utils.dart';

/// One task inside a ready-made routine.
class TemplateTask {
  final String titleKey;
  final TaskCategory category;
  final String iconKey;
  final Color color;
  final int startMinutes;
  final int endMinutes;
  final TaskRepeat repeat;
  final int weekdaysMask;

  const TemplateTask({
    required this.titleKey,
    required this.category,
    required this.iconKey,
    required this.color,
    required this.startMinutes,
    required this.endMinutes,
    this.repeat = TaskRepeat.daily,
    this.weekdaysMask = weekdaysMaskValue,
  });
}

/// A ready-made day the user can add with one tap.
class TimetableTemplate {
  final String nameKey;
  final String descriptionKey;
  final IconData icon;
  final List<TemplateTask> tasks;

  const TimetableTemplate({
    required this.nameKey,
    required this.descriptionKey,
    required this.icon,
    required this.tasks,
  });
}

/// Category colour palette shared by the editor and timeline.
const Map<TaskCategory, Color> taskCategoryColors = {
  TaskCategory.ibadah: Color(0xFF1F8F4E),
  TaskCategory.work: Color(0xFF2F6FED),
  TaskCategory.study: Color(0xFF7A4FD1),
  TaskCategory.family: Color(0xFFE08A1E),
  TaskCategory.health: Color(0xFF16A3A3),
  TaskCategory.rest: Color(0xFF6B7280),
};

/// Curated icon options (string keys are persisted; icons stay tree-shake
/// friendly).
const Map<String, IconData> taskIconOptions = {
  'task': Icons.task_alt,
  'fajr': Icons.wb_twilight,
  'quran': Icons.menu_book,
  'adhkar': Icons.radio,
  'work': Icons.work_outline,
  'family': Icons.family_restroom,
  'isha': Icons.nights_stay,
  'tahajjud': Icons.dark_mode,
  'study': Icons.school_outlined,
  'revision': Icons.autorenew,
  'exercise': Icons.directions_run,
  'breakfast': Icons.free_breakfast,
  'rest': Icons.self_improvement,
  'dinner': Icons.dinner_dining,
  'sleep': Icons.bedtime,
};

IconData taskIcon(String key) => taskIconOptions[key] ?? Icons.task_alt;

/// Localized template name.
String templateName(AppLocalizations l10n, String key) {
  switch (key) {
    case 'tplIbadahDay':
      return l10n.tplIbadahDay;
    case 'tplStudentDay':
      return l10n.tplStudentDay;
    case 'tplFamilyDay':
      return l10n.tplFamilyDay;
    default:
      return key;
  }
}

/// Localized template description.
String templateDescription(AppLocalizations l10n, String key) {
  switch (key) {
    case 'tplIbadahDayDesc':
      return l10n.tplIbadahDayDesc;
    case 'tplStudentDayDesc':
      return l10n.tplStudentDayDesc;
    case 'tplFamilyDayDesc':
      return l10n.tplFamilyDayDesc;
    default:
      return key;
  }
}

/// Localized task title used by templates.
String templateTaskTitle(AppLocalizations l10n, String key) {
  switch (key) {
    case 'taskTplFajr':
      return l10n.taskTplFajr;
    case 'taskTplQuran':
      return l10n.taskTplQuran;
    case 'taskTplAdhkar':
      return l10n.taskTplAdhkar;
    case 'taskTplWork':
      return l10n.taskTplWork;
    case 'taskTplFamily':
      return l10n.taskTplFamily;
    case 'taskTplIsha':
      return l10n.taskTplIsha;
    case 'taskTplTahajjud':
      return l10n.taskTplTahajjud;
    case 'taskTplStudy':
      return l10n.taskTplStudy;
    case 'taskTplRevision':
      return l10n.taskTplRevision;
    case 'taskTplExercise':
      return l10n.taskTplExercise;
    case 'taskTplBreakfast':
      return l10n.taskTplBreakfast;
    case 'taskTplRest':
      return l10n.taskTplRest;
    case 'taskTplDinner':
      return l10n.taskTplDinner;
    case 'taskTplSleep':
      return l10n.taskTplSleep;
    default:
      return key;
  }
}

/// Built-in routines. Times are minutes from midnight.
final List<TimetableTemplate> timetableTemplates = [
  TimetableTemplate(
    nameKey: 'tplIbadahDay',
    descriptionKey: 'tplIbadahDayDesc',
    icon: Icons.balance,
    tasks: const [
      TemplateTask(
        titleKey: 'taskTplFajr',
        category: TaskCategory.ibadah,
        iconKey: 'fajr',
        color: Color(0xFF1F8F4E),
        startMinutes: 5 * 60,
        endMinutes: 5 * 60 + 20,
      ),
      TemplateTask(
        titleKey: 'taskTplQuran',
        category: TaskCategory.ibadah,
        iconKey: 'quran',
        color: Color(0xFF1F8F4E),
        startMinutes: 5 * 60 + 20,
        endMinutes: 6 * 60,
      ),
      TemplateTask(
        titleKey: 'taskTplAdhkar',
        category: TaskCategory.ibadah,
        iconKey: 'adhkar',
        color: Color(0xFF1F8F4E),
        startMinutes: 6 * 60,
        endMinutes: 6 * 60 + 15,
      ),
      TemplateTask(
        titleKey: 'taskTplWork',
        category: TaskCategory.work,
        iconKey: 'work',
        color: Color(0xFF2F6FED),
        startMinutes: 9 * 60,
        endMinutes: 13 * 60,
        repeat: TaskRepeat.weekdays,
        weekdaysMask: weekdaysMaskValue,
      ),
      TemplateTask(
        titleKey: 'taskTplFamily',
        category: TaskCategory.family,
        iconKey: 'family',
        color: Color(0xFFE08A1E),
        startMinutes: 18 * 60,
        endMinutes: 19 * 60,
      ),
      TemplateTask(
        titleKey: 'taskTplIsha',
        category: TaskCategory.ibadah,
        iconKey: 'isha',
        color: Color(0xFF1F8F4E),
        startMinutes: 20 * 60,
        endMinutes: 20 * 60 + 20,
      ),
    ],
  ),
  TimetableTemplate(
    nameKey: 'tplStudentDay',
    descriptionKey: 'tplStudentDayDesc',
    icon: Icons.school_outlined,
    tasks: const [
      TemplateTask(
        titleKey: 'taskTplTahajjud',
        category: TaskCategory.ibadah,
        iconKey: 'tahajjud',
        color: Color(0xFF1F8F4E),
        startMinutes: 4 * 60,
        endMinutes: 4 * 60 + 30,
      ),
      TemplateTask(
        titleKey: 'taskTplFajr',
        category: TaskCategory.ibadah,
        iconKey: 'fajr',
        color: Color(0xFF1F8F4E),
        startMinutes: 5 * 60,
        endMinutes: 5 * 60 + 20,
      ),
      TemplateTask(
        titleKey: 'taskTplStudy',
        category: TaskCategory.study,
        iconKey: 'study',
        color: Color(0xFF7A4FD1),
        startMinutes: 8 * 60,
        endMinutes: 11 * 60,
        repeat: TaskRepeat.weekdays,
        weekdaysMask: weekdaysMaskValue,
      ),
      TemplateTask(
        titleKey: 'taskTplRevision',
        category: TaskCategory.study,
        iconKey: 'revision',
        color: Color(0xFF7A4FD1),
        startMinutes: 16 * 60,
        endMinutes: 18 * 60,
        repeat: TaskRepeat.weekdays,
        weekdaysMask: weekdaysMaskValue,
      ),
      TemplateTask(
        titleKey: 'taskTplQuran',
        category: TaskCategory.ibadah,
        iconKey: 'quran',
        color: Color(0xFF1F8F4E),
        startMinutes: 19 * 60,
        endMinutes: 19 * 60 + 30,
      ),
    ],
  ),
  TimetableTemplate(
    nameKey: 'tplFamilyDay',
    descriptionKey: 'tplFamilyDayDesc',
    icon: Icons.family_restroom,
    tasks: const [
      TemplateTask(
        titleKey: 'taskTplExercise',
        category: TaskCategory.health,
        iconKey: 'exercise',
        color: Color(0xFF16A3A3),
        startMinutes: 6 * 60,
        endMinutes: 6 * 60 + 30,
        repeat: TaskRepeat.customDays,
        weekdaysMask: 0x41,
      ),
      TemplateTask(
        titleKey: 'taskTplBreakfast',
        category: TaskCategory.family,
        iconKey: 'breakfast',
        color: Color(0xFFE08A1E),
        startMinutes: 8 * 60,
        endMinutes: 9 * 60,
        repeat: TaskRepeat.customDays,
        weekdaysMask: 0x41,
      ),
      TemplateTask(
        titleKey: 'taskTplFamily',
        category: TaskCategory.family,
        iconKey: 'family',
        color: Color(0xFFE08A1E),
        startMinutes: 11 * 60,
        endMinutes: 13 * 60,
        repeat: TaskRepeat.customDays,
        weekdaysMask: 0x41,
      ),
      TemplateTask(
        titleKey: 'taskTplRest',
        category: TaskCategory.rest,
        iconKey: 'rest',
        color: Color(0xFF6B7280),
        startMinutes: 14 * 60,
        endMinutes: 16 * 60,
        repeat: TaskRepeat.customDays,
        weekdaysMask: 0x41,
      ),
      TemplateTask(
        titleKey: 'taskTplDinner',
        category: TaskCategory.family,
        iconKey: 'dinner',
        color: Color(0xFFE08A1E),
        startMinutes: 19 * 60,
        endMinutes: 20 * 60,
        repeat: TaskRepeat.customDays,
        weekdaysMask: 0x41,
      ),
    ],
  ),
];
