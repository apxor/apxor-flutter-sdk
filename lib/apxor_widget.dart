import 'package:flutter/material.dart';

class ApxorWidget extends StatefulWidget {
  final Widget child;
  final containerKey;
  const ApxorWidget({Key? key, required this.child, this.containerKey}) : super(key: key);
  @override
  _ApxorWidgetState createState() => _ApxorWidgetState();
}

class _ApxorWidgetState extends State<ApxorWidget> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.containerKey,
      child: widget.child,
    );
  }
}
