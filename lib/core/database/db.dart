import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:pulse/core/database/db_tables.dart';

part 'db.g.dart';

@DriftDatabase(tables: [Profiles, ProfileSettings, Measurements])
class Db extends _$Db {
  Db() : super(driftDatabase(name: 'telemetry'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await into(profiles)
          .insert(ProfilesCompanion.insert(name: 'Astronaut 1'));
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );

  Future<int> addMeasurement(
    int profileId,
    String metricId,
    List<double> values, {
    DateTime? at,
  }) {
    assert(values.isNotEmpty && values.length <= 4);
    return into(measurements).insert(
      MeasurementsCompanion.insert(
        profileId: profileId,
        metricId: metricId,
        takenAt: (at ?? DateTime.now()).toUtc(),
        v0: values[0],
        v1: Value(values.length > 1 ? values[1] : null),
        v2: Value(values.length > 2 ? values[2] : null),
        v3: Value(values.length > 3 ? values[3] : null),
      ),
    );
  }

  SimpleSelectStatement<$MeasurementsTable, Measurement> _query(
    int profileId, {
    String? metricId,
    DateTime? from,
    DateTime? to,
  }) {
    return select(measurements)
      ..where((m) {
        var cond = m.profileId.equals(profileId);
        if (metricId != null) cond = cond & m.metricId.equals(metricId);
        if (from != null) {
          cond = cond & m.takenAt.isBiggerOrEqualValue(from.toUtc());
        }
        if (to != null) {
          cond = cond & m.takenAt.isSmallerOrEqualValue(to.toUtc());
        }
        return cond;
      })
      ..orderBy([(m) => OrderingTerm.asc(m.takenAt)]);
  }

  Future<List<Measurement>> getAll(int profileId, String? metricId) {
    return _query(profileId, metricId: metricId).get();
  }

  Stream<List<Measurement>> watchAll(int profileId, String? metricId) {
    return _query(profileId, metricId: metricId).watch();
  }

  Future<List<Measurement>> getRange(
    int profileId,
    String metricId,
    DateTime from,
    DateTime to,
  ) {
    return _query(profileId, metricId: metricId, from: from, to: to).get();
  }

  Stream<List<Measurement>> watchRange(
    int profileId,
    String metricId,
    DateTime from,
    DateTime to,
  ) {
    return _query(profileId, metricId: metricId, from: from, to: to).watch();
  }

  Future<int> editMeasurementFields({
    required int id,
    DateTime? takenAt,
    double? v0,
    Value<double?> v1 = const Value.absent(),
    Value<double?> v2 = const Value.absent(),
    Value<double?> v3 = const Value.absent(),
  }) {
    return (update(measurements)..where((m) => m.id.equals(id))).write(
      MeasurementsCompanion(
        takenAt: takenAt != null
            ? Value(takenAt.toUtc())
            : const Value.absent(),
        v0: v0 != null ? Value(v0) : const Value.absent(),
        v1: v1,
        v2: v2,
        v3: v3,
      ),
    );
  }

  Future<bool> editMeasurement(Measurement measurement) {
    return update(measurements).replace(measurement);
  }

  Future<int> deleteMeasurement(int id) {
    return (delete(measurements)..where((m) => m.id.equals(id))).go();
  }

  Future<int> deleteMetricData(int profileId, String metricId) {
    return (delete(measurements)..where(
          (m) => m.profileId.equals(profileId) & m.metricId.equals(metricId),
        ))
        .go();
  }

  Future<int> deleteAllData(int profileId) {
    return (delete(
      measurements,
    )..where((m) => m.profileId.equals(profileId))).go();
  }

  Stream<Measurement?> watchLatest(int profileId, String metricId) {
    return (select(measurements)
          ..where(
            (m) => m.profileId.equals(profileId) & m.metricId.equals(metricId),
          )
          ..orderBy([(m) => OrderingTerm.desc(m.takenAt)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Stream<List<Measurement>> watchAllLatest(int profileId) {
    return customSelect(
      '''
    SELECT m1.* FROM measurements m1
    INNER JOIN (
      SELECT metric_id, MAX(taken_at) as max_date
      FROM measurements
      WHERE profile_id = ?
      GROUP BY metric_id
    ) m2 ON m1.metric_id = m2.metric_id AND m1.taken_at = m2.max_date
    WHERE m1.profile_id = ?
    ORDER BY m1.taken_at DESC
    ''',
      variables: [Variable.withInt(profileId), Variable.withInt(profileId)],
      readsFrom: {measurements},
    ).watch().map(
      (rows) => rows.map((row) => measurements.map(row.data)).toList(),
    );
  }

  Stream<String?> watchSetting(int profileId, String key) {
    return (select(profileSettings)
          ..where((s) => s.profileId.equals(profileId) & s.key.equals(key)))
        .watchSingleOrNull()
        .map((row) => row?.value);
  }

  Future<void> setSetting(int profileId, String key, String value) {
    return into(profileSettings).insertOnConflictUpdate(
      ProfileSettingsCompanion.insert(
        profileId: profileId,
        key: key,
        value: value,
      ),
    );
  }
}

extension MeasurementValues on Measurement {
  List<double?> get values => [v0, v1, v2, v3];

  List<double> valuesFor(int fieldCount) =>
      values.take(fieldCount).whereType<double>().toList();
}
