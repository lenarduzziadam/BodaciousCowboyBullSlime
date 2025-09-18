import 'dart:async';
import 'package:flame/components.dart';
import 'package:flamingbull/constants.dart';
import 'character_animator.dart';
import 'bubble_projectile.dart';

class Player extends SpriteAnimationComponent {
  BubbleProjectile? bubble;
  late CharacterAnimator animator;
  String currentState = 'idleFront';
  double idleTimer = 0.0;
  double movementTimer = 0.0;
  final double idleThreshold = 5.0; // seconds
  final double movementThreshold = 0.02; // seconds
  String lastDirection = 'right'; // Track last direction for idle

  // Dance idle animation state
  int idleDanceIndex = 0;
  List<String> idleDanceStates = ['idleFront', 'standRight', 'standLeft'];
  double idleDanceTimer = 0.0;
  double idleDanceDuration = 0.0;

  @override
  FutureOr<void> onLoad() async {
  animator = await CharacterAnimator.load('chicken.png');
  animation = animator.idleFront();
  size = Vector2(200, 200);
  position = Vector2(0, (gameHeight / 2) - (size.y / 2));
    anchor = Anchor.center;

    // Create persistent bubble above chicken's head
    bubble = BubbleProjectile(
      position: Vector2(0, -size.y / 2 - 24), // Centered, above head
      radius: 24,
    );
    add(bubble!);

  }

  @override
  void update(double dt) {
    super.update(dt);
    double newY = position.y + (dt * 200);
    if (newY > (gameHeight / 2) - (size.y / 2)) {
      newY = (gameHeight / 2) - (size.y / 2);
    }
    position.y = newY;

    // Keep bubble above chicken until launched
    if (bubble != null && !bubble!.released) {
      bubble!.position = Vector2(0, -size.y / 2 - 24);
    }

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
      idleDanceTimer = 0.0;
      idleDanceIndex = 0;
      return;
    }

    // If not moving, increment idle timer
    if (currentState == 'moveLeft' || currentState == 'moveRight' || currentState == 'standLeft' || currentState == 'standRight' || currentState == 'idleFront') {
      idleTimer += dt;
      // Switch to standing frame after movement timer expires
      if (currentState == 'moveRight' && lastDirection == 'right' && currentState != 'standRight') {
        animation = animator.standRight();
        currentState = 'standRight';
      } else if (currentState == 'moveLeft' && lastDirection == 'left' && currentState != 'standLeft') {
        animation = animator.standLeft();
        currentState = 'standLeft';
      }

      // Start dance idle animation after idleThreshold
      if (idleTimer >= idleThreshold) {
        idleDanceTimer += dt;
        if (idleDanceDuration == 0.0) {
          // Pick a random duration for this dance frame (0.4-1.0s)
          idleDanceDuration = 0.4 + (0.6 * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000.0);
        }
        if (idleDanceTimer >= idleDanceDuration) {
          // Cycle to next dance state
          idleDanceIndex = (idleDanceIndex + 1) % idleDanceStates.length;
          idleDanceTimer = 0.0;
          idleDanceDuration = 0.0;
          // Set animation based on dance state
          switch (idleDanceStates[idleDanceIndex]) {
            case 'idleFront':
              animation = animator.idleFront();
              currentState = 'idleFront';
              break;
            case 'standRight':
              animation = animator.standRight();
              currentState = 'standRight';
              break;
            case 'standLeft':
              animation = animator.standLeft();
              currentState = 'standLeft';
              break;
          }
        }
      } else {
        // If not yet dancing, reset dance state
        idleDanceTimer = 0.0;
        idleDanceIndex = 0;
        idleDanceDuration = 0.0;
        if (idleTimer >= idleThreshold && currentState != 'idleFront') {
          animation = animator.idleFront();
          currentState = 'idleFront';
        }
      }
    } else {
      idleTimer = 0.0;
      idleDanceTimer = 0.0;
      idleDanceIndex = 0;
      idleDanceDuration = 0.0;
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