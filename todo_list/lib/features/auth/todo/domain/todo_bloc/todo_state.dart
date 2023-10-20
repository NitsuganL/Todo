// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

part of 'todo_bloc.dart';

@immutable
class TodoState {
  final List<TodoModel> todoList;
  final StateStatus stateStatus;
  final String? errorMessage;
  bool? isChecked;

  TodoState({
    required this.todoList,
    required this.stateStatus,
    this.errorMessage,
    this.isChecked,
  });

  factory TodoState.initial() =>
      TodoState(stateStatus: StateStatus.initial, todoList: const []);

  TodoState copyWith({
    List<TodoModel>? todoList,
    StateStatus? stateStatus,
    String? errorMessage,
    bool? isChecked,
  }) {
    return TodoState(
      todoList: todoList ?? this.todoList,
      stateStatus: stateStatus ?? this.stateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isChecked: isChecked ?? false
    );
  }
}
