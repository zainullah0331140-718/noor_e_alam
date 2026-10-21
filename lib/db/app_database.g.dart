// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NamazEntriesTable extends NamazEntries
    with TableInfo<$NamazEntriesTable, NamazEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NamazEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<NamazType, int> prayer =
      GeneratedColumn<int>(
        'prayer',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<NamazType>($NamazEntriesTable.$converterprayer);
  @override
  late final GeneratedColumnWithTypeConverter<NamazStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<NamazStatus>($NamazEntriesTable.$converterstatus);
  static const VerificationMeta _takbeerUlaMeta = const VerificationMeta(
    'takbeerUla',
  );
  @override
  late final GeneratedColumn<bool> takbeerUla = GeneratedColumn<bool>(
    'takbeer_ula',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("takbeer_ula" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _masbooqMeta = const VerificationMeta(
    'masbooq',
  );
  @override
  late final GeneratedColumn<bool> masbooq = GeneratedColumn<bool>(
    'masbooq',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("masbooq" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _atMasjidMeta = const VerificationMeta(
    'atMasjid',
  );
  @override
  late final GeneratedColumn<bool> atMasjid = GeneratedColumn<bool>(
    'at_masjid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("at_masjid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    prayer,
    status,
    takbeerUla,
    masbooq,
    atMasjid,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'namaz_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<NamazEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('takbeer_ula')) {
      context.handle(
        _takbeerUlaMeta,
        takbeerUla.isAcceptableOrUnknown(data['takbeer_ula']!, _takbeerUlaMeta),
      );
    }
    if (data.containsKey('masbooq')) {
      context.handle(
        _masbooqMeta,
        masbooq.isAcceptableOrUnknown(data['masbooq']!, _masbooqMeta),
      );
    }
    if (data.containsKey('at_masjid')) {
      context.handle(
        _atMasjidMeta,
        atMasjid.isAcceptableOrUnknown(data['at_masjid']!, _atMasjidMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, prayer};
  @override
  NamazEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NamazEntry(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      prayer: $NamazEntriesTable.$converterprayer.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}prayer'],
        )!,
      ),
      status: $NamazEntriesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      takbeerUla: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}takbeer_ula'],
      )!,
      masbooq: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}masbooq'],
      )!,
      atMasjid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}at_masjid'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NamazEntriesTable createAlias(String alias) {
    return $NamazEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NamazType, int, int> $converterprayer =
      const EnumIndexConverter<NamazType>(NamazType.values);
  static JsonTypeConverter2<NamazStatus, int, int> $converterstatus =
      const EnumIndexConverter<NamazStatus>(NamazStatus.values);
}

class NamazEntry extends DataClass implements Insertable<NamazEntry> {
  /// `yyyy-MM-dd` (see DateUtilsExt.ymd) — stored as text for easy
  /// string range queries and timezone-safe comparisons.
  final String date;
  final NamazType prayer;
  final NamazStatus status;

  /// Takbeer-e-Ula caught (تکبیر اولیٰ) — optional sunnah flag.
  final bool takbeerUla;

  /// Joined the prayer after it started (مسبوق) — optional flag.
  final bool masbooq;

  /// True = prayed at masjid, false = prayed at home.
  final bool atMasjid;

  /// Last modification timestamp — used by seed and conflict checks.
  final DateTime updatedAt;
  const NamazEntry({
    required this.date,
    required this.prayer,
    required this.status,
    required this.takbeerUla,
    required this.masbooq,
    required this.atMasjid,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    {
      map['prayer'] = Variable<int>(
        $NamazEntriesTable.$converterprayer.toSql(prayer),
      );
    }
    {
      map['status'] = Variable<int>(
        $NamazEntriesTable.$converterstatus.toSql(status),
      );
    }
    map['takbeer_ula'] = Variable<bool>(takbeerUla);
    map['masbooq'] = Variable<bool>(masbooq);
    map['at_masjid'] = Variable<bool>(atMasjid);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NamazEntriesCompanion toCompanion(bool nullToAbsent) {
    return NamazEntriesCompanion(
      date: Value(date),
      prayer: Value(prayer),
      status: Value(status),
      takbeerUla: Value(takbeerUla),
      masbooq: Value(masbooq),
      atMasjid: Value(atMasjid),
      updatedAt: Value(updatedAt),
    );
  }

  factory NamazEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NamazEntry(
      date: serializer.fromJson<String>(json['date']),
      prayer: $NamazEntriesTable.$converterprayer.fromJson(
        serializer.fromJson<int>(json['prayer']),
      ),
      status: $NamazEntriesTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      takbeerUla: serializer.fromJson<bool>(json['takbeerUla']),
      masbooq: serializer.fromJson<bool>(json['masbooq']),
      atMasjid: serializer.fromJson<bool>(json['atMasjid']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'prayer': serializer.toJson<int>(
        $NamazEntriesTable.$converterprayer.toJson(prayer),
      ),
      'status': serializer.toJson<int>(
        $NamazEntriesTable.$converterstatus.toJson(status),
      ),
      'takbeerUla': serializer.toJson<bool>(takbeerUla),
      'masbooq': serializer.toJson<bool>(masbooq),
      'atMasjid': serializer.toJson<bool>(atMasjid),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NamazEntry copyWith({
    String? date,
    NamazType? prayer,
    NamazStatus? status,
    bool? takbeerUla,
    bool? masbooq,
    bool? atMasjid,
    DateTime? updatedAt,
  }) => NamazEntry(
    date: date ?? this.date,
    prayer: prayer ?? this.prayer,
    status: status ?? this.status,
    takbeerUla: takbeerUla ?? this.takbeerUla,
    masbooq: masbooq ?? this.masbooq,
    atMasjid: atMasjid ?? this.atMasjid,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NamazEntry copyWithCompanion(NamazEntriesCompanion data) {
    return NamazEntry(
      date: data.date.present ? data.date.value : this.date,
      prayer: data.prayer.present ? data.prayer.value : this.prayer,
      status: data.status.present ? data.status.value : this.status,
      takbeerUla: data.takbeerUla.present
          ? data.takbeerUla.value
          : this.takbeerUla,
      masbooq: data.masbooq.present ? data.masbooq.value : this.masbooq,
      atMasjid: data.atMasjid.present ? data.atMasjid.value : this.atMasjid,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NamazEntry(')
          ..write('date: $date, ')
          ..write('prayer: $prayer, ')
          ..write('status: $status, ')
          ..write('takbeerUla: $takbeerUla, ')
          ..write('masbooq: $masbooq, ')
          ..write('atMasjid: $atMasjid, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    prayer,
    status,
    takbeerUla,
    masbooq,
    atMasjid,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NamazEntry &&
          other.date == this.date &&
          other.prayer == this.prayer &&
          other.status == this.status &&
          other.takbeerUla == this.takbeerUla &&
          other.masbooq == this.masbooq &&
          other.atMasjid == this.atMasjid &&
          other.updatedAt == this.updatedAt);
}

class NamazEntriesCompanion extends UpdateCompanion<NamazEntry> {
  final Value<String> date;
  final Value<NamazType> prayer;
  final Value<NamazStatus> status;
  final Value<bool> takbeerUla;
  final Value<bool> masbooq;
  final Value<bool> atMasjid;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NamazEntriesCompanion({
    this.date = const Value.absent(),
    this.prayer = const Value.absent(),
    this.status = const Value.absent(),
    this.takbeerUla = const Value.absent(),
    this.masbooq = const Value.absent(),
    this.atMasjid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NamazEntriesCompanion.insert({
    required String date,
    required NamazType prayer,
    this.status = const Value.absent(),
    this.takbeerUla = const Value.absent(),
    this.masbooq = const Value.absent(),
    this.atMasjid = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       prayer = Value(prayer);
  static Insertable<NamazEntry> custom({
    Expression<String>? date,
    Expression<int>? prayer,
    Expression<int>? status,
    Expression<bool>? takbeerUla,
    Expression<bool>? masbooq,
    Expression<bool>? atMasjid,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (prayer != null) 'prayer': prayer,
      if (status != null) 'status': status,
      if (takbeerUla != null) 'takbeer_ula': takbeerUla,
      if (masbooq != null) 'masbooq': masbooq,
      if (atMasjid != null) 'at_masjid': atMasjid,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NamazEntriesCompanion copyWith({
    Value<String>? date,
    Value<NamazType>? prayer,
    Value<NamazStatus>? status,
    Value<bool>? takbeerUla,
    Value<bool>? masbooq,
    Value<bool>? atMasjid,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NamazEntriesCompanion(
      date: date ?? this.date,
      prayer: prayer ?? this.prayer,
      status: status ?? this.status,
      takbeerUla: takbeerUla ?? this.takbeerUla,
      masbooq: masbooq ?? this.masbooq,
      atMasjid: atMasjid ?? this.atMasjid,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (prayer.present) {
      map['prayer'] = Variable<int>(
        $NamazEntriesTable.$converterprayer.toSql(prayer.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $NamazEntriesTable.$converterstatus.toSql(status.value),
      );
    }
    if (takbeerUla.present) {
      map['takbeer_ula'] = Variable<bool>(takbeerUla.value);
    }
    if (masbooq.present) {
      map['masbooq'] = Variable<bool>(masbooq.value);
    }
    if (atMasjid.present) {
      map['at_masjid'] = Variable<bool>(atMasjid.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NamazEntriesCompanion(')
          ..write('date: $date, ')
          ..write('prayer: $prayer, ')
          ..write('status: $status, ')
          ..write('takbeerUla: $takbeerUla, ')
          ..write('masbooq: $masbooq, ')
          ..write('atMasjid: $atMasjid, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NaflEntriesTable extends NaflEntries
    with TableInfo<$NaflEntriesTable, NaflEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NaflEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<NaflType, int> naflType =
      GeneratedColumn<int>(
        'nafl_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<NaflType>($NaflEntriesTable.$converternaflType);
  static const VerificationMeta _customNameMeta = const VerificationMeta(
    'customName',
  );
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
    'custom_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _rakatsMeta = const VerificationMeta('rakats');
  @override
  late final GeneratedColumn<int> rakats = GeneratedColumn<int>(
    'rakats',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    naflType,
    customName,
    rakats,
    done,
    note,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nafl_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<NaflEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('custom_name')) {
      context.handle(
        _customNameMeta,
        customName.isAcceptableOrUnknown(data['custom_name']!, _customNameMeta),
      );
    }
    if (data.containsKey('rakats')) {
      context.handle(
        _rakatsMeta,
        rakats.isAcceptableOrUnknown(data['rakats']!, _rakatsMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, naflType, customName};
  @override
  NaflEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NaflEntry(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      naflType: $NaflEntriesTable.$converternaflType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}nafl_type'],
        )!,
      ),
      customName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_name'],
      )!,
      rakats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rakats'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NaflEntriesTable createAlias(String alias) {
    return $NaflEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NaflType, int, int> $converternaflType =
      const EnumIndexConverter<NaflType>(NaflType.values);
}

class NaflEntry extends DataClass implements Insertable<NaflEntry> {
  /// `yyyy-MM-dd`.
  final String date;
  final NaflType naflType;

  /// User-provided name for [NaflType.custom]; '' for fixed types.
  final String customName;

  /// Rakats performed (stepper value).
  final int rakats;

  /// Done / not-done toggle.
  final bool done;

  /// Optional free-text note.
  final String? note;
  final DateTime updatedAt;
  const NaflEntry({
    required this.date,
    required this.naflType,
    required this.customName,
    required this.rakats,
    required this.done,
    this.note,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    {
      map['nafl_type'] = Variable<int>(
        $NaflEntriesTable.$converternaflType.toSql(naflType),
      );
    }
    map['custom_name'] = Variable<String>(customName);
    map['rakats'] = Variable<int>(rakats);
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NaflEntriesCompanion toCompanion(bool nullToAbsent) {
    return NaflEntriesCompanion(
      date: Value(date),
      naflType: Value(naflType),
      customName: Value(customName),
      rakats: Value(rakats),
      done: Value(done),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory NaflEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NaflEntry(
      date: serializer.fromJson<String>(json['date']),
      naflType: $NaflEntriesTable.$converternaflType.fromJson(
        serializer.fromJson<int>(json['naflType']),
      ),
      customName: serializer.fromJson<String>(json['customName']),
      rakats: serializer.fromJson<int>(json['rakats']),
      done: serializer.fromJson<bool>(json['done']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'naflType': serializer.toJson<int>(
        $NaflEntriesTable.$converternaflType.toJson(naflType),
      ),
      'customName': serializer.toJson<String>(customName),
      'rakats': serializer.toJson<int>(rakats),
      'done': serializer.toJson<bool>(done),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NaflEntry copyWith({
    String? date,
    NaflType? naflType,
    String? customName,
    int? rakats,
    bool? done,
    Value<String?> note = const Value.absent(),
    DateTime? updatedAt,
  }) => NaflEntry(
    date: date ?? this.date,
    naflType: naflType ?? this.naflType,
    customName: customName ?? this.customName,
    rakats: rakats ?? this.rakats,
    done: done ?? this.done,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NaflEntry copyWithCompanion(NaflEntriesCompanion data) {
    return NaflEntry(
      date: data.date.present ? data.date.value : this.date,
      naflType: data.naflType.present ? data.naflType.value : this.naflType,
      customName: data.customName.present
          ? data.customName.value
          : this.customName,
      rakats: data.rakats.present ? data.rakats.value : this.rakats,
      done: data.done.present ? data.done.value : this.done,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NaflEntry(')
          ..write('date: $date, ')
          ..write('naflType: $naflType, ')
          ..write('customName: $customName, ')
          ..write('rakats: $rakats, ')
          ..write('done: $done, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, naflType, customName, rakats, done, note, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NaflEntry &&
          other.date == this.date &&
          other.naflType == this.naflType &&
          other.customName == this.customName &&
          other.rakats == this.rakats &&
          other.done == this.done &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class NaflEntriesCompanion extends UpdateCompanion<NaflEntry> {
  final Value<String> date;
  final Value<NaflType> naflType;
  final Value<String> customName;
  final Value<int> rakats;
  final Value<bool> done;
  final Value<String?> note;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NaflEntriesCompanion({
    this.date = const Value.absent(),
    this.naflType = const Value.absent(),
    this.customName = const Value.absent(),
    this.rakats = const Value.absent(),
    this.done = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NaflEntriesCompanion.insert({
    required String date,
    required NaflType naflType,
    this.customName = const Value.absent(),
    this.rakats = const Value.absent(),
    this.done = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       naflType = Value(naflType);
  static Insertable<NaflEntry> custom({
    Expression<String>? date,
    Expression<int>? naflType,
    Expression<String>? customName,
    Expression<int>? rakats,
    Expression<bool>? done,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (naflType != null) 'nafl_type': naflType,
      if (customName != null) 'custom_name': customName,
      if (rakats != null) 'rakats': rakats,
      if (done != null) 'done': done,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NaflEntriesCompanion copyWith({
    Value<String>? date,
    Value<NaflType>? naflType,
    Value<String>? customName,
    Value<int>? rakats,
    Value<bool>? done,
    Value<String?>? note,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NaflEntriesCompanion(
      date: date ?? this.date,
      naflType: naflType ?? this.naflType,
      customName: customName ?? this.customName,
      rakats: rakats ?? this.rakats,
      done: done ?? this.done,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (naflType.present) {
      map['nafl_type'] = Variable<int>(
        $NaflEntriesTable.$converternaflType.toSql(naflType.value),
      );
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (rakats.present) {
      map['rakats'] = Variable<int>(rakats.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NaflEntriesCompanion(')
          ..write('date: $date, ')
          ..write('naflType: $naflType, ')
          ..write('customName: $customName, ')
          ..write('rakats: $rakats, ')
          ..write('done: $done, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QazaRecordsTable extends QazaRecords
    with TableInfo<$QazaRecordsTable, QazaRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QazaRecordsTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<NamazType, int> prayer =
      GeneratedColumn<int>(
        'prayer',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<NamazType>($QazaRecordsTable.$converterprayer);
  static const VerificationMeta _rakatsMeta = const VerificationMeta('rakats');
  @override
  late final GeneratedColumn<int> rakats = GeneratedColumn<int>(
    'rakats',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<String> logDate = GeneratedColumn<String>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('auto'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isMadeUpMeta = const VerificationMeta(
    'isMadeUp',
  );
  @override
  late final GeneratedColumn<bool> isMadeUp = GeneratedColumn<bool>(
    'is_made_up',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_made_up" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _madeUpDateMeta = const VerificationMeta(
    'madeUpDate',
  );
  @override
  late final GeneratedColumn<String> madeUpDate = GeneratedColumn<String>(
    'made_up_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    prayer,
    rakats,
    logDate,
    source,
    note,
    isMadeUp,
    madeUpDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'qaza_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<QazaRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rakats')) {
      context.handle(
        _rakatsMeta,
        rakats.isAcceptableOrUnknown(data['rakats']!, _rakatsMeta),
      );
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_made_up')) {
      context.handle(
        _isMadeUpMeta,
        isMadeUp.isAcceptableOrUnknown(data['is_made_up']!, _isMadeUpMeta),
      );
    }
    if (data.containsKey('made_up_date')) {
      context.handle(
        _madeUpDateMeta,
        madeUpDate.isAcceptableOrUnknown(
          data['made_up_date']!,
          _madeUpDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QazaRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QazaRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      prayer: $QazaRecordsTable.$converterprayer.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}prayer'],
        )!,
      ),
      rakats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rakats'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}log_date'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      isMadeUp: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_made_up'],
      )!,
      madeUpDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}made_up_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $QazaRecordsTable createAlias(String alias) {
    return $QazaRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NamazType, int, int> $converterprayer =
      const EnumIndexConverter<NamazType>(NamazType.values);
}

class QazaRecord extends DataClass implements Insertable<QazaRecord> {
  final int id;
  final NamazType prayer;
  final int rakats;

  /// Day the qaza was logged (`yyyy-MM-dd`).
  final String logDate;

  /// 'auto' | 'manual' — see QazaSource.
  final String source;

  /// Optional user note.
  final String? note;
  final bool isMadeUp;

  /// Day the qaza was made up (`yyyy-MM-dd`), null while pending.
  final String? madeUpDate;
  final DateTime createdAt;
  const QazaRecord({
    required this.id,
    required this.prayer,
    required this.rakats,
    required this.logDate,
    required this.source,
    this.note,
    required this.isMadeUp,
    this.madeUpDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['prayer'] = Variable<int>(
        $QazaRecordsTable.$converterprayer.toSql(prayer),
      );
    }
    map['rakats'] = Variable<int>(rakats);
    map['log_date'] = Variable<String>(logDate);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_made_up'] = Variable<bool>(isMadeUp);
    if (!nullToAbsent || madeUpDate != null) {
      map['made_up_date'] = Variable<String>(madeUpDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QazaRecordsCompanion toCompanion(bool nullToAbsent) {
    return QazaRecordsCompanion(
      id: Value(id),
      prayer: Value(prayer),
      rakats: Value(rakats),
      logDate: Value(logDate),
      source: Value(source),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isMadeUp: Value(isMadeUp),
      madeUpDate: madeUpDate == null && nullToAbsent
          ? const Value.absent()
          : Value(madeUpDate),
      createdAt: Value(createdAt),
    );
  }

  factory QazaRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QazaRecord(
      id: serializer.fromJson<int>(json['id']),
      prayer: $QazaRecordsTable.$converterprayer.fromJson(
        serializer.fromJson<int>(json['prayer']),
      ),
      rakats: serializer.fromJson<int>(json['rakats']),
      logDate: serializer.fromJson<String>(json['logDate']),
      source: serializer.fromJson<String>(json['source']),
      note: serializer.fromJson<String?>(json['note']),
      isMadeUp: serializer.fromJson<bool>(json['isMadeUp']),
      madeUpDate: serializer.fromJson<String?>(json['madeUpDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'prayer': serializer.toJson<int>(
        $QazaRecordsTable.$converterprayer.toJson(prayer),
      ),
      'rakats': serializer.toJson<int>(rakats),
      'logDate': serializer.toJson<String>(logDate),
      'source': serializer.toJson<String>(source),
      'note': serializer.toJson<String?>(note),
      'isMadeUp': serializer.toJson<bool>(isMadeUp),
      'madeUpDate': serializer.toJson<String?>(madeUpDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  QazaRecord copyWith({
    int? id,
    NamazType? prayer,
    int? rakats,
    String? logDate,
    String? source,
    Value<String?> note = const Value.absent(),
    bool? isMadeUp,
    Value<String?> madeUpDate = const Value.absent(),
    DateTime? createdAt,
  }) => QazaRecord(
    id: id ?? this.id,
    prayer: prayer ?? this.prayer,
    rakats: rakats ?? this.rakats,
    logDate: logDate ?? this.logDate,
    source: source ?? this.source,
    note: note.present ? note.value : this.note,
    isMadeUp: isMadeUp ?? this.isMadeUp,
    madeUpDate: madeUpDate.present ? madeUpDate.value : this.madeUpDate,
    createdAt: createdAt ?? this.createdAt,
  );
  QazaRecord copyWithCompanion(QazaRecordsCompanion data) {
    return QazaRecord(
      id: data.id.present ? data.id.value : this.id,
      prayer: data.prayer.present ? data.prayer.value : this.prayer,
      rakats: data.rakats.present ? data.rakats.value : this.rakats,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      source: data.source.present ? data.source.value : this.source,
      note: data.note.present ? data.note.value : this.note,
      isMadeUp: data.isMadeUp.present ? data.isMadeUp.value : this.isMadeUp,
      madeUpDate: data.madeUpDate.present
          ? data.madeUpDate.value
          : this.madeUpDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QazaRecord(')
          ..write('id: $id, ')
          ..write('prayer: $prayer, ')
          ..write('rakats: $rakats, ')
          ..write('logDate: $logDate, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('isMadeUp: $isMadeUp, ')
          ..write('madeUpDate: $madeUpDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    prayer,
    rakats,
    logDate,
    source,
    note,
    isMadeUp,
    madeUpDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QazaRecord &&
          other.id == this.id &&
          other.prayer == this.prayer &&
          other.rakats == this.rakats &&
          other.logDate == this.logDate &&
          other.source == this.source &&
          other.note == this.note &&
          other.isMadeUp == this.isMadeUp &&
          other.madeUpDate == this.madeUpDate &&
          other.createdAt == this.createdAt);
}

class QazaRecordsCompanion extends UpdateCompanion<QazaRecord> {
  final Value<int> id;
  final Value<NamazType> prayer;
  final Value<int> rakats;
  final Value<String> logDate;
  final Value<String> source;
  final Value<String?> note;
  final Value<bool> isMadeUp;
  final Value<String?> madeUpDate;
  final Value<DateTime> createdAt;
  const QazaRecordsCompanion({
    this.id = const Value.absent(),
    this.prayer = const Value.absent(),
    this.rakats = const Value.absent(),
    this.logDate = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.isMadeUp = const Value.absent(),
    this.madeUpDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  QazaRecordsCompanion.insert({
    this.id = const Value.absent(),
    required NamazType prayer,
    this.rakats = const Value.absent(),
    required String logDate,
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.isMadeUp = const Value.absent(),
    this.madeUpDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : prayer = Value(prayer),
       logDate = Value(logDate);
  static Insertable<QazaRecord> custom({
    Expression<int>? id,
    Expression<int>? prayer,
    Expression<int>? rakats,
    Expression<String>? logDate,
    Expression<String>? source,
    Expression<String>? note,
    Expression<bool>? isMadeUp,
    Expression<String>? madeUpDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prayer != null) 'prayer': prayer,
      if (rakats != null) 'rakats': rakats,
      if (logDate != null) 'log_date': logDate,
      if (source != null) 'source': source,
      if (note != null) 'note': note,
      if (isMadeUp != null) 'is_made_up': isMadeUp,
      if (madeUpDate != null) 'made_up_date': madeUpDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  QazaRecordsCompanion copyWith({
    Value<int>? id,
    Value<NamazType>? prayer,
    Value<int>? rakats,
    Value<String>? logDate,
    Value<String>? source,
    Value<String?>? note,
    Value<bool>? isMadeUp,
    Value<String?>? madeUpDate,
    Value<DateTime>? createdAt,
  }) {
    return QazaRecordsCompanion(
      id: id ?? this.id,
      prayer: prayer ?? this.prayer,
      rakats: rakats ?? this.rakats,
      logDate: logDate ?? this.logDate,
      source: source ?? this.source,
      note: note ?? this.note,
      isMadeUp: isMadeUp ?? this.isMadeUp,
      madeUpDate: madeUpDate ?? this.madeUpDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (prayer.present) {
      map['prayer'] = Variable<int>(
        $QazaRecordsTable.$converterprayer.toSql(prayer.value),
      );
    }
    if (rakats.present) {
      map['rakats'] = Variable<int>(rakats.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<String>(logDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isMadeUp.present) {
      map['is_made_up'] = Variable<bool>(isMadeUp.value);
    }
    if (madeUpDate.present) {
      map['made_up_date'] = Variable<String>(madeUpDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QazaRecordsCompanion(')
          ..write('id: $id, ')
          ..write('prayer: $prayer, ')
          ..write('rakats: $rakats, ')
          ..write('logDate: $logDate, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('isMadeUp: $isMadeUp, ')
          ..write('madeUpDate: $madeUpDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TilawatEntriesTable extends TilawatEntries
    with TableInfo<$TilawatEntriesTable, TilawatEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TilawatEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TilawatUnit, int> unit =
      GeneratedColumn<int>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TilawatUnit>($TilawatEntriesTable.$converterunit);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    unit,
    amount,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tilawat_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TilawatEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TilawatEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TilawatEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      unit: $TilawatEntriesTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}unit'],
        )!,
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TilawatEntriesTable createAlias(String alias) {
    return $TilawatEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TilawatUnit, int, int> $converterunit =
      const EnumIndexConverter<TilawatUnit>(TilawatUnit.values);
}

class TilawatEntry extends DataClass implements Insertable<TilawatEntry> {
  final int id;

  /// `yyyy-MM-dd`.
  final String date;

  /// Unit the [amount] is measured in (pages / ruku / para / minutes).
  final TilawatUnit unit;

  /// Quantity for the chosen [unit].
  final int amount;

  /// Optional free-text note (e.g. "after Fajr").
  final String? note;
  final DateTime createdAt;
  const TilawatEntry({
    required this.id,
    required this.date,
    required this.unit,
    required this.amount,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    {
      map['unit'] = Variable<int>(
        $TilawatEntriesTable.$converterunit.toSql(unit),
      );
    }
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TilawatEntriesCompanion toCompanion(bool nullToAbsent) {
    return TilawatEntriesCompanion(
      id: Value(id),
      date: Value(date),
      unit: Value(unit),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory TilawatEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TilawatEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      unit: $TilawatEntriesTable.$converterunit.fromJson(
        serializer.fromJson<int>(json['unit']),
      ),
      amount: serializer.fromJson<int>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'unit': serializer.toJson<int>(
        $TilawatEntriesTable.$converterunit.toJson(unit),
      ),
      'amount': serializer.toJson<int>(amount),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TilawatEntry copyWith({
    int? id,
    String? date,
    TilawatUnit? unit,
    int? amount,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => TilawatEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    unit: unit ?? this.unit,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  TilawatEntry copyWithCompanion(TilawatEntriesCompanion data) {
    return TilawatEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      unit: data.unit.present ? data.unit.value : this.unit,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TilawatEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('unit: $unit, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, unit, amount, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TilawatEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.unit == this.unit &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class TilawatEntriesCompanion extends UpdateCompanion<TilawatEntry> {
  final Value<int> id;
  final Value<String> date;
  final Value<TilawatUnit> unit;
  final Value<int> amount;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const TilawatEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.unit = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TilawatEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required TilawatUnit unit,
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date),
       unit = Value(unit);
  static Insertable<TilawatEntry> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? unit,
    Expression<int>? amount,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (unit != null) 'unit': unit,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TilawatEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<TilawatUnit>? unit,
    Value<int>? amount,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return TilawatEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      unit: unit ?? this.unit,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (unit.present) {
      map['unit'] = Variable<int>(
        $TilawatEntriesTable.$converterunit.toSql(unit.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TilawatEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('unit: $unit, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TilawatPositionsTable extends TilawatPositions
    with TableInfo<$TilawatPositionsTable, TilawatPosition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TilawatPositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _paraMeta = const VerificationMeta('para');
  @override
  late final GeneratedColumn<int> para = GeneratedColumn<int>(
    'para',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _surahMeta = const VerificationMeta('surah');
  @override
  late final GeneratedColumn<String> surah = GeneratedColumn<String>(
    'surah',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, para, surah, page, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tilawat_positions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TilawatPosition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('para')) {
      context.handle(
        _paraMeta,
        para.isAcceptableOrUnknown(data['para']!, _paraMeta),
      );
    }
    if (data.containsKey('surah')) {
      context.handle(
        _surahMeta,
        surah.isAcceptableOrUnknown(data['surah']!, _surahMeta),
      );
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TilawatPosition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TilawatPosition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      para: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}para'],
      )!,
      surah: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surah'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TilawatPositionsTable createAlias(String alias) {
    return $TilawatPositionsTable(attachedDatabase, alias);
  }
}

class TilawatPosition extends DataClass implements Insertable<TilawatPosition> {
  final int id;

  /// Current para (1..30).
  final int para;

  /// Current surah name (free text).
  final String surah;

  /// Current page number.
  final int page;
  final DateTime updatedAt;
  const TilawatPosition({
    required this.id,
    required this.para,
    required this.surah,
    required this.page,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['para'] = Variable<int>(para);
    map['surah'] = Variable<String>(surah);
    map['page'] = Variable<int>(page);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TilawatPositionsCompanion toCompanion(bool nullToAbsent) {
    return TilawatPositionsCompanion(
      id: Value(id),
      para: Value(para),
      surah: Value(surah),
      page: Value(page),
      updatedAt: Value(updatedAt),
    );
  }

  factory TilawatPosition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TilawatPosition(
      id: serializer.fromJson<int>(json['id']),
      para: serializer.fromJson<int>(json['para']),
      surah: serializer.fromJson<String>(json['surah']),
      page: serializer.fromJson<int>(json['page']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'para': serializer.toJson<int>(para),
      'surah': serializer.toJson<String>(surah),
      'page': serializer.toJson<int>(page),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TilawatPosition copyWith({
    int? id,
    int? para,
    String? surah,
    int? page,
    DateTime? updatedAt,
  }) => TilawatPosition(
    id: id ?? this.id,
    para: para ?? this.para,
    surah: surah ?? this.surah,
    page: page ?? this.page,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TilawatPosition copyWithCompanion(TilawatPositionsCompanion data) {
    return TilawatPosition(
      id: data.id.present ? data.id.value : this.id,
      para: data.para.present ? data.para.value : this.para,
      surah: data.surah.present ? data.surah.value : this.surah,
      page: data.page.present ? data.page.value : this.page,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TilawatPosition(')
          ..write('id: $id, ')
          ..write('para: $para, ')
          ..write('surah: $surah, ')
          ..write('page: $page, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, para, surah, page, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TilawatPosition &&
          other.id == this.id &&
          other.para == this.para &&
          other.surah == this.surah &&
          other.page == this.page &&
          other.updatedAt == this.updatedAt);
}

class TilawatPositionsCompanion extends UpdateCompanion<TilawatPosition> {
  final Value<int> id;
  final Value<int> para;
  final Value<String> surah;
  final Value<int> page;
  final Value<DateTime> updatedAt;
  const TilawatPositionsCompanion({
    this.id = const Value.absent(),
    this.para = const Value.absent(),
    this.surah = const Value.absent(),
    this.page = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TilawatPositionsCompanion.insert({
    this.id = const Value.absent(),
    this.para = const Value.absent(),
    this.surah = const Value.absent(),
    this.page = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<TilawatPosition> custom({
    Expression<int>? id,
    Expression<int>? para,
    Expression<String>? surah,
    Expression<int>? page,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (para != null) 'para': para,
      if (surah != null) 'surah': surah,
      if (page != null) 'page': page,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TilawatPositionsCompanion copyWith({
    Value<int>? id,
    Value<int>? para,
    Value<String>? surah,
    Value<int>? page,
    Value<DateTime>? updatedAt,
  }) {
    return TilawatPositionsCompanion(
      id: id ?? this.id,
      para: para ?? this.para,
      surah: surah ?? this.surah,
      page: page ?? this.page,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (para.present) {
      map['para'] = Variable<int>(para.value);
    }
    if (surah.present) {
      map['surah'] = Variable<String>(surah.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TilawatPositionsCompanion(')
          ..write('id: $id, ')
          ..write('para: $para, ')
          ..write('surah: $surah, ')
          ..write('page: $page, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomDhikrsTable extends CustomDhikrs
    with TableInfo<$CustomDhikrsTable, CustomDhikr> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomDhikrsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _arabicTextMeta = const VerificationMeta(
    'arabicText',
  );
  @override
  late final GeneratedColumn<String> arabicText = GeneratedColumn<String>(
    'arabic_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(33),
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
    'reminder_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    arabicText,
    target,
    reminderTime,
    active,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_dhikrs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomDhikr> instance, {
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
    if (data.containsKey('arabic_text')) {
      context.handle(
        _arabicTextMeta,
        arabicText.isAcceptableOrUnknown(data['arabic_text']!, _arabicTextMeta),
      );
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomDhikr map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomDhikr(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      arabicText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_text'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_time'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomDhikrsTable createAlias(String alias) {
    return $CustomDhikrsTable(attachedDatabase, alias);
  }
}

class CustomDhikr extends DataClass implements Insertable<CustomDhikr> {
  final int id;

  /// Display name (English/Urdu as entered).
  final String name;

  /// Optional Arabic text shown in the counter screen.
  final String arabicText;

  /// Target count for one day.
  final int target;

  /// Optional reminder time as `HH:mm`.
  final String? reminderTime;

  /// Hidden customs are kept in history but not shown on the checklist.
  final bool active;
  final DateTime createdAt;
  const CustomDhikr({
    required this.id,
    required this.name,
    required this.arabicText,
    required this.target,
    this.reminderTime,
    required this.active,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['arabic_text'] = Variable<String>(arabicText);
    map['target'] = Variable<int>(target);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<String>(reminderTime);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomDhikrsCompanion toCompanion(bool nullToAbsent) {
    return CustomDhikrsCompanion(
      id: Value(id),
      name: Value(name),
      arabicText: Value(arabicText),
      target: Value(target),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      active: Value(active),
      createdAt: Value(createdAt),
    );
  }

  factory CustomDhikr.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomDhikr(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      arabicText: serializer.fromJson<String>(json['arabicText']),
      target: serializer.fromJson<int>(json['target']),
      reminderTime: serializer.fromJson<String?>(json['reminderTime']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'arabicText': serializer.toJson<String>(arabicText),
      'target': serializer.toJson<int>(target),
      'reminderTime': serializer.toJson<String?>(reminderTime),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomDhikr copyWith({
    int? id,
    String? name,
    String? arabicText,
    int? target,
    Value<String?> reminderTime = const Value.absent(),
    bool? active,
    DateTime? createdAt,
  }) => CustomDhikr(
    id: id ?? this.id,
    name: name ?? this.name,
    arabicText: arabicText ?? this.arabicText,
    target: target ?? this.target,
    reminderTime: reminderTime.present ? reminderTime.value : this.reminderTime,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
  );
  CustomDhikr copyWithCompanion(CustomDhikrsCompanion data) {
    return CustomDhikr(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      arabicText: data.arabicText.present
          ? data.arabicText.value
          : this.arabicText,
      target: data.target.present ? data.target.value : this.target,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomDhikr(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('arabicText: $arabicText, ')
          ..write('target: $target, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    arabicText,
    target,
    reminderTime,
    active,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomDhikr &&
          other.id == this.id &&
          other.name == this.name &&
          other.arabicText == this.arabicText &&
          other.target == this.target &&
          other.reminderTime == this.reminderTime &&
          other.active == this.active &&
          other.createdAt == this.createdAt);
}

class CustomDhikrsCompanion extends UpdateCompanion<CustomDhikr> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> arabicText;
  final Value<int> target;
  final Value<String?> reminderTime;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  const CustomDhikrsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.arabicText = const Value.absent(),
    this.target = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomDhikrsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.arabicText = const Value.absent(),
    this.target = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CustomDhikr> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? arabicText,
    Expression<int>? target,
    Expression<String>? reminderTime,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (arabicText != null) 'arabic_text': arabicText,
      if (target != null) 'target': target,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomDhikrsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? arabicText,
    Value<int>? target,
    Value<String?>? reminderTime,
    Value<bool>? active,
    Value<DateTime>? createdAt,
  }) {
    return CustomDhikrsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      arabicText: arabicText ?? this.arabicText,
      target: target ?? this.target,
      reminderTime: reminderTime ?? this.reminderTime,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
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
    if (arabicText.present) {
      map['arabic_text'] = Variable<String>(arabicText.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomDhikrsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('arabicText: $arabicText, ')
          ..write('target: $target, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AzkarEntriesTable extends AzkarEntries
    with TableInfo<$AzkarEntriesTable, AzkarEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AzkarEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dhikrKeyMeta = const VerificationMeta(
    'dhikrKey',
  );
  @override
  late final GeneratedColumn<String> dhikrKey = GeneratedColumn<String>(
    'dhikr_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    dhikrKey,
    count,
    target,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'azkar_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AzkarEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('dhikr_key')) {
      context.handle(
        _dhikrKeyMeta,
        dhikrKey.isAcceptableOrUnknown(data['dhikr_key']!, _dhikrKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dhikrKeyMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, dhikrKey};
  @override
  AzkarEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AzkarEntry(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      dhikrKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dhikr_key'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AzkarEntriesTable createAlias(String alias) {
    return $AzkarEntriesTable(attachedDatabase, alias);
  }
}

class AzkarEntry extends DataClass implements Insertable<AzkarEntry> {
  /// `yyyy-MM-dd`.
  final String date;
  final String dhikrKey;
  final int count;
  final int target;
  final DateTime updatedAt;
  const AzkarEntry({
    required this.date,
    required this.dhikrKey,
    required this.count,
    required this.target,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['dhikr_key'] = Variable<String>(dhikrKey);
    map['count'] = Variable<int>(count);
    map['target'] = Variable<int>(target);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AzkarEntriesCompanion toCompanion(bool nullToAbsent) {
    return AzkarEntriesCompanion(
      date: Value(date),
      dhikrKey: Value(dhikrKey),
      count: Value(count),
      target: Value(target),
      updatedAt: Value(updatedAt),
    );
  }

  factory AzkarEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AzkarEntry(
      date: serializer.fromJson<String>(json['date']),
      dhikrKey: serializer.fromJson<String>(json['dhikrKey']),
      count: serializer.fromJson<int>(json['count']),
      target: serializer.fromJson<int>(json['target']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'dhikrKey': serializer.toJson<String>(dhikrKey),
      'count': serializer.toJson<int>(count),
      'target': serializer.toJson<int>(target),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AzkarEntry copyWith({
    String? date,
    String? dhikrKey,
    int? count,
    int? target,
    DateTime? updatedAt,
  }) => AzkarEntry(
    date: date ?? this.date,
    dhikrKey: dhikrKey ?? this.dhikrKey,
    count: count ?? this.count,
    target: target ?? this.target,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AzkarEntry copyWithCompanion(AzkarEntriesCompanion data) {
    return AzkarEntry(
      date: data.date.present ? data.date.value : this.date,
      dhikrKey: data.dhikrKey.present ? data.dhikrKey.value : this.dhikrKey,
      count: data.count.present ? data.count.value : this.count,
      target: data.target.present ? data.target.value : this.target,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AzkarEntry(')
          ..write('date: $date, ')
          ..write('dhikrKey: $dhikrKey, ')
          ..write('count: $count, ')
          ..write('target: $target, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, dhikrKey, count, target, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AzkarEntry &&
          other.date == this.date &&
          other.dhikrKey == this.dhikrKey &&
          other.count == this.count &&
          other.target == this.target &&
          other.updatedAt == this.updatedAt);
}

class AzkarEntriesCompanion extends UpdateCompanion<AzkarEntry> {
  final Value<String> date;
  final Value<String> dhikrKey;
  final Value<int> count;
  final Value<int> target;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AzkarEntriesCompanion({
    this.date = const Value.absent(),
    this.dhikrKey = const Value.absent(),
    this.count = const Value.absent(),
    this.target = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AzkarEntriesCompanion.insert({
    required String date,
    required String dhikrKey,
    this.count = const Value.absent(),
    this.target = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       dhikrKey = Value(dhikrKey);
  static Insertable<AzkarEntry> custom({
    Expression<String>? date,
    Expression<String>? dhikrKey,
    Expression<int>? count,
    Expression<int>? target,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (dhikrKey != null) 'dhikr_key': dhikrKey,
      if (count != null) 'count': count,
      if (target != null) 'target': target,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AzkarEntriesCompanion copyWith({
    Value<String>? date,
    Value<String>? dhikrKey,
    Value<int>? count,
    Value<int>? target,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AzkarEntriesCompanion(
      date: date ?? this.date,
      dhikrKey: dhikrKey ?? this.dhikrKey,
      count: count ?? this.count,
      target: target ?? this.target,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (dhikrKey.present) {
      map['dhikr_key'] = Variable<String>(dhikrKey.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AzkarEntriesCompanion(')
          ..write('date: $date, ')
          ..write('dhikrKey: $dhikrKey, ')
          ..write('count: $count, ')
          ..write('target: $target, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KhatamsTable extends Khatams with TableInfo<$KhatamsTable, Khatam> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KhatamsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, startDate, endDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'khatams';
  @override
  VerificationContext validateIntegrity(
    Insertable<Khatam> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Khatam map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Khatam(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $KhatamsTable createAlias(String alias) {
    return $KhatamsTable(attachedDatabase, alias);
  }
}

class Khatam extends DataClass implements Insertable<Khatam> {
  final int id;

  /// `yyyy-MM-dd` the khatam was started.
  final String startDate;

  /// `yyyy-MM-dd` the khatam was completed, null while active.
  final String? endDate;
  final DateTime createdAt;
  const Khatam({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  KhatamsCompanion toCompanion(bool nullToAbsent) {
    return KhatamsCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      createdAt: Value(createdAt),
    );
  }

  factory Khatam.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Khatam(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Khatam copyWith({
    int? id,
    String? startDate,
    Value<String?> endDate = const Value.absent(),
    DateTime? createdAt,
  }) => Khatam(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    createdAt: createdAt ?? this.createdAt,
  );
  Khatam copyWithCompanion(KhatamsCompanion data) {
    return Khatam(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Khatam(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startDate, endDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Khatam &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt);
}

class KhatamsCompanion extends UpdateCompanion<Khatam> {
  final Value<int> id;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<DateTime> createdAt;
  const KhatamsCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  KhatamsCompanion.insert({
    this.id = const Value.absent(),
    required String startDate,
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : startDate = Value(startDate);
  static Insertable<Khatam> custom({
    Expression<int>? id,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  KhatamsCompanion copyWith({
    Value<int>? id,
    Value<String>? startDate,
    Value<String?>? endDate,
    Value<DateTime>? createdAt,
  }) {
    return KhatamsCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KhatamsCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $KhatamParasTable extends KhatamParas
    with TableInfo<$KhatamParasTable, KhatamPara> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KhatamParasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _khatamIdMeta = const VerificationMeta(
    'khatamId',
  );
  @override
  late final GeneratedColumn<int> khatamId = GeneratedColumn<int>(
    'khatam_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES khatams (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _paraMeta = const VerificationMeta('para');
  @override
  late final GeneratedColumn<int> para = GeneratedColumn<int>(
    'para',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _doneDateMeta = const VerificationMeta(
    'doneDate',
  );
  @override
  late final GeneratedColumn<String> doneDate = GeneratedColumn<String>(
    'done_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [khatamId, para, done, doneDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'khatam_paras';
  @override
  VerificationContext validateIntegrity(
    Insertable<KhatamPara> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('khatam_id')) {
      context.handle(
        _khatamIdMeta,
        khatamId.isAcceptableOrUnknown(data['khatam_id']!, _khatamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_khatamIdMeta);
    }
    if (data.containsKey('para')) {
      context.handle(
        _paraMeta,
        para.isAcceptableOrUnknown(data['para']!, _paraMeta),
      );
    } else if (isInserting) {
      context.missing(_paraMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('done_date')) {
      context.handle(
        _doneDateMeta,
        doneDate.isAcceptableOrUnknown(data['done_date']!, _doneDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {khatamId, para};
  @override
  KhatamPara map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KhatamPara(
      khatamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}khatam_id'],
      )!,
      para: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}para'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      doneDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}done_date'],
      ),
    );
  }

  @override
  $KhatamParasTable createAlias(String alias) {
    return $KhatamParasTable(attachedDatabase, alias);
  }
}

class KhatamPara extends DataClass implements Insertable<KhatamPara> {
  final int khatamId;

  /// Para number, 1..30.
  final int para;
  final bool done;

  /// `yyyy-MM-dd` the para was completed, null while pending.
  final String? doneDate;
  const KhatamPara({
    required this.khatamId,
    required this.para,
    required this.done,
    this.doneDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['khatam_id'] = Variable<int>(khatamId);
    map['para'] = Variable<int>(para);
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || doneDate != null) {
      map['done_date'] = Variable<String>(doneDate);
    }
    return map;
  }

  KhatamParasCompanion toCompanion(bool nullToAbsent) {
    return KhatamParasCompanion(
      khatamId: Value(khatamId),
      para: Value(para),
      done: Value(done),
      doneDate: doneDate == null && nullToAbsent
          ? const Value.absent()
          : Value(doneDate),
    );
  }

  factory KhatamPara.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KhatamPara(
      khatamId: serializer.fromJson<int>(json['khatamId']),
      para: serializer.fromJson<int>(json['para']),
      done: serializer.fromJson<bool>(json['done']),
      doneDate: serializer.fromJson<String?>(json['doneDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'khatamId': serializer.toJson<int>(khatamId),
      'para': serializer.toJson<int>(para),
      'done': serializer.toJson<bool>(done),
      'doneDate': serializer.toJson<String?>(doneDate),
    };
  }

  KhatamPara copyWith({
    int? khatamId,
    int? para,
    bool? done,
    Value<String?> doneDate = const Value.absent(),
  }) => KhatamPara(
    khatamId: khatamId ?? this.khatamId,
    para: para ?? this.para,
    done: done ?? this.done,
    doneDate: doneDate.present ? doneDate.value : this.doneDate,
  );
  KhatamPara copyWithCompanion(KhatamParasCompanion data) {
    return KhatamPara(
      khatamId: data.khatamId.present ? data.khatamId.value : this.khatamId,
      para: data.para.present ? data.para.value : this.para,
      done: data.done.present ? data.done.value : this.done,
      doneDate: data.doneDate.present ? data.doneDate.value : this.doneDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KhatamPara(')
          ..write('khatamId: $khatamId, ')
          ..write('para: $para, ')
          ..write('done: $done, ')
          ..write('doneDate: $doneDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(khatamId, para, done, doneDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KhatamPara &&
          other.khatamId == this.khatamId &&
          other.para == this.para &&
          other.done == this.done &&
          other.doneDate == this.doneDate);
}

class KhatamParasCompanion extends UpdateCompanion<KhatamPara> {
  final Value<int> khatamId;
  final Value<int> para;
  final Value<bool> done;
  final Value<String?> doneDate;
  final Value<int> rowid;
  const KhatamParasCompanion({
    this.khatamId = const Value.absent(),
    this.para = const Value.absent(),
    this.done = const Value.absent(),
    this.doneDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KhatamParasCompanion.insert({
    required int khatamId,
    required int para,
    this.done = const Value.absent(),
    this.doneDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : khatamId = Value(khatamId),
       para = Value(para);
  static Insertable<KhatamPara> custom({
    Expression<int>? khatamId,
    Expression<int>? para,
    Expression<bool>? done,
    Expression<String>? doneDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (khatamId != null) 'khatam_id': khatamId,
      if (para != null) 'para': para,
      if (done != null) 'done': done,
      if (doneDate != null) 'done_date': doneDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KhatamParasCompanion copyWith({
    Value<int>? khatamId,
    Value<int>? para,
    Value<bool>? done,
    Value<String?>? doneDate,
    Value<int>? rowid,
  }) {
    return KhatamParasCompanion(
      khatamId: khatamId ?? this.khatamId,
      para: para ?? this.para,
      done: done ?? this.done,
      doneDate: doneDate ?? this.doneDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (khatamId.present) {
      map['khatam_id'] = Variable<int>(khatamId.value);
    }
    if (para.present) {
      map['para'] = Variable<int>(para.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (doneDate.present) {
      map['done_date'] = Variable<String>(doneDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KhatamParasCompanion(')
          ..write('khatamId: $khatamId, ')
          ..write('para: $para, ')
          ..write('done: $done, ')
          ..write('doneDate: $doneDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GheebatEntriesTable extends GheebatEntries
    with TableInfo<$GheebatEntriesTable, GheebatEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GheebatEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GheebatStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<GheebatStatus>($GheebatEntriesTable.$converterstatus);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _istighfarCountMeta = const VerificationMeta(
    'istighfarCount',
  );
  @override
  late final GeneratedColumn<int> istighfarCount = GeneratedColumn<int>(
    'istighfar_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    status,
    note,
    istighfarCount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gheebat_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<GheebatEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('istighfar_count')) {
      context.handle(
        _istighfarCountMeta,
        istighfarCount.isAcceptableOrUnknown(
          data['istighfar_count']!,
          _istighfarCountMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  GheebatEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GheebatEntry(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      status: $GheebatEntriesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      istighfarCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}istighfar_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GheebatEntriesTable createAlias(String alias) {
    return $GheebatEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GheebatStatus, int, int> $converterstatus =
      const EnumIndexConverter<GheebatStatus>(GheebatStatus.values);
}

class GheebatEntry extends DataClass implements Insertable<GheebatEntry> {
  /// `yyyy-MM-dd`.
  final String date;
  final GheebatStatus status;

  /// Short private reflection (never required).
  final String? note;

  /// Istighfar repetitions logged on this day.
  final int istighfarCount;
  final DateTime updatedAt;
  const GheebatEntry({
    required this.date,
    required this.status,
    this.note,
    required this.istighfarCount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    {
      map['status'] = Variable<int>(
        $GheebatEntriesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['istighfar_count'] = Variable<int>(istighfarCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GheebatEntriesCompanion toCompanion(bool nullToAbsent) {
    return GheebatEntriesCompanion(
      date: Value(date),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      istighfarCount: Value(istighfarCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory GheebatEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GheebatEntry(
      date: serializer.fromJson<String>(json['date']),
      status: $GheebatEntriesTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      note: serializer.fromJson<String?>(json['note']),
      istighfarCount: serializer.fromJson<int>(json['istighfarCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'status': serializer.toJson<int>(
        $GheebatEntriesTable.$converterstatus.toJson(status),
      ),
      'note': serializer.toJson<String?>(note),
      'istighfarCount': serializer.toJson<int>(istighfarCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GheebatEntry copyWith({
    String? date,
    GheebatStatus? status,
    Value<String?> note = const Value.absent(),
    int? istighfarCount,
    DateTime? updatedAt,
  }) => GheebatEntry(
    date: date ?? this.date,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
    istighfarCount: istighfarCount ?? this.istighfarCount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GheebatEntry copyWithCompanion(GheebatEntriesCompanion data) {
    return GheebatEntry(
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      istighfarCount: data.istighfarCount.present
          ? data.istighfarCount.value
          : this.istighfarCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GheebatEntry(')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('istighfarCount: $istighfarCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, status, note, istighfarCount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GheebatEntry &&
          other.date == this.date &&
          other.status == this.status &&
          other.note == this.note &&
          other.istighfarCount == this.istighfarCount &&
          other.updatedAt == this.updatedAt);
}

class GheebatEntriesCompanion extends UpdateCompanion<GheebatEntry> {
  final Value<String> date;
  final Value<GheebatStatus> status;
  final Value<String?> note;
  final Value<int> istighfarCount;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GheebatEntriesCompanion({
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.istighfarCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GheebatEntriesCompanion.insert({
    required String date,
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.istighfarCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<GheebatEntry> custom({
    Expression<String>? date,
    Expression<int>? status,
    Expression<String>? note,
    Expression<int>? istighfarCount,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (istighfarCount != null) 'istighfar_count': istighfarCount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GheebatEntriesCompanion copyWith({
    Value<String>? date,
    Value<GheebatStatus>? status,
    Value<String?>? note,
    Value<int>? istighfarCount,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GheebatEntriesCompanion(
      date: date ?? this.date,
      status: status ?? this.status,
      note: note ?? this.note,
      istighfarCount: istighfarCount ?? this.istighfarCount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $GheebatEntriesTable.$converterstatus.toSql(status.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (istighfarCount.present) {
      map['istighfar_count'] = Variable<int>(istighfarCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GheebatEntriesCompanion(')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('istighfarCount: $istighfarCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MuraqabaSessionsTable extends MuraqabaSessions
    with TableInfo<$MuraqabaSessionsTable, MuraqabaSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MuraqabaSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MuraqabaTime, int> timeOfDay =
      GeneratedColumn<int>(
        'time_of_day',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<MuraqabaTime>($MuraqabaSessionsTable.$convertertimeOfDay);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    minutes,
    timeOfDay,
    note,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'muraqaba_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MuraqabaSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MuraqabaSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MuraqabaSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      timeOfDay: $MuraqabaSessionsTable.$convertertimeOfDay.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}time_of_day'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MuraqabaSessionsTable createAlias(String alias) {
    return $MuraqabaSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MuraqabaTime, int, int> $convertertimeOfDay =
      const EnumIndexConverter<MuraqabaTime>(MuraqabaTime.values);
}

class MuraqabaSession extends DataClass implements Insertable<MuraqabaSession> {
  final int id;

  /// `yyyy-MM-dd`.
  final String date;
  final int minutes;
  final MuraqabaTime timeOfDay;

  /// Optional short note for the session.
  final String? note;

  /// `timer` or `manual` — how the session was recorded.
  final String source;
  final DateTime createdAt;
  const MuraqabaSession({
    required this.id,
    required this.date,
    required this.minutes,
    required this.timeOfDay,
    this.note,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['minutes'] = Variable<int>(minutes);
    {
      map['time_of_day'] = Variable<int>(
        $MuraqabaSessionsTable.$convertertimeOfDay.toSql(timeOfDay),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MuraqabaSessionsCompanion toCompanion(bool nullToAbsent) {
    return MuraqabaSessionsCompanion(
      id: Value(id),
      date: Value(date),
      minutes: Value(minutes),
      timeOfDay: Value(timeOfDay),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory MuraqabaSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MuraqabaSession(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      minutes: serializer.fromJson<int>(json['minutes']),
      timeOfDay: $MuraqabaSessionsTable.$convertertimeOfDay.fromJson(
        serializer.fromJson<int>(json['timeOfDay']),
      ),
      note: serializer.fromJson<String?>(json['note']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'minutes': serializer.toJson<int>(minutes),
      'timeOfDay': serializer.toJson<int>(
        $MuraqabaSessionsTable.$convertertimeOfDay.toJson(timeOfDay),
      ),
      'note': serializer.toJson<String?>(note),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MuraqabaSession copyWith({
    int? id,
    String? date,
    int? minutes,
    MuraqabaTime? timeOfDay,
    Value<String?> note = const Value.absent(),
    String? source,
    DateTime? createdAt,
  }) => MuraqabaSession(
    id: id ?? this.id,
    date: date ?? this.date,
    minutes: minutes ?? this.minutes,
    timeOfDay: timeOfDay ?? this.timeOfDay,
    note: note.present ? note.value : this.note,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  MuraqabaSession copyWithCompanion(MuraqabaSessionsCompanion data) {
    return MuraqabaSession(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      timeOfDay: data.timeOfDay.present ? data.timeOfDay.value : this.timeOfDay,
      note: data.note.present ? data.note.value : this.note,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MuraqabaSession(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('minutes: $minutes, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, minutes, timeOfDay, note, source, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MuraqabaSession &&
          other.id == this.id &&
          other.date == this.date &&
          other.minutes == this.minutes &&
          other.timeOfDay == this.timeOfDay &&
          other.note == this.note &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class MuraqabaSessionsCompanion extends UpdateCompanion<MuraqabaSession> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> minutes;
  final Value<MuraqabaTime> timeOfDay;
  final Value<String?> note;
  final Value<String> source;
  final Value<DateTime> createdAt;
  const MuraqabaSessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.minutes = const Value.absent(),
    this.timeOfDay = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MuraqabaSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    this.minutes = const Value.absent(),
    this.timeOfDay = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<MuraqabaSession> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? minutes,
    Expression<int>? timeOfDay,
    Expression<String>? note,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (minutes != null) 'minutes': minutes,
      if (timeOfDay != null) 'time_of_day': timeOfDay,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MuraqabaSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<int>? minutes,
    Value<MuraqabaTime>? timeOfDay,
    Value<String?>? note,
    Value<String>? source,
    Value<DateTime>? createdAt,
  }) {
    return MuraqabaSessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      minutes: minutes ?? this.minutes,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      note: note ?? this.note,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (timeOfDay.present) {
      map['time_of_day'] = Variable<int>(
        $MuraqabaSessionsTable.$convertertimeOfDay.toSql(timeOfDay.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MuraqabaSessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('minutes: $minutes, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskCategory, int> category =
      GeneratedColumn<int>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TaskCategory>($TasksTable.$convertercategory);
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('task'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF1F8F4E),
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskRepeat, int> repeat =
      GeneratedColumn<int>(
        'repeat',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      ).withConverter<TaskRepeat>($TasksTable.$converterrepeat);
  static const VerificationMeta _weekdaysMaskMeta = const VerificationMeta(
    'weekdaysMask',
  );
  @override
  late final GeneratedColumn<int> weekdaysMask = GeneratedColumn<int>(
    'weekdays_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _anchorDateMeta = const VerificationMeta(
    'anchorDate',
  );
  @override
  late final GeneratedColumn<String> anchorDate = GeneratedColumn<String>(
    'anchor_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderMinutesMeta = const VerificationMeta(
    'reminderMinutes',
  );
  @override
  late final GeneratedColumn<int> reminderMinutes = GeneratedColumn<int>(
    'reminder_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    category,
    iconKey,
    colorValue,
    startMinutes,
    endMinutes,
    repeat,
    weekdaysMask,
    anchorDate,
    reminderMinutes,
    note,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    }
    if (data.containsKey('weekdays_mask')) {
      context.handle(
        _weekdaysMaskMeta,
        weekdaysMask.isAcceptableOrUnknown(
          data['weekdays_mask']!,
          _weekdaysMaskMeta,
        ),
      );
    }
    if (data.containsKey('anchor_date')) {
      context.handle(
        _anchorDateMeta,
        anchorDate.isAcceptableOrUnknown(data['anchor_date']!, _anchorDateMeta),
      );
    } else if (isInserting) {
      context.missing(_anchorDateMeta);
    }
    if (data.containsKey('reminder_minutes')) {
      context.handle(
        _reminderMinutesMeta,
        reminderMinutes.isAcceptableOrUnknown(
          data['reminder_minutes']!,
          _reminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: $TasksTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}category'],
        )!,
      ),
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      )!,
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      )!,
      repeat: $TasksTable.$converterrepeat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}repeat'],
        )!,
      ),
      weekdaysMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays_mask'],
      )!,
      anchorDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_date'],
      )!,
      reminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskCategory, int, int> $convertercategory =
      const EnumIndexConverter<TaskCategory>(TaskCategory.values);
  static JsonTypeConverter2<TaskRepeat, int, int> $converterrepeat =
      const EnumIndexConverter<TaskRepeat>(TaskRepeat.values);
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String title;
  final TaskCategory category;

  /// Key into the curated icon map (tree-shake-safe).
  final String iconKey;

  /// ARGB colour used by the timeline block.
  final int colorValue;

  /// Start time as minutes from midnight (0..1439).
  final int startMinutes;

  /// End time as minutes from midnight (1..1440).
  final int endMinutes;
  final TaskRepeat repeat;

  /// Bit 0 = Monday … bit 6 = Sunday. Used by [TaskRepeat.customDays] and
  /// [TaskRepeat.weekdays] (the latter also checks the mask).
  final int weekdaysMask;

  /// First day the task may occur (`yyyy-MM-dd`); for one-time tasks this is
  /// also the only day it occurs.
  final String anchorDate;

  /// Optional reminder time as minutes from midnight.
  final int? reminderMinutes;
  final String? note;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Task({
    required this.id,
    required this.title,
    required this.category,
    required this.iconKey,
    required this.colorValue,
    required this.startMinutes,
    required this.endMinutes,
    required this.repeat,
    required this.weekdaysMask,
    required this.anchorDate,
    this.reminderMinutes,
    this.note,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    {
      map['category'] = Variable<int>(
        $TasksTable.$convertercategory.toSql(category),
      );
    }
    map['icon_key'] = Variable<String>(iconKey);
    map['color_value'] = Variable<int>(colorValue);
    map['start_minutes'] = Variable<int>(startMinutes);
    map['end_minutes'] = Variable<int>(endMinutes);
    {
      map['repeat'] = Variable<int>($TasksTable.$converterrepeat.toSql(repeat));
    }
    map['weekdays_mask'] = Variable<int>(weekdaysMask);
    map['anchor_date'] = Variable<String>(anchorDate);
    if (!nullToAbsent || reminderMinutes != null) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      iconKey: Value(iconKey),
      colorValue: Value(colorValue),
      startMinutes: Value(startMinutes),
      endMinutes: Value(endMinutes),
      repeat: Value(repeat),
      weekdaysMask: Value(weekdaysMask),
      anchorDate: Value(anchorDate),
      reminderMinutes: reminderMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinutes),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: $TasksTable.$convertercategory.fromJson(
        serializer.fromJson<int>(json['category']),
      ),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      endMinutes: serializer.fromJson<int>(json['endMinutes']),
      repeat: $TasksTable.$converterrepeat.fromJson(
        serializer.fromJson<int>(json['repeat']),
      ),
      weekdaysMask: serializer.fromJson<int>(json['weekdaysMask']),
      anchorDate: serializer.fromJson<String>(json['anchorDate']),
      reminderMinutes: serializer.fromJson<int?>(json['reminderMinutes']),
      note: serializer.fromJson<String?>(json['note']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<int>(
        $TasksTable.$convertercategory.toJson(category),
      ),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorValue': serializer.toJson<int>(colorValue),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'endMinutes': serializer.toJson<int>(endMinutes),
      'repeat': serializer.toJson<int>(
        $TasksTable.$converterrepeat.toJson(repeat),
      ),
      'weekdaysMask': serializer.toJson<int>(weekdaysMask),
      'anchorDate': serializer.toJson<String>(anchorDate),
      'reminderMinutes': serializer.toJson<int?>(reminderMinutes),
      'note': serializer.toJson<String?>(note),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Task copyWith({
    int? id,
    String? title,
    TaskCategory? category,
    String? iconKey,
    int? colorValue,
    int? startMinutes,
    int? endMinutes,
    TaskRepeat? repeat,
    int? weekdaysMask,
    String? anchorDate,
    Value<int?> reminderMinutes = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    iconKey: iconKey ?? this.iconKey,
    colorValue: colorValue ?? this.colorValue,
    startMinutes: startMinutes ?? this.startMinutes,
    endMinutes: endMinutes ?? this.endMinutes,
    repeat: repeat ?? this.repeat,
    weekdaysMask: weekdaysMask ?? this.weekdaysMask,
    anchorDate: anchorDate ?? this.anchorDate,
    reminderMinutes: reminderMinutes.present
        ? reminderMinutes.value
        : this.reminderMinutes,
    note: note.present ? note.value : this.note,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      repeat: data.repeat.present ? data.repeat.value : this.repeat,
      weekdaysMask: data.weekdaysMask.present
          ? data.weekdaysMask.value
          : this.weekdaysMask,
      anchorDate: data.anchorDate.present
          ? data.anchorDate.value
          : this.anchorDate,
      reminderMinutes: data.reminderMinutes.present
          ? data.reminderMinutes.value
          : this.reminderMinutes,
      note: data.note.present ? data.note.value : this.note,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('repeat: $repeat, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('note: $note, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    iconKey,
    colorValue,
    startMinutes,
    endMinutes,
    repeat,
    weekdaysMask,
    anchorDate,
    reminderMinutes,
    note,
    active,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.iconKey == this.iconKey &&
          other.colorValue == this.colorValue &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.repeat == this.repeat &&
          other.weekdaysMask == this.weekdaysMask &&
          other.anchorDate == this.anchorDate &&
          other.reminderMinutes == this.reminderMinutes &&
          other.note == this.note &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> title;
  final Value<TaskCategory> category;
  final Value<String> iconKey;
  final Value<int> colorValue;
  final Value<int> startMinutes;
  final Value<int> endMinutes;
  final Value<TaskRepeat> repeat;
  final Value<int> weekdaysMask;
  final Value<String> anchorDate;
  final Value<int?> reminderMinutes;
  final Value<String?> note;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.repeat = const Value.absent(),
    this.weekdaysMask = const Value.absent(),
    this.anchorDate = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.note = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.category = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.repeat = const Value.absent(),
    this.weekdaysMask = const Value.absent(),
    required String anchorDate,
    this.reminderMinutes = const Value.absent(),
    this.note = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title),
       anchorDate = Value(anchorDate);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? category,
    Expression<String>? iconKey,
    Expression<int>? colorValue,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<int>? repeat,
    Expression<int>? weekdaysMask,
    Expression<String>? anchorDate,
    Expression<int>? reminderMinutes,
    Expression<String>? note,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorValue != null) 'color_value': colorValue,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (repeat != null) 'repeat': repeat,
      if (weekdaysMask != null) 'weekdays_mask': weekdaysMask,
      if (anchorDate != null) 'anchor_date': anchorDate,
      if (reminderMinutes != null) 'reminder_minutes': reminderMinutes,
      if (note != null) 'note': note,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<TaskCategory>? category,
    Value<String>? iconKey,
    Value<int>? colorValue,
    Value<int>? startMinutes,
    Value<int>? endMinutes,
    Value<TaskRepeat>? repeat,
    Value<int>? weekdaysMask,
    Value<String>? anchorDate,
    Value<int?>? reminderMinutes,
    Value<String?>? note,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      repeat: repeat ?? this.repeat,
      weekdaysMask: weekdaysMask ?? this.weekdaysMask,
      anchorDate: anchorDate ?? this.anchorDate,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      note: note ?? this.note,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
        $TasksTable.$convertercategory.toSql(category.value),
      );
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<int>(
        $TasksTable.$converterrepeat.toSql(repeat.value),
      );
    }
    if (weekdaysMask.present) {
      map['weekdays_mask'] = Variable<int>(weekdaysMask.value);
    }
    if (anchorDate.present) {
      map['anchor_date'] = Variable<String>(anchorDate.value);
    }
    if (reminderMinutes.present) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('repeat: $repeat, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('note: $note, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaskCompletionsTable extends TaskCompletions
    with TableInfo<$TaskCompletionsTable, TaskCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, date, done, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, date};
  @override
  TaskCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCompletion(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskCompletionsTable createAlias(String alias) {
    return $TaskCompletionsTable(attachedDatabase, alias);
  }
}

class TaskCompletion extends DataClass implements Insertable<TaskCompletion> {
  final int taskId;

  /// `yyyy-MM-dd`.
  final String date;
  final bool done;
  final DateTime updatedAt;
  const TaskCompletion({
    required this.taskId,
    required this.date,
    required this.done,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<int>(taskId);
    map['date'] = Variable<String>(date);
    map['done'] = Variable<bool>(done);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskCompletionsCompanion toCompanion(bool nullToAbsent) {
    return TaskCompletionsCompanion(
      taskId: Value(taskId),
      date: Value(date),
      done: Value(done),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCompletion(
      taskId: serializer.fromJson<int>(json['taskId']),
      date: serializer.fromJson<String>(json['date']),
      done: serializer.fromJson<bool>(json['done']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<int>(taskId),
      'date': serializer.toJson<String>(date),
      'done': serializer.toJson<bool>(done),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskCompletion copyWith({
    int? taskId,
    String? date,
    bool? done,
    DateTime? updatedAt,
  }) => TaskCompletion(
    taskId: taskId ?? this.taskId,
    date: date ?? this.date,
    done: done ?? this.done,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskCompletion copyWithCompanion(TaskCompletionsCompanion data) {
    return TaskCompletion(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      date: data.date.present ? data.date.value : this.date,
      done: data.done.present ? data.done.value : this.done,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletion(')
          ..write('taskId: $taskId, ')
          ..write('date: $date, ')
          ..write('done: $done, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, date, done, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCompletion &&
          other.taskId == this.taskId &&
          other.date == this.date &&
          other.done == this.done &&
          other.updatedAt == this.updatedAt);
}

class TaskCompletionsCompanion extends UpdateCompanion<TaskCompletion> {
  final Value<int> taskId;
  final Value<String> date;
  final Value<bool> done;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskCompletionsCompanion({
    this.taskId = const Value.absent(),
    this.date = const Value.absent(),
    this.done = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskCompletionsCompanion.insert({
    required int taskId,
    required String date,
    this.done = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       date = Value(date);
  static Insertable<TaskCompletion> custom({
    Expression<int>? taskId,
    Expression<String>? date,
    Expression<bool>? done,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (date != null) 'date': date,
      if (done != null) 'done': done,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskCompletionsCompanion copyWith({
    Value<int>? taskId,
    Value<String>? date,
    Value<bool>? done,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskCompletionsCompanion(
      taskId: taskId ?? this.taskId,
      date: date ?? this.date,
      done: done ?? this.done,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletionsCompanion(')
          ..write('taskId: $taskId, ')
          ..write('date: $date, ')
          ..write('done: $done, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NamazEntriesTable namazEntries = $NamazEntriesTable(this);
  late final $NaflEntriesTable naflEntries = $NaflEntriesTable(this);
  late final $QazaRecordsTable qazaRecords = $QazaRecordsTable(this);
  late final $TilawatEntriesTable tilawatEntries = $TilawatEntriesTable(this);
  late final $TilawatPositionsTable tilawatPositions = $TilawatPositionsTable(
    this,
  );
  late final $CustomDhikrsTable customDhikrs = $CustomDhikrsTable(this);
  late final $AzkarEntriesTable azkarEntries = $AzkarEntriesTable(this);
  late final $KhatamsTable khatams = $KhatamsTable(this);
  late final $KhatamParasTable khatamParas = $KhatamParasTable(this);
  late final $GheebatEntriesTable gheebatEntries = $GheebatEntriesTable(this);
  late final $MuraqabaSessionsTable muraqabaSessions = $MuraqabaSessionsTable(
    this,
  );
  late final $TasksTable tasks = $TasksTable(this);
  late final $TaskCompletionsTable taskCompletions = $TaskCompletionsTable(
    this,
  );
  late final NamazDao namazDao = NamazDao(this as AppDatabase);
  late final NaflDao naflDao = NaflDao(this as AppDatabase);
  late final QazaDao qazaDao = QazaDao(this as AppDatabase);
  late final TilawatDao tilawatDao = TilawatDao(this as AppDatabase);
  late final AzkarDao azkarDao = AzkarDao(this as AppDatabase);
  late final KhatamDao khatamDao = KhatamDao(this as AppDatabase);
  late final GheebatDao gheebatDao = GheebatDao(this as AppDatabase);
  late final MuraqabaDao muraqabaDao = MuraqabaDao(this as AppDatabase);
  late final TimetableDao timetableDao = TimetableDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    namazEntries,
    naflEntries,
    qazaRecords,
    tilawatEntries,
    tilawatPositions,
    customDhikrs,
    azkarEntries,
    khatams,
    khatamParas,
    gheebatEntries,
    muraqabaSessions,
    tasks,
    taskCompletions,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'khatams',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('khatam_paras', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_completions', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$NamazEntriesTableCreateCompanionBuilder =
    NamazEntriesCompanion Function({
      required String date,
      required NamazType prayer,
      Value<NamazStatus> status,
      Value<bool> takbeerUla,
      Value<bool> masbooq,
      Value<bool> atMasjid,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$NamazEntriesTableUpdateCompanionBuilder =
    NamazEntriesCompanion Function({
      Value<String> date,
      Value<NamazType> prayer,
      Value<NamazStatus> status,
      Value<bool> takbeerUla,
      Value<bool> masbooq,
      Value<bool> atMasjid,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$NamazEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $NamazEntriesTable> {
  $$NamazEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NamazType, NamazType, int> get prayer =>
      $composableBuilder(
        column: $table.prayer,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<NamazStatus, NamazStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get takbeerUla => $composableBuilder(
    column: $table.takbeerUla,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get masbooq => $composableBuilder(
    column: $table.masbooq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get atMasjid => $composableBuilder(
    column: $table.atMasjid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NamazEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NamazEntriesTable> {
  $$NamazEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get takbeerUla => $composableBuilder(
    column: $table.takbeerUla,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get masbooq => $composableBuilder(
    column: $table.masbooq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get atMasjid => $composableBuilder(
    column: $table.atMasjid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NamazEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NamazEntriesTable> {
  $$NamazEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NamazType, int> get prayer =>
      $composableBuilder(column: $table.prayer, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NamazStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get takbeerUla => $composableBuilder(
    column: $table.takbeerUla,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get masbooq =>
      $composableBuilder(column: $table.masbooq, builder: (column) => column);

  GeneratedColumn<bool> get atMasjid =>
      $composableBuilder(column: $table.atMasjid, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NamazEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NamazEntriesTable,
          NamazEntry,
          $$NamazEntriesTableFilterComposer,
          $$NamazEntriesTableOrderingComposer,
          $$NamazEntriesTableAnnotationComposer,
          $$NamazEntriesTableCreateCompanionBuilder,
          $$NamazEntriesTableUpdateCompanionBuilder,
          (
            NamazEntry,
            BaseReferences<_$AppDatabase, $NamazEntriesTable, NamazEntry>,
          ),
          NamazEntry,
          PrefetchHooks Function()
        > {
  $$NamazEntriesTableTableManager(_$AppDatabase db, $NamazEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NamazEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NamazEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NamazEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<NamazType> prayer = const Value.absent(),
                Value<NamazStatus> status = const Value.absent(),
                Value<bool> takbeerUla = const Value.absent(),
                Value<bool> masbooq = const Value.absent(),
                Value<bool> atMasjid = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NamazEntriesCompanion(
                date: date,
                prayer: prayer,
                status: status,
                takbeerUla: takbeerUla,
                masbooq: masbooq,
                atMasjid: atMasjid,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required NamazType prayer,
                Value<NamazStatus> status = const Value.absent(),
                Value<bool> takbeerUla = const Value.absent(),
                Value<bool> masbooq = const Value.absent(),
                Value<bool> atMasjid = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NamazEntriesCompanion.insert(
                date: date,
                prayer: prayer,
                status: status,
                takbeerUla: takbeerUla,
                masbooq: masbooq,
                atMasjid: atMasjid,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NamazEntriesTable, NamazEntry>(table),
                  BaseReferences<_$AppDatabase, $NamazEntriesTable, NamazEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NamazEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NamazEntriesTable,
      NamazEntry,
      $$NamazEntriesTableFilterComposer,
      $$NamazEntriesTableOrderingComposer,
      $$NamazEntriesTableAnnotationComposer,
      $$NamazEntriesTableCreateCompanionBuilder,
      $$NamazEntriesTableUpdateCompanionBuilder,
      (
        NamazEntry,
        BaseReferences<_$AppDatabase, $NamazEntriesTable, NamazEntry>,
      ),
      NamazEntry,
      PrefetchHooks Function()
    >;
typedef $$NaflEntriesTableCreateCompanionBuilder =
    NaflEntriesCompanion Function({
      required String date,
      required NaflType naflType,
      Value<String> customName,
      Value<int> rakats,
      Value<bool> done,
      Value<String?> note,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$NaflEntriesTableUpdateCompanionBuilder =
    NaflEntriesCompanion Function({
      Value<String> date,
      Value<NaflType> naflType,
      Value<String> customName,
      Value<int> rakats,
      Value<bool> done,
      Value<String?> note,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$NaflEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $NaflEntriesTable> {
  $$NaflEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NaflType, NaflType, int> get naflType =>
      $composableBuilder(
        column: $table.naflType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rakats => $composableBuilder(
    column: $table.rakats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NaflEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NaflEntriesTable> {
  $$NaflEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get naflType => $composableBuilder(
    column: $table.naflType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rakats => $composableBuilder(
    column: $table.rakats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NaflEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NaflEntriesTable> {
  $$NaflEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NaflType, int> get naflType =>
      $composableBuilder(column: $table.naflType, builder: (column) => column);

  GeneratedColumn<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rakats =>
      $composableBuilder(column: $table.rakats, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NaflEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NaflEntriesTable,
          NaflEntry,
          $$NaflEntriesTableFilterComposer,
          $$NaflEntriesTableOrderingComposer,
          $$NaflEntriesTableAnnotationComposer,
          $$NaflEntriesTableCreateCompanionBuilder,
          $$NaflEntriesTableUpdateCompanionBuilder,
          (
            NaflEntry,
            BaseReferences<_$AppDatabase, $NaflEntriesTable, NaflEntry>,
          ),
          NaflEntry,
          PrefetchHooks Function()
        > {
  $$NaflEntriesTableTableManager(_$AppDatabase db, $NaflEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NaflEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NaflEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NaflEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<NaflType> naflType = const Value.absent(),
                Value<String> customName = const Value.absent(),
                Value<int> rakats = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NaflEntriesCompanion(
                date: date,
                naflType: naflType,
                customName: customName,
                rakats: rakats,
                done: done,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required NaflType naflType,
                Value<String> customName = const Value.absent(),
                Value<int> rakats = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NaflEntriesCompanion.insert(
                date: date,
                naflType: naflType,
                customName: customName,
                rakats: rakats,
                done: done,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NaflEntriesTable, NaflEntry>(table),
                  BaseReferences<_$AppDatabase, $NaflEntriesTable, NaflEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NaflEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NaflEntriesTable,
      NaflEntry,
      $$NaflEntriesTableFilterComposer,
      $$NaflEntriesTableOrderingComposer,
      $$NaflEntriesTableAnnotationComposer,
      $$NaflEntriesTableCreateCompanionBuilder,
      $$NaflEntriesTableUpdateCompanionBuilder,
      (NaflEntry, BaseReferences<_$AppDatabase, $NaflEntriesTable, NaflEntry>),
      NaflEntry,
      PrefetchHooks Function()
    >;
typedef $$QazaRecordsTableCreateCompanionBuilder =
    QazaRecordsCompanion Function({
      Value<int> id,
      required NamazType prayer,
      Value<int> rakats,
      required String logDate,
      Value<String> source,
      Value<String?> note,
      Value<bool> isMadeUp,
      Value<String?> madeUpDate,
      Value<DateTime> createdAt,
    });
typedef $$QazaRecordsTableUpdateCompanionBuilder =
    QazaRecordsCompanion Function({
      Value<int> id,
      Value<NamazType> prayer,
      Value<int> rakats,
      Value<String> logDate,
      Value<String> source,
      Value<String?> note,
      Value<bool> isMadeUp,
      Value<String?> madeUpDate,
      Value<DateTime> createdAt,
    });

class $$QazaRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $QazaRecordsTable> {
  $$QazaRecordsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<NamazType, NamazType, int> get prayer =>
      $composableBuilder(
        column: $table.prayer,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get rakats => $composableBuilder(
    column: $table.rakats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMadeUp => $composableBuilder(
    column: $table.isMadeUp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get madeUpDate => $composableBuilder(
    column: $table.madeUpDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QazaRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $QazaRecordsTable> {
  $$QazaRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rakats => $composableBuilder(
    column: $table.rakats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMadeUp => $composableBuilder(
    column: $table.isMadeUp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get madeUpDate => $composableBuilder(
    column: $table.madeUpDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QazaRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QazaRecordsTable> {
  $$QazaRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NamazType, int> get prayer =>
      $composableBuilder(column: $table.prayer, builder: (column) => column);

  GeneratedColumn<int> get rakats =>
      $composableBuilder(column: $table.rakats, builder: (column) => column);

  GeneratedColumn<String> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isMadeUp =>
      $composableBuilder(column: $table.isMadeUp, builder: (column) => column);

  GeneratedColumn<String> get madeUpDate => $composableBuilder(
    column: $table.madeUpDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$QazaRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QazaRecordsTable,
          QazaRecord,
          $$QazaRecordsTableFilterComposer,
          $$QazaRecordsTableOrderingComposer,
          $$QazaRecordsTableAnnotationComposer,
          $$QazaRecordsTableCreateCompanionBuilder,
          $$QazaRecordsTableUpdateCompanionBuilder,
          (
            QazaRecord,
            BaseReferences<_$AppDatabase, $QazaRecordsTable, QazaRecord>,
          ),
          QazaRecord,
          PrefetchHooks Function()
        > {
  $$QazaRecordsTableTableManager(_$AppDatabase db, $QazaRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QazaRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QazaRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QazaRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<NamazType> prayer = const Value.absent(),
                Value<int> rakats = const Value.absent(),
                Value<String> logDate = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isMadeUp = const Value.absent(),
                Value<String?> madeUpDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => QazaRecordsCompanion(
                id: id,
                prayer: prayer,
                rakats: rakats,
                logDate: logDate,
                source: source,
                note: note,
                isMadeUp: isMadeUp,
                madeUpDate: madeUpDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required NamazType prayer,
                Value<int> rakats = const Value.absent(),
                required String logDate,
                Value<String> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isMadeUp = const Value.absent(),
                Value<String?> madeUpDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => QazaRecordsCompanion.insert(
                id: id,
                prayer: prayer,
                rakats: rakats,
                logDate: logDate,
                source: source,
                note: note,
                isMadeUp: isMadeUp,
                madeUpDate: madeUpDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QazaRecordsTable, QazaRecord>(table),
                  BaseReferences<_$AppDatabase, $QazaRecordsTable, QazaRecord>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QazaRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QazaRecordsTable,
      QazaRecord,
      $$QazaRecordsTableFilterComposer,
      $$QazaRecordsTableOrderingComposer,
      $$QazaRecordsTableAnnotationComposer,
      $$QazaRecordsTableCreateCompanionBuilder,
      $$QazaRecordsTableUpdateCompanionBuilder,
      (
        QazaRecord,
        BaseReferences<_$AppDatabase, $QazaRecordsTable, QazaRecord>,
      ),
      QazaRecord,
      PrefetchHooks Function()
    >;
typedef $$TilawatEntriesTableCreateCompanionBuilder =
    TilawatEntriesCompanion Function({
      Value<int> id,
      required String date,
      required TilawatUnit unit,
      Value<int> amount,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$TilawatEntriesTableUpdateCompanionBuilder =
    TilawatEntriesCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<TilawatUnit> unit,
      Value<int> amount,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

class $$TilawatEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TilawatEntriesTable> {
  $$TilawatEntriesTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TilawatUnit, TilawatUnit, int> get unit =>
      $composableBuilder(
        column: $table.unit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TilawatEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TilawatEntriesTable> {
  $$TilawatEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TilawatEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TilawatEntriesTable> {
  $$TilawatEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TilawatUnit, int> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TilawatEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TilawatEntriesTable,
          TilawatEntry,
          $$TilawatEntriesTableFilterComposer,
          $$TilawatEntriesTableOrderingComposer,
          $$TilawatEntriesTableAnnotationComposer,
          $$TilawatEntriesTableCreateCompanionBuilder,
          $$TilawatEntriesTableUpdateCompanionBuilder,
          (
            TilawatEntry,
            BaseReferences<_$AppDatabase, $TilawatEntriesTable, TilawatEntry>,
          ),
          TilawatEntry,
          PrefetchHooks Function()
        > {
  $$TilawatEntriesTableTableManager(
    _$AppDatabase db,
    $TilawatEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TilawatEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TilawatEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TilawatEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<TilawatUnit> unit = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TilawatEntriesCompanion(
                id: id,
                date: date,
                unit: unit,
                amount: amount,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required TilawatUnit unit,
                Value<int> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TilawatEntriesCompanion.insert(
                id: id,
                date: date,
                unit: unit,
                amount: amount,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TilawatEntriesTable, TilawatEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TilawatEntriesTable,
                    TilawatEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TilawatEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TilawatEntriesTable,
      TilawatEntry,
      $$TilawatEntriesTableFilterComposer,
      $$TilawatEntriesTableOrderingComposer,
      $$TilawatEntriesTableAnnotationComposer,
      $$TilawatEntriesTableCreateCompanionBuilder,
      $$TilawatEntriesTableUpdateCompanionBuilder,
      (
        TilawatEntry,
        BaseReferences<_$AppDatabase, $TilawatEntriesTable, TilawatEntry>,
      ),
      TilawatEntry,
      PrefetchHooks Function()
    >;
typedef $$TilawatPositionsTableCreateCompanionBuilder =
    TilawatPositionsCompanion Function({
      Value<int> id,
      Value<int> para,
      Value<String> surah,
      Value<int> page,
      Value<DateTime> updatedAt,
    });
typedef $$TilawatPositionsTableUpdateCompanionBuilder =
    TilawatPositionsCompanion Function({
      Value<int> id,
      Value<int> para,
      Value<String> surah,
      Value<int> page,
      Value<DateTime> updatedAt,
    });

class $$TilawatPositionsTableFilterComposer
    extends Composer<_$AppDatabase, $TilawatPositionsTable> {
  $$TilawatPositionsTableFilterComposer({
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

  ColumnFilters<int> get para => $composableBuilder(
    column: $table.para,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surah => $composableBuilder(
    column: $table.surah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TilawatPositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TilawatPositionsTable> {
  $$TilawatPositionsTableOrderingComposer({
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

  ColumnOrderings<int> get para => $composableBuilder(
    column: $table.para,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surah => $composableBuilder(
    column: $table.surah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TilawatPositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TilawatPositionsTable> {
  $$TilawatPositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get para =>
      $composableBuilder(column: $table.para, builder: (column) => column);

  GeneratedColumn<String> get surah =>
      $composableBuilder(column: $table.surah, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TilawatPositionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TilawatPositionsTable,
          TilawatPosition,
          $$TilawatPositionsTableFilterComposer,
          $$TilawatPositionsTableOrderingComposer,
          $$TilawatPositionsTableAnnotationComposer,
          $$TilawatPositionsTableCreateCompanionBuilder,
          $$TilawatPositionsTableUpdateCompanionBuilder,
          (
            TilawatPosition,
            BaseReferences<
              _$AppDatabase,
              $TilawatPositionsTable,
              TilawatPosition
            >,
          ),
          TilawatPosition,
          PrefetchHooks Function()
        > {
  $$TilawatPositionsTableTableManager(
    _$AppDatabase db,
    $TilawatPositionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TilawatPositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TilawatPositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TilawatPositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> para = const Value.absent(),
                Value<String> surah = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TilawatPositionsCompanion(
                id: id,
                para: para,
                surah: surah,
                page: page,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> para = const Value.absent(),
                Value<String> surah = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TilawatPositionsCompanion.insert(
                id: id,
                para: para,
                surah: surah,
                page: page,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TilawatPositionsTable, TilawatPosition>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TilawatPositionsTable,
                    TilawatPosition
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TilawatPositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TilawatPositionsTable,
      TilawatPosition,
      $$TilawatPositionsTableFilterComposer,
      $$TilawatPositionsTableOrderingComposer,
      $$TilawatPositionsTableAnnotationComposer,
      $$TilawatPositionsTableCreateCompanionBuilder,
      $$TilawatPositionsTableUpdateCompanionBuilder,
      (
        TilawatPosition,
        BaseReferences<_$AppDatabase, $TilawatPositionsTable, TilawatPosition>,
      ),
      TilawatPosition,
      PrefetchHooks Function()
    >;
typedef $$CustomDhikrsTableCreateCompanionBuilder =
    CustomDhikrsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> arabicText,
      Value<int> target,
      Value<String?> reminderTime,
      Value<bool> active,
      Value<DateTime> createdAt,
    });
typedef $$CustomDhikrsTableUpdateCompanionBuilder =
    CustomDhikrsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> arabicText,
      Value<int> target,
      Value<String?> reminderTime,
      Value<bool> active,
      Value<DateTime> createdAt,
    });

class $$CustomDhikrsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomDhikrsTable> {
  $$CustomDhikrsTableFilterComposer({
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

  ColumnFilters<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomDhikrsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomDhikrsTable> {
  $$CustomDhikrsTableOrderingComposer({
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

  ColumnOrderings<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomDhikrsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomDhikrsTable> {
  $$CustomDhikrsTableAnnotationComposer({
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

  GeneratedColumn<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomDhikrsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomDhikrsTable,
          CustomDhikr,
          $$CustomDhikrsTableFilterComposer,
          $$CustomDhikrsTableOrderingComposer,
          $$CustomDhikrsTableAnnotationComposer,
          $$CustomDhikrsTableCreateCompanionBuilder,
          $$CustomDhikrsTableUpdateCompanionBuilder,
          (
            CustomDhikr,
            BaseReferences<_$AppDatabase, $CustomDhikrsTable, CustomDhikr>,
          ),
          CustomDhikr,
          PrefetchHooks Function()
        > {
  $$CustomDhikrsTableTableManager(_$AppDatabase db, $CustomDhikrsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomDhikrsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomDhikrsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomDhikrsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> arabicText = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomDhikrsCompanion(
                id: id,
                name: name,
                arabicText: arabicText,
                target: target,
                reminderTime: reminderTime,
                active: active,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> arabicText = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomDhikrsCompanion.insert(
                id: id,
                name: name,
                arabicText: arabicText,
                target: target,
                reminderTime: reminderTime,
                active: active,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomDhikrsTable, CustomDhikr>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CustomDhikrsTable,
                    CustomDhikr
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomDhikrsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomDhikrsTable,
      CustomDhikr,
      $$CustomDhikrsTableFilterComposer,
      $$CustomDhikrsTableOrderingComposer,
      $$CustomDhikrsTableAnnotationComposer,
      $$CustomDhikrsTableCreateCompanionBuilder,
      $$CustomDhikrsTableUpdateCompanionBuilder,
      (
        CustomDhikr,
        BaseReferences<_$AppDatabase, $CustomDhikrsTable, CustomDhikr>,
      ),
      CustomDhikr,
      PrefetchHooks Function()
    >;
typedef $$AzkarEntriesTableCreateCompanionBuilder =
    AzkarEntriesCompanion Function({
      required String date,
      required String dhikrKey,
      Value<int> count,
      Value<int> target,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AzkarEntriesTableUpdateCompanionBuilder =
    AzkarEntriesCompanion Function({
      Value<String> date,
      Value<String> dhikrKey,
      Value<int> count,
      Value<int> target,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AzkarEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AzkarEntriesTable> {
  $$AzkarEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dhikrKey => $composableBuilder(
    column: $table.dhikrKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AzkarEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AzkarEntriesTable> {
  $$AzkarEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dhikrKey => $composableBuilder(
    column: $table.dhikrKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AzkarEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AzkarEntriesTable> {
  $$AzkarEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get dhikrKey =>
      $composableBuilder(column: $table.dhikrKey, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AzkarEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AzkarEntriesTable,
          AzkarEntry,
          $$AzkarEntriesTableFilterComposer,
          $$AzkarEntriesTableOrderingComposer,
          $$AzkarEntriesTableAnnotationComposer,
          $$AzkarEntriesTableCreateCompanionBuilder,
          $$AzkarEntriesTableUpdateCompanionBuilder,
          (
            AzkarEntry,
            BaseReferences<_$AppDatabase, $AzkarEntriesTable, AzkarEntry>,
          ),
          AzkarEntry,
          PrefetchHooks Function()
        > {
  $$AzkarEntriesTableTableManager(_$AppDatabase db, $AzkarEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AzkarEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AzkarEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AzkarEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> dhikrKey = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AzkarEntriesCompanion(
                date: date,
                dhikrKey: dhikrKey,
                count: count,
                target: target,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String dhikrKey,
                Value<int> count = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AzkarEntriesCompanion.insert(
                date: date,
                dhikrKey: dhikrKey,
                count: count,
                target: target,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AzkarEntriesTable, AzkarEntry>(table),
                  BaseReferences<_$AppDatabase, $AzkarEntriesTable, AzkarEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AzkarEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AzkarEntriesTable,
      AzkarEntry,
      $$AzkarEntriesTableFilterComposer,
      $$AzkarEntriesTableOrderingComposer,
      $$AzkarEntriesTableAnnotationComposer,
      $$AzkarEntriesTableCreateCompanionBuilder,
      $$AzkarEntriesTableUpdateCompanionBuilder,
      (
        AzkarEntry,
        BaseReferences<_$AppDatabase, $AzkarEntriesTable, AzkarEntry>,
      ),
      AzkarEntry,
      PrefetchHooks Function()
    >;
typedef $$KhatamsTableCreateCompanionBuilder =
    KhatamsCompanion Function({
      Value<int> id,
      required String startDate,
      Value<String?> endDate,
      Value<DateTime> createdAt,
    });
typedef $$KhatamsTableUpdateCompanionBuilder =
    KhatamsCompanion Function({
      Value<int> id,
      Value<String> startDate,
      Value<String?> endDate,
      Value<DateTime> createdAt,
    });

final class $$KhatamsTableReferences
    extends BaseReferences<_$AppDatabase, $KhatamsTable, Khatam> {
  $$KhatamsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$KhatamParasTable, List<KhatamPara>>
  _khatamParasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.khatamParas,
    aliasName: 'khatams__id__khatam_paras__khatam_id',
  );

  $$KhatamParasTableProcessedTableManager get khatamParasRefs {
    final manager = $$KhatamParasTableTableManager(
      $_db,
      $_db.khatamParas,
    ).filter((f) => f.khatamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_khatamParasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KhatamsTableFilterComposer
    extends Composer<_$AppDatabase, $KhatamsTable> {
  $$KhatamsTableFilterComposer({
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

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> khatamParasRefs(
    Expression<bool> Function($$KhatamParasTableFilterComposer f) f,
  ) {
    final $$KhatamParasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.khatamParas,
      getReferencedColumn: (t) => t.khatamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhatamParasTableFilterComposer(
            $db: $db,
            $table: $db.khatamParas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KhatamsTableOrderingComposer
    extends Composer<_$AppDatabase, $KhatamsTable> {
  $$KhatamsTableOrderingComposer({
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

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KhatamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KhatamsTable> {
  $$KhatamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> khatamParasRefs<T extends Object>(
    Expression<T> Function($$KhatamParasTableAnnotationComposer a) f,
  ) {
    final $$KhatamParasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.khatamParas,
      getReferencedColumn: (t) => t.khatamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhatamParasTableAnnotationComposer(
            $db: $db,
            $table: $db.khatamParas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KhatamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KhatamsTable,
          Khatam,
          $$KhatamsTableFilterComposer,
          $$KhatamsTableOrderingComposer,
          $$KhatamsTableAnnotationComposer,
          $$KhatamsTableCreateCompanionBuilder,
          $$KhatamsTableUpdateCompanionBuilder,
          (Khatam, $$KhatamsTableReferences),
          Khatam,
          PrefetchHooks Function({bool khatamParasRefs})
        > {
  $$KhatamsTableTableManager(_$AppDatabase db, $KhatamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KhatamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KhatamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KhatamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => KhatamsCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String startDate,
                Value<String?> endDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => KhatamsCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KhatamsTable, Khatam>(table),
                  $$KhatamsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({khatamParasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (khatamParasRefs) db.khatamParas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (khatamParasRefs)
                    await $_getPrefetchedData<
                      Khatam,
                      $KhatamsTable,
                      KhatamPara
                    >(
                      currentTable: table,
                      referencedTable: $$KhatamsTableReferences
                          ._khatamParasRefsTable(db),
                      managerFromTypedResult: (p0) => $$KhatamsTableReferences(
                        db,
                        table,
                        p0,
                      ).khatamParasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.khatamId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$KhatamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KhatamsTable,
      Khatam,
      $$KhatamsTableFilterComposer,
      $$KhatamsTableOrderingComposer,
      $$KhatamsTableAnnotationComposer,
      $$KhatamsTableCreateCompanionBuilder,
      $$KhatamsTableUpdateCompanionBuilder,
      (Khatam, $$KhatamsTableReferences),
      Khatam,
      PrefetchHooks Function({bool khatamParasRefs})
    >;
typedef $$KhatamParasTableCreateCompanionBuilder =
    KhatamParasCompanion Function({
      required int khatamId,
      required int para,
      Value<bool> done,
      Value<String?> doneDate,
      Value<int> rowid,
    });
typedef $$KhatamParasTableUpdateCompanionBuilder =
    KhatamParasCompanion Function({
      Value<int> khatamId,
      Value<int> para,
      Value<bool> done,
      Value<String?> doneDate,
      Value<int> rowid,
    });

final class $$KhatamParasTableReferences
    extends BaseReferences<_$AppDatabase, $KhatamParasTable, KhatamPara> {
  $$KhatamParasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KhatamsTable _khatamIdTable(_$AppDatabase db) =>
      db.khatams.createAlias('khatam_paras__khatam_id__khatams__id');

  $$KhatamsTableProcessedTableManager get khatamId {
    final $_column = $_itemColumn<int>('khatam_id')!;

    final manager = $$KhatamsTableTableManager(
      $_db,
      $_db.khatams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_khatamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KhatamParasTableFilterComposer
    extends Composer<_$AppDatabase, $KhatamParasTable> {
  $$KhatamParasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get para => $composableBuilder(
    column: $table.para,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doneDate => $composableBuilder(
    column: $table.doneDate,
    builder: (column) => ColumnFilters(column),
  );

  $$KhatamsTableFilterComposer get khatamId {
    final $$KhatamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.khatamId,
      referencedTable: $db.khatams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhatamsTableFilterComposer(
            $db: $db,
            $table: $db.khatams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KhatamParasTableOrderingComposer
    extends Composer<_$AppDatabase, $KhatamParasTable> {
  $$KhatamParasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get para => $composableBuilder(
    column: $table.para,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doneDate => $composableBuilder(
    column: $table.doneDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$KhatamsTableOrderingComposer get khatamId {
    final $$KhatamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.khatamId,
      referencedTable: $db.khatams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhatamsTableOrderingComposer(
            $db: $db,
            $table: $db.khatams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KhatamParasTableAnnotationComposer
    extends Composer<_$AppDatabase, $KhatamParasTable> {
  $$KhatamParasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get para =>
      $composableBuilder(column: $table.para, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<String> get doneDate =>
      $composableBuilder(column: $table.doneDate, builder: (column) => column);

  $$KhatamsTableAnnotationComposer get khatamId {
    final $$KhatamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.khatamId,
      referencedTable: $db.khatams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhatamsTableAnnotationComposer(
            $db: $db,
            $table: $db.khatams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KhatamParasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KhatamParasTable,
          KhatamPara,
          $$KhatamParasTableFilterComposer,
          $$KhatamParasTableOrderingComposer,
          $$KhatamParasTableAnnotationComposer,
          $$KhatamParasTableCreateCompanionBuilder,
          $$KhatamParasTableUpdateCompanionBuilder,
          (KhatamPara, $$KhatamParasTableReferences),
          KhatamPara,
          PrefetchHooks Function({bool khatamId})
        > {
  $$KhatamParasTableTableManager(_$AppDatabase db, $KhatamParasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KhatamParasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KhatamParasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KhatamParasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> khatamId = const Value.absent(),
                Value<int> para = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<String?> doneDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KhatamParasCompanion(
                khatamId: khatamId,
                para: para,
                done: done,
                doneDate: doneDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int khatamId,
                required int para,
                Value<bool> done = const Value.absent(),
                Value<String?> doneDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KhatamParasCompanion.insert(
                khatamId: khatamId,
                para: para,
                done: done,
                doneDate: doneDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KhatamParasTable, KhatamPara>(table),
                  $$KhatamParasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({khatamId = false}) {
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
                    if (khatamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.khatamId,
                                referencedTable: $$KhatamParasTableReferences
                                    ._khatamIdTable(db),
                                referencedColumn: $$KhatamParasTableReferences
                                    ._khatamIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$KhatamParasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KhatamParasTable,
      KhatamPara,
      $$KhatamParasTableFilterComposer,
      $$KhatamParasTableOrderingComposer,
      $$KhatamParasTableAnnotationComposer,
      $$KhatamParasTableCreateCompanionBuilder,
      $$KhatamParasTableUpdateCompanionBuilder,
      (KhatamPara, $$KhatamParasTableReferences),
      KhatamPara,
      PrefetchHooks Function({bool khatamId})
    >;
typedef $$GheebatEntriesTableCreateCompanionBuilder =
    GheebatEntriesCompanion Function({
      required String date,
      Value<GheebatStatus> status,
      Value<String?> note,
      Value<int> istighfarCount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$GheebatEntriesTableUpdateCompanionBuilder =
    GheebatEntriesCompanion Function({
      Value<String> date,
      Value<GheebatStatus> status,
      Value<String?> note,
      Value<int> istighfarCount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GheebatEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $GheebatEntriesTable> {
  $$GheebatEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GheebatStatus, GheebatStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get istighfarCount => $composableBuilder(
    column: $table.istighfarCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GheebatEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $GheebatEntriesTable> {
  $$GheebatEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get istighfarCount => $composableBuilder(
    column: $table.istighfarCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GheebatEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GheebatEntriesTable> {
  $$GheebatEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GheebatStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get istighfarCount => $composableBuilder(
    column: $table.istighfarCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GheebatEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GheebatEntriesTable,
          GheebatEntry,
          $$GheebatEntriesTableFilterComposer,
          $$GheebatEntriesTableOrderingComposer,
          $$GheebatEntriesTableAnnotationComposer,
          $$GheebatEntriesTableCreateCompanionBuilder,
          $$GheebatEntriesTableUpdateCompanionBuilder,
          (
            GheebatEntry,
            BaseReferences<_$AppDatabase, $GheebatEntriesTable, GheebatEntry>,
          ),
          GheebatEntry,
          PrefetchHooks Function()
        > {
  $$GheebatEntriesTableTableManager(
    _$AppDatabase db,
    $GheebatEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GheebatEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GheebatEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GheebatEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<GheebatStatus> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> istighfarCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GheebatEntriesCompanion(
                date: date,
                status: status,
                note: note,
                istighfarCount: istighfarCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<GheebatStatus> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> istighfarCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GheebatEntriesCompanion.insert(
                date: date,
                status: status,
                note: note,
                istighfarCount: istighfarCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GheebatEntriesTable, GheebatEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GheebatEntriesTable,
                    GheebatEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GheebatEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GheebatEntriesTable,
      GheebatEntry,
      $$GheebatEntriesTableFilterComposer,
      $$GheebatEntriesTableOrderingComposer,
      $$GheebatEntriesTableAnnotationComposer,
      $$GheebatEntriesTableCreateCompanionBuilder,
      $$GheebatEntriesTableUpdateCompanionBuilder,
      (
        GheebatEntry,
        BaseReferences<_$AppDatabase, $GheebatEntriesTable, GheebatEntry>,
      ),
      GheebatEntry,
      PrefetchHooks Function()
    >;
typedef $$MuraqabaSessionsTableCreateCompanionBuilder =
    MuraqabaSessionsCompanion Function({
      Value<int> id,
      required String date,
      Value<int> minutes,
      Value<MuraqabaTime> timeOfDay,
      Value<String?> note,
      Value<String> source,
      Value<DateTime> createdAt,
    });
typedef $$MuraqabaSessionsTableUpdateCompanionBuilder =
    MuraqabaSessionsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<int> minutes,
      Value<MuraqabaTime> timeOfDay,
      Value<String?> note,
      Value<String> source,
      Value<DateTime> createdAt,
    });

class $$MuraqabaSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $MuraqabaSessionsTable> {
  $$MuraqabaSessionsTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MuraqabaTime, MuraqabaTime, int>
  get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MuraqabaSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MuraqabaSessionsTable> {
  $$MuraqabaSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MuraqabaSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MuraqabaSessionsTable> {
  $$MuraqabaSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MuraqabaTime, int> get timeOfDay =>
      $composableBuilder(column: $table.timeOfDay, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MuraqabaSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MuraqabaSessionsTable,
          MuraqabaSession,
          $$MuraqabaSessionsTableFilterComposer,
          $$MuraqabaSessionsTableOrderingComposer,
          $$MuraqabaSessionsTableAnnotationComposer,
          $$MuraqabaSessionsTableCreateCompanionBuilder,
          $$MuraqabaSessionsTableUpdateCompanionBuilder,
          (
            MuraqabaSession,
            BaseReferences<
              _$AppDatabase,
              $MuraqabaSessionsTable,
              MuraqabaSession
            >,
          ),
          MuraqabaSession,
          PrefetchHooks Function()
        > {
  $$MuraqabaSessionsTableTableManager(
    _$AppDatabase db,
    $MuraqabaSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MuraqabaSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MuraqabaSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MuraqabaSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<MuraqabaTime> timeOfDay = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MuraqabaSessionsCompanion(
                id: id,
                date: date,
                minutes: minutes,
                timeOfDay: timeOfDay,
                note: note,
                source: source,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                Value<int> minutes = const Value.absent(),
                Value<MuraqabaTime> timeOfDay = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MuraqabaSessionsCompanion.insert(
                id: id,
                date: date,
                minutes: minutes,
                timeOfDay: timeOfDay,
                note: note,
                source: source,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MuraqabaSessionsTable, MuraqabaSession>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MuraqabaSessionsTable,
                    MuraqabaSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MuraqabaSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MuraqabaSessionsTable,
      MuraqabaSession,
      $$MuraqabaSessionsTableFilterComposer,
      $$MuraqabaSessionsTableOrderingComposer,
      $$MuraqabaSessionsTableAnnotationComposer,
      $$MuraqabaSessionsTableCreateCompanionBuilder,
      $$MuraqabaSessionsTableUpdateCompanionBuilder,
      (
        MuraqabaSession,
        BaseReferences<_$AppDatabase, $MuraqabaSessionsTable, MuraqabaSession>,
      ),
      MuraqabaSession,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      required String title,
      Value<TaskCategory> category,
      Value<String> iconKey,
      Value<int> colorValue,
      Value<int> startMinutes,
      Value<int> endMinutes,
      Value<TaskRepeat> repeat,
      Value<int> weekdaysMask,
      required String anchorDate,
      Value<int?> reminderMinutes,
      Value<String?> note,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<TaskCategory> category,
      Value<String> iconKey,
      Value<int> colorValue,
      Value<int> startMinutes,
      Value<int> endMinutes,
      Value<TaskRepeat> repeat,
      Value<int> weekdaysMask,
      Value<String> anchorDate,
      Value<int?> reminderMinutes,
      Value<String?> note,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskCompletionsTable, List<TaskCompletion>>
  _taskCompletionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskCompletions,
    aliasName: 'tasks__id__task_completions__task_id',
  );

  $$TaskCompletionsTableProcessedTableManager get taskCompletionsRefs {
    final manager = $$TaskCompletionsTableTableManager(
      $_db,
      $_db.taskCompletions,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskCompletionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskCategory, TaskCategory, int>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskRepeat, TaskRepeat, int> get repeat =>
      $composableBuilder(
        column: $table.repeat,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get weekdaysMask => $composableBuilder(
    column: $table.weekdaysMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskCompletionsRefs(
    Expression<bool> Function($$TaskCompletionsTableFilterComposer f) f,
  ) {
    final $$TaskCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskCompletions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskCompletionsTableFilterComposer(
            $db: $db,
            $table: $db.taskCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdaysMask => $composableBuilder(
    column: $table.weekdaysMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskCategory, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TaskRepeat, int> get repeat =>
      $composableBuilder(column: $table.repeat, builder: (column) => column);

  GeneratedColumn<int> get weekdaysMask => $composableBuilder(
    column: $table.weekdaysMask,
    builder: (column) => column,
  );

  GeneratedColumn<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> taskCompletionsRefs<T extends Object>(
    Expression<T> Function($$TaskCompletionsTableAnnotationComposer a) f,
  ) {
    final $$TaskCompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskCompletions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskCompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({bool taskCompletionsRefs})
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<TaskCategory> category = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<TaskRepeat> repeat = const Value.absent(),
                Value<int> weekdaysMask = const Value.absent(),
                Value<String> anchorDate = const Value.absent(),
                Value<int?> reminderMinutes = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                category: category,
                iconKey: iconKey,
                colorValue: colorValue,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                repeat: repeat,
                weekdaysMask: weekdaysMask,
                anchorDate: anchorDate,
                reminderMinutes: reminderMinutes,
                note: note,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<TaskCategory> category = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<TaskRepeat> repeat = const Value.absent(),
                Value<int> weekdaysMask = const Value.absent(),
                required String anchorDate,
                Value<int?> reminderMinutes = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                category: category,
                iconKey: iconKey,
                colorValue: colorValue,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                repeat: repeat,
                weekdaysMask: weekdaysMask,
                anchorDate: anchorDate,
                reminderMinutes: reminderMinutes,
                note: note,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, Task>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskCompletionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskCompletionsRefs) db.taskCompletions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskCompletionsRefs)
                    await $_getPrefetchedData<
                      Task,
                      $TasksTable,
                      TaskCompletion
                    >(
                      currentTable: table,
                      referencedTable: $$TasksTableReferences
                          ._taskCompletionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TasksTableReferences(
                        db,
                        table,
                        p0,
                      ).taskCompletionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({bool taskCompletionsRefs})
    >;
typedef $$TaskCompletionsTableCreateCompanionBuilder =
    TaskCompletionsCompanion Function({
      required int taskId,
      required String date,
      Value<bool> done,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TaskCompletionsTableUpdateCompanionBuilder =
    TaskCompletionsCompanion Function({
      Value<int> taskId,
      Value<String> date,
      Value<bool> done,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskCompletionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaskCompletionsTable, TaskCompletion> {
  $$TaskCompletionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('task_completions__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCompletionsTable> {
  $$TaskCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCompletionsTable> {
  $$TaskCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCompletionsTable> {
  $$TaskCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCompletionsTable,
          TaskCompletion,
          $$TaskCompletionsTableFilterComposer,
          $$TaskCompletionsTableOrderingComposer,
          $$TaskCompletionsTableAnnotationComposer,
          $$TaskCompletionsTableCreateCompanionBuilder,
          $$TaskCompletionsTableUpdateCompanionBuilder,
          (TaskCompletion, $$TaskCompletionsTableReferences),
          TaskCompletion,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskCompletionsTableTableManager(
    _$AppDatabase db,
    $TaskCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> taskId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCompletionsCompanion(
                taskId: taskId,
                date: date,
                done: done,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int taskId,
                required String date,
                Value<bool> done = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCompletionsCompanion.insert(
                taskId: taskId,
                date: date,
                done: done,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TaskCompletionsTable, TaskCompletion>(table),
                  $$TaskCompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
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
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$TaskCompletionsTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$TaskCompletionsTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$TaskCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCompletionsTable,
      TaskCompletion,
      $$TaskCompletionsTableFilterComposer,
      $$TaskCompletionsTableOrderingComposer,
      $$TaskCompletionsTableAnnotationComposer,
      $$TaskCompletionsTableCreateCompanionBuilder,
      $$TaskCompletionsTableUpdateCompanionBuilder,
      (TaskCompletion, $$TaskCompletionsTableReferences),
      TaskCompletion,
      PrefetchHooks Function({bool taskId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NamazEntriesTableTableManager get namazEntries =>
      $$NamazEntriesTableTableManager(_db, _db.namazEntries);
  $$NaflEntriesTableTableManager get naflEntries =>
      $$NaflEntriesTableTableManager(_db, _db.naflEntries);
  $$QazaRecordsTableTableManager get qazaRecords =>
      $$QazaRecordsTableTableManager(_db, _db.qazaRecords);
  $$TilawatEntriesTableTableManager get tilawatEntries =>
      $$TilawatEntriesTableTableManager(_db, _db.tilawatEntries);
  $$TilawatPositionsTableTableManager get tilawatPositions =>
      $$TilawatPositionsTableTableManager(_db, _db.tilawatPositions);
  $$CustomDhikrsTableTableManager get customDhikrs =>
      $$CustomDhikrsTableTableManager(_db, _db.customDhikrs);
  $$AzkarEntriesTableTableManager get azkarEntries =>
      $$AzkarEntriesTableTableManager(_db, _db.azkarEntries);
  $$KhatamsTableTableManager get khatams =>
      $$KhatamsTableTableManager(_db, _db.khatams);
  $$KhatamParasTableTableManager get khatamParas =>
      $$KhatamParasTableTableManager(_db, _db.khatamParas);
  $$GheebatEntriesTableTableManager get gheebatEntries =>
      $$GheebatEntriesTableTableManager(_db, _db.gheebatEntries);
  $$MuraqabaSessionsTableTableManager get muraqabaSessions =>
      $$MuraqabaSessionsTableTableManager(_db, _db.muraqabaSessions);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TaskCompletionsTableTableManager get taskCompletions =>
      $$TaskCompletionsTableTableManager(_db, _db.taskCompletions);
}
