// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../isar_db/isar_timetable_class_time.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetTimetableClassTimeCollection on Isar {
  IsarCollection<TimetableClassTime> get timetableClassTimes =>
      this.collection();
}

const TimetableClassTimeSchema = CollectionSchema(
  name: r'TimetableClassTime',
  id: -601753054573602595,
  properties: {
    r'end': PropertySchema(
      id: 0,
      name: r'end',
      type: IsarType.string,
    ),
    r'start': PropertySchema(
      id: 1,
      name: r'start',
      type: IsarType.string,
    )
  },
  estimateSize: _timetableClassTimeEstimateSize,
  serialize: _timetableClassTimeSerialize,
  deserialize: _timetableClassTimeDeserialize,
  deserializeProp: _timetableClassTimeDeserializeProp,
  idName: r'period',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _timetableClassTimeGetId,
  getLinks: _timetableClassTimeGetLinks,
  attach: _timetableClassTimeAttach,
  version: '3.0.2',
);

int _timetableClassTimeEstimateSize(
  TimetableClassTime object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.end.length * 3;
  bytesCount += 3 + object.start.length * 3;
  return bytesCount;
}

void _timetableClassTimeSerialize(
  TimetableClassTime object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.end);
  writer.writeString(offsets[1], object.start);
}

TimetableClassTime _timetableClassTimeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TimetableClassTime();
  object.end = reader.readString(offsets[0]);
  object.period = id;
  object.start = reader.readString(offsets[1]);
  return object;
}

P _timetableClassTimeDeserializeProp<P>(
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

Id _timetableClassTimeGetId(TimetableClassTime object) {
  return object.period;
}

List<IsarLinkBase<dynamic>> _timetableClassTimeGetLinks(
    TimetableClassTime object) {
  return [];
}

void _timetableClassTimeAttach(
    IsarCollection<dynamic> col, Id id, TimetableClassTime object) {
  object.period = id;
}

extension TimetableClassTimeQueryWhereSort
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QWhere> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhere>
      anyPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TimetableClassTimeQueryWhere
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QWhereClause> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
      periodEqualTo(Id period) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: period,
        upper: period,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
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

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
      periodGreaterThan(Id period, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: period, includeLower: include),
      );
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
      periodLessThan(Id period, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: period, includeUpper: include),
      );
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterWhereClause>
      periodBetween(
    Id lowerPeriod,
    Id upperPeriod, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerPeriod,
        includeLower: includeLower,
        upper: upperPeriod,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TimetableClassTimeQueryFilter
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QFilterCondition> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'end',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'end',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'end',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'end',
        value: '',
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      endIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'end',
        value: '',
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      periodEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'period',
        value: value,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      periodGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'period',
        value: value,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      periodLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'period',
        value: value,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      periodBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'period',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'start',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'start',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'start',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'start',
        value: '',
      ));
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterFilterCondition>
      startIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'start',
        value: '',
      ));
    });
  }
}

extension TimetableClassTimeQueryObject
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QFilterCondition> {}

extension TimetableClassTimeQueryLinks
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QFilterCondition> {}

extension TimetableClassTimeQuerySortBy
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QSortBy> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      sortByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }
}

extension TimetableClassTimeQuerySortThenBy
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QSortThenBy> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QAfterSortBy>
      thenByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }
}

extension TimetableClassTimeQueryWhereDistinct
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QDistinct> {
  QueryBuilder<TimetableClassTime, TimetableClassTime, QDistinct> distinctByEnd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'end', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TimetableClassTime, TimetableClassTime, QDistinct>
      distinctByStart({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'start', caseSensitive: caseSensitive);
    });
  }
}

extension TimetableClassTimeQueryProperty
    on QueryBuilder<TimetableClassTime, TimetableClassTime, QQueryProperty> {
  QueryBuilder<TimetableClassTime, int, QQueryOperations> periodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'period');
    });
  }

  QueryBuilder<TimetableClassTime, String, QQueryOperations> endProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'end');
    });
  }

  QueryBuilder<TimetableClassTime, String, QQueryOperations> startProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'start');
    });
  }
}
