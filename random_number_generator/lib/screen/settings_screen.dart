import "package:flutter/material.dart";
import "package:random_number_generator/component/number_row.dart";
import "package:random_number_generator/constant/color.dart";

class SettingsScreen extends StatefulWidget {
  final int maxNumber;

  const SettingsScreen({required this.maxNumber, Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double maxNumber = 10000.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      maxNumber = widget.maxNumber.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Scaffold(
          backgroundColor: PRIMARY_COLOR,
          body: Column(
            children: [
              _Body(
                maxNumber: maxNumber,
              ),
              _Footer(
                maxNumber: maxNumber,
                onChanged: setMaxNumber,
                onPressed: saveMaxNumber,
              )
            ],
          ),
        ),
      ),
    );
  }

  void setMaxNumber(double val) {
    setState(() {
      maxNumber = val;
    });
  }

  void saveMaxNumber() {
    Navigator.of(context).pop(maxNumber.toInt());
  }
}

class _Body extends StatelessWidget {
  final double maxNumber;

  const _Body({required this.maxNumber, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NumberRow(number: maxNumber.toInt(),),
    );
  }
}

class _Footer extends StatelessWidget {
  final double maxNumber;
  final ValueChanged<double>? onChanged;
  final VoidCallback onPressed;

  const _Footer(
      {required this.maxNumber,
      required this.onChanged,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(value: maxNumber, min: 1000, max: 10000, onChanged: onChanged),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text('저장'),
              style: ElevatedButton.styleFrom(primary: RED_COLOR),
            ))
      ],
    );
  }
}
