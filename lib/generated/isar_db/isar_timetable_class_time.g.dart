// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../isar_db/isar_timetable_class_time.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetTimetableClassTimeCollection on Isar {
  IsarCollection<TimetableClassTime> get timetableClassTimes => getCollection();
}

const TimetableClassTimeSchema = CollectionSchema(
  name: 'TimetableClassTime',
  schema:
      '{"name":"TimetableClassTime","idName":"period","properties":[{"name":"end","type":"String"},{"name":"start","type":"String"}],"indexes":[],"links":[]}',
  idName: 'period',
  propertyIds: {'end': 0, 'start': 1},
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _timetableClassTimeGetId,
  setId: _timetableClassTimeSetId,
  getLinks: _timetableClassTimeGetLinks,
  attachLinks: _timetableClassTimeAttachLinks,
  serializeNative: _timetableClassTimeSerializeNative,
  deserializeNative: _timetableClassTimeDeserializeNative,
  deserializePropNative: _timetableClassTimeDeserializePropNative,
  serializeWeb: _timetableClassTimeSerializeWeb,
  deserializeWeb: _timetableClassTimeDeserializeWeb,
  deserializePropWeb: _timetableClassTimeDeserializePropWeb,
  version: 3,
);

int? _timetableClassTimeGetId(TimetableClassTime object) {
  if (object.period == Isar.autoIncrement) {
    return null;
  } else {
    return object.period;
  }
}

void _timetableClassTimeSetId(TimetableClassTime object, int id) {
  object.period = id;
}

List<IsarLinkBase> _timetableClassTimeGetLinks(TimetableClassTime object) {
  return [];
}

const _timetableClassTimeTimeOfDayConverter = TimeOfDayConverter();

void _timetableClassTimeSerializeNative(
    IsarCollection<TimetableClassTime> collection,
    IsarRawObject rawObj,
    TimetableClassTime object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = _timetableClassTimeTimeOfDayConverter.toIsar(object.end);
  final _end = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_end.length) as int;
  final value1 = _timetableClassTimeTimeOfDayConverter.toIsar(object.start);
  final _start = IsarBinaryWriter.utf8Encoder.convert(value1);
  dynamicSize += (_start.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _end);
  writer.writeBytes(offsets[1], _start);
}

TimetableClassTime _timetableClassTimeDeserializeNative(
    IsarCollection<TimetableClassTime> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = TimetableClassTime();
  object.end = _timetableClassTimeTimeOfDayConverter
      .fromIsar(reader.readString(offsets[0]));
  object.period = id;
  object.start = _timetableClassTimeTimeOfDayConverter
      .fromIsar(reader.readString(offsets[1]));
  return object;
}

P _timetableClassTimeDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (_timetableClassTimeTimeOfDayConverter
          .fromIsar(reader.readString(offset))) as P;
    case 1:
      return (_timetableClassTimeTimeOfDayConverter
          .fromIsar(reader.readString(offset))) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _timetableClassTimeSerializeWeb(
    IsarCollection<TimetableClassTime> collection, TimetableClassTime object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(
      jsObj, 'end', _timetableClassTimeTimeOfDayConverter.toIsar(object.end));
  IsarNative.jsObjectSet(jsObj, 'period', object.period);
  IsarNative.jsObjectSet(jsObj, 'start',
      _timetableClassTimeTimeOfDayConverter.toIsar(object.start));
  return jsObj;
}

TimetableClassTime _timetableClassTimeDeserializeWeb(
    IsarCollection<TimetableClassTime> collection, dynamic jsObj) {
  final object = TimetableClassTime();
  object.end = _timetableClassTimeTimeOfDayConverter
      .fromIsar(IsarNative.jsObjectGet(jsObj, 'end') ?? '');
  object.period =
      IsarNative.jsObjectGet(jsObj, 'period') ?? double.negativeInfinity;
  object.start = _timetableClassTimeTimeOfDayConverter
      .fromIsar(IsarNative.jsObjectGet(jsObj, 'start') ?? '');
  return object;
}

P _timetableClassTimeDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'end':
      return (_timetableClassTimeTimeOfDayConverter
          .fromIsar(IsarNative.jsObjectGet(jsObj, 'end') ?? '')) as P;
    case 'period':
      return (IsarNative.jsObjectGet(jsObj, 'period') ??
          double.negativeInfinity) as P;
    case 'start':
      return (_timetableClassTimeTimeOfDayConverter
          .fromIsar(IsarNative.jsObjectGet(jsObj, 'start') ?? '')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _timetableClassTimeAttachLinks(
    IsarCollection col, int id, TimetableClassTime object) {}

extension TimetableClassTimeQueryWhereSort
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QWhere> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhere>
      anyPeriod() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension TimetableClassTimeQueryWhere
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QWhereClause> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
      periodEqualTo(int period) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: period,
      includeLower: true,
      upper: period,
      includeUpper: true,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
      periodNotEqualTo(int period) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: period, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: period, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: period, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: period, includeUpper: false),
      );
    }
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
      periodGreaterThan(int period, {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: period, includeLower: include),
    );
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
      periodLessThan(int period, {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: period, includeUpper: include),
    );
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
      periodBetween(
    int lowerPeriod,
    int upperPeriod, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerPeriod,
      includeLower: includeLower,
      upper: upperPeriod,
      includeUpper: includeUpper,
    ));
  }
}

extension TimetableClassTimeQueryFilter
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QFilterCondition> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endEqualTo(
    TimeOfDay value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'end',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endGreaterThan(
    TimeOfDay value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'end',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endLessThan(
    TimeOfDay value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'end',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endBetween(
    TimeOfDay lower,
    TimeOfDay upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'end',
      lower: _timetableClassTimeTimeOfDayConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _timetableClassTimeTimeOfDayConverter.toIsar(upper),
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endStartsWith(
    TimeOfDay value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'end',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endEndsWith(
    TimeOfDay value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'end',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endContains(TimeOfDay value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'end',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'end',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      periodEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'period',
      value: value,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      periodGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'period',
      value: value,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      periodLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'period',
      value: value,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      periodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'period',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startEqualTo(
    TimeOfDay value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'start',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startGreaterThan(
    TimeOfDay value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'start',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startLessThan(
    TimeOfDay value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'start',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startBetween(
    TimeOfDay lower,
    TimeOfDay upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'start',
      lower: _timetableClassTimeTimeOfDayConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _timetableClassTimeTimeOfDayConverter.toIsar(upper),
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startStartsWith(
    TimeOfDay value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'start',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startEndsWith(
    TimeOfDay value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'start',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startContains(TimeOfDay value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'start',
      value: _timetableClassTimeTimeOfDayConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'start',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension TimetableClassTimeQueryLinks
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QFilterCondition> {}

extension TimetableClassTimeQueryWhereSortBy
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QSortBy> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByEnd() {
    return addSortByInternal('end', Sort.asc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByEndDesc() {
    return addSortByInternal('end', Sort.desc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByPeriod() {
    return addSortByInternal('period', Sort.asc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByPeriodDesc() {
    return addSortByInternal('period', Sort.desc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByStart() {
    return addSortByInternal('start', Sort.asc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByStartDesc() {
    return addSortByInternal('start', Sort.desc);
  }
}

extension TimetableClassTimeQueryWhereSortThenBy
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QSortThenBy> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByEnd() {
    return addSortByInternal('end', Sort.asc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByEndDesc() {
    return addSortByInternal('end', Sort.desc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByPeriod() {
    return addSortByInternal('period', Sort.asc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByPeriodDesc() {
    return addSortByInternal('period', Sort.desc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByStart() {
    return addSortByInternal('start', Sort.asc);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByStartDesc() {
    return addSortByInternal('start', Sort.desc);
  }
}

extension TimetableClassTimeQueryWhereDistinct
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QDistinct> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QDistinct> distinctByEnd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('end', caseSensitive: caseSensitive);
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QDistinct>
      distinctByPeriod() {
    return addDistinctByInternal('period');
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QDistinct>
      distinctByStart({bool caseSensitive = true}) {
    return addDistinctByInternal('start', caseSensitive: caseSensitive);
  }
}

extension TimetableClassTimeQueryProperty
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QQueryProperty> {
  QueryBuilder<TimetableClassTime, TimeOfDay, QQueryOperations> endProperty() {
    return addPropertyNameInternal('end');
  }

  QueryBuilder<TimetableClassTime, int, QQueryOperations> periodProperty() {
    return addPropertyNameInternal('period');
  }

  QueryBuilder<TimetableClassTime, TimeOfDay, QQueryOperations>
      startProperty() {
    return addPropertyNameInternal('start');
  }
}
