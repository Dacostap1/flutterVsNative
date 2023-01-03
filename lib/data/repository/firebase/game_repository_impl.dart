import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vs_native/domain/models/game.dart';
import 'package:flutter_vs_native/domain/repository/game_repository.dart';

class GameRepositoryImple implements GameRepository {
  final _db = FirebaseFirestore.instance;

  String gameCollection = 'nintendo';

  // final gamesRef =
  //     FirebaseFirestore.instance.collection('games').withConverter<Game>(
  //           fromFirestore: (snapshot, _) => Game.fromJson(snapshot.data()!),
  //           toFirestore: (movie, _) => movie.toJson(),
  //         );

  @override
  Future<void> deleteGame({
    required String gameId,
    required String platform,
  }) async {
    await _db.doc('$platform/$gameId').delete();
  }

  @override
  Stream<List<Game>> getGameStream(String platform) {
    return _db.collection(platform).snapshots().asyncMap(
          (snapshot) => snapshot.docs
              .map((doc) => Game.fromJsonDocument(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<Game>> get gamesStream =>
      _db.collection(gameCollection).snapshots().asyncMap(
            (snapshot) => snapshot.docs
                .map((doc) => Game.fromJsonDocument(doc.data(), doc.id))
                .toList(),
          );

  @override
  Future<void> create({
    required String title,
    required String desc,
    required String platform,
    required String imageUrl,
  }) {
    return _db
        .collection(platform)
        .add({
          'titulo': title,
          'desc': desc,
          'portada': imageUrl,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Future<void> update({
    required String gameId,
    required String title,
    required String desc,
    required String imageUrl,
    required String platform,
  }) async {
    final doc = _db.collection(platform).doc(gameId);

    await doc.update({
      'titulo': title,
      'desc': desc,
      'portada': imageUrl,
    });
  }
}
