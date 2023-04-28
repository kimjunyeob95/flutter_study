import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class ListViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  ListViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(title: "ListViewScreen", body: renderBuilder());
  }

// 1. 모두 한 번에 그림
  Widget renderDefault() {
    return ListView(
      children: numbers
          .map((number) => renderContainer(
              color: rainbowColors[number % rainbowColors.length],
              index: number))
          .toList(),
    );
  }

// 2. 보이는 부분 (+조금 더)만 그림
  Widget renderBuilder() {
    return ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return renderContainer(
              color: rainbowColors[index % rainbowColors.length], index: index);
        });
  }

  // 3. 중간 중간에 추가할 위젯을 그림 + 보이는 부분만 그림
  Widget renderSeparatorBuilder() {
    return ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
            color: rainbowColors[index % rainbowColors.length], index: index);
      },
      separatorBuilder: (context, index) {
        return renderContainer(color: Colors.black, index: index, height: 100);
      },
    );
  }

  Widget renderContainer(
      {required Color color, required int index, double? height}) {
    print(index);
    return Container(
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
