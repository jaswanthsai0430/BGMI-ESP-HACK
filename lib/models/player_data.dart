import 'package:flutter/material.dart';

class PlayerData {
  final String name;
  final int health;
  final int team;
  final List<num> worldPosition; // [x, y, z]
  List<double>? screenPosition; // [x, y] filled by W2S

  PlayerData({
    required this.name,
    required this.health,
    required this.team,
    required this.worldPosition,
    this.screenPosition,
  });
}
