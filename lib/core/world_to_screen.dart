import 'dart:math';

/// Demo W2S: Converts 3D to 2D for overlay (replace with real UE math for BGMI)
class WorldToScreen {
  static List<double> project(List<num> worldPos) {
    // This is a stub! Real formula depends on BGMI camera/viewport/angles.
    double x = worldPos[0].toDouble();
    double y = worldPos[1].toDouble();
    // fake scale to fit 1080x600 overlay
    return [x % 1080, y % 600];
  }
}
