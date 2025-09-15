import 'dart:async';

import 'package:flame/components.dart';
import 'package:flamingbull/game/flamebull.dart';
import 'package:flamingbull/player.dart';


class BullWorld extends World with HasGameRef<FlameBull> {
  @override
  FutureOr onLoad() {
    super.onLoad();

    add(Player());
  }
}