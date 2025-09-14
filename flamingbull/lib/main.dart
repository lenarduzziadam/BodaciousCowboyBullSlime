import 'package:flame/flame.dart';
import 'package:flamingbull/game_app.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();
  runApp(const GameApp());
}

