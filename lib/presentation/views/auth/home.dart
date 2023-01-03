import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vs_native/domain/models/game.dart';
import 'package:flutter_vs_native/presentation/cubit/game/game_cubit.dart';
import 'package:flutter_vs_native/presentation/views/widgets/drawer.dart';

import 'package:flutter_vs_native/presentation/views/widgets/game_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PlatformGame platformGame = PlatformGame.xbox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text('My Games'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'create-game');
              },
              icon: const Icon(Icons.add)),
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      endDrawer: MyDrawer(
        onChanged: (value) {
          platformGame = value;
          setState(() {});
        },
      ),
      body: GameList(platformGame: platformGame),
    );
  }
}

class GameList extends StatefulWidget {
  final PlatformGame platformGame;

  const GameList({
    Key? key,
    required this.platformGame,
  }) : super(key: key);

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  @override
  void didUpdateWidget(covariant GameList oldWidget) {
    print('didUpdateWidget');
    if (widget.platformGame != oldWidget.platformGame) {
      getGames();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    getGames();
    super.initState();
  }

  // @override
  // void deactivate() {
  //   context.read<GameCubit>().close();
  //   super.deactivate();
  // }

  void getGames() {
    context.read<GameCubit>().init(widget.platformGame);
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<GameCubit, GameState>(
            buildWhen: ((previous, current) => current is GameLoaded),
            builder: (context, state) {
              if (state is GameLoaded) {
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: ((context, index) =>
                        const SizedBox(height: 10)),
                    itemCount: state.games.length,
                    itemBuilder: ((context, index) => GameCardWidget(
                          game: state.games[index],
                          platform: widget.platformGame.name,
                        )),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
