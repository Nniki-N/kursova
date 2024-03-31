
/// An util that is used for exceptions formating.
abstract class ExceptionUtil {

  /// Adds [messageDetails] to [customMessage] if provided and returns as a result.
  static String addDetailsToCustomMessage(
    String customMessage,
    String? messageDetails,
  ) {
    return '$customMessage${messageDetails != null ? ' -> $messageDetails' : ''}';
  }
}
