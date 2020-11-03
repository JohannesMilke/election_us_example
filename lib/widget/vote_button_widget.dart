import 'package:flutter/material.dart';

class VoteButtonWidget extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onClicked;

  const VoteButtonWidget({
    @required this.text,
    @required this.color,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  _VoteButtonWidgetState createState() => _VoteButtonWidgetState();
}

class _VoteButtonWidgetState extends State<VoteButtonWidget> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) {
          setState(() => isTapped = true);
          widget.onClicked();
        },
        onTapCancel: () => setState(() => isTapped = false),
        onTapUp: (_) => setState(() => isTapped = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isTapped ? widget.color : Colors.white,
          ),
          child: Text(
            widget.text,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isTapped ? Colors.white : Colors.blueAccent[700]),
          ),
        ),
      );
}
