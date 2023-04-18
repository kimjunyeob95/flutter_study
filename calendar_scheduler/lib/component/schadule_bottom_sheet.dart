import "package:calendar_scheduler/component/custom_text_field.dart";
import "package:calendar_scheduler/const/colors.dart";
import "package:calendar_scheduler/database/drift_database.dart";
import "package:calendar_scheduler/model/category_color.dart";
import "package:drift/drift.dart" show Value;
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime seletedDate;

  const ScheduleBottomSheet({required this.seletedDate, Key? key})
      : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

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
                    // autovalidateMode: AutovalidateMode.always, // 자동 validation
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
                        FutureBuilder<List<CategoryColor>>(
                            future:
                                GetIt.I<LocalDatabase>().getCategoryColors(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  selectedColorId == null &&
                                  snapshot.data!.isNotEmpty) {
                                selectedColorId = snapshot.data![0].id;
                              }
                              return _ColorPicker(
                                colors: snapshot.hasData ? snapshot.data! : [],
                                selectedColorId: selectedColorId,
                                colorIdSetter: (int id) {
                                  setState(() {
                                    selectedColorId = id;
                                  });
                                },
                              );
                            }),
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

  void onSavePressed() async{
    if (formKey.currentState == null) {
      // formKey는 생성했는데 Form위젯과 결합이 안되었을 경우
      // 이미 key에 설정을 해놔서 현재 상황에서는 해당 안되긴함
      return;
    }

    // TextFormField에서 validator를 1차로 거쳐서 옴
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final key = await await GetIt.I<LocalDatabase>().createSchedule(
        SchedulesCompanion(
            date: Value(widget.seletedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!)
        ),
      );

      print("save 완료 key: $key");
      Navigator.of(context).pop();
    }
  }

  void onStartSaved(String? val) {
    startTime = int.parse(val!);
  }

  void onEndSaved(String? val) {
    endTime = int.parse(val!);
  }

  void onContentSaved(String? val) {
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

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker(
      {required this.colors,
      required this.selectedColorId,
      required this.colorIdSetter,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: colors
          .map((e) => GestureDetector(
                onTap: () {
                  colorIdSetter(e.id);
                },
                child: renderColor(e, selectedColorId == e.id ? true : false),
              ))
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, isSelected) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(int.parse('FF${color.hexCode}', radix: 16)),
          border: isSelected == true
              ? Border.all(color: Colors.black, width: 4)
              : null),
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
