import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_vs_native/data/repository/firebase/auth_repository_impl.dart';
import 'package:flutter_vs_native/data/repository/firebase/game_repository_impl.dart';
import 'package:flutter_vs_native/data/repository/firebase/storage_repository_impl.dart';
import 'package:flutter_vs_native/domain/models/game.dart';
import 'package:flutter_vs_native/domain/repository/auth_repository.dart';
import 'package:flutter_vs_native/domain/repository/game_repository.dart';
import 'package:flutter_vs_native/domain/repository/storage_repository.dart';
import 'package:flutter_vs_native/firebase_options.dart';
import 'package:flutter_vs_native/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter_vs_native/presentation/cubit/game/game_cubit.dart';
import 'package:flutter_vs_native/presentation/views/auth/home.dart';
import 'package:flutter_vs_native/presentation/views/auth/login.dart';
import 'package:flutter_vs_native/presentation/views/game/create_game.dart';
import 'package:flutter_vs_native/presentation/views/game/edit_game.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
        ),
        RepositoryProvider<GameRepository>(
          create: ((_) => GameRepositoryImple()),
        ),
        RepositoryProvider<StorageRepository>(
          create: ((_) => StorageRepositoryImplementation()),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: ((context) => AuthCubit(context.read())..init()),
          ),
          BlocProvider(
            create: ((context) => GameCubit(
                  context.read(),
                  context.read(),
                )),
          )
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
              primarySwatch: Colors.purple,
            ),
            initialRoute: 'login',
            routes: {
              'login': (_) => const LoginPage(),
              'home': (_) => const HomePage(),
              'create-game': (_) => const CreateGamePage(),
              'edit-game': (context) {
                final editParameters = ModalRoute.of(context)
                    ?.settings
                    .arguments as EditParameters;

                return EditGamePage(editParameters: editParameters);
              }
            },
          ),
        ),
      ),
    );
  }
}
