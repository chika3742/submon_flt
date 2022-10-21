// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../isar_db/isar_timetable_table.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetTimetableTableCollection on Isar {
  IsarCollection<TimetableTable> get timetableTables => getCollection();
}

const TimetableTableSchema = CollectionSchema(
  name: 'TimetableTable',
  schema:
      '{"name":"TimetableTable","idName":"id","properties":[{"name":"title","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {'title': 0},
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _timetableTableGetId,
  setId: _timetableTableSetId,
  getLinks: _timetableTableGetLinks,
  attachLinks: _timetableTableAttachLinks,
  serializeNative: _timetableTableSerializeNative,
  deserializeNative: _timetableTableDeserializeNative,
  deserializePropNative: _timetableTableDeserializePropNative,
  serializeWeb: _timetableTableSerializeWeb,
  deserializeWeb: _timetableTableDeserializeWeb,
  deserializePropWeb: _timetableTableDeserializePropWeb,
  version: 3,
);

int? _timetableTableGetId(TimetableTable object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _timetableTableSetId(TimetableTable object, int id) {
  object.id = id;
}

List<IsarLinkBase> _timetableTableGetLinks(TimetableTable object) {
  return [];
}

void _timetableTableSerializeNative(
    IsarCollection<TimetableTable> collection,
    IsarRawObject rawObj,
    TimetableTable object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.title;
  final _title = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_title.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _title);
}

TimetableTable _timetableTableDeserializeNative(
    IsarCollection<TimetableTable> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = TimetableTable();
  object.id = id;
  object.title = reader.readString(offsets[0]);
  return object;
}

P _timetableTableDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _timetableTableSerializeWeb(
    IsarCollection<TimetableTable> collection, TimetableTable object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'title', object.title);
  return jsObj;
}

TimetableTable _timetableTableDeserializeWeb(
    IsarCollection<TimetableTable> collection, dynamic jsObj) {
  final object = TimetableTable();
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.title = IsarNative.jsObjectGet(jsObj, 'title') ?? '';
  return object;
}

P _timetableTableDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'title':
      return (IsarNative.jsObjectGet(jsObj, 'title') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _timetableTableAttachLinks(
    IsarCollection col, int id, TimetableTable object) {}

extension TimetableTableQueryWhereSort
    on QueryBuilder<TimetableTable, TimetableTable, QWhere> {
  QueryBuilder<TimetableTable, TimetableTable, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension TimetableTableQueryWhere
    on QueryBuilder<TimetableTable, TimetableTable, QWhereClause> {
  QueryBuilder<TimetableTable, TimetableTable, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterWhereClause> idNotEqualTo(
      int id) {
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterWhereClause> idLessThan(
      int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterWhereClause> idBetween(
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

extension TimetableTableQueryFilter
    on QueryBuilder<TimetableTable, TimetableTable, QFilterCondition> {
  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      titleEqualTo(
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      titleGreaterThan(
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      titleLessThan(
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      titleBetween(
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      titleStartsWith(
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      titleEndsWith(
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

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'title',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension TimetableTableQueryLinks
    on QueryBuilder<TimetableTable, TimetableTable, QFilterCondition> {}

extension TimetableTableQueryWhereSortBy
    on QueryBuilder<TimetableTable, TimetableTable, QSortBy> {
  QueryBuilder<TimetableTable, TimetableTable, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterSortBy> sortByTitle() {
    return addSortByInternal('title', Sort.asc);
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterSortBy> sortByTitleDesc() {
    return addSortByInternal('title', Sort.desc);
  }
}

extension TimetableTableQueryWhereSortThenBy
    on QueryBuilder<TimetableTable, TimetableTable, QSortThenBy> {
  QueryBuilder<TimetableTable, TimetableTable, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterSortBy> thenByTitle() {
    return addSortByInternal('title', Sort.asc);
  }

  QueryBuilder<TimetableTable, TimetableTable, QAfterSortBy> thenByTitleDesc() {
    return addSortByInternal('title', Sort.desc);
  }
}

extension TimetableTableQueryWhereDistinct
    on QueryBuilder<TimetableTable, TimetableTable, QDistinct> {
  QueryBuilder<TimetableTable, TimetableTable, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<TimetableTable, TimetableTable, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('title', caseSensitive: caseSensitive);
  }
}

extension TimetableTableQueryProperty
    on QueryBuilder<TimetableTable, TimetableTable, QQueryProperty> {
  QueryBuilder<TimetableTable, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<TimetableTable, String, QQueryOperations> titleProperty() {
    return addPropertyNameInternal('title');
  }
}
