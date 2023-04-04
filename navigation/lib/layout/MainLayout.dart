import "package:flutter/material.dart";

class MainLayout extends StatelessWidget {
  final String title;
  final List<Widget> bodyWidget;
  const MainLayout({required this.title, required this.bodyWidget, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(title)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: bodyWidget,
          ),
        ),
      ),
    );
  }
}
