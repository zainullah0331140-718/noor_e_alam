import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:noor_e_amal/db/app_database.dart';
import 'package:noor_e_amal/l10n/app_localizations.dart';
import 'package:noor_e_amal/presentation/screens/settings_screen.dart';
import 'package:noor_e_amal/providers/app_providers.dart';
import 'package:noor_e_amal/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('settings probe', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final prefs = await SharedPreferences.getInstance();
    debugPrint('--- pump ---');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          dbProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: SettingsScreen()),
        ),
      ),
    );
    debugPrint('--- done ---');
    await db.close();
  });
}
