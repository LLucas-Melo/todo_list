import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:to_do/src/cubit/repositories/board_repository.dart';
import 'package:to_do/src/models/task.dart';
import 'package:to_do/src/states/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;
  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    emit(LoadingBoardState());
    try {
      final tasks = await repository.fetch();
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailBoardState(menssagem: 'error'));
    }
  }

  Future<void> addTask(Task newTask) async {
    final tasks = _getTask();
    if (tasks == null) return;
    tasks.add(newTask);

    await emiteTasks(tasks);
  }

  Future<void> removeTask(Task newTask) async {
    final tasks = _getTask();
    if (tasks == null) return;
    tasks.remove(newTask);
    await emiteTasks(tasks);
  }

  Future<void> checkTask(Task newTask) async {
    final tasks = _getTask();
    if (tasks == null) return;
    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check);

    await emiteTasks(tasks);
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTaskBoardState(tasks: tasks));
  }

  List<Task>? _getTask() {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return null;
    }
    return state.tasks.toList();
  }

  Future<void> emiteTasks(List<Task> tasks) async {
    try {
      await repository.update(
          tasks); // Certifique-se de que o método update seja assíncrono se estiver utilizando await
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailBoardState(menssagem: 'error'));
    }
  }
}
