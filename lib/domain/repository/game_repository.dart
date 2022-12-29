import 'package:flutter_vs_native/domain/models/game.dart';

abstract class GameRepository {
  Stream<List<Game>> get doctorList;

  Future<void> save({
    required String title,
    required String desc,
    required String imageUrl,
  });

  Future<void> update({
    required String gameId,
    required String title,
    required String desc,
    required String imageUrl,
  });

  Future<void> deleteDoctor({
    required String gameId,
  });
}
