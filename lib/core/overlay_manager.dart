import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class OverlayManager {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;
  
  Future<bool> startOverlay(BuildContext context) async {
    if (!await Permission.systemAlertWindow.isGranted) {
      final granted = await Permission.systemAlertWindow.request();
      if (!granted) return false;
    }
    
    if (_isShowing) return true;
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: IgnorePointer(
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;
    return true;
  }
  
  void stopOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }
  
  bool get isShowing => _isShowing;
}