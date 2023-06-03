import 'package:flutter/material.dart';

import 'card_title.dart';
import 'main_card.dart';

class HourlyCard extends StatelessWidget {
  const HourlyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardTitle(
          title: "시간별 미세먼지",
        ),
        Column(
          children: List.generate(24, (index) {
            final now = DateTime.now();
            final hour = now.hour;
            int currentHour = hour - index;

            // 3 2 1 0 23 22 형식으로 시간을 표현
            if (currentHour < 0) {
              currentHour += 24;
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  Expanded(child: Text("$currentHour시")),
                  Expanded(
                    child: Image.asset(
                      "asset/img/good.png",
                      height: 20.0,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    "좋음",
                    textAlign: TextAlign.right,
                  ))
                ],
              ),
            );
          }),
        )
      ],
    ));
  }
}
