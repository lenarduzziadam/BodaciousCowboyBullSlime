import 'dart:async';

import 'package:flame/components.dart';
import 'package:flamingbull/constants.dart';

class Player extends SpriteComponent {

@override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('chicken.png');
    size = Vector2.all(100);
    position = Vector2(0, -(gameHeight / 2) + (size.y / 2));
    anchor = Anchor.center;
  }
}