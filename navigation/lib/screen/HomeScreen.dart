import 'package:flutter/material.dart';
import 'package:navigation/layout/MainLayout.dart';
import 'package:navigation/screen/RouteOneScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          // pop 가능 여부 ENUM - 기기의 강제 뒤로가기 기능 위한 Widget
          return true;
        } else {
          print('더 이상 pop 불가능하여 기기 뒤로가기 기능 미실행');
          return false;
        }
      },
      child: MainLayout(title: "HomeScreen", bodyWidget: [
        ElevatedButton(
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                // pop 가능 여부 ENUM
                Navigator.of(context).pop();
              } else {
                print('더 이상 pop 불가능');
              }
            },
            child: Text('Pop')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => RouteOneScreen()),
              );
            },
            child: Text('go RouteOne')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/one");
            },
            child: Text("go RouteOne Named")),
      ]),
    );
  }
}
