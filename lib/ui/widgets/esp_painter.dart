import 'package:flutter/material.dart';
import '../../models/entity.dart';
import '../../models/esp_settings.dart';
import '../../utils/math_utils.dart';

class ESPPainter extends CustomPainter {
  final List<Entity> entities;
  final ESPConfig config;
  final Size screenSize;
  
  ESPPainter({
    required this.entities,
    required this.config,
    required this.screenSize,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;
    
    for (final entity in entities) {
      if (entity.screenPosition == null) continue;
      
      final screenPos = entity.screenPosition!;
      if (!screenPos.isOnScreen(screenSize.width, screenSize.height)) continue;
      
      final boxHeight = MathUtils.getBoxHeight(entity.distance);
      final boxWidth = MathUtils.getBoxWidth(boxHeight);
      
      final top = screenPos.y - boxHeight / 2;
      final bottom = screenPos.y + boxHeight / 2;
      final left = screenPos.x - boxWidth / 2;
      final right = screenPos.x + boxWidth / 2;
      
      final boxColor = entity.getBoxColor(config);
      
      // Draw box
      if (config.enableBoxESP) {
        final paint = Paint()
          ..color = boxColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = config.boxThickness;
        canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
      }
      
      // Draw health bar
      if (config.enableHealthBar) {
        final healthWidth = boxWidth * entity.healthPercent;
        final healthPaint = Paint()
          ..color = entity.healthPercent > 0.5 ? Colors.green : (entity.healthPercent > 0.2 ? Colors.orange : Colors.red)
          ..style = PaintingStyle.fill;
        canvas.drawRect(Rect.fromLTRB(left, top - 10, left + healthWidth, top - 4), healthPaint);
        
        // Health border
        final borderPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawRect(Rect.fromLTRB(left, top - 10, right, top - 4), borderPaint);
      }
      
      // Draw distance
      if (config.enableDistance) {
        final textSpan = TextSpan(
          text: '${entity.distance.toInt()}m',
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        );
        final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(canvas, Offset(left, bottom + 2));
      }
      
      // Draw name
      if (config.enableNames) {
        final textSpan = TextSpan(
          text: entity.name,
          style: TextStyle(color: boxColor, fontSize: 10),
        );
        final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(canvas, Offset(left, top - 20));
      }
      
      // Draw head circle
      if (config.enableHeadCircle) {
        final headPaint = Paint()
          ..color = boxColor.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawCircle(Offset(screenPos.x, top + 10), config.headCircleRadius, headPaint);
      }
      
      // Draw snapline
      if (config.enableSnaplines) {
        final linePaint = Paint()
          ..color = boxColor.withOpacity(0.7)
          ..strokeWidth = config.snaplineThickness;
        canvas.drawLine(Offset(centerX, centerY), Offset(screenPos.x, screenPos.y), linePaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}