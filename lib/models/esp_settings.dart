import 'package:flutter/material.dart';

class ESPConfig {
	bool enableBoxESP;
	bool enableHealthBar;
	bool enableDistance;
	bool enableNames;
	bool enableSnaplines;
	bool enableHeadCircle;
	bool enableRadar;
  
	Color enemyColor;
	Color teammateColor;
	Color knockedColor;
  
	double maxDistance;
	double boxThickness;
	double headCircleRadius;
	double radarSize;
  
	bool safeMode;
  
	ESPConfig({
		this.enableBoxESP = true,
		this.enableHealthBar = true,
		this.enableDistance = true,
		this.enableNames = true,
		this.enableSnaplines = true,
		this.enableHeadCircle = true,
		this.enableRadar = true,
		this.enemyColor = Colors.red,
		this.teammateColor = Colors.blue,
		this.knockedColor = Colors.purple,
		this.maxDistance = 300.0,
		this.boxThickness = 2.0,
		this.headCircleRadius = 8.0,
		this.radarSize = 180.0,
		this.safeMode = true,
	});
  
	Map<String, dynamic> toJson() => {
		'enableBoxESP': enableBoxESP,
		'enableHealthBar': enableHealthBar,
		'enableDistance': enableDistance,
		'enableNames': enableNames,
		'enableSnaplines': enableSnaplines,
		'enableHeadCircle': enableHeadCircle,
		'enableRadar': enableRadar,
		'enemyColor': enemyColor.value,
		'teammateColor': teammateColor.value,
		'knockedColor': knockedColor.value,
		'maxDistance': maxDistance,
		'boxThickness': boxThickness,
		'headCircleRadius': headCircleRadius,
		'radarSize': radarSize,
		'safeMode': safeMode,
	};
  
	factory ESPConfig.fromJson(Map<String, dynamic> json) => ESPConfig(
		enableBoxESP: json['enableBoxESP'] ?? true,
		enableHealthBar: json['enableHealthBar'] ?? true,
		enableDistance: json['enableDistance'] ?? true,
		enableNames: json['enableNames'] ?? true,
		enableSnaplines: json['enableSnaplines'] ?? true,
		enableHeadCircle: json['enableHeadCircle'] ?? true,
		enableRadar: json['enableRadar'] ?? true,
		enemyColor: Color(json['enemyColor'] ?? Colors.red.value),
		teammateColor: Color(json['teammateColor'] ?? Colors.blue.value),
		knockedColor: Color(json['knockedColor'] ?? Colors.purple.value),
		maxDistance: json['maxDistance'] ?? 300.0,
		boxThickness: json['boxThickness'] ?? 2.0,
		headCircleRadius: json['headCircleRadius'] ?? 8.0,
		radarSize: json['radarSize'] ?? 180.0,
		safeMode: json['safeMode'] ?? true,
	);
}
