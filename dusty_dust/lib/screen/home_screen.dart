import 'package:dusty_dust/component/category_card.dart';
import 'package:dusty_dust/component/hourly_card.dart';
import 'package:dusty_dust/component/main_app_bar.dart';
import 'package:dusty_dust/component/main_drawer.dart';
import 'package:dusty_dust/const/colors.dart';
import 'package:dusty_dust/const/regions.dart';
import 'package:dusty_dust/const/status_level.dart';
import 'package:dusty_dust/model/stat_and_status_model.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/repository/stat_repository.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();

    scrollController.addListener(scrollListener);
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<Map<ItemCode, List<StatModel>>> fetchData() async {
    Map<ItemCode, List<StatModel>> stats = {};

    List<Future> futures = [];
    for (ItemCode itemCode in ItemCode.values) {
      futures.add(StatRepository.fetchData(itemCode: itemCode));
    }
    final results = await Future.wait(futures);
    int i = 0;
    for (ItemCode itemCode in ItemCode.values) {
      stats.addAll({itemCode: results[i]});
      i++;
    }

    return stats;
  }

  void scrollListener() {
    bool isExpanded = scrollController.offset <
        500 - kToolbarHeight; // mainAppBar 높이 - 앱바 높이보다 작으면 펼쳐져 있음

    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<ItemCode, List<StatModel>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('에러가 발생'),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          Map<ItemCode, List<StatModel>> stats = snapshot.data!;
          StatModel pm10RecentStat = stats[ItemCode.PM10]![0];

          // 미세먼지 최근 데이터의 현재 상태
          final regionStat = pm10RecentStat.getLevelFromRegion(region);
          final status = DataUtils.getStatusFromItemCodeAndValue(
              itemCode: pm10RecentStat.itemCode, value: regionStat);

          final ssModel = stats.keys.map((key) {
            final value = stats[key]!;
            final stat = value[0];

            return StatAndStatusModel(
                itemCode: key,
                stat: stat,
                status: DataUtils.getStatusFromItemCodeAndValue(
                    itemCode: key, value: stat.getLevelFromRegion(region)));
          }).toList();

          return Scaffold(
            drawer: MainDrawer(
              onSelectedRegion: (String value) {
                setState(() {
                  region = value;
                });
                Navigator.of(context).pop();
              },
              region: region,
              darkColor: status.darkColor,
              lightColor: status.lightColor,
            ),
            body: Container(
              color: status.primaryColor,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  MainAppBar(
                    stat: pm10RecentStat,
                    status: status,
                    region: region,
                    dateTime: pm10RecentStat.dataTime,
                    isExpanded: isExpanded,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CategoryCard(
                          region: region,
                          models: ssModel,
                          lightColor: status.lightColor,
                          darkColor: status.darkColor,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        ...stats.keys.map((itemCode) {
                          final stat = stats[itemCode]!;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: HourlyCard(
                              lightColor: status.lightColor,
                              darkColor: status.darkColor,
                              region: region,
                              category: DataUtils.getItemCodeKrString(
                                  itemCode: itemCode),
                              stats: stat,
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
