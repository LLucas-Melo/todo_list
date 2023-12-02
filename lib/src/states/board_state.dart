// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:to_do/src/models/task.dart';

sealed class BoardState {}

class LoadingBoardState implements BoardState {}

class GettedTaskBoardState implements BoardState {
  final List<Task> tasks;

  GettedTaskBoardState({required this.tasks});
}

class EmptyBoardState extends GettedTaskBoardState {
  EmptyBoardState() : super(tasks: []);
}

class SucessBoardState implements BoardState {}

class FailBoardState implements BoardState {
  final String menssagem;
  FailBoardState({
    required this.menssagem,
  });
}
