import "package:freezed_annotation/freezed_annotation.dart";
import "package:insertable_annotation/insertable_annotation.dart";

part "digestive.freezed.dart";
part "digestive.g.dart";

@freezed
@generateInsertable
sealed class Digestive with _$Digestive {
  const factory Digestive({
    @insertableIgnore required int id,
    required int? submissionId,
    @insertableIgnore @Default(false) bool done,
    required DateTime startAt,
    required int minute,
    required String content,
  }) = _Digestive;
}
