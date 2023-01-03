import 'package:flutter_vs_native/domain/models/game.dart';

abstract class GameRepository {
  Stream<List<Game>> getGameStream(String platform);

  Stream<List<Game>> get gamesStream;

  Future<void> create({
    required String title,
    required String desc,
    required String platform,
    required String imageUrl,
  });

  Future<void> update({
    required String gameId,
    required String title,
    required String desc,
    required String platform,
    required String imageUrl,
  });

  Future<void> deleteGame({
    required String gameId,
    required String platform,
  });
}
