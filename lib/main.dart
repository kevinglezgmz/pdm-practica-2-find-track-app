import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/auth_bloc/auth_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/auth_bloc/auth_repository.dart';
import 'package:practica_2_kevin_gonzalez/blocs/favorite_tracks_bloc/favorite_tracks_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/favorite_tracks_bloc/favorite_tracks_repository.dart';
import 'package:practica_2_kevin_gonzalez/blocs/recorder_bloc/audd_repository.dart';
import 'package:practica_2_kevin_gonzalez/blocs/recorder_bloc/recorder_bloc.dart';
import 'package:practica_2_kevin_gonzalez/pages/home_page/home_page.dart';
import 'package:practica_2_kevin_gonzalez/pages/login_page/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AudDRepository(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => FavoriteTracksRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RecorderBloc(
              audDRepository: RepositoryProvider.of<AudDRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            )..add(AuthCheckLoginStatusEvent()),
          ),
          BlocProvider(
            create: (context) => FavoriteTracksBloc(
              tracksRepository:
                  RepositoryProvider.of<FavoriteTracksRepository>(context),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthNotLoggedInState) {
            BlocProvider.of<FavoriteTracksBloc>(context)
                .add(FavoriteTracksResetTracksEvent());
          } else if (state is AuthLoggedInState) {
            BlocProvider.of<FavoriteTracksBloc>(context)
                .add(FavoriteTracksLoadTracksEvent());
          }
        },
        builder: (context, state) {
          if (state is AuthNotLoggedInState) {
            return LoginPage();
          } else if (state is AuthLoggedInState) {
            return const HomePage();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
