import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flamingbull/constants.dart';
import 'package:flamingbull/player.dart';
import 'package:flutter/material.dart';

class FlameBull extends FlameGame {
  FlameBull() : super(camera: CameraComponent.withFixedResolution(width: gameWidth, height: gameHeight));

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    world.add(Player(
      position: Vector2(-(gameWidth / 4), 0),
      radius: gameWidth / 4,
      color: Colors.red,
    ));

    world.add(Player(
      position: Vector2((gameWidth / 4), 0),
      radius: gameWidth / 4,
      color: Colors.green,
    ));
  }

  @override
  Color backgroundColor(){
    return Colors.blueAccent;
  }

}