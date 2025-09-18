import 'package:flutter/services.dart' show LogicalKeyboardKey;
import '../bubble_launcher.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flamingbull/constants.dart';
import 'package:flamingbull/game/bull_world.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey, KeyEvent;


class FlameBull extends FlameGame<BullWorld> with HorizontalDragDetector, KeyboardEvents {
  late BubbleLauncher launcher;
  bool launcherActive = true;
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
  Future<void> onLoad() async {
    await super.onLoad();
    // Position launcher near bottom center, above chicken
    launcher = BubbleLauncher(
      position: Vector2(gameWidth / 2, bubbleLauncherY)
    );
    add(launcher);
  }

  @override
  Color backgroundColor(){
    return Colors.blueAccent;
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (launcherActive) {
      // Launcher controls
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        launcher.rotate(-0.05); // Adjust rotation step as needed
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        launcher.rotate(0.05);
      }
      if (event.logicalKey == LogicalKeyboardKey.space && !launcher.launched) {
        launcher.launch();
        launcherActive = false;
        remove(launcher);
        // TODO: Create and launch bubble in direction launcher.angle
      }
      return KeyEventResult.handled;
    } else {
      // Chicken controls
      _keysPressed = keysPressed;
      return KeyEventResult.handled;
    }
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    if (launcherActive) {
      // Mouse drag rotates launcher
      final dragDelta = info.delta.global.x;
      launcher.rotate(dragDelta * 0.01); // Adjust sensitivity as needed
    } else {
      super.onHorizontalDragUpdate(info);
      world.player.move(info.delta.global.x);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!launcherActive) {
      if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        world.player.move(-moveSpeed * dt);
      }
      if (_keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        world.player.move(moveSpeed * dt);
      }
    }
  }
}