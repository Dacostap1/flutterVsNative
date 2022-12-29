import 'package:flutter/material.dart';
import 'package:flutter_vs_native/domain/models/game.dart';
import 'package:flutter_vs_native/presentation/widgets/game_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      endDrawer: const MyDrawer(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          separatorBuilder: ((context, index) => const SizedBox(height: 10)),
          itemCount: gameList.length,
          itemBuilder: ((context, index) => GameCardWidget(
                title: gameList[index].name,
                desc: gameList[index].desc,
              )),
        ),
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final items = ['PlayStation', 'Xbox', 'Nintendo'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          ...items.map(
            (item) => ListTile(
              onTap: () {
                print(item);
              },
              title: Text(
                item,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              'login',
              (route) => false,
            ),
            title: Text(
              'Salir',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
