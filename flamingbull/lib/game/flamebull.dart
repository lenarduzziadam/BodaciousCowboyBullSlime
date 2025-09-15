

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flamingbull/constants.dart';
import 'package:flamingbull/game/bull_world.dart';
import 'package:flutter/material.dart';

class FlameBull extends FlameGame {
  FlameBull() 
    : super(
      world: BullWorld(),
      camera: CameraComponent.withFixedResolution(
        width: gameWidth, 
        height: gameHeight
        ),
      );
  
  @override
  Color backgroundColor(){
    return Colors.blueAccent;
  }

}