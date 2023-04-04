import 'package:flutter/material.dart';
import 'package:navigation/layout/MainLayout.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(title: "RouteOneScreen", bodyWidget: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('pop'),
      )
    ]);
  }
}
