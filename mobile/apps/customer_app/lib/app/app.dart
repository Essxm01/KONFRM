import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../features/discovery/data/public_property_search_repository.dart';
import 'shell/customer_app_shell.dart';

/// Root application widget for KONFRM | GUEST.
///
/// Sets up:
/// - Arabic-first primary locale (`ar`) with RTL text direction
/// - Governing Cairo typography via `konfrmLightTheme()`
/// - Flutter material localizations delegates
/// - `CustomerAppShell` as the home destination
class KonfrmCustomerApp extends StatelessWidget {
  const KonfrmCustomerApp({super.key, this.apiBaseUrl = ''});

  final String apiBaseUrl;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [publicApiBaseUrlProvider.overrideWithValue(apiBaseUrl)],
      child: MaterialApp(
        title: 'KONFRM | كونفرم',
        debugShowCheckedModeBanner: false,
        theme: konfrmLightTheme(),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const CustomerAppShell(),
      ),
    );
  }
}
