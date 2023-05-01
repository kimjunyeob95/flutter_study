import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';

class CustomScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  CustomScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('CustomScrollViewScreen'),
          ),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 100, (context, index) {
            return renderContainer(
                color: rainbowColors[index % rainbowColors.length],
                index: index);
          })),
        ],
      ),
    );
  }

  // 1. 한 번에 그림
  SliverList renderSliverChildList() {
    return SliverList(
        delegate: SliverChildListDelegate(numbers
            .map((index) => renderContainer(
                  color: rainbowColors[index % rainbowColors.length],
                  index: index,
                ))
            .toList()));
  }

  // 2. 화면에 보이는 영역만 그림
  SliverList renderSliverChildBuilderList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: 100, (context, index) {
      return renderContainer(
          color: rainbowColors[index % rainbowColors.length], index: index);
    }));
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
