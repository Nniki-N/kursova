import 'package:get_it/get_it.dart';
import 'package:kursova/data/datasources/nominatim_datasource.dart';
import 'package:kursova/data/datasources/osrm_datasource.dart';
import 'package:kursova/data/repositories/nominatim_location_repository.dart';
import 'package:kursova/data/repositories/osrm_route_repository.dart';
import 'package:kursova/domain/repositories/location_repository.dart';
import 'package:kursova/domain/repositories/route_repository.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Common
  getIt.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        levelColors: {
          Level.info: const AnsiColor.fg(3),
        },
      ),
    ),
  );

  // Datasources
  getIt.registerLazySingleton<OsrmDatasource>(
    () => const OsrmDatasource(),
  );
  getIt.registerLazySingleton<NominatimDatasouce>(
      () => const NominatimDatasouce());

  // Repositories
  getIt.registerLazySingleton<RouteRepository>(
    () => OsrmRouteRepository(
      osrmDatasource: getIt.get(),
    ),
  );
  getIt.registerLazySingleton<LocationRepository>(
    () => NominatimLocationRepository(
      nominatimDatasouce: getIt.get(),
      logger: getIt.get(),
    ),
  );
}
