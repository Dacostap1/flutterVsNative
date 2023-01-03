import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vs_native/domain/models/game.dart';
import 'package:flutter_vs_native/presentation/cubit/auth/auth_cubit.dart';

class MyDrawer extends StatefulWidget {
  final ValueChanged<PlatformGame> onChanged;

  const MyDrawer({super.key, required this.onChanged});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final items = [
    PlatformGame.playstation,
    PlatformGame.xbox,
    PlatformGame.nintendo,
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          // const DrawerHeader(
          //   decoration: BoxDecoration(),
          //   duration: Duration(seconds: 2),
          //   child: Text(
          //     'Menu',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 30,
          //     ),
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          const Divider(color: Colors.white),
          ...items.map(
            (item) => ListTile(
              onTap: () {
                widget.onChanged(item);
                Navigator.pop(context);
              },
              title: Text(
                item.name,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: context.read<AuthCubit>().logout,
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
