import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final Color backgroudColor;
  final Widget child;

  const MainCard({required this.backgroudColor, required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: backgroudColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: child,
    );
  }
}
