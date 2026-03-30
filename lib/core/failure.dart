import "package:freezed_annotation/freezed_annotation.dart";

part "failure.freezed.dart";

enum FailureSeverity {
  /// ユーザー操作由来の想定内エラー — Crashlytics に記録しない
  expected,

  /// 予期しないエラー — Crashlytics に記録する
  unexpected,
}

/// ProviderObserver がカスタム状態からエラーを抽出するためのマーカー。
/// freezed の error variant に `@Implements<ErrorState>()` で実装させる。
///
/// Observer は [error] の型を検査し、[Failure] なら severity に基づき記録、
/// それ以外なら無条件に Crashlytics へ記録する。
abstract interface class ErrorState {
  Object get error;
  StackTrace get errorStackTrace;
}

/// UI に露出する唯一のエラー基底型。
///
/// 全 variant で [userFriendlyMessage], [severity], [cause], [causeStackTrace]
/// を共通パラメータにすることで、freezed がベースクラスにゲッターを自動生成する。
///
/// [cause] は元となるエラー。UI 層では絶対に扱わない。
@freezed
sealed class Failure with _$Failure implements Exception {
  const Failure._();

  // --- Auth ---
  const factory Failure.auth({
    required String userFriendlyMessage,
    required FailureSeverity severity,
    Object? cause,
    StackTrace? causeStackTrace,
  }) = AuthFailure;

  // --- Firestore ---
  const factory Failure.firestoreRead({
    @Default("データの読み込みに失敗しました") String userFriendlyMessage,
    @Default(FailureSeverity.unexpected) FailureSeverity severity,
    Object? cause,
    StackTrace? causeStackTrace,
  }) = FirestoreReadFailure;

  const factory Failure.firestoreWrite({
    @Default("データの保存に失敗しました") String userFriendlyMessage,
    @Default(FailureSeverity.unexpected) FailureSeverity severity,
    Object? cause,
    StackTrace? causeStackTrace,
  }) = FirestoreWriteFailure;

  const factory Failure.firestorePermissionDenied({
    @Default("アクセス権限がありません。サインインし直してください。")
    String userFriendlyMessage,
    @Default(FailureSeverity.expected) FailureSeverity severity,
    Object? cause,
    StackTrace? causeStackTrace,
  }) = FirestorePermissionDeniedFailure;

  // --- Google Tasks ---
  const factory Failure.tasksAuth({
    required String userFriendlyMessage,
    required FailureSeverity severity,
    Object? cause,
    StackTrace? causeStackTrace,
  }) = TasksAuthFailure;

  const factory Failure.tasksOperation({
    required String userFriendlyMessage,
    required FailureSeverity severity,
    Object? cause,
    StackTrace? causeStackTrace,
  }) = TasksOperationFailure;

  // --- Generic ---
  const factory Failure.unexpected({
    @Default("エラーが発生しました") String userFriendlyMessage,
    @Default(FailureSeverity.unexpected) FailureSeverity severity,
    Object? cause,
    StackTrace? causeStackTrace,
  }) = UnexpectedFailure;

  @override
  String toString() => "$runtimeType: $userFriendlyMessage";
}
