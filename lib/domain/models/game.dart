class Game {
  final String id;
  final String title;
  final String desc;
  final String imageUrl;

  Game({
    required this.id,
    required this.title,
    required this.desc,
    required this.imageUrl,
  });

  factory Game.fromJsonDocument(Map<String, dynamic> json, id) => Game(
        id: id,
        title: json['titulo'],
        desc: json['desc'],
        imageUrl: json['portada'],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "titulo": title,
        "desc": desc,
        "portada": imageUrl,
      };

  Game copyWith({
    String? title,
    String? desc,
  }) =>
      Game(
        id: id,
        title: title ?? this.title,
        desc: desc ?? this.title,
        imageUrl: imageUrl,
      );
}

enum PlatformGame {
  playstation('PlayStation'),
  xbox('Xbox'),
  nintendo('Nintendo');

  const PlatformGame(this.message);
  final String message;
}

class EditParameters {
  final Game game;
  final String platform;

  EditParameters(this.game, this.platform);
}
