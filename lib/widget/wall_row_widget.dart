import 'package:election_us_example/model/app_state.dart';
import 'package:election_us_example/widget/brick_stone_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallRowWidget extends StatefulWidget {
  final int index;
  final int countStones;

  const WallRowWidget({
    this.index,
    this.countStones = 0,
  });

  @override
  _WallRowWidgetState createState() => _WallRowWidgetState();
}

class _WallRowWidgetState extends State<WallRowWidget> {
  @override
  Widget build(BuildContext context) => AnimatedList(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        key: widget.index == null
            ? GlobalKey<AnimatedListState>()
            : Provider.of<AppState>(context).keys[widget.index],
        padding: EdgeInsets.all(0),
        primary: false,
        initialItemCount: widget.countStones,
        itemBuilder: (context, index, animation) => buildItem(animation, index),
      );

  Widget buildItem(Animation<double> animation, int index) => BrickStoneWidget(
        animation: animation,
        stoneMatch: AppState.stoneMatch * (index + 1),
      );
}
