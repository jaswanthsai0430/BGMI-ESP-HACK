import 'package:flutter/material.dart';
import '../../models/entity.dart';
import '../../models/esp_settings.dart';
import '../../models/vector2.dart';

class RadarWidget extends StatelessWidget {
  final List<Entity> entities;
  final double size;
  final ESPConfig config;
  
  const RadarWidget({
    super.key,
    required this.entities,
    required this.size,
    required this.config,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: CustomPaint(
        painter: RadarPainter(entities: entities, config: config, radarSize: size),
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final List<Entity> entities;
  final ESPConfig config;
  final double radarSize;
  
  RadarPainter({
    required this.entities,
    required this.config,
    required this.radarSize,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radarSize / 2, radarSize / 2);
    final maxDist = config.maxDistance;
    
    // Draw circles
    for (int i = 1; i <= 3; i++) {
      final radius = (radarSize / 2) * (i / 3);
      final paint = Paint()
        ..color = Colors.white24
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(center, radius, paint);
    }
    
    // Draw crosshair
    final linePaint = Paint()..color = Colors.white24..strokeWidth = 1;
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, radarSize), linePaint);
    canvas.drawLine(Offset(0, center.dy), Offset(radarSize, center.dy), linePaint);
    
    // Draw entities on radar
    for (final entity in entities) {
      if (entity.distance > maxDist) continue;
      
      final normalizedDist = entity.distance / maxDist;
      final radarDist = (radarSize / 2) * normalizedDist;
      
      // Simple angle calculation (using XZ plane)
      final angle = entity.worldPosition.z.atan2(entity.worldPosition.x);
      final x = center.dx + radarDist * angle.cos();
      final y = center.dy + radarDist * angle.sin();
      
      final dotPaint = Paint()
        ..color = entity.getBoxColor(config)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
    
    // Draw center dot
    final centerPaint = Paint()..color = Colors.red..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, centerPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}