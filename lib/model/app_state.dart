import 'package:election_us_example/widget/brick_stone_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  static final brickStoneDuration = Duration(milliseconds: 500);
  static final rows = 4;
  static final stonesPerRow = 3;
  static final double stoneMatch = 20.0;
  static final double stoneMatchRow =
      AppState.stoneMatch / 2 * AppState.stonesPerRow;

  AppState() {
    this.stoneHeight = 0;
    this._countStones = 0;
    this.keys = List.generate(rows, (index) => GlobalKey<AnimatedListState>());
  }

  List<GlobalKey<AnimatedListState>> _keys;
  int _countStones;
  double _stoneHeight;

  List<GlobalKey<AnimatedListState>> get keys => _keys;
  int get countStones => _countStones;
  double get stoneHeight => _stoneHeight;

  set countStones(int countStones) {
    _countStones = countStones;
    notifyListeners();
  }

  set keys(List<GlobalKey<AnimatedListState>> keys) {
    _keys = keys;
    notifyListeners();
  }

  set stoneHeight(double stoneHeight) => _stoneHeight = stoneHeight;

  void addKey(GlobalKey<AnimatedListState> key) {
    _keys.add(key);
  }

  Future insertBrickStones(int count, {Duration duration}) async {
    for (int i = 0; i < count; i++) {
      _insertBrickStone();
      await Future.delayed(duration ?? brickStoneDuration);
    }
  }

  void _insertBrickStone() {
    if (countStones >= stonesPerRow * rows) return;

    final indexKey = countStones ~/ stonesPerRow;
    final indexValue = countStones % stonesPerRow;
    final key = keys[indexKey];

    key.currentState.insertItem(indexValue);
    countStones++;
  }

  Future deleteBrickStones(int count, {Duration duration}) async {
    for (int i = 0; i < count; i++) {
      _deleteBrickStone();
      await Future.delayed(duration ?? brickStoneDuration);
    }
  }

  void _deleteBrickStone() {
    if (countStones - 1 < 0) return;

    countStones--;
    final indexKey = countStones ~/ stonesPerRow;
    final indexValue = countStones % stonesPerRow;
    final key = keys[indexKey];

    key.currentState.removeItem(
      indexValue,
      (context, animation) => BrickStoneWidget(
        animation: animation,
        stoneMatch: indexKey * 20.0,
      ),
    );
  }

  void determineStoneHeight(double stoneWidth) {
    const originalStoneWidth = 640;
    const originalStoneHeight = 280;

    stoneHeight = stoneWidth / originalStoneWidth * originalStoneHeight;
  }
}
