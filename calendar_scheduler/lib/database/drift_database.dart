// private 값들은 불러올 수 없다.
import "dart:io";
import "package:calendar_scheduler/model/category_color.dart";
import "package:calendar_scheduler/model/schedule.dart";
import "package:calendar_scheduler/model/schedule_with_color.dart";
import "package:drift/drift.dart";
import "package:drift/native.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";

// 1. private 값들까지 다 불러온다.
part 'drift_database.g.dart';

// 2. 데코레이터를 사용해서 사용할 클래스를 가져옴
@DriftDatabase(tables: [Schedules, CategoryColors])
// 3. 사용할 DB를 선언함
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColors(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    // 방법 1 정석
    // final query = select(schedules);
    // query.where((tbl) => tbl.date.equals(date));
    // return query.watch();
    // 방법 2
    // return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();

    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);
    query.where(schedules.date!.equals(date));

    return query.watch().map((rows) => rows
        .map((row) => ScheduleWithColor(
            schedule: row.readTable(schedules),
            categoryColor: row.readTable(categoryColors)))
        .toList());
  }

  @override
  // TODO: implement schemaVersion
  // DB의 table이 번경 할 때마다 버전 업해야함 초기값은 1
  int get schemaVersion => 1;
}

// 4. DB연결 설정
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "db.sqlite"));
    return NativeDatabase(file);
  });
}
