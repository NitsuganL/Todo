import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/features/auth/todo/data/repository/todo_repository.dart';
import 'package:todo_list/features/auth/todo/domain/models/add_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/create_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/delete.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/update_todo.models.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(TodoRepository todoRepository) : super(TodoState.initial()) {
    on<AddTodoEvent>((event, emit) async {
      final Either<String, String> result =
          await todoRepository.addTaskRepo(event.addtodoModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));

        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (todoId) {
        final currentTodoList = state.todoList;
        emit(state.copyWith(stateStatus: StateStatus.loaded, todoList: [
          ...currentTodoList,
          TodoModel(id: todoId, title: event.addtodoModel.title)
        ]));
      });
    });
    on<UpdateTodoEvent>((event, emit) async {
      final Either<String, String> result =
          await todoRepository.updateTaskRepo(event.updateTodoModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
      }, (todoId) {
        final currentTodoList = state.todoList;
        emit(state.copyWith(stateStatus: StateStatus.loaded, todoList: [
          ...currentTodoList,
          //Kuwangan
        ]));
      });
    });

    on<DeleteTodoEvent>((event, emit) async {
      final Either<String, Unit> result =
          await todoRepository.deleteTaskRepo(event.deleteTaskModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));

        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (success) {
        final currentDeleteList = state.todoList;
        currentDeleteList.removeWhere((TodoModel e) => e.id == event.deleteTaskModel.id);
        emit(state.copyWith(
          stateStatus: StateStatus.loaded,
          todoList: [
            ...currentDeleteList,
          ],
        ));
      });
    });

    // on<UpdateTodoEvent>((event, emit) async {
    //   final Either<String, TodoModel1> result =
    //       await todoRepository.updateTaskRepo(event.id, event.todoModel);

    //   result.fold((error) {
    //     emit(state.copyWith(
    //         stateStatus: StateStatus.error, errorMessage: error));

    //     emit(state.copyWith(stateStatus: StateStatus.loaded));
    //   }, (todoModel) {
    //     emit(state.copyWith(
    //         stateStatus: StateStatus.loaded, todoModel: todoModel));
    //   });
    // });
  }
}
