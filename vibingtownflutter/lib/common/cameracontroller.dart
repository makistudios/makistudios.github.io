import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class CameraController extends PositionComponent {
  Vector2 limitMin;
  Vector2 limitMax;

  Vector2 currentSpeed = Vector2(0, 0);
  double speedLimit = 10;
  double friction = 0.95;

  Camera camera;

  bool active = false;
  List previousMousePositions = List.empty(growable: true);

  CameraController(this.limitMin, this.limitMax, this.camera) {
    camera.speed = 100;
  }

  @override
  void update(double dt) {
    //currentSpeed.clampScalar(-speedLimit, speedLimit);
    Vector2 snappedCameraPos = camera.position;
    snappedCameraPos += currentSpeed;
    currentSpeed *= active ? 0 : friction;

    snappedCameraPos.clamp(limitMin, limitMax);
    snappedCameraPos.round();
    camera.snapTo(snappedCameraPos);

    if (previousMousePositions.isNotEmpty) previousMousePositions.removeAt(0);
  }

  void onTapDown(TapDownInfo info) {
    currentSpeed = Vector2.zero();
    previousMousePositions.clear();
    active = true;
  }

  void onDragUpdate(DragUpdateInfo details) {
    previousMousePositions.add(-details.delta.viewport);
    currentSpeed = -details.delta.viewport * 2;
  }

  void onDragEnd(DragEndInfo details) {
    active = false;
    if (previousMousePositions.isEmpty ||
        previousMousePositions.last == Vector2.zero()) return;
    Vector2 actualVelocity = Vector2.zero();
    for (int i = 0; i < previousMousePositions.length; i++) {
      actualVelocity += previousMousePositions[i];
    }

    currentSpeed =
        actualVelocity / previousMousePositions.length.toDouble() / 3;
  }

  void resize(Vector2 newLimitMin, Vector2 newLimitMax) {
    limitMin = newLimitMin;
    limitMax = newLimitMax;
  }
}
