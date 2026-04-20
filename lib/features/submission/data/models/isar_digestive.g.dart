// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_digestive.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarDigestiveCollection on Isar {
  IsarCollection<IsarDigestive> get isarDigestives => this.collection();
}

const IsarDigestiveSchema = CollectionSchema(
  name: r'Digestive',
  id: 4988416188117964617,
  properties: {
    r'content': PropertySchema(id: 0, name: r'content', type: IsarType.string),
    r'done': PropertySchema(id: 1, name: r'done', type: IsarType.bool),
    r'minute': PropertySchema(id: 2, name: r'minute', type: IsarType.long),
    r'startAt': PropertySchema(
      id: 3,
      name: r'startAt',
      type: IsarType.dateTime,
    ),
    r'submissionId': PropertySchema(
      id: 4,
      name: r'submissionId',
      type: IsarType.long,
    ),
  },

  estimateSize: _isarDigestiveEstimateSize,
  serialize: _isarDigestiveSerialize,
  deserialize: _isarDigestiveDeserialize,
  deserializeProp: _isarDigestiveDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _isarDigestiveGetId,
  getLinks: _isarDigestiveGetLinks,
  attach: _isarDigestiveAttach,
  version: '3.3.2',
);

int _isarDigestiveEstimateSize(
  IsarDigestive object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  return bytesCount;
}

void _isarDigestiveSerialize(
  IsarDigestive object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeBool(offsets[1], object.done);
  writer.writeLong(offsets[2], object.minute);
  writer.writeDateTime(offsets[3], object.startAt);
  writer.writeLong(offsets[4], object.submissionId);
}

IsarDigestive _isarDigestiveDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarDigestive();
  object.content = reader.readString(offsets[0]);
  object.done = reader.readBool(offsets[1]);
  object.id = id;
  object.minute = reader.readLong(offsets[2]);
  object.startAt = reader.readDateTime(offsets[3]);
  object.submissionId = reader.readLongOrNull(offsets[4]);
  return object;
}

P _isarDigestiveDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
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
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarDigestiveGetId(IsarDigestive object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarDigestiveGetLinks(IsarDigestive object) {
  return [];
}

void _isarDigestiveAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarDigestive object,
) {
  object.id = id;
}

extension IsarDigestiveQueryWhereSort
    on QueryBuilder<IsarDigestive, IsarDigestive, QWhere> {
  QueryBuilder<IsarDigestive, IsarDigestive, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarDigestiveQueryWhere
    on QueryBuilder<IsarDigestive, IsarDigestive, QWhereClause> {
  QueryBuilder<IsarDigestive, IsarDigestive, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension IsarDigestiveQueryFilter
    on QueryBuilder<IsarDigestive, IsarDigestive, QFilterCondition> {
  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'content',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'content',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'content',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'content', value: ''),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'content', value: ''),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition> doneEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'done', value: value),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition> idEqualTo(
    Id? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  idGreaterThan(Id? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  minuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'minute', value: value),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  minuteGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'minute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  minuteLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'minute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  minuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'minute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  startAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startAt', value: value),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  startAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  startAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  startAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  submissionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'submissionId'),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  submissionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'submissionId'),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  submissionIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'submissionId', value: value),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  submissionIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'submissionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  submissionIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'submissionId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterFilterCondition>
  submissionIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'submissionId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension IsarDigestiveQueryObject
    on QueryBuilder<IsarDigestive, IsarDigestive, QFilterCondition> {}

extension IsarDigestiveQueryLinks
    on QueryBuilder<IsarDigestive, IsarDigestive, QFilterCondition> {}

extension IsarDigestiveQuerySortBy
    on QueryBuilder<IsarDigestive, IsarDigestive, QSortBy> {
  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> sortByDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> sortByDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.desc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> sortByMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> sortByMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.desc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> sortByStartAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> sortByStartAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.desc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy>
  sortBySubmissionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'submissionId', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy>
  sortBySubmissionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'submissionId', Sort.desc);
    });
  }
}

extension IsarDigestiveQuerySortThenBy
    on QueryBuilder<IsarDigestive, IsarDigestive, QSortThenBy> {
  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenByDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenByDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.desc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenByMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenByMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.desc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenByStartAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy> thenByStartAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.desc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy>
  thenBySubmissionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'submissionId', Sort.asc);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QAfterSortBy>
  thenBySubmissionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'submissionId', Sort.desc);
    });
  }
}

extension IsarDigestiveQueryWhereDistinct
    on QueryBuilder<IsarDigestive, IsarDigestive, QDistinct> {
  QueryBuilder<IsarDigestive, IsarDigestive, QDistinct> distinctByContent({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QDistinct> distinctByDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'done');
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QDistinct> distinctByMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minute');
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QDistinct> distinctByStartAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startAt');
    });
  }

  QueryBuilder<IsarDigestive, IsarDigestive, QDistinct>
  distinctBySubmissionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'submissionId');
    });
  }
}

extension IsarDigestiveQueryProperty
    on QueryBuilder<IsarDigestive, IsarDigestive, QQueryProperty> {
  QueryBuilder<IsarDigestive, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarDigestive, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<IsarDigestive, bool, QQueryOperations> doneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'done');
    });
  }

  QueryBuilder<IsarDigestive, int, QQueryOperations> minuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minute');
    });
  }

  QueryBuilder<IsarDigestive, DateTime, QQueryOperations> startAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startAt');
    });
  }

  QueryBuilder<IsarDigestive, int?, QQueryOperations> submissionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'submissionId');
    });
  }
}

// **************************************************************************
// IsarMapperGenerator
// **************************************************************************

extension IsarDigestiveToDigestive on IsarDigestive {
  Digestive toDomain() {
    return Digestive(
      id: id!,
      submissionId: submissionId,
      done: done,
      startAt: startAt,
      minute: minute,
      content: content,
    );
  }
}

extension DigestiveToIsarDigestive on Digestive {
  IsarDigestive toIsar() {
    return IsarDigestive()
      ..id = id
      ..submissionId = submissionId
      ..done = done
      ..startAt = startAt
      ..minute = minute
      ..content = content;
  }
}

extension DigestiveInsertableToIsarDigestive on DigestiveInsertable {
  IsarDigestive toIsar() {
    return IsarDigestive()
      ..submissionId = submissionId
      ..startAt = startAt
      ..minute = minute
      ..content = content;
  }
}
