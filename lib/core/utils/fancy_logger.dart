import 'package:logger/logger.dart';

class FancyLogger {
  // Create a logger instance with a PrettyPrinter
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to display
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.none, // Don't show timestamp
    ),
  );

  static void info(String message) {
    _logger.i(message);
  }

  static void navigation(String message) {
    // Using 'd' (debug) for navigation. 
    // We explicitly add a prefix to distinguish it visually if colors fail, 
    // but the logger will colorize 'debug' usually in blue/cyan or grey.
    // Let's use 't' (trace) or 'd' (debug).
    // Custom hack: prepend emoji or tag
    _logger.d('[NAV] $message');
  }

  static void apiRequest(String method, String url, [dynamic body, Map<String, String>? headers]) {
    // using 'w' (warning) color (usually yellow/orange) for requests to make them stand out
    String msg = '$method $url';
    if (headers != null) {
      // Filter out sensitive info like full token if needed, but for debugging we might want to see it exists
      final safeHeaders = Map<String, String>.from(headers);
      if (safeHeaders.containsKey('Authorization')) {
        safeHeaders['Authorization'] = safeHeaders['Authorization']!.substring(0, min(20, safeHeaders['Authorization']!.length)) + '...';
      }
      msg += '\nHeaders: $safeHeaders';
    }
    if (body != null) {
      msg += '\nBody: $body';
    }
    _logger.w('[API-REQ] $msg');
  }

  static int min(int a, int b) => a < b ? a : b;

  static void apiResponse(String method, String url, int statusCode, [dynamic body]) {
    final bool isSuccess = statusCode >= 200 && statusCode < 300;
    String msg = '$statusCode $method $url';
    if (body != null) {
      String bodyStr = body.toString();
      if (bodyStr.length > 500) {
        bodyStr = '${bodyStr.substring(0, 500)}...';
      }
      msg += '\nBody: $bodyStr';
    }

    if (isSuccess) {
      // 'i' (info) is usually blue, 't' is grey. 
      // There isn't a strict 'green' info in standard logger PRESETS without custom printer.
      // But Logger's PrettyPrinter uses:
      // Verbose/Trace: Gray
      // Debug: Blue
      // Info: Blue (or sometimes Green depending on theme)
      // Warning: Yellow/Orange
      // Error: Red
      // WTF: Magenta
      
      // Let's use 'i' for success.
       _logger.i('[API-RES] $msg');
    } else {
      _logger.e('[API-RES] $msg');
    }
  }

  static void error(String message) {
    _logger.e(message);
  }
}
