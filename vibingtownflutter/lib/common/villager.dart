import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:vibingtownflutter/common/pathpoint.dart';
import 'package:vibingtownflutter/common/levelcontroller.dart';
import 'package:vibingtownflutter/common/animationcoordinator.dart';

enum VillagerAnimations {
  idle,
  playingArcade,
  dancing,
  fishing,
  floating,
  singing,
  talking,
  playingVolleyball,
  walking
}

double animSpeed = 0.25;

class Villager extends SpriteAnimationGroupComponent {
  late final SpriteSheet spriteSheet;
  late SpriteAnimation anim;

  late PathPoint? from;
  late PathPoint target;

  final bool isActive;
  late bool timerActive;
  double timer = 0;
  bool inPlace = true;

  double timeElapsed = 0;
  double timePerFrame = 1 / 60;

  final List<AnimationInfo>? animationsInfo;
  late AnimationInfo currentAnimationInfo;
  late int animationInfoIndex;
  late int startingAnimIndex;

  Vector2 extraPos = Vector2(0, 0);
  late final AnimationCoordinator animationController;

  Villager(this.isActive, Image image,
      {int priority = 10,
      this.from,
      this.animationsInfo,
      required this.extraPos,
      this.startingAnimIndex = -1})
      : super(priority: priority, anchor: Anchor.center) {
    spriteSheet =
        SpriteSheet.fromColumnsAndRows(image: image, columns: 8, rows: 3);

    size = spriteSheet.getSprite(0, 0).srcSize;
  }

  @override
  Future<void>? onLoad() {
    double myAnimSpeed = animSpeed + ((Random().nextDouble() - 0.5) * 0.1);
    animations = {
      VillagerAnimations.playingArcade: spriteSheet.createAnimation(
          stepTime: myAnimSpeed, from: 0, to: 2, row: 0),
      VillagerAnimations.singing: spriteSheet.createAnimation(
          stepTime: myAnimSpeed, from: 2, to: 4, row: 0),
      VillagerAnimations.fishing: spriteSheet.createAnimation(
          stepTime: myAnimSpeed, from: 4, to: 6, row: 0),
      VillagerAnimations.floating: spriteSheet.createAnimation(
          stepTime: myAnimSpeed, from: 0, to: 2, row: 1),
      VillagerAnimations.talking: spriteSheet.createAnimation(
          stepTime: myAnimSpeed, from: 2, to: 7, row: 1),
      VillagerAnimations.idle: spriteSheet.createAnimation(
          stepTime: myAnimSpeed, from: 0, to: 2, row: 2),
      VillagerAnimations.dancing: spriteSheet.createAnimation(
          stepTime: myAnimSpeed, from: 2, to: 4, row: 2),
      VillagerAnimations.playingVolleyball: spriteSheet.createAnimation(
          stepTime: myAnimSpeed, from: 4, to: 6, row: 2),
      VillagerAnimations.walking: spriteSheet.createAnimation(
          stepTime: myAnimSpeed, from: 6, to: 8, row: 2),
    };

    currentAnimationInfo = startingAnimIndex == -1
        ? animationsInfo![animationInfoIndex =
            Random().nextInt(animationsInfo!.length)]
        : animationsInfo![animationInfoIndex = startingAnimIndex];
    scale = Vector2(currentAnimationInfo.scale.toDouble(), 1);
    position = currentAnimationInfo.position + extraPos;

    if (animationsInfo!.length > 1) {
      animationInfoIndex = (animationInfoIndex - 1).abs();
      currentAnimationInfo = animationsInfo![animationInfoIndex];
    }

    timerActive =
        currentAnimationInfo.hasStayTime() && animationsInfo!.length != 1;
    currentAnimationInfo.getRandomStayTime();
    current = currentAnimationInfo.anim;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeElapsed += dt;
    if (timeElapsed > timePerFrame) {
      timeElapsed %= timePerFrame;
    }

    if (!timerActive) return;

    if (inPlace) {
      timer += timeElapsed;
      if (timer >= currentAnimationInfo.currentStayTime) {
        animationInfoIndex = (animationInfoIndex - 1).abs();
        currentAnimationInfo = animationsInfo![animationInfoIndex];
        currentAnimationInfo.getRandomStayTime();

        if (currentAnimationInfo.scale.toDouble() != 0) {
          scale.x = currentAnimationInfo.scale.toDouble();
        }

        scale = Vector2(currentAnimationInfo.scale.toDouble(), 1);
        position = currentAnimationInfo.position + extraPos;
        timer = 0;
        inPlace = false;
        current = VillagerAnimations.walking;
        animationController.animEnded(this);
      }
    } else {
      Vector2 targetPos =
          animationsInfo![(animationInfoIndex - 1).abs()].position + extraPos;

      Vector2 direction = (targetPos - position).normalized();
      if (-direction.x.sign != 0) scale.x = -direction.x.sign;
      position += direction * timeElapsed * 20;
      if ((targetPos - position).length < 1) {
        inPlace = true;
        current = currentAnimationInfo.anim;
        animationController.animEnded(this);
      }
    }
  }

  void setAnimation(VillagerAnimations newAnim) {
    current = newAnim;
  }

  void setAnimationController(AnimationCoordinator newAnimationController) {
    animationController = newAnimationController;
  }

  void playNextAnim() {
    animationInfoIndex++;
    if (animationInfoIndex >= animationsInfo!.length) {
      animationInfoIndex = 0;
    }

    currentAnimationInfo = animationsInfo![animationInfoIndex];
    current = currentAnimationInfo.anim;
    scale = Vector2(currentAnimationInfo.scale.toDouble(), 1);
  }
}
