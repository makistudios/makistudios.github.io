import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class DecorationObject extends SpriteComponent {
  DecorationObject(Vector2 position, Vector2 size, Sprite sprite, int priority)
      : super(
            position: position,
            size: size,
            sprite: sprite,
            anchor: Anchor.center,
            paint: Paint()..color = const Color.fromRGBO(1, 1, 1, 1),
            priority: priority);
}
