import 'package:connectivity_plus/connectivity_plus.dart';

enum CnnectionStatus {
  connected,
  disconnected,
}

/// A service for network monitoring.
class ConnectionService {
  /// Checks the connection status of the device.
  Future<CnnectionStatus> checkConnectivity() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    return _convertConnectivityResult(connectivityResult);
  }

  /// Fires whenever the connectivity state changes.
  Stream<CnnectionStatus> onConnectivityChanged() {
    return Connectivity()
        .onConnectivityChanged
        .asBroadcastStream()
        .map(_convertConnectivityResult)
        .asBroadcastStream();
  }

  /// Coverts [connectivityResult] only in two possible statuses: [CnnectionStatus.connected] or [CnnectionStatus.disconnected]
  CnnectionStatus _convertConnectivityResult(
    ConnectivityResult connectivityResult,
  ) {
    if (connectivityResult == ConnectivityResult.mobile) {
      return CnnectionStatus.connected;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return CnnectionStatus.connected;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return CnnectionStatus.connected;
    } else if (connectivityResult == ConnectivityResult.vpn) {
      return CnnectionStatus.connected;
    } else {
      return CnnectionStatus.disconnected;
    }
  }
}
