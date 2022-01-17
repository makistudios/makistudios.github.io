import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'levelcontroller.dart';
import 'dart:html' as html;


enum ButtonState { unpressed, pressed, hover }

class Building extends SpriteGroupComponent<ButtonState>
    with Tappable, Hoverable {
  final Sprite pressedSprite;
  final Sprite unpressedSprite;
  final Sprite hoverSprite;
  late final SpriteComponent speechBubble;
  late final TextComponent buildingTitle;
  late final TextComponent buildingText;
  String url;
  double alpha = 0;
  double targetAlpha = 0;
  bool isPressed = false;
  double fontSize;

  Building(this.pressedSprite, this.unpressedSprite, this.hoverSprite,
      this.speechBubble, Vector2 position, this.buildingTitle, this.buildingText, this.url, this.fontSize)
      : super(position: position, priority: 5, anchor: Anchor.center) {
    sprites = {
      ButtonState.pressed: pressedSprite,
      ButtonState.unpressed: unpressedSprite,
      ButtonState.hover: hoverSprite,
    };

    current = ButtonState.unpressed;
    size = sprite!.srcSize;

    buildingTitle.textRenderer = TextPaint(style: const TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0),
      fontSize: 16,
      fontFamily: 'Pixel',
    )
    );

    buildingText.textRenderer = TextPaint(style: const TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0),
      fontSize: 8,
      fontFamily: 'Pixel',
    )
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if(alpha != targetAlpha) {
      alpha = lerpDouble(alpha, targetAlpha, 0.2)!;
      speechBubble.paint.color = Color.fromRGBO(255, 255, 255, alpha);

      buildingTitle.textRenderer = TextPaint(style: TextStyle(
        color: Color.fromRGBO(0, 0, 0, alpha),
        fontSize: 16,
        fontFamily: 'Pixel',
      )
      );

      buildingText.textRenderer = TextPaint(style: TextStyle(
        color: Color.fromRGBO(0, 0, 0, alpha),
        fontSize: fontSize,
        fontFamily: 'Pixel',
      )
      );
    }

    if (!sensorActive || isHovered || isPressed) return;
    if ((cameraPos - position + Vector2(0, 20)).length < 60) {
      current = ButtonState.hover;
      targetAlpha = 1;
      size = sprite!.srcSize;
    } else {
      current = ButtonState.unpressed;
      targetAlpha = 0;
      size = sprite!.srcSize;
    }
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    current = ButtonState.hover;
    size = sprite!.srcSize;
    targetAlpha = 1;
    return false;
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    current = ButtonState.unpressed;
    size = sprite!.srcSize;
    targetAlpha = 0;
    return false;
  }

  @override
  bool onTapDown(_) {
    isPressed = true;
    current = ButtonState.pressed;
    size = sprite!.srcSize;
    return false;
  }

  @override
  bool onTapUp(_) {
    isPressed = false;
    current = ButtonState.hover;
    size = sprite!.srcSize;
    if(url.isEmpty) return false;
    html.window.open(url, url);
    return false;
  }

  @override
  bool onTapCancel() {
    isPressed = false;
    current = ButtonState.hover;
    size = sprite!.srcSize;
    return false;
  }
}
