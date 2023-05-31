import 'package:dusty_dust/component/main_app_bar.dart';
import 'package:dusty_dust/component/main_drawer.dart';
import 'package:dusty_dust/component/main_stat.dart';
import 'package:dusty_dust/const/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(),
      body: CustomScrollView(
        slivers: [
          MainAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  color: lightColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          decoration: const BoxDecoration(
                              color: darkColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0))),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "종류별 통계",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MainStat(
                              category: "미세먼지",
                              imgPath: "asset/img/best.png",
                              level: "최고",
                              stat: "0㎍/㎥"),
                          MainStat(
                              category: "미세먼지",
                              imgPath: "asset/img/best.png",
                              level: "최고",
                              stat: "0㎍/㎥"),
                          MainStat(
                              category: "미세먼지",
                              imgPath: "asset/img/best.png",
                              level: "최고",
                              stat: "0㎍/㎥")
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
