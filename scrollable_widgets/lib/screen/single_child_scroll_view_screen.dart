import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class SingleChildScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  SingleChildScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        title: "SingleChildScrollView",
        body: SingleChildScrollView(
          child: Column(
            children: numbers
                .map((e) => renderContainer(
                    index: e, color: rainbowColors[e % rainbowColors.length]))
                .toList(),
          ),
        ));
  }

  // 1. 기본 랜더링 화면
  Widget renderSimple() {
    return SingleChildScrollView(
      child: Column(
        children: rainbowColors.map((e) => renderContainer(color: e)).toList(),
      ),
    );
  }

  // 2. 화면을 넘어가지 않아도 스크롤 되는 화면
  Widget renderAlwaysScroll() {
    return SingleChildScrollView(
      // NeverScrollableScrollPhysics - 디폴트 값이며 스크롤 안되게 하는 설정
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [renderContainer(color: Colors.black)],
      ),
    );
  }

  // 3. 스크롤 시 화면이 안짤리게 하는 화면 (ios에서 확인가능)
  Widget renderClip() {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [renderContainer(color: Colors.black)],
      ),
    );
  }

  // 4. 종합 physics 정리
  Widget renderPhysics() {
    return SingleChildScrollView(
      // NeverScrollableScrollPhysics 스크롤 막음
      // AlwaysScrollableScrollPhysics 스크롤 허용
      // BouncingScrollPhysics ios 스크롤 모션
      // ClampingScrollPhysics aos 스크롤 모션
      physics: ClampingScrollPhysics(),
      child: Column(
        children: rainbowColors.map((e) => renderContainer(color: e)).toList(),
      ),
    );
  }

  // 5. SingleChildScrollView 퍼포먼스
  // ListView는 화면에 보이는 부분만 렌더링 하지만 singleview는 전체를 렌더링함
  Widget renderPerformance() {
    return SingleChildScrollView(
      child: Column(
        children: numbers
            .map((e) => renderContainer(
                index: e, color: rainbowColors[e % rainbowColors.length]))
            .toList(),
      ),
    );
  }

  Widget renderContainer({required Color color, int? index}) {
    return Container(
      height: 300,
      color: color,
    );
  }
}
