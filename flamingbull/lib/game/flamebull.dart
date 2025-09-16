

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flamingbull/constants.dart';
import 'package:flamingbull/game/bull_world.dart';
import 'package:flutter/material.dart';

class FlameBull extends FlameGame<BullWorld> with HorizontalDragDetector{
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

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    super.onHorizontalDragUpdate(info);
    world.player.move(info.delta.global.x);
  }

}