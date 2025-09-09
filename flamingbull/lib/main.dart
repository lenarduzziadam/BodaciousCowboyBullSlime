import 'package:flame/game.dart';
import 'package:flamingbull/flamebull.dart';
import 'package:flutter/material.dart';

void main() {
  final game = FlameBull();
  runApp(GameWidget(game: game));
}

