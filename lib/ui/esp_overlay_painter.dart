import 'package:flutter/material.dart';
import '../models/player_data.dart';

class EspOverlayPainter extends CustomPainter {
  final List<PlayerData> players;

  EspOverlayPainter({required this.players});

  @override
  void paint(Canvas canvas, Size size) {
    final boxPaint = Paint()
      ..color = Colors.red.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final healthPaint = Paint()
      ..color = Colors.green.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    for (var player in players) {
      if (player.screenPosition == null) continue;
      final pos = player.screenPosition!;

      // Example: Draw box at player's screen position
      final rect = Rect.fromCenter(center: Offset(pos[0], pos[1]), width: 60, height: 100);
      canvas.drawRect(rect, boxPaint);

      // Draw player name
      final textSpan = TextSpan(
        text: player.name,
        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(pos[0] - tp.width / 2, pos[1] - 60));

      // Draw health bar under box
      final width = 60.0 * (player.health.clamp(0, 100) / 100.0);
      canvas.drawRect(
        Rect.fromLTWH(pos[0] - 30, pos[1] + 50, width, 8),
        healthPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EspOverlayPainter oldDelegate) => oldDelegate.players != players;
}
