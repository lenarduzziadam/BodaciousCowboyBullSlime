
import 'package:flame/components.dart';
import 'package:flamingbull/character_animator.dart';
import 'package:flamingbull/constants.dart';

enum Phase { idle, dancing }

class PlayerIdle {
  double movementTimer = 0.0;
  double idleTimer = 0.0;
  String currentState = 'idleFront';
  String lastDirection = 'right';
  SpriteAnimation? animation;
  late CharacterAnimator animator;
  Vector2 position = Vector2.zero();
  Vector2 size = Vector2(64, 64); // Example size, adjust as needed
  double gameWidth = 800.0; // Example width, adjust as needed
  double idleThreshold = 1.0; // Example threshold, adjust as needed
  double movementThreshold = 0.2; // Example threshold, adjust as needed

  void update(double dt) {
    // Update movement timer
    if (movementTimer > 0) {
      movementTimer -= dt;
      if (movementTimer < 0) movementTimer = 0;
      // If still moving, reset idle timer and return
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
    // If deltaX == 0, don't change animation here; let update handle idle/

    position.x = newX;
  }
}