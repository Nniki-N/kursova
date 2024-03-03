abstract class InternetStatusState {
  const InternetStatusState();
}

class InternetStatusInitial extends InternetStatusState {
  const InternetStatusInitial();
}

class InternetStatusConnected extends InternetStatusState {
  const InternetStatusConnected();
}

class InternetStatusDisconnected extends InternetStatusState {
  const InternetStatusDisconnected();
}

class InternetStatusListeningException extends InternetStatusState {
  const InternetStatusListeningException();
}
