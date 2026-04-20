// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_timetable_class_time.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarTimetableClassTimeCollection on Isar {
  IsarCollection<IsarTimetableClassTime> get isarTimetableClassTimes =>
      this.collection();
}

const IsarTimetableClassTimeSchema = CollectionSchema(
  name: r'TimetableClassTime',
  id: -601753054573602595,
  properties: {
    r'end': PropertySchema(id: 0, name: r'end', type: IsarType.string),
    r'start': PropertySchema(id: 1, name: r'start', type: IsarType.string),
  },

  estimateSize: _isarTimetableClassTimeEstimateSize,
  serialize: _isarTimetableClassTimeSerialize,
  deserialize: _isarTimetableClassTimeDeserialize,
  deserializeProp: _isarTimetableClassTimeDeserializeProp,
  idName: r'period',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _isarTimetableClassTimeGetId,
  getLinks: _isarTimetableClassTimeGetLinks,
  attach: _isarTimetableClassTimeAttach,
  version: '3.3.2',
);

int _isarTimetableClassTimeEstimateSize(
  IsarTimetableClassTime object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.end.length * 3;
  bytesCount += 3 + object.start.length * 3;
  return bytesCount;
}

void _isarTimetableClassTimeSerialize(
  IsarTimetableClassTime object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.end);
  writer.writeString(offsets[1], object.start);
}

IsarTimetableClassTime _isarTimetableClassTimeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarTimetableClassTime();
  object.end = reader.readString(offsets[0]);
  object.period = id;
  object.start = reader.readString(offsets[1]);
  return object;
}

P _isarTimetableClassTimeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarTimetableClassTimeGetId(IsarTimetableClassTime object) {
  return object.period;
}

List<IsarLinkBase<dynamic>> _isarTimetableClassTimeGetLinks(
  IsarTimetableClassTime object,
) {
  return [];
}

void _isarTimetableClassTimeAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarTimetableClassTime object,
) {
  object.period = id;
}

extension IsarTimetableClassTimeQueryWhereSort
    on QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QWhere> {
  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterWhere>
  anyPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarTimetableClassTimeQueryWhere
    on
        QueryBuilder<
          IsarTimetableClassTime,
          IsarTimetableClassTime,
          QWhereClause
        > {
  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterWhereClause
  >
  periodEqualTo(Id period) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: period, upper: period),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterWhereClause
  >
  periodNotEqualTo(Id period) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: period, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: period, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: period, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: period, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterWhereClause
  >
  periodGreaterThan(Id period, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: period, includeLower: include),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterWhereClause
  >
  periodLessThan(Id period, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: period, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterWhereClause
  >
  periodBetween(
    Id lowerPeriod,
    Id upperPeriod, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerPeriod,
          includeLower: includeLower,
          upper: upperPeriod,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension IsarTimetableClassTimeQueryFilter
    on
        QueryBuilder<
          IsarTimetableClassTime,
          IsarTimetableClassTime,
          QFilterCondition
        > {
  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'end',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'end',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'end',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'end',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'end',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'end',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'end',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'end',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'end', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  endIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'end', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  periodEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'period', value: value),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  periodGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  periodLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  periodBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'period',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'start',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'start',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'start',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'start',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'start',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'start',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'start',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'start',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'start', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarTimetableClassTime,
    IsarTimetableClassTime,
    QAfterFilterCondition
  >
  startIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'start', value: ''),
      );
    });
  }
}

extension IsarTimetableClassTimeQueryObject
    on
        QueryBuilder<
          IsarTimetableClassTime,
          IsarTimetableClassTime,
          QFilterCondition
        > {}

extension IsarTimetableClassTimeQueryLinks
    on
        QueryBuilder<
          IsarTimetableClassTime,
          IsarTimetableClassTime,
          QFilterCondition
        > {}

extension IsarTimetableClassTimeQuerySortBy
    on QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QSortBy> {
  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  sortByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  sortByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  sortByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  sortByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }
}

extension IsarTimetableClassTimeQuerySortThenBy
    on
        QueryBuilder<
          IsarTimetableClassTime,
          IsarTimetableClassTime,
          QSortThenBy
        > {
  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  thenByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  thenByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  thenByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  thenByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  thenByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QAfterSortBy>
  thenByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }
}

extension IsarTimetableClassTimeQueryWhereDistinct
    on QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QDistinct> {
  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QDistinct>
  distinctByEnd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'end', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarTimetableClassTime, IsarTimetableClassTime, QDistinct>
  distinctByStart({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'start', caseSensitive: caseSensitive);
    });
  }
}

extension IsarTimetableClassTimeQueryProperty
    on
        QueryBuilder<
          IsarTimetableClassTime,
          IsarTimetableClassTime,
          QQueryProperty
        > {
  QueryBuilder<IsarTimetableClassTime, int, QQueryOperations> periodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'period');
    });
  }

  QueryBuilder<IsarTimetableClassTime, String, QQueryOperations> endProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'end');
    });
  }

  QueryBuilder<IsarTimetableClassTime, String, QQueryOperations>
  startProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'start');
    });
  }
}

// **************************************************************************
// IsarMapperGenerator
// **************************************************************************

extension IsarTimetableClassTimeToTimetableClassTimePeriod
    on IsarTimetableClassTime {
  TimetableClassTimePeriod toDomain() {
    return TimetableClassTimePeriod(
      period: period,
      start: const _TimeOfDayConverter().toDomain(start),
      end: const _TimeOfDayConverter().toDomain(end),
    );
  }
}

extension TimetableClassTimePeriodToIsarTimetableClassTime
    on TimetableClassTimePeriod {
  IsarTimetableClassTime toIsar() {
    return IsarTimetableClassTime()
      ..period = period
      ..start = const _TimeOfDayConverter().fromDomain(start)
      ..end = const _TimeOfDayConverter().fromDomain(end);
  }
}
