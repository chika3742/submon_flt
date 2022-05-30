// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../isar_db/isar_timetable.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetTimetableCollection on Isar {
  IsarCollection<Timetable> get timetables => getCollection();
}

const TimetableSchema = CollectionSchema(
  name: 'Timetable',
  schema:
      '{"name":"Timetable","idName":"id","properties":[{"name":"cellId","type":"Long"},{"name":"note","type":"String"},{"name":"room","type":"String"},{"name":"subject","type":"String"},{"name":"tableId","type":"Long"},{"name":"teacher","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'cellId': 0,
    'note': 1,
    'room': 2,
    'subject': 3,
    'tableId': 4,
    'teacher': 5
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _timetableGetId,
  setId: _timetableSetId,
  getLinks: _timetableGetLinks,
  attachLinks: _timetableAttachLinks,
  serializeNative: _timetableSerializeNative,
  deserializeNative: _timetableDeserializeNative,
  deserializePropNative: _timetableDeserializePropNative,
  serializeWeb: _timetableSerializeWeb,
  deserializeWeb: _timetableDeserializeWeb,
  deserializePropWeb: _timetableDeserializePropWeb,
  version: 3,
);

int? _timetableGetId(Timetable object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _timetableSetId(Timetable object, int id) {
  object.id = id;
}

List<IsarLinkBase> _timetableGetLinks(Timetable object) {
  return [];
}

void _timetableSerializeNative(
    IsarCollection<Timetable> collection,
    IsarRawObject rawObj,
    Timetable object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.cellId;
  final _cellId = value0;
  final value1 = object.note;
  final _note = IsarBinaryWriter.utf8Encoder.convert(value1);
  dynamicSize += (_note.length) as int;
  final value2 = object.room;
  final _room = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_room.length) as int;
  final value3 = object.subject;
  final _subject = IsarBinaryWriter.utf8Encoder.convert(value3);
  dynamicSize += (_subject.length) as int;
  final value4 = object.tableId;
  final _tableId = value4;
  final value5 = object.teacher;
  final _teacher = IsarBinaryWriter.utf8Encoder.convert(value5);
  dynamicSize += (_teacher.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], _cellId);
  writer.writeBytes(offsets[1], _note);
  writer.writeBytes(offsets[2], _room);
  writer.writeBytes(offsets[3], _subject);
  writer.writeLong(offsets[4], _tableId);
  writer.writeBytes(offsets[5], _teacher);
}

Timetable _timetableDeserializeNative(IsarCollection<Timetable> collection,
    int id, IsarBinaryReader reader, List<int> offsets) {
  final object = Timetable();
  object.cellId = reader.readLong(offsets[0]);
  object.id = id;
  object.note = reader.readString(offsets[1]);
  object.room = reader.readString(offsets[2]);
  object.subject = reader.readString(offsets[3]);
  object.tableId = reader.readLong(offsets[4]);
  object.teacher = reader.readString(offsets[5]);
  return object;
}

P _timetableDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _timetableSerializeWeb(
    IsarCollection<Timetable> collection, Timetable object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'cellId', object.cellId);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'note', object.note);
  IsarNative.jsObjectSet(jsObj, 'room', object.room);
  IsarNative.jsObjectSet(jsObj, 'subject', object.subject);
  IsarNative.jsObjectSet(jsObj, 'tableId', object.tableId);
  IsarNative.jsObjectSet(jsObj, 'teacher', object.teacher);
  return jsObj;
}

Timetable _timetableDeserializeWeb(
    IsarCollection<Timetable> collection, dynamic jsObj) {
  final object = Timetable();
  object.cellId =
      IsarNative.jsObjectGet(jsObj, 'cellId') ?? double.negativeInfinity;
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.note = IsarNative.jsObjectGet(jsObj, 'note') ?? '';
  object.room = IsarNative.jsObjectGet(jsObj, 'room') ?? '';
  object.subject = IsarNative.jsObjectGet(jsObj, 'subject') ?? '';
  object.tableId =
      IsarNative.jsObjectGet(jsObj, 'tableId') ?? double.negativeInfinity;
  object.teacher = IsarNative.jsObjectGet(jsObj, 'teacher') ?? '';
  return object;
}

P _timetableDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'cellId':
      return (IsarNative.jsObjectGet(jsObj, 'cellId') ??
          double.negativeInfinity) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'note':
      return (IsarNative.jsObjectGet(jsObj, 'note') ?? '') as P;
    case 'room':
      return (IsarNative.jsObjectGet(jsObj, 'room') ?? '') as P;
    case 'subject':
      return (IsarNative.jsObjectGet(jsObj, 'subject') ?? '') as P;
    case 'tableId':
      return (IsarNative.jsObjectGet(jsObj, 'tableId') ??
          double.negativeInfinity) as P;
    case 'teacher':
      return (IsarNative.jsObjectGet(jsObj, 'teacher') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _timetableAttachLinks(IsarCollection col, int id, Timetable object) {}

extension TimetableQueryWhereSort
    on QueryBuilder<Timetable, Timetable, QWhere> {
  QueryBuilder<Timetable, Timetable, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension TimetableQueryWhere
    on QueryBuilder<Timetable, Timetable, QWhereClause> {
  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idBetween(
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

extension TimetableQueryFilter
    on QueryBuilder<Timetable, Timetable, QFilterCondition> {
  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> cellIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'cellId',
      value: value,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> cellIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'cellId',
      value: value,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> cellIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'cellId',
      value: value,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> cellIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'cellId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'note',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'note',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'room',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'room',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'room',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'room',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'room',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'room',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'room',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'room',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'subject',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'subject',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> tableIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'tableId',
      value: value,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> tableIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'tableId',
      value: value,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> tableIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'tableId',
      value: value,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> tableIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'tableId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'teacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'teacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'teacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'teacher',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'teacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'teacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'teacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'teacher',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension TimetableQueryLinks
    on QueryBuilder<Timetable, Timetable, QFilterCondition> {}

extension TimetableQueryWhereSortBy
    on QueryBuilder<Timetable, Timetable, QSortBy> {
  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByCellId() {
    return addSortByInternal('cellId', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByCellIdDesc() {
    return addSortByInternal('cellId', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByNote() {
    return addSortByInternal('note', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByNoteDesc() {
    return addSortByInternal('note', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByRoom() {
    return addSortByInternal('room', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByRoomDesc() {
    return addSortByInternal('room', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortBySubject() {
    return addSortByInternal('subject', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortBySubjectDesc() {
    return addSortByInternal('subject', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByTableId() {
    return addSortByInternal('tableId', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByTableIdDesc() {
    return addSortByInternal('tableId', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByTeacher() {
    return addSortByInternal('teacher', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByTeacherDesc() {
    return addSortByInternal('teacher', Sort.desc);
  }
}

extension TimetableQueryWhereSortThenBy
    on QueryBuilder<Timetable, Timetable, QSortThenBy> {
  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByCellId() {
    return addSortByInternal('cellId', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByCellIdDesc() {
    return addSortByInternal('cellId', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByNote() {
    return addSortByInternal('note', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByNoteDesc() {
    return addSortByInternal('note', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByRoom() {
    return addSortByInternal('room', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByRoomDesc() {
    return addSortByInternal('room', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenBySubject() {
    return addSortByInternal('subject', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenBySubjectDesc() {
    return addSortByInternal('subject', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByTableId() {
    return addSortByInternal('tableId', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByTableIdDesc() {
    return addSortByInternal('tableId', Sort.desc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByTeacher() {
    return addSortByInternal('teacher', Sort.asc);
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByTeacherDesc() {
    return addSortByInternal('teacher', Sort.desc);
  }
}

extension TimetableQueryWhereDistinct
    on QueryBuilder<Timetable, Timetable, QDistinct> {
  QueryBuilder<Timetable, Timetable, QDistinct> distinctByCellId() {
    return addDistinctByInternal('cellId');
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('note', caseSensitive: caseSensitive);
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctByRoom(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('room', caseSensitive: caseSensitive);
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctBySubject(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('subject', caseSensitive: caseSensitive);
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctByTableId() {
    return addDistinctByInternal('tableId');
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctByTeacher(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('teacher', caseSensitive: caseSensitive);
  }
}

extension TimetableQueryProperty
    on QueryBuilder<Timetable, Timetable, QQueryProperty> {
  QueryBuilder<Timetable, int, QQueryOperations> cellIdProperty() {
    return addPropertyNameInternal('cellId');
  }

  QueryBuilder<Timetable, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Timetable, String, QQueryOperations> noteProperty() {
    return addPropertyNameInternal('note');
  }

  QueryBuilder<Timetable, String, QQueryOperations> roomProperty() {
    return addPropertyNameInternal('room');
  }

  QueryBuilder<Timetable, String, QQueryOperations> subjectProperty() {
    return addPropertyNameInternal('subject');
  }

  QueryBuilder<Timetable, int, QQueryOperations> tableIdProperty() {
    return addPropertyNameInternal('tableId');
  }

  QueryBuilder<Timetable, String, QQueryOperations> teacherProperty() {
    return addPropertyNameInternal('teacher');
  }
}
