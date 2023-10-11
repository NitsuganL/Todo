part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final AddTodoModel addtodoModel;

  AddTodoEvent({required this.addtodoModel});
}

class UpdateTodoEvent extends TodoEvent {
  final String id;
  final TodoModel1 todoModel;

  UpdateTodoEvent({required this.id, required this.todoModel});
}

class DeleteTodoEvent extends TodoEvent {
  final TodoModel1 todoModel;

  DeleteTodoEvent({required this.todoModel});
}
