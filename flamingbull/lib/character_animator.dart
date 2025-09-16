import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';

class CharacterAnimator {
  // Standing right (second column of row 1)
  SpriteAnimation standRight() => SpriteAnimation.spriteList([
    spriteSheet.getSprite(0, 1)
  ], stepTime: 0.2);

  // Standing left (second column of row 2)
  SpriteAnimation standLeft() => SpriteAnimation.spriteList([
    spriteSheet.getSprite(2, 1)
  ], stepTime: 0.2);
  final SpriteSheet spriteSheet;

  CharacterAnimator(this.spriteSheet);

  // Removed idleBack animation (no upward-facing row)

  // Move right animation (row 0)
  SpriteAnimation moveRight() => spriteSheet.createAnimation(row: 0, stepTime: 0.12, from: 0, to: 2);

  // Idle animation (facing camera, row 1)
  SpriteAnimation idleFront() => spriteSheet.createAnimation(row: 1, stepTime: 0.15, from: 0, to: 2);

  // Move left animation (row 2)
  SpriteAnimation moveLeft() => spriteSheet.createAnimation(row: 2, stepTime: 0.12, from: 0, to: 2);

  // Add more as needed

  static Future<CharacterAnimator> load(String imagePath) async {
    final image = await Flame.images.load(imagePath);
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(32, 32),
    );
    return CharacterAnimator(spriteSheet);
  }
}
