import 'package:flutter/material.dart';
import 'package:navigation/layout/MainLayout.dart';

class RouteThreeScreen extends StatelessWidget {
  const RouteThreeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(title: "RouteThreeScreen", bodyWidget: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('pop'),
      )
    ]);
  }
}
