import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:to_do/src/cubit/repositories/board_repository.dart';
import 'package:to_do/src/models/task.dart';
import 'package:to_do/src/states/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;
  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTask() async {
    emit(LoadingBoardState());
    try {
      final tasks = await repository.fetch();
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailBoardState(menssagem: 'error'));
    }
  }

  Future<void> addTask(Task newTask) async {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return;
    }

    final tasks = state.tasks.toList();
    tasks.add(newTask);

    try {
      // Certifique-se de que o método update seja assíncrono se estiver utilizando await
      await repository.update(tasks);
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailBoardState(menssagem: 'error'));
    }
  }

  Future<void> removeTask(Task newTask) async {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return;
    }
    final tasks = state.tasks.toList();
    tasks.remove(newTask);
    try {
      await repository.update(tasks);
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailBoardState(menssagem: 'error'));
    }
  }

  Future<void> checkTask(Task newTask) async {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return;
    }
    final tasks = state.tasks.toList();
    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check);

    try {
      await repository.update(tasks);
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailBoardState(menssagem: 'error'));
    }
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTaskBoardState(tasks: tasks));
  }
}
