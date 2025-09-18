import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flamingbull/constants.dart';

class BubbleProjectile extends PositionComponent {
  Vector2 velocity = Vector2.zero();
  bool released = false;
  // No gravity for pong/brick breaker style
  double bounceFactor = 0.8;
  double speed = bubbleSpeed;

  BubbleProjectile({Vector2? position, double radius = 24}) {
    this.position = position ?? Vector2.zero();
    this.size = Vector2(radius * 2, radius * 2);
  }

  void release(Vector2 initialVelocity) {
    velocity = initialVelocity;
    released = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!released) return;

  // Move according to velocity only
  position += velocity * dt;

    // Bounce off left/right/top borders
    if (position.x < 0) {
      position.x = 0;
      velocity.x = -velocity.x * bounceFactor;
    } else if (position.x + size.x > gameWidth) {
      position.x = gameWidth - size.x;
      velocity.x = -velocity.x * bounceFactor;
    }
    if (position.y < 0) {
      position.y = 0;
      velocity.y = -velocity.y * bounceFactor;
    }

    // Falls through bottom
    if (position.y > gameHeight) {
      removeFromParent();
    }

    // Paddle collision (chicken body)
    // TODO: Replace with actual player position if needed
    // If bubble is moving down and overlaps paddle
    // (This is a placeholder, real collision should use player position)
    // if (velocity.y > 0 && position.y + size.y > paddleY && position.y < paddleY + 40 && position.x + size.x > paddleX && position.x < paddleX + 200) {
    //   position.y = paddleY - size.y;
    //   velocity.y = -velocity.y * bounceFactor;
    // }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
    // Optional: add a white highlight for bubble effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.x * 0.7, size.y * 0.4), size.x * 0.2, highlightPaint);
  }
}
