import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screen/home_screen.dart';

void main() async {
  // 방법 1
  // await initializeDateFormatting().then((_) => runApp(MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       theme: ThemeData(fontFamily: "NotoSans"),
  //       home: HomeScreen(),
  //     )));

  // 방법2
  WidgetsFlutterBinding.ensureInitialized(); // 1. flutter를 실행한 준비를 확인
  await initializeDateFormatting(); // 2. intl formatting 설정
  runApp(MaterialApp( // 3. runApp 실행
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: "NotoSanas",
    ),
    home: HomeScreen(),
  ));
}
