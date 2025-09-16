import 'dart:async';
import 'package:flame/components.dart';
import 'package:flamingbull/constants.dart';
import 'character_animator.dart';

class Player extends SpriteAnimationComponent {
  late CharacterAnimator animator;
  String currentState = 'idleBack';
  double idleTimer = 0.0;
  final double idleThreshold = 7.0; // seconds
  String lastDirection = 'right'; // Track last direction for idle

  @override
  FutureOr<void> onLoad() async {
    animator = await CharacterAnimator.load('chicken.png');
    animation = animator.idleBack();
    size = Vector2(232, 232);
    position = Vector2(0, -(gameHeight / 2) + (size.y / 2));
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    double newY = position.y + (dt * 200);
    if (newY > (gameHeight / 2) - (size.y / 2)) {
      newY = (gameHeight / 2) - (size.y / 2);
    }
    position.y = newY;

    // If not moving left or right, increment idle timer
    if (currentState == 'moveLeft' || currentState == 'moveRight') {
      idleTimer += dt;
      if (idleTimer < idleThreshold) {
        // Show standing frame for direction
        if (currentState == 'moveRight' && animation != animator.standRight()) {
          animation = animator.standRight();
        } else if (currentState == 'moveLeft' && animation != animator.standLeft()) {
          animation = animator.standLeft();
        }
      } else if (idleTimer >= idleThreshold && currentState != 'idleFront') {
        animation = animator.idleFront();
        currentState = 'idleFront';
      }
    } else if (currentState == 'idleBack') {
      idleTimer += dt;
      if (idleTimer >= idleThreshold && currentState != 'idleFront') {
        animation = animator.idleFront();
        currentState = 'idleFront';
      }
    } else {
      idleTimer = 0.0;
    }
  }

  void move(double deltaX) {
    double newX = position.x + deltaX;
    if (newX < -(gameWidth / 2) + (size.x / 2)) {
      newX = -(gameWidth / 2) + (size.x / 2);
    } else if (newX > (gameWidth / 2) - (size.x / 2)) {
      newX = (gameWidth / 2) - (size.x / 2);
    }
    // Switch animation based on direction
    if (deltaX > 0) {
      if (currentState != 'moveRight') {
        animation = animator.moveRight();
        currentState = 'moveRight';
        lastDirection = 'right';
      }
      idleTimer = 0.0;
    } else if (deltaX < 0) {
      if (currentState != 'moveLeft') {
        animation = animator.moveLeft();
        currentState = 'moveLeft';
        lastDirection = 'left';
      }
      idleTimer = 0.0;
    } else {
      // No movement, keep standing frame for direction
      if (lastDirection == 'right' && animation != animator.standRight()) {
        animation = animator.standRight();
        currentState = 'moveRight';
      } else if (lastDirection == 'left' && animation != animator.standLeft()) {
        animation = animator.standLeft();
        currentState = 'moveLeft';
      }
      // Don't reset idleTimer here; let update handle it
    }
    position.x = newX;
  }
}