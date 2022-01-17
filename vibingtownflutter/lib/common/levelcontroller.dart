import 'dart:html';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/cupertino.dart';
import 'package:vibingtownflutter/common/animateddecoration.dart';
import 'package:vibingtownflutter/common/audiocontroller.dart';
import 'package:vibingtownflutter/common/building.dart';
import 'package:vibingtownflutter/common/background.dart';
import 'package:vibingtownflutter/common/cameracontroller.dart';
import 'package:vibingtownflutter/common/mapdecoration.dart';
import 'package:vibingtownflutter/common/villager.dart';
import 'package:vibingtownflutter/common/pathpoint.dart';
import 'package:vibingtownflutter/common/animationcoordinator.dart';

late Vector2 mapSize;
late Vector2 cameraPos;
List<Villager> villagers = List.empty(growable: true);

var interactionPoints = [
  //Docks
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(360, 228), 1, 0, 0, VillagerAnimations.fishing),
        ]),
        25
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(148, 260), 1, 0, 0, VillagerAnimations.fishing),
        ]),
        25
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(300, 228), 1, 0, 0, VillagerAnimations.fishing),
        ]),
        25
      ],
    ],
  ],
//Museum
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-166, -137), -1, 10, 15, VillagerAnimations.idle),
          AnimationInfo(
              Vector2(-260, -137), 1, 10, 10, VillagerAnimations.idle),
        ]),
        25
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-166, -137), 1, 0, 0, VillagerAnimations.talking),
        ]),
        25
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-188, -137), -1, 0, 0, VillagerAnimations.talking),
        ]),
        25
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-166, -137), 1, 0, 0, VillagerAnimations.idle),
          AnimationInfo(
              Vector2(-260, -137), 1, 0, 0, VillagerAnimations.talking),
          AnimationInfo(Vector2(-166, -137), 1, 0, 0, VillagerAnimations.idle),
          AnimationInfo(Vector2(-166, -137), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
        0
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-188, -137), -1, 3, 5, VillagerAnimations.talking),
          AnimationInfo(
              Vector2(-238, -137), 1, 3, 5, VillagerAnimations.talking),
        ]),
        25,
        0
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-260, -137), -1, 0, 0, VillagerAnimations.idle),
          AnimationInfo(Vector2(-260, -137), -1, 0, 0, VillagerAnimations.idle),
          AnimationInfo(Vector2(-260, -137), -1, 0, 0, VillagerAnimations.idle),
          AnimationInfo(
              Vector2(-260, -137), -1, 0, 0, VillagerAnimations.talking),
        ]),
        25,
        0
      ],
    ],
  ],
  //Library
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(40, -148), -1, 0, 0, VillagerAnimations.talking),
        ]),
        25
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(60, -148), 1, 0, 0, VillagerAnimations.talking),
        ]),
        25
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-8, -148), 1, 0, 0, VillagerAnimations.talking),
        ]),
        25
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-28, -148), -1, 0, 0, VillagerAnimations.talking),
        ]),
        25
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(50, -148), 1, 5, 7, VillagerAnimations.idle),
          AnimationInfo(Vector2(-20, -148), 1, 5, 7, VillagerAnimations.idle),
        ]),
        25,
        0
      ],
    ],
  ],
  //Shrine
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(242, -170), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(264, -124), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(200, -150), -1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(244, -124), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(180, -150), -1, 20, 24, VillagerAnimations.talking),
          AnimationInfo(
              Vector2(220, -124), -1, 10, 16, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
  ],
  //Bank
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-166, -12), 1, 0, 0, VillagerAnimations.talking),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-188, -12), -1, 0, 0, VillagerAnimations.talking),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-166, -12), 1, 6, 9, VillagerAnimations.idle),
          AnimationInfo(Vector2(-250, -12), -1, 5, 7, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
  ],
  //Bazaar
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(54, -22), -1, 0, 0, VillagerAnimations.talking),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(82, -18), 1, 0, 0, VillagerAnimations.talking),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(76, -34), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
  ],
  //Plaza
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-34, 0), -1, 0, 0, VillagerAnimations.talking),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-8, 0), 1, 0, 0, VillagerAnimations.talking),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-40, -83), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-34, -32), -1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(15, -85), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-17, -68), 1, 0, 0, VillagerAnimations.singing),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-34, -32), -1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(1, -32), 1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(15, 15), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-17, -68), 1, 0, 0, VillagerAnimations.singing),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-34, -32), -1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-17, -68), 1, 0, 0, VillagerAnimations.singing),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(1, -32), 1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-17, -68), 1, 0, 0, VillagerAnimations.singing),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-34, -32), -1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(1, -32), 1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(8, -83), -1, 10, 12, VillagerAnimations.talking),
          AnimationInfo(
              Vector2(-40, -83), 1, 10, 12, VillagerAnimations.talking),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-60, -83), -1, 0, 0, VillagerAnimations.idle),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(24, -83), 1, 0, 0, VillagerAnimations.idle),
        ]),
        15,
      ],
    ],
  ],
  //Banners
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(100, 95), 1, 0, 0, VillagerAnimations.dancing),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(65, 95), -1, 0, 0, VillagerAnimations.dancing),
        ]),
        15,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-70, 95), -1, 3, 4, VillagerAnimations.idle),
          AnimationInfo(Vector2(100, 95), -1, 3, 4, VillagerAnimations.idle),
        ]),
        15,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-20, 96), 1, 0, 0, VillagerAnimations.dancing),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-52, 88), -1, 0, 0, VillagerAnimations.singing),
        ]),
        15,
      ],
    ],
  ],
  //HousesLeft
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-290, 115), -1, 30, 40, VillagerAnimations.idle),
          AnimationInfo(Vector2(-170, 115), 1, 30, 40, VillagerAnimations.idle),
        ]),
        15,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-228, 115), 1, 0, 0, VillagerAnimations.talking),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-252, 115), -1, 0, 0, VillagerAnimations.talking),
        ]),
        15,
      ],
    ],
  ],
  //HousesRight
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(290, -15), -1, 30, 40, VillagerAnimations.idle),
          AnimationInfo(Vector2(215, -15), 1, 30, 40, VillagerAnimations.idle),
        ]),
        0,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(160, -15), -1, 0, 0, VillagerAnimations.talking),
        ]),
        0,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(185, -15), 1, 0, 0, VillagerAnimations.talking),
        ]),
        0,
      ],
    ],
  ],
  //SunBathers
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-62, 198), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-174, 216), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-215, 216), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(-276, 202), 1, 0, 0, VillagerAnimations.idle),
        ]),
        25,
      ],
    ],
  ],
  //Beach
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-50, 320), -1, 0, 0, VillagerAnimations.floating),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-180, 280), 1, 0, 0, VillagerAnimations.floating),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(120, 180), 1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(75, 190), -1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-50, 320), -1, 0, 0, VillagerAnimations.floating),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(-180, 280), 1, 0, 0, VillagerAnimations.floating),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(120, 180), 1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(75, 190), -1, 0, 0, VillagerAnimations.dancing),
        ]),
        25,
      ],
    ],
  ],
  //Carnival
  [
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(294, 135), -1, 0, 0, VillagerAnimations.playingArcade),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(320, 135), 1, 0, 0, VillagerAnimations.playingArcade),
        ]),
        15,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(294, 135), -1, 0, 0, VillagerAnimations.playingArcade),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(320, 135), 1, 0, 0, VillagerAnimations.playingArcade),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(270, 135), -1, 0, 0, VillagerAnimations.idle),
        ]),
        15,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(294, 135), -1, 0, 0, VillagerAnimations.playingArcade),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(270, 135), -1, 0, 0, VillagerAnimations.idle),
        ]),
        15,
      ],
    ],
    [
      [
        List<AnimationInfo>.from([
          AnimationInfo(Vector2(265, 100), 1, 0, 0, VillagerAnimations.talking),
        ]),
        15,
      ],
      [
        List<AnimationInfo>.from([
          AnimationInfo(
              Vector2(240, 100), -1, 0, 0, VillagerAnimations.talking),
        ]),
        15,
      ],
    ],
  ],
];

var buildings = [
  ["bank", Vector2(-216, -56)],
  ["museum", Vector2(-215, -193.5960591133005)],
  ["ferrisWheel", Vector2(289, 43.5)],
  ["bazaar", Vector2(84.60591133004925, -54)],
  ["shrine", Vector2(241, -183.25123152709358)],
  ["library", Vector2(16.625615763546797, -191)],
];

var villagerSpritesheets = [
  'baby_monkette.png',
  'hamster.png',
  'owl.png',
  'doggo.png',
  'cat.png',
  'fokiballena.png',
  'fox.png',
  'frog.png',
  'ninfa.png'
];

var decorations = [
  ["carnivalStandGreen", Vector2(216.5, 128), 20],
  ["banners", Vector2(246, 159), 20],
  ["flowerBedBig", Vector2(-27, 116.5), 20],
  ["flowerBedBig", Vector2(69, 116.5), 20],
  ["umbrellaRed", Vector2(-83, 175.5), 20],
  ["umbrellaPurple", Vector2(-195, 193.5), 20],
  ["umbrellaGreen", Vector2(-295, 180.5), 20],
  ["stairs", Vector2(181.3, 194), 0],
  ["mushroom", Vector2(156, -218), 25],
];

var animatedDecorations = [
  ["Fountain.png", Vector2(-54, -66), 2, 3, 0],
  ["BeachBird.png", Vector2(-106, 270), 1, 4, 0],
  ["CarnivalBird1.png", Vector2(-27, 66), 3, 6, 1],
  ["CarnivalBird2.png", Vector2(43, 58), 3, 6, 1],
  ["Dock.png", Vector2(139.5, 207), 2, 2, 0],
  ["GreenLifeSaver.png", Vector2(-273.5, 256), 2, 2, 0],
  ["LibraryBird.png", Vector2(-25, -214), 4, 6, 0],
  ["Monolith.png", Vector2(120, -265), 4, 5, 0],
  ["Pond.png", Vector2(280, -137), 2, 3, 0],
  ["RedLifeSaver.png", Vector2(-23, 265), 2, 2, 0],
  ["SandCastle.png", Vector2(-266.5, 198), 3, 6, 1],
  ["Stereo.png", Vector2(63, 127), 2, 5, 0],
  ["TreesBird1.png", Vector2(-345.5, -209), 3, 6, 2],
  ["TreesBird2.png", Vector2(-299.5, -247), 3, 6, 0],
  ["TreesBird3.png", Vector2(-259, -228), 3, 6, 1],
  ["WestHousesBird.png", Vector2(-163, 31), 3, 6, 1],
  //["Volley_Atlas.png", Vector2(-28, 142), 1, 5, 0],
];

var buildingTexts = [
  ["BANK", "Where you trade \n  your tokens", "https://token.vibing.studio", 8],
  ["MUSEUM", "Here we collect our\nmost precious items", "https://solsteads.com/71-ape-lane", 7.5],
  ["CARNIVAL", "Games coming soon", "", 8],
  ["BAZAAR", "Spend your \n\$VIBE here!", "https://vibe.market", 8],
  ["SHRINE", "Under construction", "", 8],
  ["LIBRARY", " Information about the \n  monkettes universe", "https://solanamonkette.business", 7],
];

late bool sensorActive = true;

class LevelController extends FlameGame
    with HasTappables, HasHoverables, HasDraggables {
  late CameraController cameraController;
  late AudioController audioController;
  bool audioControllerSpawned = false;

  @override
  Color backgroundColor() {
    return const Color.fromRGBO(255, 255, 255, 1);
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    double scale = size.y * 2 / 900;

    camera.snapTo(Vector2(0, -120));
    cameraPos = camera.position + (size / 2) + Vector2(0, -120);

    sensorActive = size.x < size.y;
    camera.zoom *= scale * (sensorActive ? 0.8 : 1.15);

    scale = 1;
    mapSize = Vector2(1150, 900);

    add(Background(size / 2));
    add(cameraController = CameraController(
        (-mapSize / 2) + size / 2, (mapSize / 2) - (size / 2), camera));

    Random random = Random();
    List<int> unusedIndexes = List.empty(growable: true);
    for (int i = 0; i < interactionPoints.length; i++) {
      unusedIndexes.add(i);
    }

    int activeInteractionPoints = interactionPoints.length;
    // min(interactionPoints.length, 5 + random.nextInt(7));
    for (int i = 0; i < activeInteractionPoints; i++) {
      int n = random.nextInt(unusedIndexes.length);
      int areaIndex = unusedIndexes[n];
      unusedIndexes.removeAt(n);

      var array = interactionPoints[areaIndex]
          [random.nextInt(interactionPoints[areaIndex].length)];

      AnimationCoordinator animationCoordinator = AnimationCoordinator();
      for (int j = 0; j < array.length; j++) {
        /*Sprite spr = await loadSprite(
            villagerSpritesheets[random.nextInt(villagerSpritesheets.length)]
                .toString());*/
        Sprite spr = await loadSprite(villagerSpritesheets[0].toString());

        List<AnimationInfo> anims = array[j][0] as List<AnimationInfo>;
        Villager v = Villager(false, spr.image,
            animationsInfo: anims,
            priority: array[j][1] as int,
            extraPos: size / 2,
            startingAnimIndex: array[j].length >= 3 ? array[j][2] as int : -1);

        add(v);
        villagers.add(v);
        animationCoordinator.addVillager(v);
      }
      add(animationCoordinator);
    }

    Sprite speechBubbleSprite = await loadSprite('DialogBubble_half.png');
    FireAtlas mapAtlas = await loadFireAtlas("vibingtown.fa");
    for (int i = 0; i < buildings.length; i++) {
      final Sprite pressedSprite =
          mapAtlas.getSprite(buildings[i][0].toString() + "Pressed");
      final Sprite unpressedSprite =
          mapAtlas.getSprite(buildings[i][0].toString());
      final Sprite hoverSprite =
          mapAtlas.getSprite(buildings[i][0].toString() + "Hover");

      final Vector2 pos = (buildings[i][1] as Vector2) + (size / 2);
      SpriteComponent speechBubble = SpriteComponent(
        sprite: speechBubbleSprite,
        position: pos + Vector2(0, -30),
        size: speechBubbleSprite.srcSize,
        anchor: Anchor.bottomCenter,
        paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 0),
        priority: 50,
      );

      TextComponent buildingTitle =
          TextComponent(text: buildingTexts[i][0] as String, priority: 51)
            ..position =
                pos + Vector2(0, -speechBubbleSprite.srcSize.y / 2 - 40)
            ..anchor = Anchor.center;

      TextComponent buildingText =
          TextComponent(text: buildingTexts[i][1] as String, priority: 51)
            ..position =
                pos + Vector2(0, -speechBubbleSprite.srcSize.y / 2 - 25)
            ..anchor = Anchor.center;

      add(buildingTitle);
      add(buildingText);
      add(speechBubble);
      add(Building(pressedSprite, unpressedSprite, hoverSprite, speechBubble,
          pos, buildingTitle, buildingText, buildingTexts[i][2] as String, buildingTexts[i][3] as double));
    }

    for (int i = 0; i < decorations.length; i++) {
      Sprite sprite = mapAtlas.getSprite(decorations[i][0].toString());
      Vector2 pos = (decorations[i][1] as Vector2) + size / 2;

      add(DecorationObject(
          pos, sprite.srcSize, sprite, decorations[i][2] as int));
    }

    for (int i = 0; i < animatedDecorations.length; i++) {
      int rows = animatedDecorations[i][2] as int;
      int columns = animatedDecorations[i][3] as int;
      Sprite sprite = await loadSprite(animatedDecorations[i][0].toString());
      SpriteSheet spriteSheet = SpriteSheet.fromColumnsAndRows(
          image: sprite.image, columns: columns, rows: rows);
      Vector2 pos = (animatedDecorations[i][1] as Vector2) + size / 2;

      List<Sprite> sprites = List.empty(growable: true);
      int spriteCount = rows * columns;
      for (int j = 0; j < rows; j++) {
        for (int k = 0; k < columns; k++) {
          int spritesLeft = spriteCount - (j * columns) - k;

          if (spritesLeft > (animatedDecorations[i][4] as int)) {
            sprites.add(spriteSheet.getSprite(j, k));
          }
        }
      }

      add(AnimatedDecoration(
          SpriteAnimation.spriteList(sprites, stepTime: 0.1, loop: true), pos));
    }

    Sprite unpressedSprite = mapAtlas.getSprite("musicButton");
    Sprite hoverSprite = mapAtlas.getSprite("musicButtonHover");
    Sprite pressedSprite = mapAtlas.getSprite("musicButtonPressed");
    Sprite unpressedSpriteBlocked = mapAtlas.getSprite("musicButtonOff");
    Sprite pressedSpriteBlocked = mapAtlas.getSprite("musicButtonOffPressed");
    Sprite hoverSpriteBlocked = mapAtlas.getSprite("musicButtonOffHover");
    add(audioController = AudioController(
        List<Sprite>.from([unpressedSprite, hoverSprite, pressedSprite]),
        List<Sprite>.from(
            [unpressedSpriteBlocked, hoverSpriteBlocked, pressedSpriteBlocked]),
        scale * 0.65)
      ..position = Vector2(size.x - hoverSprite.srcSize.x - 20,
          cameraPos.y - (size.y / 2) + (hoverSprite.srcSize.y / 2) + 80)
      ..anchor = Anchor.center);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    for (int i = 0; i < villagers.length; i++) {
      villagers[i].extraPos = size / 2;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    cameraPos = camera.position + (size / 2);
    audioController.position = Vector2(
        cameraPos.x + (size.x / 2) - 30, cameraPos.y + (size.y / 2) - 35);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    cameraController.onTapDown(info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo details) {
    super.onDragUpdate(pointerId, details);
    cameraController.onDragUpdate(details);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo details) {
    super.onDragEnd(pointerId, details);
    cameraController.onDragEnd(details);
  }
}
