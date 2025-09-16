import 'dart:async';

import 'package:flame/components.dart';
import 'package:flamingbull/game/flamebull.dart';
import 'package:flamingbull/player.dart';


class BullWorld extends World with HasGameRef<FlameBull> {
  
  late final Player player;
  
  @override
  FutureOr onLoad() {
    super.onLoad();
    player = Player();
    add(player);
  }
}