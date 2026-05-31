import 'package:flutter/material.dart';
import '../models/player_data.dart';
import '../core/memory_reader.dart';
import '../core/world_to_screen.dart';

class EspController with ChangeNotifier {
  final MemoryReader _memoryReader = MemoryReader();
  List<PlayerData> players = [];
  bool isRunning = false;

  Future<void> startEspLoop() async {
    isRunning = true;
    while (isRunning) {
      await Future.delayed(Duration(milliseconds: 50)); // throttle
      await _fetchAndProcessData();
      notifyListeners();
    }
  }

  Future<void> stopEspLoop() async {
    isRunning = false;
  }

  Future<void> _fetchAndProcessData() async {
    // Stub: In a real system, call _memoryReader to get player/entity data
    players = await _memoryReader.getPlayers();
    // Process coordinates to screen positions
    for (var p in players) {
      p.screenPosition = WorldToScreen.project(p.worldPosition);
    }
  }
}
