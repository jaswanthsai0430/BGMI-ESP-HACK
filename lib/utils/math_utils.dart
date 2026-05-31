import 'dart:math';
import '../models/vector3.dart';
import '../models/vector2.dart';

class MathUtils {
	static Vector2? worldToScreen(
		Vector3 worldPos,
		Vector3 cameraPos,
		Vector3 cameraRot,
		double fov,
		double screenWidth,
		double screenHeight,
	) {
		// Calculate relative position
		final deltaX = worldPos.x - cameraPos.x;
		final deltaY = worldPos.y - cameraPos.y;
		final deltaZ = worldPos.z - cameraPos.z;
    
		// Camera rotation
		final cosYaw = cos(cameraRot.y);
		final sinYaw = sin(cameraRot.y);
		final cosPitch = cos(cameraRot.x);
		final sinPitch = sin(cameraRot.x);
    
		// Transform to camera space
		final x = deltaZ * cosYaw - deltaX * sinYaw;
		final y = deltaY * cosPitch - deltaZ * sinPitch;
		final z = deltaX * cosYaw * cosPitch + 
							deltaZ * sinYaw * cosPitch + 
							deltaY * sinPitch;
    
		if (z <= 0.1) return null;
    
		// Project to 2D
		final aspect = screenWidth / screenHeight;
		final angle = (fov * 0.5) * pi / 180.0;
		final tanAngle = tan(angle);
    
		final screenX = (x / z / tanAngle / aspect) * screenWidth / 2 + screenWidth / 2;
		final screenY = (y / z / tanAngle) * screenHeight / 2 + screenHeight / 2;
    
		return Vector2(screenX, screenY);
	}
  
	static double calculateDistance(Vector3 pos1, Vector3 pos2) {
		final dx = pos1.x - pos2.x;
		final dy = pos1.y - pos2.y;
		final dz = pos1.z - pos2.z;
		return sqrt(dx * dx + dy * dy + dz * dz);
	}
  
	static double getBoxHeight(double distance) {
		final baseHeight = 120.0;
		final minHeight = 25.0;
		double calculated = baseHeight * (80.0 / distance);
		return calculated.clamp(minHeight, baseHeight);
	}
  
	static double getBoxWidth(double height) {
		return height * 0.55;
	}
}
