/// BubbleLauncher
///
/// This component represents a bubble launcher, similar to the arrow launcher in Bust-a-Move.
/// It is positioned near the bottom center of the screen, independently from the chicken.
/// The launcher consists of an arrow and a bubble at its tip.
/// The player can rotate the launcher using keyboard (left/right arrows) or mouse drag.
/// When the player launches (space bar or mouse click), the bubble is fired in the direction the arrow is pointing.
/// After launch, the launcher disappears and control switches to the chicken.

import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flamingbull/constants.dart';

/// BubbleLauncher draws an arrow and a bubble, and handles aiming/launching logic.
/// - angle: direction the arrow points (radians)
/// - launched: true after bubble is fired
/// - arrowLength/arrowWidth: visual dimensions
/// - bubbleRadius: size of bubble

class BubbleLauncher extends PositionComponent {
  double angle = -pi / 2; // Default: straight up
  bool launched = false;
  double arrowLength = bubbleLauncherArrowLength;
  double arrowWidth = bubbleLauncherArrowWidth;
  double bubbleRadius = bubbleLauncherBubbleRadius;

  BubbleLauncher({Vector2? position}) {
    this.position = position ?? Vector2.zero();
    this.size = Vector2(arrowWidth, arrowLength + bubbleRadius * 2);
    anchor = Anchor.center;
  }

  /// Rotate the launcher by [delta] radians. Clamped to upward directions.
  void rotate(double delta) {
    angle += delta;
    // Clamp angle between -pi and 0 (upwards)
    angle = angle.clamp(-pi, 0.0);
  }

  /// Launch the bubble. Sets launched=true. Actual bubble creation handled by game world.
  void launch() {
    launched = true;
    // Bubble launching logic will be handled by the game world
  }

  /// Render the arrow and bubble at the tip, rotated by [angle].
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final Paint arrowPaint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;
    final Paint bubblePaint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;
    // Draw arrow
    final arrowStart = Offset(size.x / 2, size.y - bubbleRadius * 2);
    final arrowEnd = Offset(size.x / 2 + arrowLength * cos(angle), size.y - bubbleRadius * 2 + arrowLength * sin(angle));
    canvas.drawLine(arrowStart, arrowEnd, arrowPaint..strokeWidth = arrowWidth);
    // Draw bubble at tip
    final bubbleCenter = Offset(
      size.x / 2 + (arrowLength + bubbleRadius) * cos(angle),
      size.y - bubbleRadius * 2 + (arrowLength + bubbleRadius) * sin(angle),
    );
    canvas.drawCircle(bubbleCenter, bubbleRadius, bubblePaint);
  }
}
