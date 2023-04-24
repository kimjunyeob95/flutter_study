import "package:calendar_scheduler/component/custom_text_field.dart";
import "package:calendar_scheduler/const/colors.dart";
import "package:calendar_scheduler/database/drift_database.dart";
import "package:calendar_scheduler/model/category_color.dart";
import "package:drift/drift.dart" show Value;
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime seletedDate;
  final int? scheduleId;

  const ScheduleBottomSheet(
      {required this.seletedDate, this.scheduleId, Key? key})
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

  String getStartTime = "";
  String getEndTime = "";
  String getContent = "";

  bool modify = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId != null
              ? GetIt.I<LocalDatabase>().getSchedule(widget.scheduleId!)
              : null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('스케줄을 불러오지 못했습니다.'),
              );
            }

            // futuebuild가 처음 실행되었고 로딩중일때
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              getStartTime = snapshot.data!.startTime.toString().padLeft(2, "0");
              getEndTime = snapshot.data!.endTime.toString().padLeft(2, "0");
              getContent = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorId;
              modify = true;
            }

            return SafeArea(
              child: Container(
                  color: Colors.white,
                  height:
                  (MediaQuery
                      .of(context)
                      .size
                      .height / 2) + bottomInset,
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
                                getStartTime: getStartTime,
                                getEndTime: getEndTime,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              _Content(
                                onContentSaved: onContentSaved,
                                getContent: getContent,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              FutureBuilder<List<CategoryColor>>(
                                  future: GetIt.I<LocalDatabase>()
                                      .getCategoryColors(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        selectedColorId == null &&
                                        snapshot.data!.isNotEmpty) {
                                      selectedColorId = snapshot.data![0].id;
                                    }
                                    return _ColorPicker(
                                      colors: snapshot.hasData
                                          ? snapshot.data!
                                          : [],
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
                                modify: modify,
                              ),
                            ],
                          ),
                        )),
                  )),
            );
          }),
    );
  }

  void onSavePressed() async {
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
            colorId: Value(selectedColorId!)),
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
  final String getStartTime;
  final String getEndTime;

  const _Time({required this.onStartSaved,
    required this.onEndSaved,
    required this.getStartTime,
    required this.getEndTime,
    Key? key})
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
              initialText: getStartTime,
            )),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            child: CustomTextField(
              label: "마감 시간",
              inputType: "number",
              onSaved: onEndSaved,
              initialText: getEndTime,
            )),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onContentSaved;
  final String getContent;

  const _Content(
      {required this.onContentSaved, required this.getContent, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomTextField(
          label: "내용",
          inputType: "text",
          onSaved: onContentSaved,
          initialText: getContent,
        ));
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({required this.colors,
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
          .map((e) =>
          GestureDetector(
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
  final bool modify;

  const _SaveButton({required this.onPressed,
    required this.modify, Key? key}) : super(key: key);

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
                child: modify ? Text('수정') : Text('저장'))),
      ],
    );
  }
}
