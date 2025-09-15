import 'dart:async';

import 'package:flame/components.dart';
import 'package:flamingbull/constants.dart';

class Player extends SpriteComponent {

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('chicken.png');
    size = Vector2.all(600);
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
  }
}