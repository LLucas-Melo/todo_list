import 'package:to_do/src/models/task.dart';

abstract class BoardRepository {
  Future<List<Task>> fetch();
  Future<List<Task>> update(List<Task> tasks);
}
