import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  const Calendar(
      {required this.selectedDay,
      required this.focusedDay,
      required this.onDaySelected,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
        color: Colors.grey[200], borderRadius: BorderRadius.circular(6));

    final defaultTextStyle =
        TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700);

    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      onDaySelected: onDaySelected,
      selectedDayPredicate: (DateTime day) {
        // 시분초까지 같을 필요는 없기 때문에 아래 분기로 코딩
        return day.year == selectedDay?.year &&
            day.month == selectedDay?.month &&
            day.day == selectedDay?.day;
      },
      calendarStyle: CalendarStyle(
          todayDecoration: defaultBoxDeco.copyWith(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: PRIMARY_COLOR, width: 1),
          ),
          todayTextStyle: defaultTextStyle,
          defaultTextStyle: defaultTextStyle,
          defaultDecoration: defaultBoxDeco,
          weekendDecoration: defaultBoxDeco,
          weekendTextStyle: defaultTextStyle,
          selectedDecoration: defaultBoxDeco.copyWith(
            color: PRIMARY_COLOR,
          ),
          selectedTextStyle: defaultTextStyle.copyWith(color: Colors.white),
          outsideDecoration: BoxDecoration(shape: BoxShape.rectangle)),
    );
  }
}
