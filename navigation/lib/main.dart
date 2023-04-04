import 'package:flutter/material.dart';
import 'package:navigation/screen/RouteOneScreen.dart';
import 'package:navigation/screen/RouteThreeScreen.dart';
import 'package:navigation/screen/RouteTwoScreen.dart';

import 'screen/HomeScreen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/one": (context) => RouteOneScreen(),
        "/two": (context) => RouteTwoScreen(),
        "/three": (context) => RouteThreeScreen()
      },
    )
  );
}

