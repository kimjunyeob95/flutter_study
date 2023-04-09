import "package:calendar_scheduler/const/colors.dart";
import "package:flutter/material.dart";

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;
  final Color color;

  const ScheduleCard(
      {required this.startTime,
      required this.endTime,
      required this.content,
      required this.color,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: PRIMARY_COLOR, width: 1),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(
                startTime: startTime,
                endTime: endTime,
              ),
              const SizedBox(
                width: 16,
              ),
              _Content(content: content),
              const SizedBox(
                width: 16,
              ),
              _Category(color: color)
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  const _Time({required this.startTime, required this.endTime, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        color: PRIMARY_COLOR, fontSize: 16, fontWeight: FontWeight.w600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${startTime.toString().padLeft(2, "0")}:00",
          style: textStyle,
        ),
        Text(
          "${endTime.toString().padLeft(2, "0")}:00",
          style: textStyle.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(content),
    );
  }
}

class _Category extends StatelessWidget {
  final Color color;

  const _Category({required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: 16,
      height: 16,
    );
  }
}
