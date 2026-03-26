
class TasksOperationException implements Exception {
  final TasksOperationErrorCode code;

  const TasksOperationException(this.code);
}

enum TasksOperationErrorCode {
  taskListDoesNotExist("タスクリストが見つかりません。Tasksアプリでタスクリストを作成してください。"),
  unknown("不明なエラーが発生しました。"),
  ;

  final String userFriendlyMessage;

  const TasksOperationErrorCode(this.userFriendlyMessage);
}
