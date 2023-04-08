
import 'package:flutter/material.dart';
import 'package:video_agora_v6/screen/HomeScreen.dart';
import 'package:video_agora_v6/screen/cam_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "NotoSans"
      ),
     initialRoute: "/",
      routes: {
        "/camScreen": (context) => CamScreen(),
      },
      home: HomeScreen(),
    )
  );
}