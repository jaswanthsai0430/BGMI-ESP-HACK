import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/esp_engine.dart';
import '../../core/overlay_manager.dart';
import '../../services/config_service.dart';
import '../widgets/esp_painter.dart';
import '../widgets/radar_widget.dart';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  late ESPEngine _espEngine;
  List<Entity> _entities = [];
  bool _isRunning = false;
  
  @override
  void initState() {
    super.initState();
    _espEngine = ESPEngine();
    _startESP();
  }
  
  Future<void> _startESP() async {
    final config = Provider.of<ConfigService>(context, listen: false).config;
    
    _espEngine.onEntitiesUpdated = (entities) {
      setState(() {
        _entities = entities;
      });
    };
    
    await _espEngine.start(config);
    setState(() {
      _isRunning = true;
    });
  }
  
  Future<void> _stopESP() async {
    await _espEngine.stop();
    setState(() {
      _isRunning = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigService>(context).config;
    final screenSize = MediaQuery.of(context).size;
    
    _espEngine.updateScreenSize(screenSize);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ESP Overlay Preview
          if (_entities.isNotEmpty)
            CustomPaint(
              size: screenSize,
              painter: ESPPainter(
                entities: _entities,
                config: config,
                screenSize: screenSize,
              ),
            ),
          
          // Radar
          if (config.enableRadar && _isRunning)
            Positioned(
              top: 20,
              right: 20,
              child: RadarWidget(
                entities: _entities,
                size: config.radarSize,
                config: config,
              ),
            ),
          
          // Control Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow, color: Colors.red),
                    onPressed: () {
                      if (_isRunning) {
                        _stopESP();
                      } else {
                        _startESP();
                      }
                    },
                  ),
                  Text(
                    'Tracking: ${_entities.length} players',
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _espEngine.stop();
    super.dispose();
  }
}