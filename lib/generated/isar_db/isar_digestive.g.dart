// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../isar_db/isar_digestive.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetDigestiveCollection on Isar {
  IsarCollection<Digestive> get digestives => getCollection();
}

const DigestiveSchema = CollectionSchema(
  name: 'Digestive',
  schema:
      '{"name":"Digestive","idName":"id","properties":[{"name":"content","type":"String"},{"name":"done","type":"Bool"},{"name":"minute","type":"Long"},{"name":"startAt","type":"Long"},{"name":"submissionId","type":"Long"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'content': 0,
    'done': 1,
    'minute': 2,
    'startAt': 3,
    'submissionId': 4
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _digestiveGetId,
  setId: _digestiveSetId,
  getLinks: _digestiveGetLinks,
  attachLinks: _digestiveAttachLinks,
  serializeNative: _digestiveSerializeNative,
  deserializeNative: _digestiveDeserializeNative,
  deserializePropNative: _digestiveDeserializePropNative,
  serializeWeb: _digestiveSerializeWeb,
  deserializeWeb: _digestiveDeserializeWeb,
  deserializePropWeb: _digestiveDeserializePropWeb,
  version: 3,
);

int? _digestiveGetId(Digestive object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _digestiveSetId(Digestive object, int id) {
  object.id = id;
}

List<IsarLinkBase> _digestiveGetLinks(Digestive object) {
  return [];
}

void _digestiveSerializeNative(
    IsarCollection<Digestive> collection,
    IsarRawObject rawObj,
    Digestive object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.content;
  final _content = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_content.length) as int;
  final value1 = object.done;
  final _done = value1;
  final value2 = object.minute;
  final _minute = value2;
  final value3 = object.startAt;
  final _startAt = value3;
  final value4 = object.submissionId;
  final _submissionId = value4;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _content);
  writer.writeBool(offsets[1], _done);
  writer.writeLong(offsets[2], _minute);
  writer.writeDateTime(offsets[3], _startAt);
  writer.writeLong(offsets[4], _submissionId);
}

Digestive _digestiveDeserializeNative(IsarCollection<Digestive> collection,
    int id, IsarBinaryReader reader, List<int> offsets) {
  final object = Digestive();
  object.content = reader.readString(offsets[0]);
  object.done = reader.readBool(offsets[1]);
  object.id = id;
  object.minute = reader.readLong(offsets[2]);
  object.startAt = reader.readDateTime(offsets[3]);
  object.submissionId = reader.readLongOrNull(offsets[4]);
  return object;
}

P _digestiveDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _digestiveSerializeWeb(
    IsarCollection<Digestive> collection, Digestive object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'content', object.content);
  IsarNative.jsObjectSet(jsObj, 'done', object.done);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'minute', object.minute);
  IsarNative.jsObjectSet(
      jsObj, 'startAt', object.startAt.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'submissionId', object.submissionId);
  return jsObj;
}

Digestive _digestiveDeserializeWeb(
    IsarCollection<Digestive> collection, dynamic jsObj) {
  final object = Digestive();
  object.content = IsarNative.jsObjectGet(jsObj, 'content') ?? '';
  object.done = IsarNative.jsObjectGet(jsObj, 'done') ?? false;
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.minute =
      IsarNative.jsObjectGet(jsObj, 'minute') ?? double.negativeInfinity;
  object.startAt = IsarNative.jsObjectGet(jsObj, 'startAt') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'startAt'),
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  object.submissionId = IsarNative.jsObjectGet(jsObj, 'submissionId');
  return object;
}

P _digestiveDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'content':
      return (IsarNative.jsObjectGet(jsObj, 'content') ?? '') as P;
    case 'done':
      return (IsarNative.jsObjectGet(jsObj, 'done') ?? false) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'minute':
      return (IsarNative.jsObjectGet(jsObj, 'minute') ??
          double.negativeInfinity) as P;
    case 'startAt':
      return (IsarNative.jsObjectGet(jsObj, 'startAt') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'startAt'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case 'submissionId':
      return (IsarNative.jsObjectGet(jsObj, 'submissionId')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _digestiveAttachLinks(IsarCollection col, int id, Digestive object) {}

extension DigestiveQueryWhereSort
    on QueryBuilder<Digestive, Digestive, QWhere> {
  QueryBuilder<Digestive, Digestive, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension DigestiveQueryWhere
    on QueryBuilder<Digestive, Digestive, QWhereClause> {
  QueryBuilder<Digestive, Digestive, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Digestive, Digestive, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Digestive, Digestive, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Digestive, Digestive, QAfterWhereClause> idBetween(
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

extension DigestiveQueryFilter
    on QueryBuilder<Digestive, Digestive, QFilterCondition> {
  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> contentGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> contentLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'content',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'content',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> doneEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'done',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> minuteEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'minute',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> minuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'minute',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> minuteLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'minute',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> minuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'minute',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> startAtEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'startAt',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> startAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'startAt',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> startAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'startAt',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> startAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'startAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition>
      submissionIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'submissionId',
      value: null,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> submissionIdEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'submissionId',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition>
      submissionIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'submissionId',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition>
      submissionIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'submissionId',
      value: value,
    ));
  }

  QueryBuilder<Digestive, Digestive, QAfterFilterCondition> submissionIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'submissionId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension DigestiveQueryLinks
    on QueryBuilder<Digestive, Digestive, QFilterCondition> {}

extension DigestiveQueryWhereSortBy
    on QueryBuilder<Digestive, Digestive, QSortBy> {
  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortByContent() {
    return addSortByInternal('content', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortByContentDesc() {
    return addSortByInternal('content', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortByDone() {
    return addSortByInternal('done', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortByDoneDesc() {
    return addSortByInternal('done', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortByMinute() {
    return addSortByInternal('minute', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortByMinuteDesc() {
    return addSortByInternal('minute', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortByStartAt() {
    return addSortByInternal('startAt', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortByStartAtDesc() {
    return addSortByInternal('startAt', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortBySubmissionId() {
    return addSortByInternal('submissionId', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> sortBySubmissionIdDesc() {
    return addSortByInternal('submissionId', Sort.desc);
  }
}

extension DigestiveQueryWhereSortThenBy
    on QueryBuilder<Digestive, Digestive, QSortThenBy> {
  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenByContent() {
    return addSortByInternal('content', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenByContentDesc() {
    return addSortByInternal('content', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenByDone() {
    return addSortByInternal('done', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenByDoneDesc() {
    return addSortByInternal('done', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenByMinute() {
    return addSortByInternal('minute', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenByMinuteDesc() {
    return addSortByInternal('minute', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenByStartAt() {
    return addSortByInternal('startAt', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenByStartAtDesc() {
    return addSortByInternal('startAt', Sort.desc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenBySubmissionId() {
    return addSortByInternal('submissionId', Sort.asc);
  }

  QueryBuilder<Digestive, Digestive, QAfterSortBy> thenBySubmissionIdDesc() {
    return addSortByInternal('submissionId', Sort.desc);
  }
}

extension DigestiveQueryWhereDistinct
    on QueryBuilder<Digestive, Digestive, QDistinct> {
  QueryBuilder<Digestive, Digestive, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('content', caseSensitive: caseSensitive);
  }

  QueryBuilder<Digestive, Digestive, QDistinct> distinctByDone() {
    return addDistinctByInternal('done');
  }

  QueryBuilder<Digestive, Digestive, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Digestive, Digestive, QDistinct> distinctByMinute() {
    return addDistinctByInternal('minute');
  }

  QueryBuilder<Digestive, Digestive, QDistinct> distinctByStartAt() {
    return addDistinctByInternal('startAt');
  }

  QueryBuilder<Digestive, Digestive, QDistinct> distinctBySubmissionId() {
    return addDistinctByInternal('submissionId');
  }
}

extension DigestiveQueryProperty
    on QueryBuilder<Digestive, Digestive, QQueryProperty> {
  QueryBuilder<Digestive, String, QQueryOperations> contentProperty() {
    return addPropertyNameInternal('content');
  }

  QueryBuilder<Digestive, bool, QQueryOperations> doneProperty() {
    return addPropertyNameInternal('done');
  }

  QueryBuilder<Digestive, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Digestive, int, QQueryOperations> minuteProperty() {
    return addPropertyNameInternal('minute');
  }

  QueryBuilder<Digestive, DateTime, QQueryOperations> startAtProperty() {
    return addPropertyNameInternal('startAt');
  }

  QueryBuilder<Digestive, int?, QQueryOperations> submissionIdProperty() {
    return addPropertyNameInternal('submissionId');
  }
}
