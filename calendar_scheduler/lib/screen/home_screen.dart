import "package:calendar_scheduler/component/schedule_card.dart";
import "package:calendar_scheduler/component/today_banner.dart";
import "package:flutter/material.dart";
import "package:calendar_scheduler/component/calendar.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
                selectedDay: selectedDay,
                focusedDay: focusedDay,
                onDaySelected: onDaySelected),
            const SizedBox(
              height: 8,
            ),
            TodayBanner(
              selectedDay: selectedDay,
              scheduleCount: 3,
            ),
            const SizedBox(
              height: 8,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ScheduleCard(
                  startTime: 3, endTime: 4, content: "내용", color: Colors.red),
            )
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}
