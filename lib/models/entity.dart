import 'package:flutter/material.dart';
import 'vector3.dart';
import 'vector2.dart';
import 'esp_settings.dart';

enum EntityType {
	enemy,
	teammate,
	knocked,
}

class Entity {
	final String name;
	final Vector3 worldPosition;
	Vector2? screenPosition;
	double health;
	final double maxHealth;
	final int teamId;
	final EntityType type;
	final double distance;
	final bool isVisible;
  
	Entity({
		required this.name,
		required this.worldPosition,
		this.screenPosition,
		required this.health,
		required this.maxHealth,
		required this.teamId,
		required this.type,
		required this.distance,
		this.isVisible = true,
	});
  
	double get healthPercent => health / maxHealth;
  
	Color getBoxColor(ESPConfig config) {
		switch (type) {
			case EntityType.enemy:
				return config.enemyColor;
			case EntityType.teammate:
				return config.teammateColor;
			case EntityType.knocked:
				return config.knockedColor;
		}
	}
}
