import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/esp_controller.dart';
import 'esp_overlay_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final espController = Provider.of<EspController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('BGMI ESP Overlay Demo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                await espController.startEspLoop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EspOverlayScreen()),
                );
              },
              child: const Text('Start ESP Overlay'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => espController.stopEspLoop(),
              child: const Text('Stop Overlay'),
            ),
          ],
        ),
      ),
    );
  }
}
