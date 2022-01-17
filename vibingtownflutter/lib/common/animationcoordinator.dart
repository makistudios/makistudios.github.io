import 'dart:math';
import 'package:flame/components.dart';
import 'package:vibingtownflutter/common/villager.dart';

class AnimationCoordinator extends Component {
  List<Villager> villagers = List<Villager>.empty(growable: true);

  void animEnded(Villager origin) {
    for (int i = 0; i < villagers.length; i++) {
      Villager current = villagers[i];
      if (current != origin) {
        current.playNextAnim();
      }
    }
  }

  void addVillager(Villager child) {
    villagers.add(child);
    child.setAnimationController(this);
  }
}

class AnimationInfo {
  Vector2 position;
  int scale;
  double stayTimeMin;
  double stayTimeMax;
  VillagerAnimations anim;
  double currentStayTime = 0;

  AnimationInfo(
      this.position, this.scale, this.stayTimeMin, this.stayTimeMax, this.anim);

  bool hasStayTime() => stayTimeMin != 0 && stayTimeMax != 0;

  double getRandomStayTime() => currentStayTime =
      stayTimeMin + (Random().nextDouble() * (stayTimeMax - stayTimeMin));
}
