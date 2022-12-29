import 'package:flutter/material.dart';
import 'package:flutter_vs_native/presentation/auth/home.dart';
import 'package:flutter_vs_native/presentation/auth/login.dart';
import 'package:flutter_vs_native/presentation/game/create_game.dart';
import 'package:flutter_vs_native/presentation/game/edit_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginPage(),
        'home': (_) => const HomePage(),
        'create-game': (_) => const CreateGamePage(),
        'edit-game': (_) => const EditGamePage(),
      },
    );
  }
}
