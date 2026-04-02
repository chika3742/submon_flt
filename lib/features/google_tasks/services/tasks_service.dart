import "package:googleapis/tasks/v1.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../models/tasks_operation_exception.dart";
import "../repositories/tasks_auth_notifier.dart";

part "tasks_service.g.dart";

abstract interface class TasksService {
  final TasksApi _api;

  const TasksService(this._api);

  Future<String> addTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String taskId);
}

@riverpod
TasksService? tasksService(Ref ref) {
  final authClient = ref.watch(tasksAuthProvider).value;
  if (authClient == null) return null;
  return TaskServiceImpl(TasksApi(authClient));
}

class TaskServiceImpl extends TasksService {
  const TaskServiceImpl(super._api);

  Future<TaskList> taskList() async {
    final taskLists = await _api.tasklists.list(maxResults: 1);
    if (taskLists case TaskLists(items: [final taskList])) {
      return taskList;
    }
    throw const TasksOperationException(
      TasksOperationErrorCode.taskListDoesNotExist,
    );
  }

  @override
  Future<String> addTask(Task task) async {
    final tasklist = await taskList();
    final createdTask = await _api.tasks.insert(task, tasklist.id!);
    return createdTask.id!;
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasklist = await taskList();

    await _api.tasks.update(task, tasklist.id!, task.id!);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final tasklist = await taskList();

    await _api.tasks.delete(tasklist.id!, taskId);
  }
}
