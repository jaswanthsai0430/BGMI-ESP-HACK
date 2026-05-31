import 'dart:async';
import 'dart:ui';
import '../models/entity.dart';
import '../models/vector3.dart';
import '../models/esp_settings.dart';
import 'memory_manager.dart';
import '../utils/math_utils.dart';
import '../utils/logger.dart';

class ESPEngine {
  final MemoryManager _memory = MemoryManager();
  Timer? _updateTimer;
  List<Entity> _entities = [];
  bool _isRunning = false;
  ESPConfig _config = ESPConfig();
  Function(List<Entity>)? onEntitiesUpdated;
  
  Vector3 _cameraPos = Vector3.zero();
  Vector3 _cameraRot = Vector3.zero();
  int _localTeamId = 1;
  Size _screenSize = const Size(1080, 2400);
  
  Future<void> start(ESPConfig config) async {
    if (_isRunning) return;
    _config = config;
    
    if (!await _memory.attachToProcess()) {
      Logger.error('Cannot start ESP - failed to attach');
      return;
    }
    
    _isRunning = true;
    Logger.success('ESP Engine started');
    
    final interval = Duration(milliseconds: 1000 ~/ 60);
    _updateTimer = Timer.periodic(interval, (_) => _update());
  }
  
  Future<void> _update() async {
    if (!_isRunning) return;
    
    try {
      await _updateCamera();
      await _updateLocalPlayer();
      
      // Read GWorld
      final gworld = await _memory.readPointer(MemoryManager.OFFSETS['GWorld']!);
      if (gworld == 0) return;
      
      final uworld = await _memory.readPointer(gworld + MemoryManager.OFFSETS['UWorld']!);
      if (uworld == 0) return;
      
      final level = await _memory.readPointer(uworld + MemoryManager.OFFSETS['PersistentLevel']!);
      if (level == 0) return;
      
      final actorArray = await _memory.readPointer(level + MemoryManager.OFFSETS['ActorArray']!);
      final actorCount = await _memory.readInt(level + MemoryManager.OFFSETS['ActorCount']!);
      
      if (actorCount > 500) return;
      
      final List<Entity> newEntities = [];
      
      for (int i = 0; i < actorCount; i++) {
        final actor = await _memory.readPointer(actorArray + (i * 8));
        if (actor == 0) continue;
        
        final entity = await _parseActor(actor);
        if (entity != null && entity.distance <= _config.maxDistance) {
          final screenPos = MathUtils.worldToScreen(
            entity.worldPosition,
            _cameraPos,
            _cameraRot,
            90.0,
            _screenSize.width,
            _screenSize.height,
          );
          
          if (screenPos != null) {
            entity.screenPosition = screenPos;
            newEntities.add(entity);
          }
        }
      }
      
      newEntities.sort((a, b) => a.distance.compareTo(b.distance));
      _entities = newEntities;
      onEntitiesUpdated?.call(_entities);
      
    } catch (e) {
      // Silent fail
    }
  }
  
  Future<void> _updateCamera() async {
    final cameraManager = await _memory.readPointer(MemoryManager.OFFSETS['CameraManager']!);
    if (cameraManager != 0) {
      _cameraRot.x = await _memory.readFloat(cameraManager + MemoryManager.OFFSETS['ViewPitch']!);
      _cameraRot.y = await _memory.readFloat(cameraManager + MemoryManager.OFFSETS['ViewYaw']!);
    }
  }
  
  Future<void> _updateLocalPlayer() async {
    // Find local player and get team ID
    final gworld = await _memory.readPointer(MemoryManager.OFFSETS['GWorld']!);
    if (gworld != 0) {
      final localPlayer = await _memory.readPointer(gworld + 0x100);
      if (localPlayer != 0) {
        _localTeamId = await _memory.readInt(localPlayer + MemoryManager.OFFSETS['TeamId']!);
      }
    }
  }
  
  Future<Entity?> _parseActor(int actorPtr) async {
    try {
      final health = await _memory.readFloat(actorPtr + MemoryManager.OFFSETS['PlayerHealth']!);
      if (health <= 0 || health > 100) return null;
      
      final maxHealth = await _memory.readFloat(actorPtr + MemoryManager.OFFSETS['PlayerMaxHealth']!);
      final teamId = await _memory.readInt(actorPtr + MemoryManager.OFFSETS['TeamId']!);
      final playerState = await _memory.readInt(actorPtr + MemoryManager.OFFSETS['PlayerState']!);
      
      final rootComp = await _memory.readPointer(actorPtr + MemoryManager.OFFSETS['RootComponent']!);
      final pos = await _memory.readVector3(rootComp + MemoryManager.OFFSETS['Position']!);
      
      final namePtr = await _memory.readPointer(actorPtr + MemoryManager.OFFSETS['PlayerName']!);
      String name = await _memory.readString(namePtr, 32);
      if (name.isEmpty) name = "Player";
      
      final distance = MathUtils.calculateDistance(_cameraPos, pos);
      
      EntityType type;
      if (playerState == 1) {
        type = EntityType.knocked;
      } else if (teamId == _localTeamId && teamId != 0) {
        type = EntityType.teammate;
      } else {
        type = EntityType.enemy;
      }
      
      return Entity(
        name: name,
        worldPosition: pos,
        health: health,
        maxHealth: maxHealth,
        teamId: teamId,
        type: type,
        distance: distance,
      );
      
    } catch (e) {
      return null;
    }
  }
  
  Future<void> stop() async {
    _isRunning = false;
    _updateTimer?.cancel();
    _memory.detach();
    Logger.info('ESP Engine stopped');
  }
  
  void updateScreenSize(Size size) {
    _screenSize = size;
  }
  
  List<Entity> getEntities() => _entities;
  bool get isRunning => _isRunning;
}