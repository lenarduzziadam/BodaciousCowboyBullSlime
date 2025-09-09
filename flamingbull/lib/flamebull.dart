import 'dart:async';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flamingbull/player.dart';
import 'package:flutter/material.dart';

class FlameBull extends FlameGame {
  FlameBull({super.children});

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    world.add(Player(
      position: Vector2(0, 0),
      radius: 50.0,
      color: Colors.red,
    ));
  }

  @override
  Color backgroundColor(){
    return Colors.blueAccent;
  }

}