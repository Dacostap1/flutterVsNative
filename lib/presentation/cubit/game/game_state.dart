part of 'game_cubit.dart';

@immutable
abstract class GameState {}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final List<Game> games;

  GameLoaded(this.games);
}

class GameLoadFailed extends GameState {
  final String message;

  GameLoadFailed(this.message);
}

class GamePickImage extends GameState {
  final File file;

  GamePickImage({required this.file});
}

class GameCreateLoading extends GameState {}

class GameCreatedSuccess extends GameState {}

class GameCreateFailed extends GameState {
  final String message;

  GameCreateFailed(this.message);
}

class GameUpdateLoading extends GameState {}

class GameUpdateSuccess extends GameState {}

class GameUpdateFailed extends GameState {
  final String message;

  GameUpdateFailed(this.message);
}
