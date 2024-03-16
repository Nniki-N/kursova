import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/di/locator.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_bloc.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_event.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_bloc.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_bloc.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_bloc.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_event.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_bloc.dart';
import 'package:kursova/presentation/screens/initial_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MapMarkersBloc(
            logger: getIt.get(),
          ),
        ),
        BlocProvider(
          create: (context) => RouteBloc(
            findRouteUseCase: getIt.get(),
            logger: getIt.get(),
          ),
        ),
        BlocProvider(
          create: (context) => LocationsBloc(
            retrieveCurrentLocationUseCase: getIt.get(),
            retrieveLocationByAddresssUseCase: getIt.get(),
            retrieveLocationByCoordinatesUseCase: getIt.get(),
            logger: getIt.get(),
          ),
        ),
        BlocProvider(
          create: (context) => InternetStatusBloc(
            connectionService: getIt.get(),
            logger: getIt.get(),
          )..add(
              const InternetStatusListenRequested(),
            ),
        ),
        BlocProvider(
          create: (context) => PermissionBloc(
            logger: getIt.get(),
            locationService: getIt.get(),
            permissionsService: getIt.get(),
          )..add(
              const PermissionInitRequested(),
            ),
        ),
      ],
      child: MaterialApp(
        title: 'Kursova',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const InitialScreen(),
      ),
    );
  }
}
