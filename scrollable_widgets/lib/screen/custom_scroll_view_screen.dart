import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';

class CustomScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  CustomScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            renderSliverAppbar(),
            renderBuilderListView(),
            renderBuilderGridListView(),
          ],
        ),
      ),
    );
  }

  // AppBar
  SliverAppBar renderSliverAppbar() {
    return SliverAppBar(
      floating: true,
      // 위로 스크롤 시 나타남
      pinned: false,
      // 스크롤해도 계속 고정되게함
      snap: true,
      // floating: true로 두고 snap: true면 앱바가 애니메이션 효과로 나타남
      stretch: true,
      // 맨 위에서 한 개이상에서 스크롤 시 앱바가 남는 공간을 차지함 ios에서 확인가능
      expandedHeight: 200,
      // 앱바의 최대 높이 값,
      collapsedHeight: 100,
      // 스크롤 위로 시 앱바의 최소 높이 값,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset('asset/img/image_1.jpeg',
        fit: BoxFit.cover,),
        title: Text('FlexibleSpaceBar'),
        centerTitle: true,
      ),
      title: Text('CustomScrollViewScreen'),
    );
  }

  // 1. ListView 한 번에 그림
  SliverList renderListView() {
    return SliverList(
        delegate: SliverChildListDelegate(numbers
            .map((index) => renderContainer(
                  color: rainbowColors[index % rainbowColors.length],
                  index: index,
                ))
            .toList()));
  }

  // 2. ListView 화면에 보이는 영역만 그림
  SliverList renderBuilderListView() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: 20, (context, index) {
      return renderContainer(
          color: rainbowColors[index % rainbowColors.length], index: index);
    }));
  }

  // 3. GridView 한 번에 그림
  SliverGrid renderGridListView() {
    return SliverGrid(
        delegate: SliverChildListDelegate(numbers
            .map((index) => renderContainer(
                color: rainbowColors[index % rainbowColors.length],
                index: index))
            .toList()),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2));
  }

  // 4. GridView 화면에 보이는 영역만 그림
  SliverGrid renderBuilderGridListView() {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate(childCount: 100, (context, index) {
          return renderContainer(
              color: rainbowColors[index % rainbowColors.length], index: index);
        }),
        gridDelegate:
            SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200));
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
