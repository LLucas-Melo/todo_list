import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do/src/cubit/repositories/board_repository.dart';

import 'package:to_do/src/cubit/repositories/isar/isar_board_repository.dart';
import 'package:to_do/src/cubit/repositories/isar/isar_datasource.dart';
import 'package:to_do/src/cubit/repositories/isar/task_model.dart';
import 'package:to_do/src/models/task.dart';

class IsarDataSourcemock extends Mock implements IsarDataSource {}

void main() {
  late IsarDataSource dataSource;
  late BoardRepository repository;
  setUp(() {
    dataSource = IsarDataSourcemock();
    repository = IsarBoardRepository(dataSource);
  });

  test('fetch', () async {
    when(() => dataSource.getTasks()).thenAnswer((_) async => [
          TaskModel()..id = 1,
        ]);

    final tasks = await repository.fetch();
    expect(tasks.length, 1);
  });

  test('Update', () async {
    when(() => dataSource.deletAllTasks()).thenAnswer((_) async => []);
    when(() => dataSource.putAllTask(any())).thenAnswer((_) async => []);

    final tasks = await repository.update(
        [const Task(id: -1, description: ''), Task(id: 2, description: '')]);
    expect(tasks.length, 2);
  });
}
