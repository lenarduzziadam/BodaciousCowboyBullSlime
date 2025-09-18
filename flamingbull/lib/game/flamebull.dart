

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flamingbull/constants.dart';
import 'package:flamingbull/game/bull_world.dart';
import 'package:flamingbull/bubble_projectile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey, KeyEvent;
import 'dart:math';

class FlameBull extends FlameGame<BullWorld> with HorizontalDragDetector, KeyboardEvents {
  // Track if bubble is released
  bool bubbleReleased = false;
  void onTapDown(int pointerId, TapDownInfo info) {
    _releaseBubble();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _keysPressed = keysPressed;
    if (event.logicalKey == LogicalKeyboardKey.space) {
      _releaseBubble();
    }
    return KeyEventResult.handled;
  }

  void _releaseBubble() {
    if (bubbleReleased) return;
    final player = world.player;
    if (player.bubble != null && !player.bubble!.released) {
      // Launch upward and slightly diagonal in a random direction
      final random = Random();
      final angle = (-pi / 2) + (random.nextDouble() - 0.5) * (pi / 4); // -90deg ± 22.5deg
      final velocity = Vector2(cos(angle), sin(angle)) * bubbleSpeed;
      player.bubble!.release(velocity);
      bubbleReleased = true;
    }
  }
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