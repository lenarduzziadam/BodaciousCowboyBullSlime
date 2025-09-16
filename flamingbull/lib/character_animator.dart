import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';

class CharacterAnimator {
  // Standing right (second column of row 1)
  SpriteAnimation standRight() => SpriteAnimation.spriteList([
    spriteSheet.getSprite(1, 1)
  ], stepTime: 0.2);

  // Standing left (second column of row 3)
  SpriteAnimation standLeft() => SpriteAnimation.spriteList([
    spriteSheet.getSprite(3, 1)
  ], stepTime: 0.2);
  final SpriteSheet spriteSheet;

  CharacterAnimator(this.spriteSheet);

  // Idle animation (back to screen)
  SpriteAnimation idleBack() => spriteSheet.createAnimation(row: 0, stepTime: 0.15, from: 0, to: 2);

  // Move right animation
  SpriteAnimation moveRight() => spriteSheet.createAnimation(row: 1, stepTime: 0.12, from: 0, to: 2);

  // Idle animation (facing camera)
  SpriteAnimation idleFront() => spriteSheet.createAnimation(row: 2, stepTime: 0.15, from: 0, to: 2);

  // Move left animation
  SpriteAnimation moveLeft() => spriteSheet.createAnimation(row: 3, stepTime: 0.12, from: 0, to: 2);

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
