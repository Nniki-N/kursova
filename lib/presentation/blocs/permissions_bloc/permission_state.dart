abstract class PermissionState {
  final bool locationServiceIsEnabled;
  final bool locationIsGranted;

  const PermissionState({
    required this.locationServiceIsEnabled,
    required this.locationIsGranted,
  });

  @override
  String toString() => '$runtimeType(locationServiceIsEnabled: $locationServiceIsEnabled, locationIsGranted: $locationIsGranted)';
}

class PermissionInitial extends PermissionState {
  PermissionInitial()
      : super(
          locationServiceIsEnabled: false,
          locationIsGranted: false,
        );
}

class PermissionLoaded extends PermissionState {
  PermissionLoaded({
    required bool locationServiceIsEnabled,
    required bool locationIsGranted,
  }) : super(
          locationServiceIsEnabled: locationServiceIsEnabled,
          locationIsGranted: locationIsGranted,
        );
}
