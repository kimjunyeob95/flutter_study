import 'package:dusty_dust/const/colors.dart';
import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const CardTitle(
      {required this.backgroundColor, required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ));
  }
}
