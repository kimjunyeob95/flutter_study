import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/model/status_model.dart';
import 'package:flutter/material.dart';
import 'package:dusty_dust/const/colors.dart';

class MainAppBar extends StatelessWidget {
  final StatusModel status;
  final StatModel stat;

  const MainAppBar({required this.status, required this.stat, Key? key})
      : super(key: key);

  final ts = const TextStyle(color: Colors.white, fontSize: 30.0);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: status.primaryColor,
      expandedHeight: 500.0,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: kToolbarHeight),
            child: Column(
              children: [
                Text(
                  "서울",
                  style: ts,
                ),
                Text(
                  getTimeFromDateTime(datetime: stat.dataTime),
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

  String getTimeFromDateTime({required DateTime datetime}) {
    return "${datetime.year}-${getDateTimeFormat(datetime.month)}-${getDateTimeFormat(datetime.day)} ${getDateTimeFormat(datetime.hour)}:${getDateTimeFormat(datetime.minute)}";
  }

  String getDateTimeFormat(int number) {
    return number.toString().padLeft(2, "0");
  }
}
