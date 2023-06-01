import 'package:dusty_dust/component/main_card.dart';
import 'package:flutter/material.dart';

import 'card_title.dart';
import 'main_stat.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: MainCard(
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardTitle(title: "종류별 통계",),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                  children: List.generate(
                      20,
                      (index) => MainStat(
                          width: constraint.maxWidth / 3,
                          category: "미세먼지$index",
                          imgPath: "asset/img/best.png",
                          level: "최고",
                          stat: "0㎍/㎥")),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
