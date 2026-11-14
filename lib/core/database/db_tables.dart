import 'package:drift/drift.dart';

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class ProfileSettings extends Table {
  IntColumn get profileId =>
      integer().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get key => text()(); // 'units', 'theme', 'reminder_time'
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {profileId, key};
}

@TableIndex(name: 'meas_idx', columns: {#profileId, #metricId, #takenAt})
class Measurements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId =>
      integer().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get metricId => text()(); // 'hr', 'bp', ...
  DateTimeColumn get takenAt => dateTime()();
  RealColumn get v0 => real()(); // First / main value
  RealColumn get v1 => real().nullable()();
  RealColumn get v2 => real().nullable()();
  RealColumn get v3 => real().nullable()();
}
