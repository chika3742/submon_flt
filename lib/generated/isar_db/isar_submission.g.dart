// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../isar_db/isar_submission.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetSubmissionCollection on Isar {
  IsarCollection<Submission> get submissions => getCollection();
}

const SubmissionSchema = CollectionSchema(
  name: 'Submission',
  schema:
      '{"name":"Submission","idName":"id","properties":[{"name":"canvasPlannableId","type":"Long"},{"name":"color","type":"Long"},{"name":"details","type":"String"},{"name":"done","type":"Bool"},{"name":"due","type":"Long"},{"name":"googleTasksTaskId","type":"String"},{"name":"important","type":"Bool"},{"name":"repeat","type":"Long"},{"name":"repeatSubmissionCreated","type":"Bool"},{"name":"title","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'canvasPlannableId': 0,
    'color': 1,
    'details': 2,
    'done': 3,
    'due': 4,
    'googleTasksTaskId': 5,
    'important': 6,
    'repeat': 7,
    'repeatSubmissionCreated': 8,
    'title': 9
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _submissionGetId,
  setId: _submissionSetId,
  getLinks: _submissionGetLinks,
  attachLinks: _submissionAttachLinks,
  serializeNative: _submissionSerializeNative,
  deserializeNative: _submissionDeserializeNative,
  deserializePropNative: _submissionDeserializePropNative,
  serializeWeb: _submissionSerializeWeb,
  deserializeWeb: _submissionDeserializeWeb,
  deserializePropWeb: _submissionDeserializePropWeb,
  version: 3,
);

int? _submissionGetId(Submission object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _submissionSetId(Submission object, int id) {
  object.id = id;
}

List<IsarLinkBase> _submissionGetLinks(Submission object) {
  return [];
}

const _submissionColorConverter = ColorConverter();
const _submissionRepeatConverter = RepeatConverter();

void _submissionSerializeNative(
    IsarCollection<Submission> collection,
    IsarRawObject rawObj,
    Submission object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.canvasPlannableId;
  final _canvasPlannableId = value0;
  final value1 = _submissionColorConverter.toIsar(object.color);
  final _color = value1;
  final value2 = object.details;
  final _details = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_details.length) as int;
  final value3 = object.done;
  final _done = value3;
  final value4 = object.due;
  final _due = value4;
  final value5 = object.googleTasksTaskId;
  IsarUint8List? _googleTasksTaskId;
  if (value5 != null) {
    _googleTasksTaskId = IsarBinaryWriter.utf8Encoder.convert(value5);
  }
  dynamicSize += (_googleTasksTaskId?.length ?? 0) as int;
  final value6 = object.important;
  final _important = value6;
  final value7 = _submissionRepeatConverter.toIsar(object.repeat);
  final _repeat = value7;
  final value8 = object.repeatSubmissionCreated;
  final _repeatSubmissionCreated = value8;
  final value9 = object.title;
  final _title = IsarBinaryWriter.utf8Encoder.convert(value9);
  dynamicSize += (_title.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], _canvasPlannableId);
  writer.writeLong(offsets[1], _color);
  writer.writeBytes(offsets[2], _details);
  writer.writeBool(offsets[3], _done);
  writer.writeDateTime(offsets[4], _due);
  writer.writeBytes(offsets[5], _googleTasksTaskId);
  writer.writeBool(offsets[6], _important);
  writer.writeLong(offsets[7], _repeat);
  writer.writeBool(offsets[8], _repeatSubmissionCreated);
  writer.writeBytes(offsets[9], _title);
}

Submission _submissionDeserializeNative(IsarCollection<Submission> collection,
    int id, IsarBinaryReader reader, List<int> offsets) {
  final object = Submission();
  object.canvasPlannableId = reader.readLongOrNull(offsets[0]);
  object.color =
      _submissionColorConverter.fromIsar(reader.readLong(offsets[1]));
  object.details = reader.readString(offsets[2]);
  object.done = reader.readBool(offsets[3]);
  object.due = reader.readDateTime(offsets[4]);
  object.googleTasksTaskId = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.important = reader.readBool(offsets[6]);
  object.repeat =
      _submissionRepeatConverter.fromIsar(reader.readLong(offsets[7]));
  object.repeatSubmissionCreated = reader.readBoolOrNull(offsets[8]);
  object.title = reader.readString(offsets[9]);
  return object;
}

P _submissionDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (_submissionColorConverter.fromIsar(reader.readLong(offset))) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (_submissionRepeatConverter.fromIsar(reader.readLong(offset)))
          as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _submissionSerializeWeb(
    IsarCollection<Submission> collection, Submission object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'canvasPlannableId', object.canvasPlannableId);
  IsarNative.jsObjectSet(
      jsObj, 'color', _submissionColorConverter.toIsar(object.color));
  IsarNative.jsObjectSet(jsObj, 'details', object.details);
  IsarNative.jsObjectSet(jsObj, 'done', object.done);
  IsarNative.jsObjectSet(
      jsObj, 'due', object.due.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'googleTasksTaskId', object.googleTasksTaskId);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'important', object.important);
  IsarNative.jsObjectSet(
      jsObj, 'repeat', _submissionRepeatConverter.toIsar(object.repeat));
  IsarNative.jsObjectSet(
      jsObj, 'repeatSubmissionCreated', object.repeatSubmissionCreated);
  IsarNative.jsObjectSet(jsObj, 'title', object.title);
  return jsObj;
}

Submission _submissionDeserializeWeb(
    IsarCollection<Submission> collection, dynamic jsObj) {
  final object = Submission();
  object.canvasPlannableId = IsarNative.jsObjectGet(jsObj, 'canvasPlannableId');
  object.color = _submissionColorConverter.fromIsar(
      IsarNative.jsObjectGet(jsObj, 'color') ?? double.negativeInfinity);
  object.details = IsarNative.jsObjectGet(jsObj, 'details') ?? '';
  object.done = IsarNative.jsObjectGet(jsObj, 'done') ?? false;
  object.due = IsarNative.jsObjectGet(jsObj, 'due') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'due'),
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  object.googleTasksTaskId = IsarNative.jsObjectGet(jsObj, 'googleTasksTaskId');
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.important = IsarNative.jsObjectGet(jsObj, 'important') ?? false;
  object.repeat = _submissionRepeatConverter.fromIsar(
      IsarNative.jsObjectGet(jsObj, 'repeat') ?? double.negativeInfinity);
  object.repeatSubmissionCreated =
      IsarNative.jsObjectGet(jsObj, 'repeatSubmissionCreated');
  object.title = IsarNative.jsObjectGet(jsObj, 'title') ?? '';
  return object;
}

P _submissionDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'canvasPlannableId':
      return (IsarNative.jsObjectGet(jsObj, 'canvasPlannableId')) as P;
    case 'color':
      return (_submissionColorConverter.fromIsar(
          IsarNative.jsObjectGet(jsObj, 'color') ??
              double.negativeInfinity)) as P;
    case 'details':
      return (IsarNative.jsObjectGet(jsObj, 'details') ?? '') as P;
    case 'done':
      return (IsarNative.jsObjectGet(jsObj, 'done') ?? false) as P;
    case 'due':
      return (IsarNative.jsObjectGet(jsObj, 'due') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'due'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case 'googleTasksTaskId':
      return (IsarNative.jsObjectGet(jsObj, 'googleTasksTaskId')) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'important':
      return (IsarNative.jsObjectGet(jsObj, 'important') ?? false) as P;
    case 'repeat':
      return (_submissionRepeatConverter.fromIsar(
          IsarNative.jsObjectGet(jsObj, 'repeat') ??
              double.negativeInfinity)) as P;
    case 'repeatSubmissionCreated':
      return (IsarNative.jsObjectGet(jsObj, 'repeatSubmissionCreated')) as P;
    case 'title':
      return (IsarNative.jsObjectGet(jsObj, 'title') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _submissionAttachLinks(IsarCollection col, int id, Submission object) {}

extension SubmissionQueryWhereSort
    on QueryBuilder<Submission, Submission, QWhere> {
  QueryBuilder<Submission, Submission, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension SubmissionQueryWhere
    on QueryBuilder<Submission, Submission, QWhereClause> {
  QueryBuilder<Submission, Submission, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Submission, Submission, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Submission, Submission, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Submission, Submission, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension SubmissionQueryFilter
    on QueryBuilder<Submission, Submission, QFilterCondition> {
  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'canvasPlannableId',
      value: null,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'canvasPlannableId',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'canvasPlannableId',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'canvasPlannableId',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'canvasPlannableId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> colorEqualTo(
      Color value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'color',
      value: _submissionColorConverter.toIsar(value),
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> colorGreaterThan(
    Color value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'color',
      value: _submissionColorConverter.toIsar(value),
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> colorLessThan(
    Color value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'color',
      value: _submissionColorConverter.toIsar(value),
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> colorBetween(
    Color lower,
    Color upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'color',
      lower: _submissionColorConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _submissionColorConverter.toIsar(upper),
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'details',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      detailsGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'details',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'details',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'details',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'details',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'details',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'details',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'details',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> doneEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'done',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> dueEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'due',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> dueGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'due',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> dueLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'due',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> dueBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'due',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'googleTasksTaskId',
      value: null,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'googleTasksTaskId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'googleTasksTaskId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'googleTasksTaskId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'googleTasksTaskId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'googleTasksTaskId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'googleTasksTaskId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'googleTasksTaskId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'googleTasksTaskId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> importantEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'important',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> repeatEqualTo(
      Repeat value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'repeat',
      value: _submissionRepeatConverter.toIsar(value),
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> repeatGreaterThan(
    Repeat value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'repeat',
      value: _submissionRepeatConverter.toIsar(value),
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> repeatLessThan(
    Repeat value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'repeat',
      value: _submissionRepeatConverter.toIsar(value),
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> repeatBetween(
    Repeat lower,
    Repeat upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'repeat',
      lower: _submissionRepeatConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _submissionRepeatConverter.toIsar(upper),
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      repeatSubmissionCreatedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'repeatSubmissionCreated',
      value: null,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      repeatSubmissionCreatedEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'repeatSubmissionCreated',
      value: value,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'title',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'title',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension SubmissionQueryLinks
    on QueryBuilder<Submission, Submission, QFilterCondition> {}

extension SubmissionQueryWhereSortBy
    on QueryBuilder<Submission, Submission, QSortBy> {
  QueryBuilder<Submission, Submission, QAfterSortBy> sortByCanvasPlannableId() {
    return addSortByInternal('canvasPlannableId', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      sortByCanvasPlannableIdDesc() {
    return addSortByInternal('canvasPlannableId', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByColor() {
    return addSortByInternal('color', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByColorDesc() {
    return addSortByInternal('color', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDetails() {
    return addSortByInternal('details', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDetailsDesc() {
    return addSortByInternal('details', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDone() {
    return addSortByInternal('done', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDoneDesc() {
    return addSortByInternal('done', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDue() {
    return addSortByInternal('due', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDueDesc() {
    return addSortByInternal('due', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByGoogleTasksTaskId() {
    return addSortByInternal('googleTasksTaskId', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      sortByGoogleTasksTaskIdDesc() {
    return addSortByInternal('googleTasksTaskId', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByImportant() {
    return addSortByInternal('important', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByImportantDesc() {
    return addSortByInternal('important', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByRepeat() {
    return addSortByInternal('repeat', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByRepeatDesc() {
    return addSortByInternal('repeat', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      sortByRepeatSubmissionCreated() {
    return addSortByInternal('repeatSubmissionCreated', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      sortByRepeatSubmissionCreatedDesc() {
    return addSortByInternal('repeatSubmissionCreated', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByTitle() {
    return addSortByInternal('title', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByTitleDesc() {
    return addSortByInternal('title', Sort.desc);
  }
}

extension SubmissionQueryWhereSortThenBy
    on QueryBuilder<Submission, Submission, QSortThenBy> {
  QueryBuilder<Submission, Submission, QAfterSortBy> thenByCanvasPlannableId() {
    return addSortByInternal('canvasPlannableId', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      thenByCanvasPlannableIdDesc() {
    return addSortByInternal('canvasPlannableId', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByColor() {
    return addSortByInternal('color', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByColorDesc() {
    return addSortByInternal('color', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDetails() {
    return addSortByInternal('details', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDetailsDesc() {
    return addSortByInternal('details', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDone() {
    return addSortByInternal('done', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDoneDesc() {
    return addSortByInternal('done', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDue() {
    return addSortByInternal('due', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDueDesc() {
    return addSortByInternal('due', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByGoogleTasksTaskId() {
    return addSortByInternal('googleTasksTaskId', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      thenByGoogleTasksTaskIdDesc() {
    return addSortByInternal('googleTasksTaskId', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByImportant() {
    return addSortByInternal('important', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByImportantDesc() {
    return addSortByInternal('important', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByRepeat() {
    return addSortByInternal('repeat', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByRepeatDesc() {
    return addSortByInternal('repeat', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      thenByRepeatSubmissionCreated() {
    return addSortByInternal('repeatSubmissionCreated', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      thenByRepeatSubmissionCreatedDesc() {
    return addSortByInternal('repeatSubmissionCreated', Sort.desc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByTitle() {
    return addSortByInternal('title', Sort.asc);
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByTitleDesc() {
    return addSortByInternal('title', Sort.desc);
  }
}

extension SubmissionQueryWhereDistinct
    on QueryBuilder<Submission, Submission, QDistinct> {
  QueryBuilder<Submission, Submission, QDistinct>
      distinctByCanvasPlannableId() {
    return addDistinctByInternal('canvasPlannableId');
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByColor() {
    return addDistinctByInternal('color');
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByDetails(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('details', caseSensitive: caseSensitive);
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByDone() {
    return addDistinctByInternal('done');
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByDue() {
    return addDistinctByInternal('due');
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByGoogleTasksTaskId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('googleTasksTaskId',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByImportant() {
    return addDistinctByInternal('important');
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByRepeat() {
    return addDistinctByInternal('repeat');
  }

  QueryBuilder<Submission, Submission, QDistinct>
      distinctByRepeatSubmissionCreated() {
    return addDistinctByInternal('repeatSubmissionCreated');
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('title', caseSensitive: caseSensitive);
  }
}

extension SubmissionQueryProperty
    on QueryBuilder<Submission, Submission, QQueryProperty> {
  QueryBuilder<Submission, int?, QQueryOperations> canvasPlannableIdProperty() {
    return addPropertyNameInternal('canvasPlannableId');
  }

  QueryBuilder<Submission, Color, QQueryOperations> colorProperty() {
    return addPropertyNameInternal('color');
  }

  QueryBuilder<Submission, String, QQueryOperations> detailsProperty() {
    return addPropertyNameInternal('details');
  }

  QueryBuilder<Submission, bool, QQueryOperations> doneProperty() {
    return addPropertyNameInternal('done');
  }

  QueryBuilder<Submission, DateTime, QQueryOperations> dueProperty() {
    return addPropertyNameInternal('due');
  }

  QueryBuilder<Submission, String?, QQueryOperations>
      googleTasksTaskIdProperty() {
    return addPropertyNameInternal('googleTasksTaskId');
  }

  QueryBuilder<Submission, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Submission, bool, QQueryOperations> importantProperty() {
    return addPropertyNameInternal('important');
  }

  QueryBuilder<Submission, Repeat, QQueryOperations> repeatProperty() {
    return addPropertyNameInternal('repeat');
  }

  QueryBuilder<Submission, bool?, QQueryOperations>
      repeatSubmissionCreatedProperty() {
    return addPropertyNameInternal('repeatSubmissionCreated');
  }

  QueryBuilder<Submission, String, QQueryOperations> titleProperty() {
    return addPropertyNameInternal('title');
  }
}
