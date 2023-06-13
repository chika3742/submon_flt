// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../isar_db/isar_submission.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSubmissionCollection on Isar {
  IsarCollection<Submission> get submissions => this.collection();
}

const SubmissionSchema = CollectionSchema(
  name: r'Submission',
  id: -3538876163806880374,
  properties: {
    r'canvasPlannableId': PropertySchema(
      id: 0,
      name: r'canvasPlannableId',
      type: IsarType.long,
    ),
    r'color': PropertySchema(
      id: 1,
      name: r'color',
      type: IsarType.long,
    ),
    r'details': PropertySchema(
      id: 2,
      name: r'details',
      type: IsarType.string,
    ),
    r'done': PropertySchema(
      id: 3,
      name: r'done',
      type: IsarType.bool,
    ),
    r'due': PropertySchema(
      id: 4,
      name: r'due',
      type: IsarType.dateTime,
    ),
    r'googleTasksTaskId': PropertySchema(
      id: 5,
      name: r'googleTasksTaskId',
      type: IsarType.string,
    ),
    r'important': PropertySchema(
      id: 6,
      name: r'important',
      type: IsarType.bool,
    ),
    r'repeat': PropertySchema(
      id: 7,
      name: r'repeat',
      type: IsarType.byte,
      enumMap: _SubmissionrepeatEnumValueMap,
    ),
    r'repeatSubmissionCreated': PropertySchema(
      id: 8,
      name: r'repeatSubmissionCreated',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _submissionEstimateSize,
  serialize: _submissionSerialize,
  deserialize: _submissionDeserialize,
  deserializeProp: _submissionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _submissionGetId,
  getLinks: _submissionGetLinks,
  attach: _submissionAttach,
  version: '3.1.0+1',
);

int _submissionEstimateSize(
  Submission object,
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

void _submissionSerialize(
  Submission object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.canvasPlannableId);
  writer.writeLong(offsets[1], object.color);
  writer.writeString(offsets[2], object.details);
  writer.writeBool(offsets[3], object.done);
  writer.writeDateTime(offsets[4], object.due);
  writer.writeString(offsets[5], object.googleTasksTaskId);
  writer.writeBool(offsets[6], object.important);
  writer.writeByte(offsets[7], object.repeat.index);
  writer.writeBool(offsets[8], object.repeatSubmissionCreated);
  writer.writeString(offsets[9], object.title);
}

Submission _submissionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Submission();
  object.canvasPlannableId = reader.readLongOrNull(offsets[0]);
  object.color = reader.readLong(offsets[1]);
  object.details = reader.readString(offsets[2]);
  object.done = reader.readBool(offsets[3]);
  object.due = reader.readDateTime(offsets[4]);
  object.googleTasksTaskId = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.important = reader.readBool(offsets[6]);
  object.repeat =
      _SubmissionrepeatValueEnumMap[reader.readByteOrNull(offsets[7])] ??
          Repeat.none;
  object.repeatSubmissionCreated = reader.readBoolOrNull(offsets[8]);
  object.title = reader.readString(offsets[9]);
  return object;
}

P _submissionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
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
      return (_SubmissionrepeatValueEnumMap[reader.readByteOrNull(offset)] ??
          Repeat.none) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SubmissionrepeatEnumValueMap = {
  'none': 0,
  'weekly': 1,
  'monthly': 2,
};
const _SubmissionrepeatValueEnumMap = {
  0: Repeat.none,
  1: Repeat.weekly,
  2: Repeat.monthly,
};

Id _submissionGetId(Submission object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _submissionGetLinks(Submission object) {
  return [];
}

void _submissionAttach(IsarCollection<dynamic> col, Id id, Submission object) {
  object.id = id;
}

extension SubmissionQueryWhereSort
    on QueryBuilder<Submission, Submission, QWhere> {
  QueryBuilder<Submission, Submission, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SubmissionQueryWhere
    on QueryBuilder<Submission, Submission, QWhereClause> {
  QueryBuilder<Submission, Submission, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Submission, Submission, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Submission, Submission, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Submission, Submission, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SubmissionQueryFilter
    on QueryBuilder<Submission, Submission, QFilterCondition> {
  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'canvasPlannableId',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'canvasPlannableId',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canvasPlannableId',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'canvasPlannableId',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'canvasPlannableId',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      canvasPlannableIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'canvasPlannableId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> colorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> colorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> colorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> colorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      detailsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'details',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'details',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'details',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> detailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'details',
        value: '',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      detailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'details',
        value: '',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> doneEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'done',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> dueEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'due',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> dueGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'due',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> dueLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'due',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> dueBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'due',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'googleTasksTaskId',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'googleTasksTaskId',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googleTasksTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'googleTasksTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'googleTasksTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'googleTasksTaskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'googleTasksTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'googleTasksTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'googleTasksTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'googleTasksTaskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googleTasksTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      googleTasksTaskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'googleTasksTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> importantEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'important',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> repeatEqualTo(
      Repeat value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeat',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> repeatGreaterThan(
    Repeat value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeat',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> repeatLessThan(
    Repeat value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeat',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> repeatBetween(
    Repeat lower,
    Repeat upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      repeatSubmissionCreatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repeatSubmissionCreated',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      repeatSubmissionCreatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repeatSubmissionCreated',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      repeatSubmissionCreatedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatSubmissionCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Submission, Submission, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension SubmissionQueryObject
    on QueryBuilder<Submission, Submission, QFilterCondition> {}

extension SubmissionQueryLinks
    on QueryBuilder<Submission, Submission, QFilterCondition> {}

extension SubmissionQuerySortBy
    on QueryBuilder<Submission, Submission, QSortBy> {
  QueryBuilder<Submission, Submission, QAfterSortBy> sortByCanvasPlannableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasPlannableId', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      sortByCanvasPlannableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasPlannableId', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByGoogleTasksTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleTasksTaskId', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      sortByGoogleTasksTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleTasksTaskId', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByImportant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'important', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByImportantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'important', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByRepeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      sortByRepeatSubmissionCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatSubmissionCreated', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      sortByRepeatSubmissionCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatSubmissionCreated', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension SubmissionQuerySortThenBy
    on QueryBuilder<Submission, Submission, QSortThenBy> {
  QueryBuilder<Submission, Submission, QAfterSortBy> thenByCanvasPlannableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasPlannableId', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      thenByCanvasPlannableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canvasPlannableId', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'details', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'done', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByGoogleTasksTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleTasksTaskId', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      thenByGoogleTasksTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleTasksTaskId', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByImportant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'important', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByImportantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'important', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByRepeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      thenByRepeatSubmissionCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatSubmissionCreated', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy>
      thenByRepeatSubmissionCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatSubmissionCreated', Sort.desc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Submission, Submission, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension SubmissionQueryWhereDistinct
    on QueryBuilder<Submission, Submission, QDistinct> {
  QueryBuilder<Submission, Submission, QDistinct>
      distinctByCanvasPlannableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canvasPlannableId');
    });
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color');
    });
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByDetails(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'details', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'done');
    });
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'due');
    });
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByGoogleTasksTaskId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'googleTasksTaskId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByImportant() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'important');
    });
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeat');
    });
  }

  QueryBuilder<Submission, Submission, QDistinct>
      distinctByRepeatSubmissionCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatSubmissionCreated');
    });
  }

  QueryBuilder<Submission, Submission, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension SubmissionQueryProperty
    on QueryBuilder<Submission, Submission, QQueryProperty> {
  QueryBuilder<Submission, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Submission, int?, QQueryOperations> canvasPlannableIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canvasPlannableId');
    });
  }

  QueryBuilder<Submission, int, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<Submission, String, QQueryOperations> detailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'details');
    });
  }

  QueryBuilder<Submission, bool, QQueryOperations> doneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'done');
    });
  }

  QueryBuilder<Submission, DateTime, QQueryOperations> dueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'due');
    });
  }

  QueryBuilder<Submission, String?, QQueryOperations>
      googleTasksTaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'googleTasksTaskId');
    });
  }

  QueryBuilder<Submission, bool, QQueryOperations> importantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'important');
    });
  }

  QueryBuilder<Submission, Repeat, QQueryOperations> repeatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeat');
    });
  }

  QueryBuilder<Submission, bool?, QQueryOperations>
      repeatSubmissionCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatSubmissionCreated');
    });
  }

  QueryBuilder<Submission, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
