import "package:calendar_scheduler/component/custom_text_field.dart";
import "package:calendar_scheduler/const/colors.dart";
import "package:flutter/material.dart";

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;

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
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 8,
                    right: 8,
                  ),
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Time(
                          onStartSaved: onStartSaved,
                          onEndSaved: onEndSaved,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _Content(
                          onContentSaved: onContentSaved,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const _ColorPicker(),
                        const SizedBox(
                          height: 8,
                        ),
                        _SaveButton(
                          onPressed: onSavePressed,
                        ),
                      ],
                    ),
                  )),
            )),
      ),
    );
  }

  void onSavePressed() {
    if (formKey.currentState == null) {
      // formKey는 생성했는데 Form위젯과 결합이 안되었을 경우
      // 이미 key에 설정을 해놔서 현재 상황에서는 해당 안되긴함
      return;
    }

    // TextFormField에서 validator를 1차로 거쳐서 옴
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }
  }

  void onStartSaved(String? val){
    startTime = int.parse(val!);
  }
  void onEndSaved(String? val){
    endTime = int.parse(val!);
  }
  void onContentSaved(String? val){
    content = val!;
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;

  const _Time({required this.onStartSaved, required this.onEndSaved, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          label: "시작 시간",
          inputType: "number",
          onSaved: onStartSaved,
        )),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            child: CustomTextField(
          label: "마감 시간",
          inputType: "number",
          onSaved: onEndSaved,
        )),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onContentSaved;

  const _Content({required this.onContentSaved, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomTextField(
      label: "내용",
      inputType: "text",
      onSaved: onContentSaved,
    ));
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
  final VoidCallback onPressed;

  const _SaveButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                onPressed: onPressed,
                child: Text('저장'))),
      ],
    );
  }
}
