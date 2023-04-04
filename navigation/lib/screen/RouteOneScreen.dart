import 'package:flutter/material.dart';
import 'package:navigation/layout/MainLayout.dart';
import 'package:navigation/screen/RouteThreeScreen.dart';

class RouteOneScreen extends StatelessWidget {
  const RouteOneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(title: "RouteOneScreen", bodyWidget: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('pop'),
      ),
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => RouteThreeScreen()),
                (route) => route.settings.name == "/");
          },
          child: Text("push Until")),
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/three", (route) => route.settings.name == "/");
          },
          child: Text("push NamedUntil"))
    ]);
  }
}
