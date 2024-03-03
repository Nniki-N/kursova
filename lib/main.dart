import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kursova/core/di/locator.dart';
import 'package:kursova/presentation/app/my_app.dart';
import 'package:kursova/presentation/blocs/app_bloc_observer.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await EasyLocalization.ensureInitialized();

    setupDependencies();

    setUpBlocObserver(logger: getIt.get());

    runApp(const MyApp());
  }, (exception, stackTrace) async {
    print('$exception, $stackTrace');
  });
}