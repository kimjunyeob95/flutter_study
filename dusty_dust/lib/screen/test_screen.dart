import 'package:dusty_dust/main.dart';
import 'package:dusty_dust/screen/test2_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TestScreen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>(
              valueListenable: Hive.box(testBox).listenable(),
              builder: (context, box, widget) {
                return Column(
                  children: box.values.map((e) => Text(e)).toList(),
                );
              }),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                print('key: ${box.keys} / values: ${box.values}');
              },
              child: const Text("박스 프린트하기")),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);

                box.add('테스트1');
              },
              child: const Text("데이터 넣기")),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                print(box.get(0));
              },
              child: const Text("특정 값 가져오기")),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                box.deleteAt(0);
              },
              child: const Text("삭제하기")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const Test2Screen()));
              },
              child: const Text("다음 화면 이동"))
        ],
      ),
    );
  }
}
