import "package:calendar_scheduler/component/schadule_bottom_sheet.dart";
import "package:calendar_scheduler/component/schedule_card.dart";
import "package:calendar_scheduler/component/today_banner.dart";
import "package:calendar_scheduler/const/colors.dart";
import "package:calendar_scheduler/database/drift_database.dart";
import "package:calendar_scheduler/model/schedule_with_color.dart";
import "package:flutter/material.dart";
import "package:calendar_scheduler/component/calendar.dart";
import "package:get_it/get_it.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
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
            _ScheduleList(selectedDay: selectedDay),
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
  final DateTime selectedDay;

  const _ScheduleList({required this.selectedDay, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder<List<ScheduleWithColor>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                // 데이터 불러올 때 hasData = null 체크
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if(snapshot.data!.isEmpty && snapshot.hasData){
                return const Center(child: Text('등록 된 스케줄이 없습니다.'),);
              }

              return ListView.separated(
                itemCount: snapshot.hasData ?  snapshot.data!.length : 0,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 8,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  if (!snapshot.hasData) return null;

                  final scheduleWithColor = snapshot.data![index];
                  return ScheduleCard(
                      startTime: scheduleWithColor.schedule.startTime,
                      endTime: scheduleWithColor.schedule.endTime,
                      content: scheduleWithColor.schedule.content,
                      color: Color(int.parse('FF${scheduleWithColor.categoryColor.hexCode}', radix: 16)),
                  );
                },
              );
            }),
      ),
    );
  }
}
