// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_submission.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarSubmissionCollection on Isar {
  IsarCollection<IsarSubmission> get isarSubmissions => this.collection();
}

const IsarSubmissionSchema = CollectionSchema(
  name: r'Submission',
  id: -3538876163806880374,
  properties: {
    r'color': PropertySchema(id: 0, name: r'color', type: IsarType.long),
    r'details': PropertySchema(id: 1, name: r'details', type: IsarType.string),
    r'done': PropertySchema(id: 2, name: r'done', type: IsarType.bool),
    r'due': PropertySchema(id: 3, name: r'due', type: IsarType.dateTime),
    r'googleTasksTaskId': PropertySchema(
      id: 4,
      name: r'googleTasksTaskId',
      type: IsarType.string,
    ),
    r'important': PropertySchema(
      id: 5,
      name: r'important',
      type: IsarType.bool,
    ),
    r'repeat': PropertySchema(
      id: 6,
      name: r'repeat',
      type: IsarType.byte,
      enumMap: _IsarSubmissionrepeatEnumValueMap,
    ),
    r'repeatSubmissionCreated': PropertySchema(
      id: 7,
      name: r'repeatSubmissionCreated',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(id: 8, name: r'title', type: IsarType.string),
  },

  estimateSize: _isarSubmissionEstimateSize,
  serialize: _isarSubmissionSerialize,
  deserialize: _isarSubmissionDeserialize,
  deserializeProp: _isarSubmissionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _isarSubmissionGetId,
  getLinks: _isarSubmissionGetLinks,
  attach: _isarSubmissionAttach,
  version: '3.3.2',
);

int _isarSubmissionEstimateSize(
  IsarSubmission object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.details.length * 3;
  {
    final value = object.googleTasksTaskId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _isarSubmissionSerialize(
  IsarSubmission object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.color);
  writer.writeString(offsets[1], object.details);
  writer.writeBool(offsets[2], object.done);
  writer.writeDateTime(offsets[3], object.due);
  writer.writeString(offsets[4], object.googleTasksTaskId);
  writer.writeBool(offsets[5], object.important);
  writer.writeByte(offsets[6], object.repeat.index);
  writer.writeBool(offsets[7], object.repeatSubmissionCreated);
  writer.writeString(offsets[8], object.title);
}

IsarSubmission _isarSubmissionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarSubmission();
  object.color = reader.readLong(offsets[0]);
  object.details = reader.readString(offsets[1]);
  object.done = reader.readBool(offsets[2]);
  object.due = reader.readDateTime(offsets[3]);
  object.googleTasksTaskId = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.important = reader.readBool(offsets[5]);
  object.repeat =
      _IsarSubmissionrepeatValueEnumMap[reader.readByteOrNull(offsets[6])] ??
      RepeatType.none;
  object.repeatSubmissionCreated = reader.readBool(offsets[7]);
  object.title = reader.readString(offsets[8]);
  return object;
}

P _isarSubmissionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (_IsarSubmissionrepeatValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              RepeatType.none)
          as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _IsarSubmissionrepeatEnumValueMap = {
  'none': 0,
  'weekly': 1,
  'monthly': 2,
};
const _IsarSubmissionrepeatValueEnumMap = {
  0: RepeatType.none,
  1: RepeatType.weekly,
  2: RepeatType.monthly,
};

Id _isarSubmissionGetId(IsarSubmission object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarSubmissionGetLinks(IsarSubmission object) {
  return [];
}

void _isarSubmissionAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarSubmission object,
) {
  object.id = id;
}

extension IsarSubmissionQueryWhereSort
    on QueryBuilder<IsarSubmission, IsarSubmission, QWhere> {
  QueryBuilder<IsarSubmission, IsarSubmission, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarSubmissionQueryWhere
    on QueryBuilder<IsarSubmission, IsarSubmission, QWhereClause> {
  QueryBuilder<IsarSubmission, IsarSubmission, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterWhereClause> idBetween(
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

extension IsarSubmissionQueryFilter
    on QueryBuilder<IsarSubmission, IsarSubmission, QFilterCondition> {
  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  colorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'color', value: value),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  colorGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'color',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  colorLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'color',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  colorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'color',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'details',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'details',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'details',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'details',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'details',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'details',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'details',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'details',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'details', value: ''),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  detailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'details', value: ''),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  doneEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'done', value: value),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  dueEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'due', value: value),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  dueGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'due',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  dueLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'due',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  dueBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'due',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'googleTasksTaskId'),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'googleTasksTaskId'),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'googleTasksTaskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'googleTasksTaskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'googleTasksTaskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'googleTasksTaskId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'googleTasksTaskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'googleTasksTaskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'googleTasksTaskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'googleTasksTaskId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'googleTasksTaskId', value: ''),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  googleTasksTaskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'googleTasksTaskId', value: ''),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition> idEqualTo(
    Id? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
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

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  idLessThan(Id? value, {bool include = false}) {
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

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  importantEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'important', value: value),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  repeatEqualTo(RepeatType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'repeat', value: value),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  repeatGreaterThan(RepeatType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'repeat',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  repeatLessThan(RepeatType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'repeat',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  repeatBetween(
    RepeatType lower,
    RepeatType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'repeat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  repeatSubmissionCreatedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'repeatSubmissionCreated',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }
}

extension IsarSubmissionQueryObject
    on QueryBuilder<IsarSubmission, IsarSubmission, QFilterCondition> {}

extension IsarSubmissionQueryLinks
    on QueryBuilder<IsarSubmission, IsarSubmission, QFilterCondition> {}

extension IsarSubmissionQuerySortBy
    on QueryBuilder<IsarSubmission, IsarSubmission, QSortBy> {
  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  sortByDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  sortByGoogleTasksTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleTasksTaskId', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  sortByGoogleTasksTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleTasksTaskId', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByImportant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'important', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  sortByImportantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'important', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  sortByRepeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  sortByRepeatSubmissionCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatSubmissionCreated', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  sortByRepeatSubmissionCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatSubmissionCreated', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension IsarSubmissionQuerySortThenBy
    on QueryBuilder<IsarSubmission, IsarSubmission, QSortThenBy> {
  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  thenByDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  thenByGoogleTasksTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleTasksTaskId', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  thenByGoogleTasksTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleTasksTaskId', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByImportant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'important', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  thenByImportantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'important', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  thenByRepeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  thenByRepeatSubmissionCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatSubmissionCreated', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy>
  thenByRepeatSubmissionCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatSubmissionCreated', Sort.desc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension IsarSubmissionQueryWhereDistinct
    on QueryBuilder<IsarSubmission, IsarSubmission, QDistinct> {
  QueryBuilder<IsarSubmission, IsarSubmission, QDistinct> distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color');
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QDistinct> distinctByDetails({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'details', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QDistinct> distinctByDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'done');
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QDistinct> distinctByDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'due');
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QDistinct>
  distinctByGoogleTasksTaskId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'googleTasksTaskId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QDistinct>
  distinctByImportant() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'important');
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QDistinct> distinctByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeat');
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QDistinct>
  distinctByRepeatSubmissionCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatSubmissionCreated');
    });
  }

  QueryBuilder<IsarSubmission, IsarSubmission, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension IsarSubmissionQueryProperty
    on QueryBuilder<IsarSubmission, IsarSubmission, QQueryProperty> {
  QueryBuilder<IsarSubmission, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarSubmission, int, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<IsarSubmission, String, QQueryOperations> detailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'details');
    });
  }

  QueryBuilder<IsarSubmission, bool, QQueryOperations> doneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'done');
    });
  }

  QueryBuilder<IsarSubmission, DateTime, QQueryOperations> dueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'due');
    });
  }

  QueryBuilder<IsarSubmission, String?, QQueryOperations>
  googleTasksTaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'googleTasksTaskId');
    });
  }

  QueryBuilder<IsarSubmission, bool, QQueryOperations> importantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'important');
    });
  }

  QueryBuilder<IsarSubmission, RepeatType, QQueryOperations> repeatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeat');
    });
  }

  QueryBuilder<IsarSubmission, bool, QQueryOperations>
  repeatSubmissionCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatSubmissionCreated');
    });
  }

  QueryBuilder<IsarSubmission, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

// **************************************************************************
// IsarMapperGenerator
// **************************************************************************

extension IsarSubmissionToSubmission on IsarSubmission {
  Submission toDomain() {
    return Submission(
      id: id!,
      title: title,
      details: details,
      due: due,
      done: done,
      important: important,
      repeat: repeat,
      repeatSubmissionCreated: repeatSubmissionCreated,
      color: const SubmissionColorConverter().toDomain(color),
      googleTasksTaskId: googleTasksTaskId,
    );
  }
}

extension SubmissionToIsarSubmission on Submission {
  IsarSubmission toIsar() {
    return IsarSubmission()
      ..id = id
      ..title = title
      ..details = details
      ..due = due
      ..done = done
      ..important = important
      ..repeat = repeat
      ..color = const SubmissionColorConverter().fromDomain(color)
      ..googleTasksTaskId = googleTasksTaskId
      ..repeatSubmissionCreated = repeatSubmissionCreated;
  }
}

extension SubmissionInsertableToIsarSubmission on SubmissionInsertable {
  IsarSubmission toIsar() {
    return IsarSubmission()
      ..title = title
      ..details = details
      ..due = due
      ..repeat = repeat
      ..color = const SubmissionColorConverter().fromDomain(color);
  }
}
