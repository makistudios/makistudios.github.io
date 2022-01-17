import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/input.dart';
import 'package:vibingtownflutter/common/building.dart';

class AudioController extends SpriteGroupComponent<ButtonState>
    with Tappable, Hoverable {
  bool musicPlaying = false;
  bool isFirstTime = true;
  double volume = 0.1;
  bool isPressed = false;
  double customSize = 0.5;
  List<Sprite> regularSprites = List<Sprite>.empty(growable: true);
  List<Sprite> blockedSprites = List<Sprite>.empty(growable: true);

  AudioController(this.regularSprites, this.blockedSprites, this.customSize)
      : super(priority: 100) {
    sprites = {
      ButtonState.unpressed: blockedSprites[0],
      ButtonState.hover: blockedSprites[1],
      ButtonState.pressed: blockedSprites[2],
    };

    current = ButtonState.unpressed;
    size = sprite!.srcSize * customSize;
  }

  @override
  Future<void>? onLoad() async {
    await FlameAudio.audioCache.load('City_POP.mp3');
    return super.onLoad();
  }

  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('City_POP.mp3', volume: volume);
  }

  void toggleMusic() {
    musicPlaying = !musicPlaying;
    if (musicPlaying) {
      if (isFirstTime) {
        startBgmMusic();
        isFirstTime = !FlameAudio.bgm.isPlaying;
        musicPlaying = FlameAudio.bgm.isPlaying;
      } else {
        FlameAudio.bgm.resume();
      }
    } else {
      FlameAudio.bgm.pause();
    }

    List<Sprite> currentSprites =
        musicPlaying ? regularSprites : blockedSprites;

    sprites = {
      ButtonState.unpressed: currentSprites[0],
      ButtonState.hover: currentSprites[1],
      ButtonState.pressed: currentSprites[2],
    };

    current = ButtonState.unpressed;
    size = sprite!.srcSize * customSize;
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    current = ButtonState.hover;
    size = sprite!.srcSize * customSize;
    return false;
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    current = ButtonState.unpressed;
    size = sprite!.srcSize * customSize;
    return false;
  }

  @override
  bool onTapDown(_) {
    current = ButtonState.pressed;
    size = sprite!.srcSize * customSize;
    isPressed = true;
    toggleMusic();
    return false;
  }

  @override
  bool onTapUp(_) {
    current = ButtonState.hover;
    size = sprite!.srcSize * customSize;
    isPressed = false;
    return false;
  }

  @override
  bool onTapCancel() {
    current = ButtonState.hover;
    size = sprite!.srcSize * customSize;
    isPressed = false;
    return false;
  }
}
