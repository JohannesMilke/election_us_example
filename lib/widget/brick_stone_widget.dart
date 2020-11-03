import 'package:election_us_example/images.dart';
import 'package:election_us_example/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrickStoneWidget extends StatelessWidget {
  final Animation animation;
  final double stoneMatch;

  const BrickStoneWidget({
    @required this.animation,
    @required this.stoneMatch,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final stoneWidth = width / 3 + AppState.stoneMatchRow;

    final provider = Provider.of<AppState>(context);
    if (provider.stoneHeight == 0) {
      provider.determineStoneHeight(stoneWidth);
    }

    return ScaleTransition(
      scale: animation,
      child: Container(
        width: stoneWidth,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: -stoneMatch,
              bottom: 0,
              child: Image.asset(
                Images.brickStone,
                width: stoneWidth,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
