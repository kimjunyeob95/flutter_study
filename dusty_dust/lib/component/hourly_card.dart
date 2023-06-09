import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';

import 'card_title.dart';
import 'main_card.dart';

class HourlyCard extends StatelessWidget {
  final Color lightColor;
  final Color darkColor;
  final String category;
  final List<StatModel> stats;
  final String region;

  const HourlyCard({
    required this.darkColor,
    required this.lightColor,
    required this.category,
    required this.stats,
    required this.region,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainCard(
        backgroudColor: lightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardTitle(
              title: "시간별 ${category}",
              backgroundColor: darkColor,
            ),
            Column(
              children: stats.map((stat) => renderRow(stat: stat)).toList(),
            )
          ],
        ));
  }

  Widget renderRow({required StatModel stat}) {
    final status = DataUtils.getStatusFromItemCodeAndValue(
        value: stat.getLevelFromRegion(region), itemCode: stat.itemCode);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text("${stat.dataTime.hour}시")),
          Expanded(
            child: Image.asset(
              status.imagePath,
              height: 20.0,
            ),
          ),
          Expanded(
              child: Text(
            status.label,
            textAlign: TextAlign.right,
          ))
        ],
      ),
    );
  }
}
