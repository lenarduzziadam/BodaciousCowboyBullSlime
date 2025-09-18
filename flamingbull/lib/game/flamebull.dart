import 'package:flutter/services.dart' show LogicalKeyboardKey;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flamingbull/constants.dart';
import 'package:flamingbull/game/bull_world.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey, KeyEvent;


class FlameBull extends FlameGame<BullWorld> with HorizontalDragDetector, KeyboardEvents {
  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _keysPressed = keysPressed;
    return KeyEventResult.handled;
  }
  // Bubble logic removed; only chicken/game logic remains
  Set<LogicalKeyboardKey> _keysPressed = {};

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

  // Removed duplicate onKeyEvent method to resolve naming conflict.

  @override
  void update(double dt) {
    super.update(dt);
    if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      world.player.move(-moveSpeed * dt);
    }
    if (_keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      world.player.move(moveSpeed * dt);
    }
  }
}