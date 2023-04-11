import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screen/home_screen.dart';
import 'package:calendar_scheduler/database/drift_database.dart';

const DEFAULT_COLORS = [
  'F44336', // 빨강
  'FF9980', // 파랑
  'FFEB3B', // 노랑
  'FCAF50', // 초록
  '2196F3', // 파랑
  '3F51B5', // 남색
  '9C27B0', // 보라
];

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

  final database = LocalDatabase();
  final List colorList = await database.getCategoryColors();
  if (colorList.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColors(
          CategoryColorsCompanion(hexCode: Value(hexCode)));
    }
  }

  runApp(MaterialApp(
    // 3. runApp 실행
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: "NotoSanas",
    ),
    home: HomeScreen(),
  ));
}
