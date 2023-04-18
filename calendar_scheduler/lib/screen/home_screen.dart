import "package:calendar_scheduler/component/schadule_bottom_sheet.dart";
import "package:calendar_scheduler/component/schedule_card.dart";
import "package:calendar_scheduler/component/today_banner.dart";
import "package:calendar_scheduler/const/colors.dart";
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
      floatingActionButton: renderFlaotingActionButton(),
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
            _ScheduleList(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFlaotingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return ScheduleBottomSheet(
                seletedDate: selectedDay,
              );
            });
      },
      backgroundColor: PRIMARY_COLOR,
      child: const Icon(Icons.add),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.separated(
          itemCount: 3,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 8,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return ScheduleCard(
                startTime: 3, endTime: 4, content: "내용", color: Colors.red);
          },
        ),
      ),
    );
  }
}
