import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vs_native/domain/models/game.dart';
import 'package:flutter_vs_native/presentation/cubit/game/game_cubit.dart';

class GameCardWidget extends StatelessWidget {
  final Game game;
  final String platform;

  const GameCardWidget({
    Key? key,
    required this.game,
    required this.platform,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final editParameters = EditParameters(game, platform);
        Navigator.pushNamed(context, 'edit-game', arguments: editParameters);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: game.imageUrl,
              imageBuilder: (context, imageProvider) => AspectRatio(
                aspectRatio: 16 / 9,
                child: Image(
                  image: imageProvider,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              progressIndicatorBuilder: (context, url, progress) => AspectRatio(
                aspectRatio: 16 / 9,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      value: progress.progress,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 10),
            Text(game.title),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                shape: const StadiumBorder(),
                side: const BorderSide(width: 1, color: Colors.red),
                fixedSize: const Size(120, 40),
              ),
              onPressed: () {
                context
                    .read<GameCubit>()
                    .delete(game: game, platform: platform);
              },
              child: const Text('Eliminar'),
            )
          ],
        ),
      ),
    );
  }
}
