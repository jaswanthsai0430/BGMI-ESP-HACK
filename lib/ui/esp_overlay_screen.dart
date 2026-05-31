import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/esp_controller.dart';
import 'esp_overlay_painter.dart';

class EspOverlayScreen extends StatelessWidget {
  const EspOverlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final espController = Provider.of<EspController>(context);
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: EspOverlayPainter(players: espController.players),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to home
                espController.stopEspLoop();
              },
              child: const Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}
