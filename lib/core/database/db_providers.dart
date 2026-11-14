import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/database/db.dart';

final dbProvider = Provider<Db>((ref) {
  final db = Db();
  ref.onDispose(db.close);
  return db;
});

final activeProfileIdProvider = Provider<int>((ref) => 1);

typedef SeriesQuery = ({String metricId, DateTime from, DateTime to});

final seriesProvider = StreamProvider.autoDispose
    .family<List<Measurement>, SeriesQuery>((ref, q) {
      final pid = ref.watch(activeProfileIdProvider);
      return ref.watch(dbProvider).watchRange(pid, q.metricId, q.from, q.to);
    });

final dbWatchProvider = StreamProvider.autoDispose<List<Measurement>>((ref) {
  final pid = ref.watch(activeProfileIdProvider);
  return ref.watch(dbProvider).watchAll(pid, null);
});

final indicatorHistoryProvider = StreamProvider.autoDispose
    .family<List<Measurement>, String>((ref, metricId) {
      final profileId = ref.watch(activeProfileIdProvider);
      final db = ref.watch(dbProvider);

      return db.watchAll(profileId, metricId);
    });

final latestProvider = StreamProvider.autoDispose.family<Measurement?, String>((
  ref,
  metricId,
) {
  final pid = ref.watch(activeProfileIdProvider);
  return ref.watch(dbProvider).watchLatest(pid, metricId);
});

final latestAllProvider = StreamProvider.autoDispose<List<Measurement>>((ref) {
  final pid = ref.watch(activeProfileIdProvider);
  return ref.watch(dbProvider).watchAllLatest(pid);
});

final settingProvider = StreamProvider.autoDispose.family<String?, String>((
  ref,
  key,
) {
  final pid = ref.watch(activeProfileIdProvider);
  return ref.watch(dbProvider).watchSetting(pid, key);
});
