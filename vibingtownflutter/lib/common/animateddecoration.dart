import 'package:flame/components.dart';

class AnimatedDecoration extends SpriteAnimationComponent {
  AnimatedDecoration(SpriteAnimation anim, Vector2 pos)
      : super(
            position: pos, priority: 20, size: anim.frames[0].sprite.srcSize) {
    animation = anim;
  }
}
