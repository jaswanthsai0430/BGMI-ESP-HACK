import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import '../utils/logger.dart';

class MemoryManager {
  static const String BGMI_PACKAGE = "com.pubg.imobile";
  int _pid = -1;
  bool _isAttached = false;
  
  // BGMI 4.4.0 Offsets
  static const Map<String, int> OFFSETS = {
    'GWorld': 0x0E73B8A0,
    'GNames': 0x0E738A60,
    'UWorld': 0x0F12B7C0,
    'PersistentLevel': 0x30,
    'ActorArray': 0xA0,
    'ActorCount': 0xA8,
    'PlayerHealth': 0x0F50,
    'PlayerMaxHealth': 0x0F54,
    'TeamId': 0x0F68,
    'PlayerState': 0x0F70,
    'PlayerName': 0x0800,
    'RootComponent': 0x190,
    'Position': 0x160,
    'CameraManager': 0x6A0,
    'ViewPitch': 0x8C0,
    'ViewYaw': 0x8C4,
  };
  
  Future<bool> attachToProcess() async {
    try {
      // Find BGMI process
      final result = await Process.run('pgrep', ['-f', BGMI_PACKAGE]);
      if (result.exitCode != 0) {
        Logger.error('BGMI process not found');
        return false;
      }
      
      _pid = int.parse(result.stdout.toString().trim());
      Logger.success('Attached to BGMI (PID: $_pid)');
      _isAttached = true;
      return true;
      
    } catch (e) {
      Logger.error('Failed to attach', e);
      return false;
    }
  }
  
  Future<int> readPointer(int address) async {
    if (!_isAttached) return 0;
    
    try {
      final result = await Process.run('su', [
        '-c',
        'dd if=/proc/$_pid/mem bs=1 skip=$address count=8 2>/dev/null | xxd -p'
      ]);
      
      if (result.exitCode == 0 && result.stdout.toString().isNotEmpty) {
        final hex = result.stdout.toString().trim();
        if (hex.length >= 16) {
          return int.parse(hex.substring(0, 16), radix: 16);
        }
      }
      return 0;
      
    } catch (e) {
      return 0;
    }
  }
  
  Future<int> readInt(int address) async {
    if (!_isAttached) return 0;
    
    try {
      final result = await Process.run('su', [
        '-c',
        'dd if=/proc/$_pid/mem bs=1 skip=$address count=4 2>/dev/null | xxd -p'
      ]);
      
      if (result.exitCode == 0 && result.stdout.toString().isNotEmpty) {
        final hex = result.stdout.toString().trim();
        if (hex.length >= 8) {
          return int.parse(hex.substring(0, 8), radix: 16);
        }
      }
      return 0;
      
    } catch (e) {
      return 0;
    }
  }
  
  Future<double> readFloat(int address) async {
    final intValue = await readInt(address);
    if (intValue == 0) return 0.0;
    
    // Convert int to float
    final byteData = ByteData(4);
    byteData.setInt32(0, intValue);
    return byteData.getFloat32(0);
  }
  
  Future<String> readString(int address, int maxLength) async {
    if (!_isAttached) return '';
    
    try {
      final result = await Process.run('su', [
        '-c',
        'dd if=/proc/$_pid/mem bs=1 skip=$address count=$maxLength 2>/dev/null'
      ]);
      
      if (result.exitCode == 0) {
        String str = result.stdout.toString();
        // Find null terminator
        final nullIndex = str.indexOf('\0');
        if (nullIndex != -1) {
          str = str.substring(0, nullIndex);
        }
        return str.trim();
      }
      return '';
      
    } catch (e) {
      return '';
    }
  }
  
  Future<Vector3> readVector3(int address) async {
    final x = await readFloat(address);
    final y = await readFloat(address + 4);
    final z = await readFloat(address + 8);
    return Vector3(x, y, z);
  }
  
  void detach() {
    _isAttached = false;
    Logger.info('Detached from BGMI');
  }
  
  bool get isAttached => _isAttached;
  int get pid => _pid;
}

import '../models/vector3.dart';