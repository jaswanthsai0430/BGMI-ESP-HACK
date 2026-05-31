import 'package:flutter/foundation.dart';

class Logger {
	static const String tag = 'BGMI_ESP';
  
	static void info(String message) {
		if (!kReleaseMode) {
			debugPrint('[$tag] ℹ️ $message');
		}
	}
  
	static void error(String message, [dynamic error]) {
		debugPrint('[$tag] ❌ $message');
		if (error != null) {
			debugPrint('[$tag] 📝 $error');
		}
	}
  
	static void success(String message) {
		if (!kReleaseMode) {
			debugPrint('[$tag] ✅ $message');
		}
	}
  
	static void warn(String message) {
		debugPrint('[$tag] ⚠️ $message');
	}
}
