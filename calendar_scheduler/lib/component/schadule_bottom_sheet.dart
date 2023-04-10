import "package:calendar_scheduler/component/custom_text_field.dart";
import "package:calendar_scheduler/const/colors.dart";
import "package:flutter/material.dart";

class ScheduleBottomSheet extends StatelessWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Container(
            color: Colors.white,
            height: (MediaQuery.of(context).size.height / 2) + bottomInset,
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Time(),
                    SizedBox(
                      height: 16,
                    ),
                    _Content(),
                    SizedBox(
                      height: 16,
                    ),
                    _ColorPicker(),
                    SizedBox(
                      height: 8,
                    ),
                    _SaveButton(),
                  ],
                ))),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
            child: CustomTextField(
          label: "시작 시간",
          inputType: "number",
        )),
        SizedBox(
          width: 16,
        ),
        Expanded(child: CustomTextField(label: "마감 시간", inputType: "number")),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: CustomTextField(label: "내용", inputType: "text"));
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colorList = [Colors.red, Colors.yellow, Colors.black];

    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: colorList.map((e) => renderColor(e)).toList(),
    );
  }

  Widget renderColor(Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 32,
      height: 32,
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                onPressed: () {},
                child: Text('저장'))),
      ],
    );
  }
}
