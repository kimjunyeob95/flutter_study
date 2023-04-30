import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class ReorderableListViewScreen extends StatefulWidget {
  ReorderableListViewScreen({Key? key}) : super(key: key);

  @override
  State<ReorderableListViewScreen> createState() =>
      _ReorderableListViewScreenState();
}

class _ReorderableListViewScreenState extends State<ReorderableListViewScreen> {
  List<int> numbers = List.generate(100, (index) => index);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        title: 'ReorderableListViewScreen', body: renderBuilder());
  }

  // 1. 모두 화면에 그림
  Widget renderDefault() {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          // [red, orange, yellow]
          // red를 yellow 뒤로 이동시킨다.
          // red: 0 oldIndex -> 3 newIndex
          // [orange, yellow, red] -> 최종 index는 2가 됨

          // [red, orange, yellow]
          // yellow를 red 앞으로 이동시킨다.
          // yellow: 2 oldIndex -> 0 newIndex
          // [yellow, red, orange] -> 최종 index는 0이 됨

          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
      children: numbers
          .map((index) => renderContainer(
              color: rainbowColors[index % rainbowColors.length], index: index))
          .toList(),
    );
  }

  // 2. 보이는 부분 (+조금 더)만 그림
  // 다른 ListView와 다르게 index를 직접 조작하는 numbers의 index를 참조하게 해야함
  Widget renderBuilder() {
    return ReorderableListView.builder(
      itemCount: numbers.length,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          // [red, orange, yellow]
          // red를 yellow 뒤로 이동시킨다.
          // red: 0 oldIndex -> 3 newIndex
          // [orange, yellow, red] -> 최종 index는 2가 됨

          // [red, orange, yellow]
          // yellow를 red 앞으로 이동시킨다.
          // yellow: 2 oldIndex -> 0 newIndex
          // [yellow, red, orange] -> 최종 index는 0이 됨

          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
      itemBuilder: (context, index) {
        return renderContainer(
            color: rainbowColors[numbers[index] % rainbowColors.length],
            index: numbers[index]);
      },
    );
  }

  Widget renderContainer(
      {required Color color, required int index, double? height}) {
    print(index);
    return Container(
      key: Key(index.toString()),
      height: height ?? 300,
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30.0),
        ),
      ),
    );
  }
}
