import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flamingbull/constants.dart';
import 'player.dart';

class BubbleProjectile extends CircleComponent {
  Vector2 velocity;
  final double speed;
  final Player chicken; // Reference to the chicken (paddle)

  BubbleProjectile({
    required Vector2 position,
    required double angle,
    required this.chicken,
    this.speed = 400.0,
    double radius = bubbleLauncherBubbleRadius,
  })  : velocity = Vector2(cos(angle), sin(angle)),
        super(
          position: position,
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.lightBlueAccent,
        );

  @override
  void update(double dt) {
    super.update(dt);

    // Move the bubble
    position += velocity * speed * dt;

    // Bounce off left/right walls
    if ((position.x - radius < 0 && velocity.x < 0) ||
        (position.x + radius > gameWidth && velocity.x > 0)) {
      velocity.x = -velocity.x;
    }

    // Bounce off top
    if (position.y - radius < 0 && velocity.y < 0) {
      velocity.y = -velocity.y;
    }

    // Bounce off chicken (paddle) if coming from above
    final chickenRect = Rect.fromLTWH(
      chicken.position.x - chicken.size.x / 2,
      chicken.position.y - chicken.size.y / 2,
      chicken.size.x,
      chicken.size.y,
    );
    final bubbleRect = Rect.fromCircle(
      center: Offset(position.x, position.y),
      radius: radius,
    );
    if (bubbleRect.overlaps(chickenRect) && velocity.y > 0) {
      velocity.y = -velocity.y;

      // Optional: tweak x-velocity based on where it hit the paddle
      final hitPos = (position.x - chicken.position.x) / (chicken.size.x / 2);
      velocity.x += hitPos * 0.5;
      velocity.normalize();
    }

    // Remove if falls through bottom
    if (position.y - radius > gameHeight) {
      removeFromParent();
      // You can trigger launcher reset here if needed
    }
  }
}