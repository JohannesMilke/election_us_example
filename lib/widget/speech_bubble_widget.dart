import 'package:election_us_example/widget/speech_bubble_clipper.dart';
import 'package:flutter/material.dart';

class SpeechBubbleWidget extends StatelessWidget {
  final Widget child;

  const SpeechBubbleWidget({
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: child,
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(right: 52),
                child: ClipPath(
                  clipper: SpeechBubbleClipper(),
                  child: Container(color: Colors.white, width: 80, height: 40),
                ),
              ),
            ),
          ],
        ),
      );
}
