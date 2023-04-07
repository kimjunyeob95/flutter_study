import 'package:flutter/material.dart';
import 'package:video_agora_v6/screen/HomeScreen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "NotoSans"
      ),
      home: HomeScreen(),
    )
  );
}