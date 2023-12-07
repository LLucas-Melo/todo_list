import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do/src/cubit/board_cubit.dart';
import 'package:to_do/src/cubit/repositories/board_repository.dart';
import 'package:to_do/src/pages/board_page.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  testWidgets('board page with all taske', (tester) async {
    when(() => repository.fetch()).thenAnswer((_) async => []);
    await tester.pumpWidget(BlocProvider.value(
      value: cubit,
      child: const MaterialApp(home: BoardPage()),
    ));
    expect(find.byKey(const Key('EmpetyState')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const Key('GettedState')), findsOneWidget);
  });

  testWidgets('board page with failure state', (tester) async {
    when(() => repository.fetch()).thenThrow(Exception('Error'));
    await tester.pumpWidget(BlocProvider.value(
      value: cubit,
      child: const MaterialApp(home: BoardPage()),
    ));
    expect(find.byKey(const Key('EmpetyState')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const Key('Failure')), findsOneWidget);
  });
}
