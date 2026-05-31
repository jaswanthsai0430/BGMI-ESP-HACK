import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/config_service.dart';
import '../../utils/permissions.dart';
import '../../utils/logger.dart';
import 'overlay_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'BGMI ESP',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Battle Royale Visualization Tool',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 60),
              
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                      context,
                      title: 'START ESP',
                      subtitle: 'Launch overlay and begin tracking',
                      icon: Icons.play_arrow,
                      color: Colors.red,
                      onTap: () async {
                        final hasRoot = await PermissionHelper.checkRootAccess();
                        if (!hasRoot) {
                          await PermissionHelper.showRootRequiredDialog(context);
                          return;
                        }
                        
                        final hasOverlay = await PermissionHelper.checkOverlayPermission();
                        if (!hasOverlay) {
                          await PermissionHelper.requestOverlayPermission();
                        }
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OverlayScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildButton(
                      context,
                      title: 'SETTINGS',
                      subtitle: 'Configure ESP appearance',
                      icon: Icons.settings,
                      color: Colors.grey,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  '⚠️ Root Required | Use at your own risk',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildButton(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
