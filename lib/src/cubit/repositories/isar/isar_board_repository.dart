import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do/src/cubit/repositories/board_repository.dart';
import 'package:to_do/src/cubit/repositories/isar/isar_datasource.dart';
import 'package:to_do/src/cubit/repositories/isar/task_model.dart';
import 'package:to_do/src/models/task.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDataSource dataSource;
  IsarBoardRepository(this.dataSource) {}

  @override
  Future<List<Task>> fetch() async {
    final models = await dataSource.getTasks();

    return models
        .map(
          (e) => Task(id: e.id, description: e.description, check: e.check),
        )
        .toList();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) async {
    final models = tasks.map((e) {
      final model = TaskModel()
        ..check = e.check
        ..description = e.description;
      if (e.id != -1) {
        model.id = e.id;
      }
      return model;
    }).toList();
    await dataSource.deletAllTasks();
    await dataSource.putAllTask(models);

    return tasks;
  }
}
