import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screen/home_screen.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "NotoSans"),
        home: HomeScreen(),
      )));
}
