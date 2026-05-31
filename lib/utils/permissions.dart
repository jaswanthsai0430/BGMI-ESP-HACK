import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> checkOverlayPermission() async {
    return await Permission.systemAlertWindow.isGranted;
  }
  
  static Future<bool> requestOverlayPermission() async {
    final status = await Permission.systemAlertWindow.request();
    return status.isGranted;
  }
  
  static Future<bool> checkRootAccess() async {
    try {
      final result = await Process.run('su', ['-c', 'echo root']);
      return result.exitCode == 0 && result.stdout.toString().trim() == 'root';
    } catch (e) {
      return false;
    }
  }
  
  static Future<void> showRootRequiredDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Root Required'),
        content: const Text(
          'BGMI ESP requires root access to read game memory.\n\n'
          'Please root your device with Magisk and grant root permission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}