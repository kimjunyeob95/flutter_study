import 'package:dusty_dust/const/regions.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final String region;
  final void Function(String) onSelectedRegion;
  final Color darkColor;
  final Color lightColor;

  const MainDrawer(
      {required this.region,
      required this.onSelectedRegion,
      required this.darkColor,
      required this.lightColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: darkColor,
      child: ListView(
        children: [
          DrawerHeader(
              child: Text(
            "지역 선택",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          )),
          ...regions
              .map((e) => ListTile(
                    tileColor: Colors.white,
                    selectedTileColor: lightColor,
                    selectedColor: Colors.black,
                    selected: e == region,
                    onTap: () {
                      onSelectedRegion(e.toString());
                    },
                    title: Text(e),
                  ))
              .toList()
        ],
      ),
    );
  }
}
