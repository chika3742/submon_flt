// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../isar_db/isar_memorization_card_group.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetMemorizationCardGroupCollection on Isar {
  IsarCollection<MemorizationCardGroup> get memorizationCardGroups =>
      getCollection();
}

const MemorizationCardGroupSchema = CollectionSchema(
  name: 'MemorizationCardGroup',
  schema:
      '{"name":"MemorizationCardGroup","idName":"id","properties":[{"name":"title","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {'title': 0},
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _memorizationCardGroupGetId,
  setId: _memorizationCardGroupSetId,
  getLinks: _memorizationCardGroupGetLinks,
  attachLinks: _memorizationCardGroupAttachLinks,
  serializeNative: _memorizationCardGroupSerializeNative,
  deserializeNative: _memorizationCardGroupDeserializeNative,
  deserializePropNative: _memorizationCardGroupDeserializePropNative,
  serializeWeb: _memorizationCardGroupSerializeWeb,
  deserializeWeb: _memorizationCardGroupDeserializeWeb,
  deserializePropWeb: _memorizationCardGroupDeserializePropWeb,
  version: 3,
);

int? _memorizationCardGroupGetId(MemorizationCardGroup object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _memorizationCardGroupSetId(MemorizationCardGroup object, int id) {
  object.id = id;
}

List<IsarLinkBase> _memorizationCardGroupGetLinks(
    MemorizationCardGroup object) {
  return [];
}

void _memorizationCardGroupSerializeNative(
    IsarCollection<MemorizationCardGroup> collection,
    IsarRawObject rawObj,
    MemorizationCardGroup object,
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

MemorizationCardGroup _memorizationCardGroupDeserializeNative(
    IsarCollection<MemorizationCardGroup> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = MemorizationCardGroup();
  object.id = id;
  object.title = reader.readString(offsets[0]);
  return object;
}

P _memorizationCardGroupDeserializePropNative<P>(
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

dynamic _memorizationCardGroupSerializeWeb(
    IsarCollection<MemorizationCardGroup> collection,
    MemorizationCardGroup object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'title', object.title);
  return jsObj;
}

MemorizationCardGroup _memorizationCardGroupDeserializeWeb(
    IsarCollection<MemorizationCardGroup> collection, dynamic jsObj) {
  final object = MemorizationCardGroup();
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.title = IsarNative.jsObjectGet(jsObj, 'title') ?? '';
  return object;
}

P _memorizationCardGroupDeserializePropWeb<P>(
    Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'title':
      return (IsarNative.jsObjectGet(jsObj, 'title') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _memorizationCardGroupAttachLinks(
    IsarCollection col, int id, MemorizationCardGroup object) {}

extension MemorizationCardGroupQueryWhereSort
    on QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QWhere> {
  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterWhere>
      anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension MemorizationCardGroupQueryWhere on QueryBuilder<MemorizationCardGroup,
    MemorizationCardGroup, QWhereClause> {
  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterWhereClause>
      idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterWhereClause>
      idNotEqualTo(int id) {
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterWhereClause>
      idGreaterThan(int id, {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterWhereClause>
      idLessThan(int id, {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterWhereClause>
      idBetween(
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

extension MemorizationCardGroupQueryFilter on QueryBuilder<
    MemorizationCardGroup, MemorizationCardGroup, QFilterCondition> {
  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> titleBetween(
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
      QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'title',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension MemorizationCardGroupQueryLinks on QueryBuilder<MemorizationCardGroup,
    MemorizationCardGroup, QFilterCondition> {}

extension MemorizationCardGroupQueryWhereSortBy
    on QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QSortBy> {
  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterSortBy>
      sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterSortBy>
      sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterSortBy>
      sortByTitle() {
    return addSortByInternal('title', Sort.asc);
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterSortBy>
      sortByTitleDesc() {
    return addSortByInternal('title', Sort.desc);
  }
}

extension MemorizationCardGroupQueryWhereSortThenBy
    on QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QSortThenBy> {
  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterSortBy>
      thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterSortBy>
      thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterSortBy>
      thenByTitle() {
    return addSortByInternal('title', Sort.asc);
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QAfterSortBy>
      thenByTitleDesc() {
    return addSortByInternal('title', Sort.desc);
  }
}

extension MemorizationCardGroupQueryWhereDistinct
    on QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QDistinct> {
  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QDistinct>
      distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<MemorizationCardGroup, MemorizationCardGroup, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return addDistinctByInternal('title', caseSensitive: caseSensitive);
  }
}

extension MemorizationCardGroupQueryProperty on QueryBuilder<
    MemorizationCardGroup, MemorizationCardGroup, QQueryProperty> {
  QueryBuilder<MemorizationCardGroup, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<MemorizationCardGroup, String, QQueryOperations>
      titleProperty() {
    return addPropertyNameInternal('title');
  }
}
