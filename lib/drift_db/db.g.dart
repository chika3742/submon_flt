// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $SubmissionsTable extends Submissions
    with TableInfo<$SubmissionsTable, Submission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
      'due', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
      'done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("done" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _importantMeta =
      const VerificationMeta('important');
  @override
  late final GeneratedColumn<bool> important = GeneratedColumn<bool>(
      'important', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("important" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumnWithTypeConverter<RepeatType, int> repeat =
      GeneratedColumn<int>('repeat', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(RepeatType.none.index))
          .withConverter<RepeatType>($SubmissionsTable.$converterrepeat);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumnWithTypeConverter<Color, int> color =
      GeneratedColumn<int>('color', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(0xFFFFFFFF))
          .withConverter<Color>($SubmissionsTable.$convertercolor);
  static const VerificationMeta _googleTasksTaskIdMeta =
      const VerificationMeta('googleTasksTaskId');
  @override
  late final GeneratedColumn<String> googleTasksTaskId =
      GeneratedColumn<String>('google_tasks_task_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _repeatSubmissionCreatedMeta =
      const VerificationMeta('repeatSubmissionCreated');
  @override
  late final GeneratedColumn<bool> repeatSubmissionCreated =
      GeneratedColumn<bool>('repeat_submission_created', aliasedName, true,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("repeat_submission_created" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        details,
        due,
        done,
        important,
        repeat,
        color,
        googleTasksTaskId,
        repeatSubmissionCreated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submissions';
  @override
  VerificationContext validateIntegrity(Insertable<Submission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    } else if (isInserting) {
      context.missing(_detailsMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
          _dueMeta, due.isAcceptableOrUnknown(data['due']!, _dueMeta));
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
          _doneMeta, done.isAcceptableOrUnknown(data['done']!, _doneMeta));
    }
    if (data.containsKey('important')) {
      context.handle(_importantMeta,
          important.isAcceptableOrUnknown(data['important']!, _importantMeta));
    }
    context.handle(_repeatMeta, const VerificationResult.success());
    context.handle(_colorMeta, const VerificationResult.success());
    if (data.containsKey('google_tasks_task_id')) {
      context.handle(
          _googleTasksTaskIdMeta,
          googleTasksTaskId.isAcceptableOrUnknown(
              data['google_tasks_task_id']!, _googleTasksTaskIdMeta));
    }
    if (data.containsKey('repeat_submission_created')) {
      context.handle(
          _repeatSubmissionCreatedMeta,
          repeatSubmissionCreated.isAcceptableOrUnknown(
              data['repeat_submission_created']!,
              _repeatSubmissionCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Submission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Submission(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details'])!,
      due: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due'])!,
      done: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}done'])!,
      important: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}important'])!,
      repeat: $SubmissionsTable.$converterrepeat.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repeat'])!),
      color: $SubmissionsTable.$convertercolor.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!),
      googleTasksTaskId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}google_tasks_task_id']),
      repeatSubmissionCreated: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}repeat_submission_created']),
    );
  }

  @override
  $SubmissionsTable createAlias(String alias) {
    return $SubmissionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RepeatType, int, int> $converterrepeat =
      const EnumIndexConverter<RepeatType>(RepeatType.values);
  static TypeConverter<Color, int> $convertercolor = ColorConverter();
}

class Submission extends DataClass implements Insertable<Submission> {
  final String id;
  final String title;
  final String details;
  final DateTime due;
  final bool done;
  final bool important;
  final RepeatType repeat;
  final Color color;
  final String? googleTasksTaskId;
  final bool? repeatSubmissionCreated;
  const Submission(
      {required this.id,
      required this.title,
      required this.details,
      required this.due,
      required this.done,
      required this.important,
      required this.repeat,
      required this.color,
      this.googleTasksTaskId,
      this.repeatSubmissionCreated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['details'] = Variable<String>(details);
    map['due'] = Variable<DateTime>(due);
    map['done'] = Variable<bool>(done);
    map['important'] = Variable<bool>(important);
    {
      map['repeat'] =
          Variable<int>($SubmissionsTable.$converterrepeat.toSql(repeat));
    }
    {
      map['color'] =
          Variable<int>($SubmissionsTable.$convertercolor.toSql(color));
    }
    if (!nullToAbsent || googleTasksTaskId != null) {
      map['google_tasks_task_id'] = Variable<String>(googleTasksTaskId);
    }
    if (!nullToAbsent || repeatSubmissionCreated != null) {
      map['repeat_submission_created'] =
          Variable<bool>(repeatSubmissionCreated);
    }
    return map;
  }

  SubmissionsCompanion toCompanion(bool nullToAbsent) {
    return SubmissionsCompanion(
      id: Value(id),
      title: Value(title),
      details: Value(details),
      due: Value(due),
      done: Value(done),
      important: Value(important),
      repeat: Value(repeat),
      color: Value(color),
      googleTasksTaskId: googleTasksTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(googleTasksTaskId),
      repeatSubmissionCreated: repeatSubmissionCreated == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatSubmissionCreated),
    );
  }

  factory Submission.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Submission(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      details: serializer.fromJson<String>(json['details']),
      due: serializer.fromJson<DateTime>(json['due']),
      done: serializer.fromJson<bool>(json['done']),
      important: serializer.fromJson<bool>(json['important']),
      repeat: $SubmissionsTable.$converterrepeat
          .fromJson(serializer.fromJson<int>(json['repeat'])),
      color: serializer.fromJson<Color>(json['color']),
      googleTasksTaskId:
          serializer.fromJson<String?>(json['googleTasksTaskId']),
      repeatSubmissionCreated:
          serializer.fromJson<bool?>(json['repeatSubmissionCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'details': serializer.toJson<String>(details),
      'due': serializer.toJson<DateTime>(due),
      'done': serializer.toJson<bool>(done),
      'important': serializer.toJson<bool>(important),
      'repeat': serializer
          .toJson<int>($SubmissionsTable.$converterrepeat.toJson(repeat)),
      'color': serializer.toJson<Color>(color),
      'googleTasksTaskId': serializer.toJson<String?>(googleTasksTaskId),
      'repeatSubmissionCreated':
          serializer.toJson<bool?>(repeatSubmissionCreated),
    };
  }

  Submission copyWith(
          {String? id,
          String? title,
          String? details,
          DateTime? due,
          bool? done,
          bool? important,
          RepeatType? repeat,
          Color? color,
          Value<String?> googleTasksTaskId = const Value.absent(),
          Value<bool?> repeatSubmissionCreated = const Value.absent()}) =>
      Submission(
        id: id ?? this.id,
        title: title ?? this.title,
        details: details ?? this.details,
        due: due ?? this.due,
        done: done ?? this.done,
        important: important ?? this.important,
        repeat: repeat ?? this.repeat,
        color: color ?? this.color,
        googleTasksTaskId: googleTasksTaskId.present
            ? googleTasksTaskId.value
            : this.googleTasksTaskId,
        repeatSubmissionCreated: repeatSubmissionCreated.present
            ? repeatSubmissionCreated.value
            : this.repeatSubmissionCreated,
      );
  Submission copyWithCompanion(SubmissionsCompanion data) {
    return Submission(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      details: data.details.present ? data.details.value : this.details,
      due: data.due.present ? data.due.value : this.due,
      done: data.done.present ? data.done.value : this.done,
      important: data.important.present ? data.important.value : this.important,
      repeat: data.repeat.present ? data.repeat.value : this.repeat,
      color: data.color.present ? data.color.value : this.color,
      googleTasksTaskId: data.googleTasksTaskId.present
          ? data.googleTasksTaskId.value
          : this.googleTasksTaskId,
      repeatSubmissionCreated: data.repeatSubmissionCreated.present
          ? data.repeatSubmissionCreated.value
          : this.repeatSubmissionCreated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Submission(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('details: $details, ')
          ..write('due: $due, ')
          ..write('done: $done, ')
          ..write('important: $important, ')
          ..write('repeat: $repeat, ')
          ..write('color: $color, ')
          ..write('googleTasksTaskId: $googleTasksTaskId, ')
          ..write('repeatSubmissionCreated: $repeatSubmissionCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, details, due, done, important,
      repeat, color, googleTasksTaskId, repeatSubmissionCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Submission &&
          other.id == this.id &&
          other.title == this.title &&
          other.details == this.details &&
          other.due == this.due &&
          other.done == this.done &&
          other.important == this.important &&
          other.repeat == this.repeat &&
          other.color == this.color &&
          other.googleTasksTaskId == this.googleTasksTaskId &&
          other.repeatSubmissionCreated == this.repeatSubmissionCreated);
}

class SubmissionsCompanion extends UpdateCompanion<Submission> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> details;
  final Value<DateTime> due;
  final Value<bool> done;
  final Value<bool> important;
  final Value<RepeatType> repeat;
  final Value<Color> color;
  final Value<String?> googleTasksTaskId;
  final Value<bool?> repeatSubmissionCreated;
  final Value<int> rowid;
  const SubmissionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.details = const Value.absent(),
    this.due = const Value.absent(),
    this.done = const Value.absent(),
    this.important = const Value.absent(),
    this.repeat = const Value.absent(),
    this.color = const Value.absent(),
    this.googleTasksTaskId = const Value.absent(),
    this.repeatSubmissionCreated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubmissionsCompanion.insert({
    required String id,
    required String title,
    required String details,
    required DateTime due,
    this.done = const Value.absent(),
    this.important = const Value.absent(),
    this.repeat = const Value.absent(),
    this.color = const Value.absent(),
    this.googleTasksTaskId = const Value.absent(),
    this.repeatSubmissionCreated = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        details = Value(details),
        due = Value(due);
  static Insertable<Submission> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? details,
    Expression<DateTime>? due,
    Expression<bool>? done,
    Expression<bool>? important,
    Expression<int>? repeat,
    Expression<int>? color,
    Expression<String>? googleTasksTaskId,
    Expression<bool>? repeatSubmissionCreated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (details != null) 'details': details,
      if (due != null) 'due': due,
      if (done != null) 'done': done,
      if (important != null) 'important': important,
      if (repeat != null) 'repeat': repeat,
      if (color != null) 'color': color,
      if (googleTasksTaskId != null) 'google_tasks_task_id': googleTasksTaskId,
      if (repeatSubmissionCreated != null)
        'repeat_submission_created': repeatSubmissionCreated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubmissionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? details,
      Value<DateTime>? due,
      Value<bool>? done,
      Value<bool>? important,
      Value<RepeatType>? repeat,
      Value<Color>? color,
      Value<String?>? googleTasksTaskId,
      Value<bool?>? repeatSubmissionCreated,
      Value<int>? rowid}) {
    return SubmissionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      due: due ?? this.due,
      done: done ?? this.done,
      important: important ?? this.important,
      repeat: repeat ?? this.repeat,
      color: color ?? this.color,
      googleTasksTaskId: googleTasksTaskId ?? this.googleTasksTaskId,
      repeatSubmissionCreated:
          repeatSubmissionCreated ?? this.repeatSubmissionCreated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (important.present) {
      map['important'] = Variable<bool>(important.value);
    }
    if (repeat.present) {
      map['repeat'] =
          Variable<int>($SubmissionsTable.$converterrepeat.toSql(repeat.value));
    }
    if (color.present) {
      map['color'] =
          Variable<int>($SubmissionsTable.$convertercolor.toSql(color.value));
    }
    if (googleTasksTaskId.present) {
      map['google_tasks_task_id'] = Variable<String>(googleTasksTaskId.value);
    }
    if (repeatSubmissionCreated.present) {
      map['repeat_submission_created'] =
          Variable<bool>(repeatSubmissionCreated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('details: $details, ')
          ..write('due: $due, ')
          ..write('done: $done, ')
          ..write('important: $important, ')
          ..write('repeat: $repeat, ')
          ..write('color: $color, ')
          ..write('googleTasksTaskId: $googleTasksTaskId, ')
          ..write('repeatSubmissionCreated: $repeatSubmissionCreated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DigestivesTable extends Digestives
    with TableInfo<$DigestivesTable, Digestive> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigestivesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _submissionIdMeta =
      const VerificationMeta('submissionId');
  @override
  late final GeneratedColumn<String> submissionId = GeneratedColumn<String>(
      'submission_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES submissions (id)'));
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
      'done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("done" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _startAtMeta =
      const VerificationMeta('startAt');
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
      'start_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
      'minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _columnMeta = const VerificationMeta('column');
  @override
  late final GeneratedColumn<String> column = GeneratedColumn<String>(
      'column', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, submissionId, done, startAt, minute, column];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digestives';
  @override
  VerificationContext validateIntegrity(Insertable<Digestive> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('submission_id')) {
      context.handle(
          _submissionIdMeta,
          submissionId.isAcceptableOrUnknown(
              data['submission_id']!, _submissionIdMeta));
    } else if (isInserting) {
      context.missing(_submissionIdMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
          _doneMeta, done.isAcceptableOrUnknown(data['done']!, _doneMeta));
    }
    if (data.containsKey('start_at')) {
      context.handle(_startAtMeta,
          startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta));
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(_minuteMeta,
          minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta));
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('column')) {
      context.handle(_columnMeta,
          column.isAcceptableOrUnknown(data['column']!, _columnMeta));
    } else if (isInserting) {
      context.missing(_columnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Digestive map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Digestive(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      submissionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}submission_id'])!,
      done: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}done'])!,
      startAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_at'])!,
      minute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minute'])!,
      column: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}column'])!,
    );
  }

  @override
  $DigestivesTable createAlias(String alias) {
    return $DigestivesTable(attachedDatabase, alias);
  }
}

class Digestive extends DataClass implements Insertable<Digestive> {
  final String id;
  final String submissionId;
  final bool done;
  final DateTime startAt;
  final int minute;
  final String column;
  const Digestive(
      {required this.id,
      required this.submissionId,
      required this.done,
      required this.startAt,
      required this.minute,
      required this.column});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['submission_id'] = Variable<String>(submissionId);
    map['done'] = Variable<bool>(done);
    map['start_at'] = Variable<DateTime>(startAt);
    map['minute'] = Variable<int>(minute);
    map['column'] = Variable<String>(column);
    return map;
  }

  DigestivesCompanion toCompanion(bool nullToAbsent) {
    return DigestivesCompanion(
      id: Value(id),
      submissionId: Value(submissionId),
      done: Value(done),
      startAt: Value(startAt),
      minute: Value(minute),
      column: Value(column),
    );
  }

  factory Digestive.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Digestive(
      id: serializer.fromJson<String>(json['id']),
      submissionId: serializer.fromJson<String>(json['submissionId']),
      done: serializer.fromJson<bool>(json['done']),
      startAt: serializer.fromJson<DateTime>(json['startAt']),
      minute: serializer.fromJson<int>(json['minute']),
      column: serializer.fromJson<String>(json['column']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'submissionId': serializer.toJson<String>(submissionId),
      'done': serializer.toJson<bool>(done),
      'startAt': serializer.toJson<DateTime>(startAt),
      'minute': serializer.toJson<int>(minute),
      'column': serializer.toJson<String>(column),
    };
  }

  Digestive copyWith(
          {String? id,
          String? submissionId,
          bool? done,
          DateTime? startAt,
          int? minute,
          String? column}) =>
      Digestive(
        id: id ?? this.id,
        submissionId: submissionId ?? this.submissionId,
        done: done ?? this.done,
        startAt: startAt ?? this.startAt,
        minute: minute ?? this.minute,
        column: column ?? this.column,
      );
  Digestive copyWithCompanion(DigestivesCompanion data) {
    return Digestive(
      id: data.id.present ? data.id.value : this.id,
      submissionId: data.submissionId.present
          ? data.submissionId.value
          : this.submissionId,
      done: data.done.present ? data.done.value : this.done,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      minute: data.minute.present ? data.minute.value : this.minute,
      column: data.column.present ? data.column.value : this.column,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Digestive(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('done: $done, ')
          ..write('startAt: $startAt, ')
          ..write('minute: $minute, ')
          ..write('column: $column')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, submissionId, done, startAt, minute, column);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Digestive &&
          other.id == this.id &&
          other.submissionId == this.submissionId &&
          other.done == this.done &&
          other.startAt == this.startAt &&
          other.minute == this.minute &&
          other.column == this.column);
}

class DigestivesCompanion extends UpdateCompanion<Digestive> {
  final Value<String> id;
  final Value<String> submissionId;
  final Value<bool> done;
  final Value<DateTime> startAt;
  final Value<int> minute;
  final Value<String> column;
  final Value<int> rowid;
  const DigestivesCompanion({
    this.id = const Value.absent(),
    this.submissionId = const Value.absent(),
    this.done = const Value.absent(),
    this.startAt = const Value.absent(),
    this.minute = const Value.absent(),
    this.column = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DigestivesCompanion.insert({
    required String id,
    required String submissionId,
    this.done = const Value.absent(),
    required DateTime startAt,
    required int minute,
    required String column,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        submissionId = Value(submissionId),
        startAt = Value(startAt),
        minute = Value(minute),
        column = Value(column);
  static Insertable<Digestive> custom({
    Expression<String>? id,
    Expression<String>? submissionId,
    Expression<bool>? done,
    Expression<DateTime>? startAt,
    Expression<int>? minute,
    Expression<String>? column,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (submissionId != null) 'submission_id': submissionId,
      if (done != null) 'done': done,
      if (startAt != null) 'start_at': startAt,
      if (minute != null) 'minute': minute,
      if (column != null) 'column': column,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DigestivesCompanion copyWith(
      {Value<String>? id,
      Value<String>? submissionId,
      Value<bool>? done,
      Value<DateTime>? startAt,
      Value<int>? minute,
      Value<String>? column,
      Value<int>? rowid}) {
    return DigestivesCompanion(
      id: id ?? this.id,
      submissionId: submissionId ?? this.submissionId,
      done: done ?? this.done,
      startAt: startAt ?? this.startAt,
      minute: minute ?? this.minute,
      column: column ?? this.column,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (submissionId.present) {
      map['submission_id'] = Variable<String>(submissionId.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (column.present) {
      map['column'] = Variable<String>(column.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigestivesCompanion(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('done: $done, ')
          ..write('startAt: $startAt, ')
          ..write('minute: $minute, ')
          ..write('column: $column, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubmissionsTable submissions = $SubmissionsTable(this);
  late final $DigestivesTable digestives = $DigestivesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [submissions, digestives];
}

typedef $$SubmissionsTableCreateCompanionBuilder = SubmissionsCompanion
    Function({
  required String id,
  required String title,
  required String details,
  required DateTime due,
  Value<bool> done,
  Value<bool> important,
  Value<RepeatType> repeat,
  Value<Color> color,
  Value<String?> googleTasksTaskId,
  Value<bool?> repeatSubmissionCreated,
  Value<int> rowid,
});
typedef $$SubmissionsTableUpdateCompanionBuilder = SubmissionsCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> details,
  Value<DateTime> due,
  Value<bool> done,
  Value<bool> important,
  Value<RepeatType> repeat,
  Value<Color> color,
  Value<String?> googleTasksTaskId,
  Value<bool?> repeatSubmissionCreated,
  Value<int> rowid,
});

final class $$SubmissionsTableReferences
    extends BaseReferences<_$AppDatabase, $SubmissionsTable, Submission> {
  $$SubmissionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DigestivesTable, List<Digestive>>
      _digestivesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.digestives,
              aliasName: $_aliasNameGenerator(
                  db.submissions.id, db.digestives.submissionId));

  $$DigestivesTableProcessedTableManager get digestivesRefs {
    final manager = $$DigestivesTableTableManager($_db, $_db.digestives)
        .filter((f) => f.submissionId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_digestivesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SubmissionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionsTable> {
  $$SubmissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get due => $composableBuilder(
      column: $table.due, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get important => $composableBuilder(
      column: $table.important, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RepeatType, RepeatType, int> get repeat =>
      $composableBuilder(
          column: $table.repeat,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Color, Color, int> get color =>
      $composableBuilder(
          column: $table.color,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get googleTasksTaskId => $composableBuilder(
      column: $table.googleTasksTaskId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get repeatSubmissionCreated => $composableBuilder(
      column: $table.repeatSubmissionCreated,
      builder: (column) => ColumnFilters(column));

  Expression<bool> digestivesRefs(
      Expression<bool> Function($$DigestivesTableFilterComposer f) f) {
    final $$DigestivesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.digestives,
        getReferencedColumn: (t) => t.submissionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DigestivesTableFilterComposer(
              $db: $db,
              $table: $db.digestives,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SubmissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionsTable> {
  $$SubmissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get due => $composableBuilder(
      column: $table.due, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get important => $composableBuilder(
      column: $table.important, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repeat => $composableBuilder(
      column: $table.repeat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get googleTasksTaskId => $composableBuilder(
      column: $table.googleTasksTaskId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get repeatSubmissionCreated => $composableBuilder(
      column: $table.repeatSubmissionCreated,
      builder: (column) => ColumnOrderings(column));
}

class $$SubmissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionsTable> {
  $$SubmissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<bool> get important =>
      $composableBuilder(column: $table.important, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RepeatType, int> get repeat =>
      $composableBuilder(column: $table.repeat, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Color, int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get googleTasksTaskId => $composableBuilder(
      column: $table.googleTasksTaskId, builder: (column) => column);

  GeneratedColumn<bool> get repeatSubmissionCreated => $composableBuilder(
      column: $table.repeatSubmissionCreated, builder: (column) => column);

  Expression<T> digestivesRefs<T extends Object>(
      Expression<T> Function($$DigestivesTableAnnotationComposer a) f) {
    final $$DigestivesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.digestives,
        getReferencedColumn: (t) => t.submissionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DigestivesTableAnnotationComposer(
              $db: $db,
              $table: $db.digestives,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SubmissionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubmissionsTable,
    Submission,
    $$SubmissionsTableFilterComposer,
    $$SubmissionsTableOrderingComposer,
    $$SubmissionsTableAnnotationComposer,
    $$SubmissionsTableCreateCompanionBuilder,
    $$SubmissionsTableUpdateCompanionBuilder,
    (Submission, $$SubmissionsTableReferences),
    Submission,
    PrefetchHooks Function({bool digestivesRefs})> {
  $$SubmissionsTableTableManager(_$AppDatabase db, $SubmissionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubmissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubmissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubmissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> details = const Value.absent(),
            Value<DateTime> due = const Value.absent(),
            Value<bool> done = const Value.absent(),
            Value<bool> important = const Value.absent(),
            Value<RepeatType> repeat = const Value.absent(),
            Value<Color> color = const Value.absent(),
            Value<String?> googleTasksTaskId = const Value.absent(),
            Value<bool?> repeatSubmissionCreated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubmissionsCompanion(
            id: id,
            title: title,
            details: details,
            due: due,
            done: done,
            important: important,
            repeat: repeat,
            color: color,
            googleTasksTaskId: googleTasksTaskId,
            repeatSubmissionCreated: repeatSubmissionCreated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String details,
            required DateTime due,
            Value<bool> done = const Value.absent(),
            Value<bool> important = const Value.absent(),
            Value<RepeatType> repeat = const Value.absent(),
            Value<Color> color = const Value.absent(),
            Value<String?> googleTasksTaskId = const Value.absent(),
            Value<bool?> repeatSubmissionCreated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubmissionsCompanion.insert(
            id: id,
            title: title,
            details: details,
            due: due,
            done: done,
            important: important,
            repeat: repeat,
            color: color,
            googleTasksTaskId: googleTasksTaskId,
            repeatSubmissionCreated: repeatSubmissionCreated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SubmissionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({digestivesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (digestivesRefs) db.digestives],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (digestivesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SubmissionsTableReferences
                            ._digestivesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SubmissionsTableReferences(db, table, p0)
                                .digestivesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.submissionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SubmissionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubmissionsTable,
    Submission,
    $$SubmissionsTableFilterComposer,
    $$SubmissionsTableOrderingComposer,
    $$SubmissionsTableAnnotationComposer,
    $$SubmissionsTableCreateCompanionBuilder,
    $$SubmissionsTableUpdateCompanionBuilder,
    (Submission, $$SubmissionsTableReferences),
    Submission,
    PrefetchHooks Function({bool digestivesRefs})>;
typedef $$DigestivesTableCreateCompanionBuilder = DigestivesCompanion Function({
  required String id,
  required String submissionId,
  Value<bool> done,
  required DateTime startAt,
  required int minute,
  required String column,
  Value<int> rowid,
});
typedef $$DigestivesTableUpdateCompanionBuilder = DigestivesCompanion Function({
  Value<String> id,
  Value<String> submissionId,
  Value<bool> done,
  Value<DateTime> startAt,
  Value<int> minute,
  Value<String> column,
  Value<int> rowid,
});

final class $$DigestivesTableReferences
    extends BaseReferences<_$AppDatabase, $DigestivesTable, Digestive> {
  $$DigestivesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubmissionsTable _submissionIdTable(_$AppDatabase db) =>
      db.submissions.createAlias(
          $_aliasNameGenerator(db.digestives.submissionId, db.submissions.id));

  $$SubmissionsTableProcessedTableManager? get submissionId {
    if ($_item.submissionId == null) return null;
    final manager = $$SubmissionsTableTableManager($_db, $_db.submissions)
        .filter((f) => f.id($_item.submissionId!));
    final item = $_typedResult.readTableOrNull(_submissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DigestivesTableFilterComposer
    extends Composer<_$AppDatabase, $DigestivesTable> {
  $$DigestivesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startAt => $composableBuilder(
      column: $table.startAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get column => $composableBuilder(
      column: $table.column, builder: (column) => ColumnFilters(column));

  $$SubmissionsTableFilterComposer get submissionId {
    final $$SubmissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.submissionId,
        referencedTable: $db.submissions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubmissionsTableFilterComposer(
              $db: $db,
              $table: $db.submissions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DigestivesTableOrderingComposer
    extends Composer<_$AppDatabase, $DigestivesTable> {
  $$DigestivesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
      column: $table.startAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get column => $composableBuilder(
      column: $table.column, builder: (column) => ColumnOrderings(column));

  $$SubmissionsTableOrderingComposer get submissionId {
    final $$SubmissionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.submissionId,
        referencedTable: $db.submissions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubmissionsTableOrderingComposer(
              $db: $db,
              $table: $db.submissions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DigestivesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DigestivesTable> {
  $$DigestivesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<String> get column =>
      $composableBuilder(column: $table.column, builder: (column) => column);

  $$SubmissionsTableAnnotationComposer get submissionId {
    final $$SubmissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.submissionId,
        referencedTable: $db.submissions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubmissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.submissions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DigestivesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DigestivesTable,
    Digestive,
    $$DigestivesTableFilterComposer,
    $$DigestivesTableOrderingComposer,
    $$DigestivesTableAnnotationComposer,
    $$DigestivesTableCreateCompanionBuilder,
    $$DigestivesTableUpdateCompanionBuilder,
    (Digestive, $$DigestivesTableReferences),
    Digestive,
    PrefetchHooks Function({bool submissionId})> {
  $$DigestivesTableTableManager(_$AppDatabase db, $DigestivesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigestivesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DigestivesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DigestivesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> submissionId = const Value.absent(),
            Value<bool> done = const Value.absent(),
            Value<DateTime> startAt = const Value.absent(),
            Value<int> minute = const Value.absent(),
            Value<String> column = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DigestivesCompanion(
            id: id,
            submissionId: submissionId,
            done: done,
            startAt: startAt,
            minute: minute,
            column: column,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String submissionId,
            Value<bool> done = const Value.absent(),
            required DateTime startAt,
            required int minute,
            required String column,
            Value<int> rowid = const Value.absent(),
          }) =>
              DigestivesCompanion.insert(
            id: id,
            submissionId: submissionId,
            done: done,
            startAt: startAt,
            minute: minute,
            column: column,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DigestivesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({submissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (submissionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.submissionId,
                    referencedTable:
                        $$DigestivesTableReferences._submissionIdTable(db),
                    referencedColumn:
                        $$DigestivesTableReferences._submissionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DigestivesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DigestivesTable,
    Digestive,
    $$DigestivesTableFilterComposer,
    $$DigestivesTableOrderingComposer,
    $$DigestivesTableAnnotationComposer,
    $$DigestivesTableCreateCompanionBuilder,
    $$DigestivesTableUpdateCompanionBuilder,
    (Digestive, $$DigestivesTableReferences),
    Digestive,
    PrefetchHooks Function({bool submissionId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubmissionsTableTableManager get submissions =>
      $$SubmissionsTableTableManager(_db, _db.submissions);
  $$DigestivesTableTableManager get digestives =>
      $$DigestivesTableTableManager(_db, _db.digestives);
}
