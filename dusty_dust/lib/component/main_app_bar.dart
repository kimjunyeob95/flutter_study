import 'package:flutter/material.dart';
import 'package:dusty_dust/const/colors.dart';

class MainAppBar extends StatelessWidget {
  MainAppBar({Key? key}) : super(key: key);

  final ts = TextStyle(color: Colors.white, fontSize: 30.0);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: primaryColor,
      expandedHeight: 400.0,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Column(
            children: [
              Text(
                "서울",
                style: ts,
              ),
              Text(
                DateTime.now().toString(),
                style: ts.copyWith(fontSize: 20.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Image.asset(
                "asset/img/mediocre.png",
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "보통",
                style: ts.copyWith(fontSize: 40.0, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "나쁘지 않네요",
                style: ts.copyWith(fontSize: 20.0, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
