// ignore_for_file: must_be_immutable

part of 'todo_bloc.dart';

@immutable
class TodoState {
  final List<TodoModel> todoList;
  final StateStatus stateStatus;
  final String? errorMessage;
  bool? isDone;
  bool? isDeleted;

  TodoState(
      {required this.todoList,
      required this.stateStatus,
      this.errorMessage,
      this.isDone,
      this.isDeleted});

  factory TodoState.initial() =>
      TodoState(stateStatus: StateStatus.initial, todoList: const []);

  TodoState copyWith({
    List<TodoModel>? todoList,
    StateStatus? stateStatus,
    String? errorMessage,
    bool? isDone,
    bool? isDeleted,
  }) {
    return TodoState(
        todoList: todoList ?? this.todoList,
        stateStatus: stateStatus ?? this.stateStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        isDone: isDone ?? false,
        isDeleted: isDeleted ?? false);
  }
}
