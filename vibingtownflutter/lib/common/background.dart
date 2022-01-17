import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:vibingtownflutter/common/levelcontroller.dart';

class Background extends SpriteComponent with HasGameRef {
  Background(Vector2 position)
      : super(
            position: position,
            size: mapSize,
            priority: -10,
            anchor: Anchor.center,
            paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 1));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('VibingTownN.png');

    mapSize = sprite!.srcSize;
  }
}
