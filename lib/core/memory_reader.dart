import '../models/player_data.dart';

class MemoryReader {
  // Stub: Replace all methods with real memory reading if/when safe/legal
  Future<List<PlayerData>> getPlayers() async {
    // TODO: Implement real memory scan via FFI or platform channel
    // Demo: Return a list of fake/mock player objects for overlay testing
    return [
      PlayerData(
        name: 'BOT#1',
        health: 80,
        team: 2,
        worldPosition: [320, 100, 64],
      ),
      PlayerData(
        name: 'You',
        health: 100,
        team: 1,
        worldPosition: [250, 120, 64],
      ),
    ];
  }
}
