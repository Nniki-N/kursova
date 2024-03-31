import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

void setUpBlocObserver({
  required Logger logger,
}) {
  Bloc.observer = AppBlocObserver(
    logger: logger,
  );
}

/// A BLoC Observer with overrided methods to log every change.
class AppBlocObserver extends BlocObserver {
  final Logger _logger;

  AppBlocObserver({
    required Logger logger,
  }) : _logger = logger;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.i('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.i('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _logger.i('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.i('onClose -- ${bloc.runtimeType}');
  }
}
