// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../isar_db/isar_timetable.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTimetableCollection on Isar {
  IsarCollection<Timetable> get timetables => this.collection();
}

const TimetableSchema = CollectionSchema(
  name: r'Timetable',
  id: 6380985727860081250,
  properties: {
    r'cellId': PropertySchema(
      id: 0,
      name: r'cellId',
      type: IsarType.long,
    ),
    r'note': PropertySchema(
      id: 1,
      name: r'note',
      type: IsarType.string,
    ),
    r'room': PropertySchema(
      id: 2,
      name: r'room',
      type: IsarType.string,
    ),
    r'subject': PropertySchema(
      id: 3,
      name: r'subject',
      type: IsarType.string,
    ),
    r'tableId': PropertySchema(
      id: 4,
      name: r'tableId',
      type: IsarType.long,
    ),
    r'teacher': PropertySchema(
      id: 5,
      name: r'teacher',
      type: IsarType.string,
    )
  },
  estimateSize: _timetableEstimateSize,
  serialize: _timetableSerialize,
  deserialize: _timetableDeserialize,
  deserializeProp: _timetableDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _timetableGetId,
  getLinks: _timetableGetLinks,
  attach: _timetableAttach,
  version: '3.1.0+1',
);

int _timetableEstimateSize(
  Timetable object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.note.length * 3;
  bytesCount += 3 + object.room.length * 3;
  bytesCount += 3 + object.subject.length * 3;
  bytesCount += 3 + object.teacher.length * 3;
  return bytesCount;
}

void _timetableSerialize(
  Timetable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cellId);
  writer.writeString(offsets[1], object.note);
  writer.writeString(offsets[2], object.room);
  writer.writeString(offsets[3], object.subject);
  writer.writeLong(offsets[4], object.tableId);
  writer.writeString(offsets[5], object.teacher);
}

Timetable _timetableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
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

P _timetableDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _timetableGetId(Timetable object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _timetableGetLinks(Timetable object) {
  return [];
}

void _timetableAttach(IsarCollection<dynamic> col, Id id, Timetable object) {
  object.id = id;
}

extension TimetableQueryWhereSort
    on QueryBuilder<Timetable, Timetable, QWhere> {
  QueryBuilder<Timetable, Timetable, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TimetableQueryWhere
    on QueryBuilder<Timetable, Timetable, QWhereClause> {
  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterWhereClause> idBetween(
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

extension TimetableQueryFilter
    on QueryBuilder<Timetable, Timetable, QFilterCondition> {
  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> cellIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cellId',
        value: value,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> cellIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cellId',
        value: value,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> cellIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cellId',
        value: value,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> cellIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cellId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'room',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'room',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'room',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'room',
        value: '',
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> roomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'room',
        value: '',
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subject',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subject',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> subjectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subject',
        value: '',
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition>
      subjectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subject',
        value: '',
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> tableIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tableId',
        value: value,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> tableIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tableId',
        value: value,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> tableIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tableId',
        value: value,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> tableIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tableId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teacher',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'teacher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'teacher',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition> teacherIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teacher',
        value: '',
      ));
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterFilterCondition>
      teacherIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'teacher',
        value: '',
      ));
    });
  }
}

extension TimetableQueryObject
    on QueryBuilder<Timetable, Timetable, QFilterCondition> {}

extension TimetableQueryLinks
    on QueryBuilder<Timetable, Timetable, QFilterCondition> {}

extension TimetableQuerySortBy on QueryBuilder<Timetable, Timetable, QSortBy> {
  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByCellId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cellId', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByCellIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cellId', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByRoom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'room', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByRoomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'room', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortBySubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortBySubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByTableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByTeacher() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teacher', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> sortByTeacherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teacher', Sort.desc);
    });
  }
}

extension TimetableQuerySortThenBy
    on QueryBuilder<Timetable, Timetable, QSortThenBy> {
  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByCellId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cellId', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByCellIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cellId', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByRoom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'room', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByRoomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'room', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenBySubject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenBySubjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subject', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByTableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tableId', Sort.desc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByTeacher() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teacher', Sort.asc);
    });
  }

  QueryBuilder<Timetable, Timetable, QAfterSortBy> thenByTeacherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teacher', Sort.desc);
    });
  }
}

extension TimetableQueryWhereDistinct
    on QueryBuilder<Timetable, Timetable, QDistinct> {
  QueryBuilder<Timetable, Timetable, QDistinct> distinctByCellId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cellId');
    });
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctByRoom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'room', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctBySubject(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subject', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctByTableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tableId');
    });
  }

  QueryBuilder<Timetable, Timetable, QDistinct> distinctByTeacher(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teacher', caseSensitive: caseSensitive);
    });
  }
}

extension TimetableQueryProperty
    on QueryBuilder<Timetable, Timetable, QQueryProperty> {
  QueryBuilder<Timetable, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Timetable, int, QQueryOperations> cellIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cellId');
    });
  }

  QueryBuilder<Timetable, String, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<Timetable, String, QQueryOperations> roomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'room');
    });
  }

  QueryBuilder<Timetable, String, QQueryOperations> subjectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subject');
    });
  }

  QueryBuilder<Timetable, int, QQueryOperations> tableIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tableId');
    });
  }

  QueryBuilder<Timetable, String, QQueryOperations> teacherProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teacher');
    });
  }
}
