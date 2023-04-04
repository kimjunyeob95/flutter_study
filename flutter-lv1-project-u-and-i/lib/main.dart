import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: "sunflower",
        textTheme: TextTheme(
      headline1: TextStyle(
          color: Colors.white, fontSize: 80, fontFamily: "parisienne"),
      headline2: TextStyle(
          color: Colors.white,
          fontSize: 50,
          fontWeight: FontWeight.w700),
      bodyText1:
          TextStyle(color: Colors.white, fontSize: 30),
      bodyText2:
          TextStyle(color: Colors.white, fontSize: 20),
    )),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('ko', 'KO'),
      const Locale('en', 'US'),
    ],
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}
