import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vs_native/data/repository/firebase/auth_repository_impl.dart';
import 'package:flutter_vs_native/domain/repository/auth_repository.dart';
import 'package:flutter_vs_native/firebase_options.dart';
import 'package:flutter_vs_native/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter_vs_native/presentation/views/auth/home.dart';
import 'package:flutter_vs_native/presentation/views/auth/login.dart';
import 'package:flutter_vs_native/presentation/views/game/create_game.dart';
import 'package:flutter_vs_native/presentation/views/game/edit_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: ((_) => AuthRepositoryImpl()),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: ((context) => AuthCubit(context.read())))
        ],
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            print(state.toString());
            if (state is AuthSuccess) {
              _navigatorKey.currentState
                  ?.pushNamedAndRemoveUntil('home', (route) => false);
            }
            if (state is AuthLogout) {
              _navigatorKey.currentState
                  ?.pushNamedAndRemoveUntil('login', (route) => false);
            }
          },
          child: MaterialApp(
            navigatorKey: _navigatorKey,
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
          ),
        ),
      ),
    );
  }
}
