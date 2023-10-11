import 'package:dartz/dartz.dart';
import 'package:todo_list/features/auth/todo/data/datasource/todo_remote.datasource.dart';
import 'package:todo_list/features/auth/todo/domain/models/add_todo.model.dart';

class TodoRepository {
  late TodoRemoteDatasource _todoRemoteDatesource;

  TodoRepository(
    TodoRemoteDatasource remoteDatasource,
  ) {
    _todoRemoteDatesource = remoteDatasource;
  }

  Future<Either<String, String>> addTaskRepo(AddTodoModel addtodoModel) async {
    try {
      final result = await _todoRemoteDatesource.addTask(addtodoModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //Each CRUD operation have it's own model
  //add task model done
  // create a model for delete and update
  //delete and update need rework

  //need rework
  // Future<Either<String, TodoModel1>> updateTaskRepo(
  //     String id, TodoModel1 todoModel) async {
  //   try {
  //     await _todoRemoteDatesource.updateTask(id, todoModel);

  //     return Right(todoModel);
  //   } catch (e) {
  //     return Left(e.toString());
  //   }
  // }

  //need rework
  // Future<Either<String, TodoModel1>> getIdRepo(String id) async {
  //   final TodoModel1 todoModel = await _todoRemoteDatesource.getIdTask(id);

  //   try {
  //     await _todoRemoteDatesource.getIdTask(id);

  //     return Right(todoModel);
  //   } catch (e) {
  //     return Left(e.toString());
  //   }
  // }

  //need rework
  // Future<Either<String, TodoModel1>> deleteTaskRepo(String id) async {
  //   final TodoModel1 todoModel = await _todoRemoteDatesource.deleteTask(id);

  //   try {
  //     await _todoRemoteDatesource.deleteTask(id);

  //     return Right(todoModel);
  //   } catch (e) {
  //     return Left(e.toString());
  //   }
  // }
}
