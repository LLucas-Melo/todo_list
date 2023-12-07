import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/src/cubit/board_cubit.dart';
import 'package:to_do/src/models/task.dart';
import 'package:to_do/src/states/board_state.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BoardCubit>().fetchTasks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BoardCubit>();
    final state = cubit.state;
    Widget body = Container();

    if (state is EmptyBoardState) {
      print('aqui esta vazio');
      body = const Center(
        key: Key('EmpetyState'),
        child: Text('insert a new task'),
      );
    } else if (state is GettedTaskBoardState) {
      final tasks = state.tasks;
      print('aqui esta pegando o estado');
      body = ListView.builder(
        key: const Key('GettedState'),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onLongPress: () {
              cubit.removeTask(task);
            },
            child: CheckboxListTile(
                value: task.check,
                title: Text(task.description),
                onChanged: (value) {
                  cubit.checkTask(task);
                }),
          );
        },
      );
    } else if (state is FailBoardState) {
      print('aqui esta erro');
      body = const Center(
        key: const Key('Failure'),
        child: Text('Unable to complete tasks'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void addTaskDialog(BuildContext context) {
  var description = '';
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('exit')),
            TextButton(
                onPressed: () {
                  final task = Task(id: -1, description: description);
                  context.read<BoardCubit>().addTask(task);
                  Navigator.pop(context);
                },
                child: Text('Add task')),
          ],
          title: Text('Add New Task'),
          content: TextField(
            onChanged: (value) => description = value,
          ),
        );
      });
}
