import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do/src/cubit/board_cubit.dart';
import 'package:to_do/src/cubit/repositories/board_repository.dart';
import 'package:to_do/src/models/task.dart';
import 'package:to_do/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  group('fetchTask |', () {
    test('should take all task', () async {
      when(() => repository.fetch()).thenAnswer(
        (_) async => [
          Task(id: 1, description: '', check: false),
        ],
      );
      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<GettedTaskBoardState>(),
        ]),
      );
      await cubit.fetchTask();
    });

    test('should return an error', () async {
      when(() => repository.fetch()).thenThrow(Exception('error'));

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<LoadingBoardState>(),
            isA<FailBoardState>(),
          ],
        ),
      );
      await cubit.fetchTask();
    });
  });

  group('add Task |', () {
    test('should add new task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      expect(cubit.stream, emitsInOrder([isA<GettedTaskBoardState>()]));

      final task = Task(id: 1, description: '');
      await cubit.addTask(task);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks, [task]);
    });
    test('should return an error', () async {
      when(() => repository.update(any())).thenThrow(Exception('error'));

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailBoardState>(),
          ],
        ),
      );
      final task = Task(
        id: 1,
        description: '',
      );
      await cubit.addTask(task);
    });
  });

  group(' Remove a task |', () {
    test('should remove a task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      const tasks = Task(id: 1, description: '');
      cubit.addTasks([tasks]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      await cubit.removeTask(tasks);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks.length, 0);
    });
    test('should return an error', () async {
      when(() => repository.update(any())).thenThrow(Exception('error'));
      final task = Task(id: 1, description: '');
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailBoardState>(),
          ],
        ),
      );

      await cubit.removeTask(task);
    });
  });

  group(' check a task |', () {
    test('should check a task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      const task = Task(id: 1, description: '');
      cubit.addTasks([task]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
      expect((cubit.state as GettedTaskBoardState).tasks.first.check, false);
      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      await cubit.checkTask(task);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks.first.check, true);
    });
    test('should return an error', () async {
      when(() => repository.update(any())).thenThrow(Exception('error'));
      final task = Task(id: 1, description: '');
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailBoardState>(),
          ],
        ),
      );

      await cubit.checkTask(task);
    });
  });
}
