
import 'package:flame/components.dart';
import 'package:flamingbull/character_animator.dart';

enum Phase { idle, dancing } //represents the two phases of chicken idle behavior/logic

class PlayerIdle {
  double movementTimer = 0.0; //defines how long the player continues moving after input
  double idleTimer = 0.0; //defines how long the player remains idle
  String currentState = 'idleFront'; //tracks the current animation state
  String lastDirection = 'right'; 

  // Line: after String lastDirection = 'right';
  final List<String> danceSequence = [
    'standLeft',
    'idleFront',
    'standRight',
    'moveRight',
    'standForward',
    'moveLeft',
  ];
  int danceIndex = 0;
  double danceTimer = 0.0;
  bool isDancing = false;

  SpriteAnimation? animation; // Current animation
  late CharacterAnimator animator; // Creates instance of animator (late tag) so it can be initialized in onLoad
  Vector2 position = Vector2.zero(); // Initial position
  Vector2 size = Vector2(64, 64); // Example size, adjust as needed
  double gameWidth = 800.0; // Example width, adjust as needed
  double idleThreshold = 1.0; // Example threshold, adjust as needed
  double movementThreshold = 0.2; // Example threshold, adjust as needed

  void update(double dt) {
    // Update movement timer
    if (movementTimer > 0) {
      movementTimer -= dt; // Decrease timer by delta time

      // Clamp movement timer to zero
      if (movementTimer < 0) movementTimer = 0;

      // If still moving, reset idle timer and return
      if (lastDirection == 'right' && currentState != 'moveRight') {
        animation = animator.moveRight();
        currentState = 'moveRight';
      } else if (lastDirection == 'left' && currentState != 'moveLeft') {
        animation = animator.moveLeft();
        currentState = 'moveLeft';
      }
      // Reset timers
      idleTimer = 0.0; 
      return;
    }

    // If not moving, increment idle timer
    if (currentState == 'standLeft' || currentState == 'standRight') {
      idleTimer += dt;

      if (idleTimer >= idleThreshold && !isDancing) {
        // Start dancing
        isDancing = true;
        danceIndex = 0;
        danceTimer = 0.0;
      }
    } 
    if (isDancing) {
      danceTimer += dt;

      double danceFrameDuration = 0.4 + (0.6 * (animator.hashCode % 100) / 100); // Duration for each dance move

      if (danceTimer >= danceFrameDuration) { // Change dance move every danceFrameDuration seconds
        danceTimer = 0.0;
        currentState = danceSequence[danceIndex];
        switch (currentState) {
          case 'standLeft':
            animation = animator.standLeft();
            break;
          case 'standRight':
            animation = animator.standRight();
            break;
          case 'moveRight':
            animation = animator.moveRight();
            break;
          case 'moveLeft':
            animation = animator.moveLeft();
            break;
          case 'idleFront':
            animation = animator.idleFront();
            break;
          default:
            animation = animator.idleFront();
        }
        danceIndex++;
        if (danceIndex >= danceSequence.length) {
          // End dancing after one full sequence
          isDancing = false;
          danceIndex = 0;
          idleTimer = 0.0; // Reset idle timer after dancing
          currentState = 'idleFront';
          animation = animator.idleFront();
        }
      }
      return; // Skip the rest of the update while dancing
    
    
    
    }else if (currentState == 'moveRight' && lastDirection == 'right' && currentState != 'standRight') {
      animation = animator.standRight(); //switch to standRight animation
      currentState = 'standRight';
      idleTimer = 0.0;

    } else if (currentState == 'moveLeft' && lastDirection == 'left' && currentState != 'standLeft') {
      animation = animator.standLeft(); //switch to standLeft animation
      currentState = 'standLeft';
      idleTimer = 0.0;

    } else {
      animation = animator.idleFront(); //switch to idleFront animation
      idleTimer = 0.0;
    }
  }

  void move(double deltaX) {
    double newX = position.x + deltaX;
    
    if (newX < -(gameWidth / 2) + (size.x / 2)) {
      newX = -(gameWidth / 2) + (size.x / 2); // Left boundary
    }
    else if (newX > (gameWidth / 2) - (size.x / 2)) {
      newX = (gameWidth / 2) - (size.x / 2); // Right boundary
    }
    
    // Switch animation based on direction
    if (deltaX > 0) {

      if (currentState != 'moveRight') {
        animation = animator.moveRight(); //switch to moveRight animation
        currentState = 'moveRight';

        lastDirection = 'right';

        isDancing = false; // Stop dancing if moving
        danceIndex = 0;
        danceTimer = 0.0;

      }
      // Reset timers
      idleTimer = 0.0; // Reset idle timer
      movementTimer = movementThreshold; // Reset movement timer
    } 
    else if (deltaX < 0) {
        if (currentState != 'moveLeft') { //only switch if not already moving left
          animation = animator.moveLeft(); //switch to moveLeft animation
          currentState = 'moveLeft';
          lastDirection = 'left';

          isDancing = false; // Stop dancing if moving
          danceIndex = 0;
          danceTimer = 0.0;
        }
        idleTimer = 0.0;
        movementTimer = movementThreshold;
    }
    // If deltaX == 0, don't change animation here; let update handle idle/standing/movement timer

    position.x = newX; // Update position
  }
}