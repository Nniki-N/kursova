import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kursova/core/app_localization.dart';
import 'package:kursova/core/di/locator.dart';
import 'package:kursova/presentation/app/my_app.dart';
import 'package:kursova/presentation/blocs/app_bloc_observer.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom],
    );

    setupDependencies();

    setUpBlocObserver(logger: getIt.get());

    runApp(
      EasyLocalization(
        supportedLocales: AppLocalization.supportedLocales,
        path: AppLocalization.translationsPath,
        fallbackLocale: AppLocalization.ukLocale,
        useFallbackTranslations: true,
        useOnlyLangCode: true,
        child: const MyApp(),
      ),
    );
  }, (exception, stackTrace) async {
    getIt.get<Logger>().e(
          'Main guarded zone',
          error: exception,
          stackTrace: stackTrace,
        );
  });
}
