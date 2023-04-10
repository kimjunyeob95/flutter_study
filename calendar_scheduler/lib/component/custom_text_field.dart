import "package:calendar_scheduler/const/colors.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class CustomTextField extends StatelessWidget {
  final String label;
  final String inputType;

  const CustomTextField(
      {required this.label, required this.inputType, Key? key})
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
        if (inputType == "number") _textField(inputType),
        if (inputType == "text") Expanded(child: _textField(inputType)),
      ],
    );
  }

  Widget _textField(type) {
    return TextField(
      cursorColor: Colors.grey,
      maxLines: type == "number" ? 1 : null,
      expands: type == "number" ? false : true,
      // 숫자 키보드
      keyboardType:
          type == "number" ? TextInputType.number : TextInputType.multiline,
      inputFormatters: type == "number"
          ?
          // 숫자만 허용
          [FilteringTextInputFormatter.digitsOnly]
          : [],
      decoration: InputDecoration(
          border: InputBorder.none, filled: true, fillColor: Colors.grey[300]),
    );
  }
}
