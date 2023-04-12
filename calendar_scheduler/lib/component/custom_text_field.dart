import "package:calendar_scheduler/const/colors.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class CustomTextField extends StatelessWidget {
  final String label;
  final String inputType;
  final FormFieldSetter<String> onSaved;

  const CustomTextField(
      {required this.label,
      required this.inputType,
      required this.onSaved,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
        ),
        if (inputType == "number") _textField(),
        if (inputType == "text") Expanded(child: _textField()),
      ],
    );
  }

  Widget _textField() {
    return TextFormField(
      onSaved: onSaved,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "값을 입력해주세요.";
        }

        if (inputType == "number") {
          int time = int.parse(val);

          if (time < 0) return "0 이상의 숫자를 입력하세요.";
          if (time > 25) return "24 이하의 숫자를 입력하세요.";
        } else {
          if (val.length > 500) return "500자 이하로 입력하세요.";
        }
        return null;
      },
      cursorColor: Colors.grey,
      maxLines: inputType == "number" ? 1 : null,
      expands: inputType == "number" ? false : true,
      // 숫자 키보드
      keyboardType: inputType == "number"
          ? TextInputType.number
          : TextInputType.multiline,
      inputFormatters: inputType == "number"
          ?
          // 숫자만 허용
          [FilteringTextInputFormatter.digitsOnly]
          : [],
      decoration: InputDecoration(
          border: InputBorder.none, filled: true, fillColor: Colors.grey[300]),
    );
  }
}
