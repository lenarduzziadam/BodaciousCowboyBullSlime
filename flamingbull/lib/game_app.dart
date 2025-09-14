import 'package:flame/game.dart';
import 'package:flamingbull/constants.dart';
import 'package:flamingbull/flamebull.dart';
import 'package:flutter/material.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {

  late final FlameBull game;

  @override
  void initState() {
    super.initState();
    game = FlameBull();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flame Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: FittedBox(
              child: SizedBox(
                width: gameWidth,
                height: gameHeight,
                child: GameWidget(game: game),
              ),
            ),
          ),
        ),
      ),
    );
  }
}