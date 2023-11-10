part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final AddTodoModel addtodoModel;

  AddTodoEvent({
    required this.addtodoModel,
  });
}

class UpdateTodoEvent extends TodoEvent {
  final UpdateTodoModel updateTodoModel;

  UpdateTodoEvent({
    required this.updateTodoModel,
  });
}

class DeleteTodoEvent extends TodoEvent {
  final DeleteTaskModel deleteTaskModel;

  DeleteTodoEvent({
    required this.deleteTaskModel,
  });
}

class GetTodoEvent extends TodoEvent {}

class CheckedEvent extends TodoEvent {
  final CheckTodoModel checkTodoModel;

  CheckedEvent({
    required this.checkTodoModel
  });
}
