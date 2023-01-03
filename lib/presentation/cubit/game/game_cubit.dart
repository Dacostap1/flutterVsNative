import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vs_native/domain/models/game.dart';
import 'package:flutter_vs_native/domain/repository/game_repository.dart';
import 'package:flutter_vs_native/domain/repository/storage_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final GameRepository _gameRepository;
  final StorageRepository _storageRepository;

  late StreamSubscription _streamSubscription;

  GameCubit(this._gameRepository, this._storageRepository)
      : super(GameInitial());

  void init(PlatformGame platform) async {
    print('initGames');
    emit(GameLoading());

    await Future.delayed(const Duration(seconds: 1));

    _streamSubscription =
        _gameRepository.getGameStream(platform.name).listen((games) {
      // print(games);
      return emit(GameLoaded(games));
    }, onError: (error) {
      print(error.toString());
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  void pickImage(ImageSource source) {
    ImagePicker()
        .pickImage(source: source)
        .then((xfile) => emit(GamePickImage(file: File(xfile!.path))));
  }

  void create({
    required String title,
    required String desc,
    required PlatformGame platform,
    required File image,
  }) async {
    emit(GameCreateLoading());

    final res =
        await _storageRepository.uploadImage(image: image, imageName: title);

    //TODO: SI SUBEN 2 CON EL MISMO NOMBRE SOLO GRABA 1

    await _gameRepository
        .create(
            title: title,
            desc: desc,
            platform: platform.name,
            imageUrl: res['image_url'])
        .then((value) => emit(GameCreatedSuccess()))
        .catchError((e) {
      print(e);
      emit(GameCreateFailed(e.message));
    });
  }

  void update({
    required Game game,
    required File? image,
    required String platform,
  }) async {
    emit(GameUpdateLoading());

    if (image != null) {
      await _storageRepository.deleteImage(game.imageUrl);
      final res = await _storageRepository.uploadImage(
          image: image, imageName: platform);

      await _gameRepository
          .update(
              gameId: game.id,
              title: game.title,
              desc: game.desc,
              platform: platform,
              imageUrl: res['image_url'])
          .then((value) => emit(GameUpdateSuccess()))
          .catchError((e) {
        print(e);
        emit(GameUpdateFailed(e.message));
      });
    } else {
      await _gameRepository
          .update(
            gameId: game.id,
            title: game.title,
            desc: game.desc,
            platform: platform,
            imageUrl: game.imageUrl,
          )
          .then((value) => emit(GameUpdateSuccess()))
          .catchError((e) {
        print(e);
        emit(GameUpdateFailed(e.message));
      });
    }
  }

  void delete({
    required Game game,
    required String platform,
  }) async {
    await _storageRepository.deleteImage(game.imageUrl).catchError((e) {
      print(e);
    });
    print('before-delete-game');
    await _gameRepository
        .deleteGame(
          gameId: game.id,
          platform: platform,
        )
        .then((value) => null)
        .catchError((e) {
      print(e);
    });
  }
}
