import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/model/status_model.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  final StatusModel status;
  final StatModel stat;
  final String region;
  final DateTime dateTime;
  final bool isExpanded;

  const MainAppBar(
      {required this.status,
      required this.stat,
      required this.region,
      required this.dateTime,
      required this.isExpanded,
      Key? key})
      : super(key: key);

  final ts = const TextStyle(color: Colors.white, fontSize: 30.0);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: status.primaryColor,
      pinned: true,
      title: isExpanded
          ? null
          : Text(
              '$region ${DataUtils.getTimeFromDateTime(datetime: dateTime)}'),
      expandedHeight: 500.0,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: kToolbarHeight),
            child: Column(
              children: [
                Text(
                  region,
                  style: ts,
                ),
                Text(
                  DataUtils.getTimeFromDateTime(datetime: stat.dataTime),
                  style: ts.copyWith(fontSize: 20.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  status.imagePath,
                  width: MediaQuery.of(context).size.width / 2,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  status.label,
                  style:
                      ts.copyWith(fontSize: 40.0, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  status.comment,
                  style:
                      ts.copyWith(fontSize: 20.0, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
