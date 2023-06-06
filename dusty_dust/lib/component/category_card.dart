import 'package:dusty_dust/component/main_card.dart';
import 'package:dusty_dust/model/stat_and_status_model.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'card_title.dart';
import 'main_stat.dart';

class CategoryCard extends StatelessWidget {
  final String region;
  final Color lightColor;
  final Color darkColor;
  final List<StatAndStatusModel> models;

  const CategoryCard(
      {required this.lightColor,
      required this.darkColor,
      required this.region,
      required this.models,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: MainCard(
        backgroudColor: lightColor,
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardTitle(
                backgroundColor: darkColor,
                title: "종류별 통계",
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                  children: models
                      .map((model) => MainStat(
                          width: constraint.maxWidth / 3,
                          category: DataUtils.getItemCodeKrString(
                              itemCode: model.itemCode),
                          imgPath: model.status.imagePath,
                          level: model.status.label,
                          stat:
                              "${model.stat.getLevelFromRegion(region)}${DataUtils.getUnitFromItemCode(itemCode: model.itemCode)}"))
                      .toList(),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
