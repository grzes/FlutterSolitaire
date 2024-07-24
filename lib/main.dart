import 'package:blocsolitaire/blocs/autoplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens.dart';
import 'blocs/game.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GameCubit()),
          BlocProvider(create: (_) => AutoPlayCubit()),
          BlocProvider(create: (_) => GameWon()),
        ],
        child: GameScreen()
    ),
        );
  }
}