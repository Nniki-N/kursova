abstract class ExceptionUtil {
  static String addDetailsToCustomMessage(
    String customMessage,
    String? messageDetails,
  ) {
    return '$customMessage${messageDetails != null ? ' -> $messageDetails' : ''}';
  }
}
