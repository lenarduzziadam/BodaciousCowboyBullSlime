// import 'bubble_projectile.dart';
import 'dart:async';
import 'package:flame/components.dart';
import 'package:flamingbull/constants.dart';
import 'character_animator.dart';

class Player extends SpriteAnimationComponent {
  // BubbleProjectile removed
  late CharacterAnimator animator;
  String currentState = 'idleFront';
  double idleTimer = 0.0;
  double movementTimer = 0.0;
  final double idleThreshold = 5.0; // seconds
  final double movementThreshold = 0.02; // seconds
  String lastDirection = 'right'; // Track last direction for idle

  @override
  FutureOr<void> onLoad() async {
  animator = await CharacterAnimator.load('chicken.png');
  animation = animator.idleFront();
  size = Vector2(200, 200);
  position = Vector2(0, (gameHeight / 2) - (size.y / 2));
    anchor = Anchor.center;

    // Bubble logic removed

  }

  @override
  void update(double dt) {
    super.update(dt);
    double newY = position.y + (dt * 200);
    if (newY > (gameHeight / 2) - (size.y / 2)) {
      newY = (gameHeight / 2) - (size.y / 2);
    }
    position.y = newY;

    // Bubble logic removed

    // Movement timer logic
    if (movementTimer > 0) {
      movementTimer -= dt;
      // Continue movement animation for 1 second after key release
      if (lastDirection == 'right' && currentState != 'moveRight') {
        animation = animator.moveRight();
        currentState = 'moveRight';
      } else if (lastDirection == 'left' && currentState != 'moveLeft') {
        animation = animator.moveLeft();
        currentState = 'moveLeft';
      }
      idleTimer = 0.0;
      return;
    }

    // If not moving, increment idle timer
    if (currentState == 'moveLeft' || currentState == 'moveRight' || currentState == 'standLeft' || currentState == 'standRight') {
      idleTimer += dt;
      // Switch to standing frame after movement timer expires
      if (currentState == 'moveRight' && lastDirection == 'right' && currentState != 'standRight') {
        animation = animator.standRight();
        currentState = 'standRight';
      } else if (currentState == 'moveLeft' && lastDirection == 'left' && currentState != 'standLeft') {
        animation = animator.standLeft();
        currentState = 'standLeft';
      }
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
      movementTimer = movementThreshold;
    } else if (deltaX < 0) {
      if (currentState != 'moveLeft') {
        animation = animator.moveLeft();
        currentState = 'moveLeft';
        lastDirection = 'left';
      }
      idleTimer = 0.0;
      movementTimer = movementThreshold;
    }
    // If deltaX == 0, don't change animation here; let update handle idle/standing/movement timer
    position.x = newX;
  }
}