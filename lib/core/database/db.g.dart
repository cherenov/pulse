// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String name;
  const Profile({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(id: Value(id), name: Value(name));
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Profile copyWith({int? id, String? name}) =>
      Profile(id: id ?? this.id, name: name ?? this.name);
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile && other.id == this.id && other.name == this.name);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> name;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ProfilesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ProfilesCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ProfileSettingsTable extends ProfileSettings
    with TableInfo<$ProfileSettingsTable, ProfileSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, key};
  @override
  ProfileSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileSetting(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $ProfileSettingsTable createAlias(String alias) {
    return $ProfileSettingsTable(attachedDatabase, alias);
  }
}

class ProfileSetting extends DataClass implements Insertable<ProfileSetting> {
  final int profileId;
  final String key;
  final String value;
  const ProfileSetting({
    required this.profileId,
    required this.key,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  ProfileSettingsCompanion toCompanion(bool nullToAbsent) {
    return ProfileSettingsCompanion(
      profileId: Value(profileId),
      key: Value(key),
      value: Value(value),
    );
  }

  factory ProfileSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileSetting(
      profileId: serializer.fromJson<int>(json['profileId']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  ProfileSetting copyWith({int? profileId, String? key, String? value}) =>
      ProfileSetting(
        profileId: profileId ?? this.profileId,
        key: key ?? this.key,
        value: value ?? this.value,
      );
  ProfileSetting copyWithCompanion(ProfileSettingsCompanion data) {
    return ProfileSetting(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileSetting(')
          ..write('profileId: $profileId, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileSetting &&
          other.profileId == this.profileId &&
          other.key == this.key &&
          other.value == this.value);
}

class ProfileSettingsCompanion extends UpdateCompanion<ProfileSetting> {
  final Value<int> profileId;
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const ProfileSettingsCompanion({
    this.profileId = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfileSettingsCompanion.insert({
    required int profileId,
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       key = Value(key),
       value = Value(value);
  static Insertable<ProfileSetting> custom({
    Expression<int>? profileId,
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfileSettingsCompanion copyWith({
    Value<int>? profileId,
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return ProfileSettingsCompanion(
      profileId: profileId ?? this.profileId,
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileSettingsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasurementsTable extends Measurements
    with TableInfo<$MeasurementsTable, Measurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _metricIdMeta = const VerificationMeta(
    'metricId',
  );
  @override
  late final GeneratedColumn<String> metricId = GeneratedColumn<String>(
    'metric_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _v0Meta = const VerificationMeta('v0');
  @override
  late final GeneratedColumn<double> v0 = GeneratedColumn<double>(
    'v0',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _v1Meta = const VerificationMeta('v1');
  @override
  late final GeneratedColumn<double> v1 = GeneratedColumn<double>(
    'v1',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _v2Meta = const VerificationMeta('v2');
  @override
  late final GeneratedColumn<double> v2 = GeneratedColumn<double>(
    'v2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _v3Meta = const VerificationMeta('v3');
  @override
  late final GeneratedColumn<double> v3 = GeneratedColumn<double>(
    'v3',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    metricId,
    takenAt,
    v0,
    v1,
    v2,
    v3,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Measurement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('metric_id')) {
      context.handle(
        _metricIdMeta,
        metricId.isAcceptableOrUnknown(data['metric_id']!, _metricIdMeta),
      );
    } else if (isInserting) {
      context.missing(_metricIdMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('v0')) {
      context.handle(_v0Meta, v0.isAcceptableOrUnknown(data['v0']!, _v0Meta));
    } else if (isInserting) {
      context.missing(_v0Meta);
    }
    if (data.containsKey('v1')) {
      context.handle(_v1Meta, v1.isAcceptableOrUnknown(data['v1']!, _v1Meta));
    }
    if (data.containsKey('v2')) {
      context.handle(_v2Meta, v2.isAcceptableOrUnknown(data['v2']!, _v2Meta));
    }
    if (data.containsKey('v3')) {
      context.handle(_v3Meta, v3.isAcceptableOrUnknown(data['v3']!, _v3Meta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Measurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Measurement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      metricId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric_id'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      v0: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}v0'],
      )!,
      v1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}v1'],
      ),
      v2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}v2'],
      ),
      v3: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}v3'],
      ),
    );
  }

  @override
  $MeasurementsTable createAlias(String alias) {
    return $MeasurementsTable(attachedDatabase, alias);
  }
}

class Measurement extends DataClass implements Insertable<Measurement> {
  final int id;
  final int profileId;
  final String metricId;
  final DateTime takenAt;
  final double v0;
  final double? v1;
  final double? v2;
  final double? v3;
  const Measurement({
    required this.id,
    required this.profileId,
    required this.metricId,
    required this.takenAt,
    required this.v0,
    this.v1,
    this.v2,
    this.v3,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['metric_id'] = Variable<String>(metricId);
    map['taken_at'] = Variable<DateTime>(takenAt);
    map['v0'] = Variable<double>(v0);
    if (!nullToAbsent || v1 != null) {
      map['v1'] = Variable<double>(v1);
    }
    if (!nullToAbsent || v2 != null) {
      map['v2'] = Variable<double>(v2);
    }
    if (!nullToAbsent || v3 != null) {
      map['v3'] = Variable<double>(v3);
    }
    return map;
  }

  MeasurementsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      metricId: Value(metricId),
      takenAt: Value(takenAt),
      v0: Value(v0),
      v1: v1 == null && nullToAbsent ? const Value.absent() : Value(v1),
      v2: v2 == null && nullToAbsent ? const Value.absent() : Value(v2),
      v3: v3 == null && nullToAbsent ? const Value.absent() : Value(v3),
    );
  }

  factory Measurement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Measurement(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      metricId: serializer.fromJson<String>(json['metricId']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      v0: serializer.fromJson<double>(json['v0']),
      v1: serializer.fromJson<double?>(json['v1']),
      v2: serializer.fromJson<double?>(json['v2']),
      v3: serializer.fromJson<double?>(json['v3']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'metricId': serializer.toJson<String>(metricId),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'v0': serializer.toJson<double>(v0),
      'v1': serializer.toJson<double?>(v1),
      'v2': serializer.toJson<double?>(v2),
      'v3': serializer.toJson<double?>(v3),
    };
  }

  Measurement copyWith({
    int? id,
    int? profileId,
    String? metricId,
    DateTime? takenAt,
    double? v0,
    Value<double?> v1 = const Value.absent(),
    Value<double?> v2 = const Value.absent(),
    Value<double?> v3 = const Value.absent(),
  }) => Measurement(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    metricId: metricId ?? this.metricId,
    takenAt: takenAt ?? this.takenAt,
    v0: v0 ?? this.v0,
    v1: v1.present ? v1.value : this.v1,
    v2: v2.present ? v2.value : this.v2,
    v3: v3.present ? v3.value : this.v3,
  );
  Measurement copyWithCompanion(MeasurementsCompanion data) {
    return Measurement(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      metricId: data.metricId.present ? data.metricId.value : this.metricId,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      v0: data.v0.present ? data.v0.value : this.v0,
      v1: data.v1.present ? data.v1.value : this.v1,
      v2: data.v2.present ? data.v2.value : this.v2,
      v3: data.v3.present ? data.v3.value : this.v3,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Measurement(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('metricId: $metricId, ')
          ..write('takenAt: $takenAt, ')
          ..write('v0: $v0, ')
          ..write('v1: $v1, ')
          ..write('v2: $v2, ')
          ..write('v3: $v3')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, metricId, takenAt, v0, v1, v2, v3);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Measurement &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.metricId == this.metricId &&
          other.takenAt == this.takenAt &&
          other.v0 == this.v0 &&
          other.v1 == this.v1 &&
          other.v2 == this.v2 &&
          other.v3 == this.v3);
}

class MeasurementsCompanion extends UpdateCompanion<Measurement> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> metricId;
  final Value<DateTime> takenAt;
  final Value<double> v0;
  final Value<double?> v1;
  final Value<double?> v2;
  final Value<double?> v3;
  const MeasurementsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.metricId = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.v0 = const Value.absent(),
    this.v1 = const Value.absent(),
    this.v2 = const Value.absent(),
    this.v3 = const Value.absent(),
  });
  MeasurementsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String metricId,
    required DateTime takenAt,
    required double v0,
    this.v1 = const Value.absent(),
    this.v2 = const Value.absent(),
    this.v3 = const Value.absent(),
  }) : profileId = Value(profileId),
       metricId = Value(metricId),
       takenAt = Value(takenAt),
       v0 = Value(v0);
  static Insertable<Measurement> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? metricId,
    Expression<DateTime>? takenAt,
    Expression<double>? v0,
    Expression<double>? v1,
    Expression<double>? v2,
    Expression<double>? v3,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (metricId != null) 'metric_id': metricId,
      if (takenAt != null) 'taken_at': takenAt,
      if (v0 != null) 'v0': v0,
      if (v1 != null) 'v1': v1,
      if (v2 != null) 'v2': v2,
      if (v3 != null) 'v3': v3,
    });
  }

  MeasurementsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? metricId,
    Value<DateTime>? takenAt,
    Value<double>? v0,
    Value<double?>? v1,
    Value<double?>? v2,
    Value<double?>? v3,
  }) {
    return MeasurementsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      metricId: metricId ?? this.metricId,
      takenAt: takenAt ?? this.takenAt,
      v0: v0 ?? this.v0,
      v1: v1 ?? this.v1,
      v2: v2 ?? this.v2,
      v3: v3 ?? this.v3,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (metricId.present) {
      map['metric_id'] = Variable<String>(metricId.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (v0.present) {
      map['v0'] = Variable<double>(v0.value);
    }
    if (v1.present) {
      map['v1'] = Variable<double>(v1.value);
    }
    if (v2.present) {
      map['v2'] = Variable<double>(v2.value);
    }
    if (v3.present) {
      map['v3'] = Variable<double>(v3.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('metricId: $metricId, ')
          ..write('takenAt: $takenAt, ')
          ..write('v0: $v0, ')
          ..write('v1: $v1, ')
          ..write('v2: $v2, ')
          ..write('v3: $v3')
          ..write(')'))
        .toString();
  }
}

abstract class _$Db extends GeneratedDatabase {
  _$Db(QueryExecutor e) : super(e);
  $DbManager get managers => $DbManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $ProfileSettingsTable profileSettings = $ProfileSettingsTable(
    this,
  );
  late final $MeasurementsTable measurements = $MeasurementsTable(this);
  late final Index measIdx = Index(
    'meas_idx',
    'CREATE INDEX meas_idx ON measurements (profile_id, metric_id, taken_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    profileSettings,
    measurements,
    measIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('profile_settings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('measurements', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$Db, $ProfilesTable, Profile> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProfileSettingsTable, List<ProfileSetting>>
  _profileSettingsRefsTable(_$Db db) => MultiTypedResultKey.fromTable(
    db.profileSettings,
    aliasName: 'profiles__id__profile_settings__profile_id',
  );

  $$ProfileSettingsTableProcessedTableManager get profileSettingsRefs {
    final manager = $$ProfileSettingsTableTableManager(
      $_db,
      $_db.profileSettings,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _profileSettingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MeasurementsTable, List<Measurement>>
  _measurementsRefsTable(_$Db db) => MultiTypedResultKey.fromTable(
    db.measurements,
    aliasName: 'profiles__id__measurements__profile_id',
  );

  $$MeasurementsTableProcessedTableManager get measurementsRefs {
    final manager = $$MeasurementsTableTableManager(
      $_db,
      $_db.measurements,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_measurementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer extends Composer<_$Db, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> profileSettingsRefs(
    Expression<bool> Function($$ProfileSettingsTableFilterComposer f) f,
  ) {
    final $$ProfileSettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profileSettings,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileSettingsTableFilterComposer(
            $db: $db,
            $table: $db.profileSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> measurementsRefs(
    Expression<bool> Function($$MeasurementsTableFilterComposer f) f,
  ) {
    final $$MeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer extends Composer<_$Db, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer extends Composer<_$Db, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> profileSettingsRefs<T extends Object>(
    Expression<T> Function($$ProfileSettingsTableAnnotationComposer a) f,
  ) {
    final $$ProfileSettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profileSettings,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileSettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.profileSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> measurementsRefs<T extends Object>(
    Expression<T> Function($$MeasurementsTableAnnotationComposer a) f,
  ) {
    final $$MeasurementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableAnnotationComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$Db,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, $$ProfilesTableReferences),
          Profile,
          PrefetchHooks Function({
            bool profileSettingsRefs,
            bool measurementsRefs,
          })
        > {
  $$ProfilesTableTableManager(_$Db db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => ProfilesCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => ProfilesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileSettingsRefs = false, measurementsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (profileSettingsRefs) db.profileSettings,
                    if (measurementsRefs) db.measurements,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (profileSettingsRefs)
                        await $_getPrefetchedDataByColumns<
                          Profile,
                          $ProfilesTable,
                          ProfileSetting,
                          $ProfileSettingsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._profileSettingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).profileSettingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (measurementsRefs)
                        await $_getPrefetchedDataByColumns<
                          Profile,
                          $ProfilesTable,
                          Measurement,
                          $MeasurementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._measurementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).measurementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$Db,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, $$ProfilesTableReferences),
      Profile,
      PrefetchHooks Function({bool profileSettingsRefs, bool measurementsRefs})
    >;
typedef $$ProfileSettingsTableCreateCompanionBuilder =
    ProfileSettingsCompanion Function({
      required int profileId,
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$ProfileSettingsTableUpdateCompanionBuilder =
    ProfileSettingsCompanion Function({
      Value<int> profileId,
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

final class $$ProfileSettingsTableReferences
    extends BaseReferences<_$Db, $ProfileSettingsTable, ProfileSetting> {
  $$ProfileSettingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$Db db) =>
      db.profiles.createAlias('profile_settings__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProfileSettingsTableFilterComposer
    extends Composer<_$Db, $ProfileSettingsTable> {
  $$ProfileSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileSettingsTableOrderingComposer
    extends Composer<_$Db, $ProfileSettingsTable> {
  $$ProfileSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileSettingsTableAnnotationComposer
    extends Composer<_$Db, $ProfileSettingsTable> {
  $$ProfileSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileSettingsTableTableManager
    extends
        RootTableManager<
          _$Db,
          $ProfileSettingsTable,
          ProfileSetting,
          $$ProfileSettingsTableFilterComposer,
          $$ProfileSettingsTableOrderingComposer,
          $$ProfileSettingsTableAnnotationComposer,
          $$ProfileSettingsTableCreateCompanionBuilder,
          $$ProfileSettingsTableUpdateCompanionBuilder,
          (ProfileSetting, $$ProfileSettingsTableReferences),
          ProfileSetting,
          PrefetchHooks Function({bool profileId})
        > {
  $$ProfileSettingsTableTableManager(_$Db db, $ProfileSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfileSettingsCompanion(
                profileId: profileId,
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => ProfileSettingsCompanion.insert(
                profileId: profileId,
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfileSettingsTable, ProfileSetting>(table),
                  $$ProfileSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$ProfileSettingsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$ProfileSettingsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProfileSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$Db,
      $ProfileSettingsTable,
      ProfileSetting,
      $$ProfileSettingsTableFilterComposer,
      $$ProfileSettingsTableOrderingComposer,
      $$ProfileSettingsTableAnnotationComposer,
      $$ProfileSettingsTableCreateCompanionBuilder,
      $$ProfileSettingsTableUpdateCompanionBuilder,
      (ProfileSetting, $$ProfileSettingsTableReferences),
      ProfileSetting,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$MeasurementsTableCreateCompanionBuilder =
    MeasurementsCompanion Function({
      Value<int> id,
      required int profileId,
      required String metricId,
      required DateTime takenAt,
      required double v0,
      Value<double?> v1,
      Value<double?> v2,
      Value<double?> v3,
    });
typedef $$MeasurementsTableUpdateCompanionBuilder =
    MeasurementsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> metricId,
      Value<DateTime> takenAt,
      Value<double> v0,
      Value<double?> v1,
      Value<double?> v2,
      Value<double?> v3,
    });

final class $$MeasurementsTableReferences
    extends BaseReferences<_$Db, $MeasurementsTable, Measurement> {
  $$MeasurementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$Db db) =>
      db.profiles.createAlias('measurements__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MeasurementsTableFilterComposer
    extends Composer<_$Db, $MeasurementsTable> {
  $$MeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metricId => $composableBuilder(
    column: $table.metricId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get v0 => $composableBuilder(
    column: $table.v0,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get v1 => $composableBuilder(
    column: $table.v1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get v2 => $composableBuilder(
    column: $table.v2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get v3 => $composableBuilder(
    column: $table.v3,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementsTableOrderingComposer
    extends Composer<_$Db, $MeasurementsTable> {
  $$MeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metricId => $composableBuilder(
    column: $table.metricId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get v0 => $composableBuilder(
    column: $table.v0,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get v1 => $composableBuilder(
    column: $table.v1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get v2 => $composableBuilder(
    column: $table.v2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get v3 => $composableBuilder(
    column: $table.v3,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementsTableAnnotationComposer
    extends Composer<_$Db, $MeasurementsTable> {
  $$MeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get metricId =>
      $composableBuilder(column: $table.metricId, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<double> get v0 =>
      $composableBuilder(column: $table.v0, builder: (column) => column);

  GeneratedColumn<double> get v1 =>
      $composableBuilder(column: $table.v1, builder: (column) => column);

  GeneratedColumn<double> get v2 =>
      $composableBuilder(column: $table.v2, builder: (column) => column);

  GeneratedColumn<double> get v3 =>
      $composableBuilder(column: $table.v3, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementsTableTableManager
    extends
        RootTableManager<
          _$Db,
          $MeasurementsTable,
          Measurement,
          $$MeasurementsTableFilterComposer,
          $$MeasurementsTableOrderingComposer,
          $$MeasurementsTableAnnotationComposer,
          $$MeasurementsTableCreateCompanionBuilder,
          $$MeasurementsTableUpdateCompanionBuilder,
          (Measurement, $$MeasurementsTableReferences),
          Measurement,
          PrefetchHooks Function({bool profileId})
        > {
  $$MeasurementsTableTableManager(_$Db db, $MeasurementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasurementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> metricId = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<double> v0 = const Value.absent(),
                Value<double?> v1 = const Value.absent(),
                Value<double?> v2 = const Value.absent(),
                Value<double?> v3 = const Value.absent(),
              }) => MeasurementsCompanion(
                id: id,
                profileId: profileId,
                metricId: metricId,
                takenAt: takenAt,
                v0: v0,
                v1: v1,
                v2: v2,
                v3: v3,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String metricId,
                required DateTime takenAt,
                required double v0,
                Value<double?> v1 = const Value.absent(),
                Value<double?> v2 = const Value.absent(),
                Value<double?> v3 = const Value.absent(),
              }) => MeasurementsCompanion.insert(
                id: id,
                profileId: profileId,
                metricId: metricId,
                takenAt: takenAt,
                v0: v0,
                v1: v1,
                v2: v2,
                v3: v3,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MeasurementsTable, Measurement>(table),
                  $$MeasurementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$MeasurementsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$MeasurementsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$Db,
      $MeasurementsTable,
      Measurement,
      $$MeasurementsTableFilterComposer,
      $$MeasurementsTableOrderingComposer,
      $$MeasurementsTableAnnotationComposer,
      $$MeasurementsTableCreateCompanionBuilder,
      $$MeasurementsTableUpdateCompanionBuilder,
      (Measurement, $$MeasurementsTableReferences),
      Measurement,
      PrefetchHooks Function({bool profileId})
    >;

class $DbManager {
  final _$Db _db;
  $DbManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$ProfileSettingsTableTableManager get profileSettings =>
      $$ProfileSettingsTableTableManager(_db, _db.profileSettings);
  $$MeasurementsTableTableManager get measurements =>
      $$MeasurementsTableTableManager(_db, _db.measurements);
}
