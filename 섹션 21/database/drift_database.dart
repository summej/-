import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fluttertest/model/category_color.dart';
import 'package:fluttertest/model/schedule.dart';
import 'package:fluttertest/model/schedule_with_color.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<Schedule> getScheduleById(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((tbl) => tbl.id.equals((id)))).write(data);

  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  Stream<List<ScheduleWitchColor>> watchSchedules(DateTime date) {
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);

    query.where(schedules.date.equals(date));
    query.orderBy(
      [
        OrderingTerm.asc(schedules.startTime),
      ],
    );

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWitchColor(
                  schedule: row.readTable(schedules),
                  categoryColor: row.readTable(categoryColors),
                ),
              )
              .toList(),
        );
    // return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
