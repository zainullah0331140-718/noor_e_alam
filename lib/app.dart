import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'presentation/screens/home_shell.dart';
import 'presentation/screens/splash_screen.dart';
import 'providers/app_providers.dart';
import 'providers/notification_providers.dart';
import 'providers/settings_providers.dart';
import 'theme/app_theme.dart';

/// Root widget: themes, localization delegates, locale + theme-mode
/// bindings, then a splash → home-shell hand-off once the DB seed is done.
class NoorEAmalApp extends ConsumerStatefulWidget {
  const NoorEAmalApp({super.key});

  @override
  ConsumerState<NoorEAmalApp> createState() => _NoorEAmalAppState();
}

class _NoorEAmalAppState extends ConsumerState<NoorEAmalApp> {
  bool _splashDone = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final seed = ref.watch(seedProvider);

    // Keep the scheduled notifications in sync with prefs/location/prayer times.
    ref.watch(notificationScheduleProvider);

    // Show the shell once the DB seed finished AND the splash timer elapsed.
    final ready = _splashDone && seed.hasValue;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ready
          ? const HomeShell()
          : SplashScreen(
              onDone: () => setState(() => _splashDone = true),
            ),
    );
  }
}
