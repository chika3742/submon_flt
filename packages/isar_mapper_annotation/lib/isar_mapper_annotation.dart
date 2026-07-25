class IsarMap {
  const IsarMap({required this.domain, this.insertable});

  final Type domain;
  final Type? insertable;
}

abstract class DomainFieldConverter<DomainT, IsarT> {
  const DomainFieldConverter();

  IsarT fromDomain(DomainT value);
  DomainT toDomain(IsarT value);
}

class ConvertDomainField<
  Converter extends DomainFieldConverter<Object?, Object?>
> {
  const ConvertDomainField();
}
