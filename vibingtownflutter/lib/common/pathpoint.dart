import 'package:flame/components.dart';

class PathPoint extends SpriteComponent {
  final List<int> connections;

  PathPoint(Vector2 pos, Sprite sprite, this.connections)
      : super(
            sprite: sprite,
            size: Vector2(10, 10),
            position: pos,
            anchor: Anchor.center);
}
