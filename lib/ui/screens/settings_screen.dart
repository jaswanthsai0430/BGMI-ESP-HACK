import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/config_service.dart';
import '../widgets/color_picker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<ConfigService>(
        builder: (context, configService, child) {
          final config = configService.config;
          return ListView(
            children: [
              _buildSection('VISUAL', [
                _buildSwitch(
                  'Box ESP',
                  config.enableBoxESP,
                  (v) => configService.updateSetting((c) => c.enableBoxESP = v),
                ),
                _buildSwitch(
                  'Health Bar',
                  config.enableHealthBar,
                  (v) => configService.updateSetting((c) => c.enableHealthBar = v),
                ),
                _buildSwitch(
                  'Distance',
                  config.enableDistance,
                  (v) => configService.updateSetting((c) => c.enableDistance = v),
                ),
                _buildSwitch(
                  'Names',
                  config.enableNames,
                  (v) => configService.updateSetting((c) => c.enableNames = v),
                ),
                _buildSwitch(
                  'Snaplines',
                  config.enableSnaplines,
                  (v) => configService.updateSetting((c) => c.enableSnaplines = v),
                ),
                _buildSwitch(
                  'Radar',
                  config.enableRadar,
                  (v) => configService.updateSetting((c) => c.enableRadar = v),
                ),
              ]),
              
              _buildSection('COLORS', [
                _buildColorOption(
                  'Enemy Color',
                  config.enemyColor,
                  (color) => configService.updateSetting((c) => c.enemyColor = color),
                ),
                _buildColorOption(
                  'Teammate Color',
                  config.teammateColor,
                  (color) => configService.updateSetting((c) => c.teammateColor = color),
                ),
                _buildColorOption(
                  'Knocked Color',
                  config.knockedColor,
                  (color) => configService.updateSetting((c) => c.knockedColor = color),
                ),
              ]),
              
              _buildSection('DISTANCE', [
                _buildSlider(
                  'Max Distance: ${config.maxDistance.toInt()}m',
                  config.maxDistance,
                  100, 500,
                  (v) => configService.updateSetting((c) => c.maxDistance = v),
                ),
              ]),
              
              _buildSection('SAFE MODE', [
                _buildSwitch(
                  'Safe Mode (Lower Risk)',
                  config.safeMode,
                  (v) => configService.updateSetting((c) => c.safeMode = v),
                ),
              ]),
              
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(title, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
        ...children,
        const Divider(color: Colors.white24),
      ],
    );
  }
  
  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.red,
    );
  }
  
  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: Colors.red,
          onChanged: onChanged,
        ),
      ],
    );
  }
  
  Widget _buildColorOption(String label, Color color, Function(Color) onChanged) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: GestureDetector(
        onTap: () async {
          final newColor = await showDialog<Color>(
            context: navigatorKey.currentContext!,
            builder: (context) => ColorPickerDialog(initialColor: color),
          );
          if (newColor != null) onChanged(newColor);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();