import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do/src/cubit/repositories/isar/task_model.dart';

class IsarDataSource {
  Isar? _isar;

  Future<Isar> _getInstance() async {
    if (_isar != null) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TaskModelSchema],
      directory: dir.path,
    );

    return _isar!;
  }

  Future<List<TaskModel>> getTasks() async {
    final isar = await _getInstance();
    return await isar.taskModels.where().findAll();
  }

  Future<void> deletAllTasks() async {
    final isar = await _getInstance();
    await isar.writeTxn(() async {
      return isar.taskModels.where().deleteAll(); // insert & update
    });
  }

  Future<void> putAllTask(List<TaskModel> model) async {
    final isar = await _getInstance();
    await isar.writeTxn(() async {
      return isar.taskModels.putAll(model); // insert & update
    });
  }
}
