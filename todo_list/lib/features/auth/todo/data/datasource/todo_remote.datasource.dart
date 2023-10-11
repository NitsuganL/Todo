import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_list/config.dart';
import 'package:todo_list/features/auth/todo/domain/models/add_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/todo.models.dart';

class TodoRemoteDatasource {
  late Databases _databases;

  TodoRemoteDatasource(Databases databases) {
    _databases = databases;
  }

  Future<String> addTask(AddTodoModel addtodoModel) async {
    final String taskId = ID.unique();
    final docs = await _databases.createDocument(
        databaseId: Config.userdbId,
        collectionId: Config.todoTitleID,
        documentId: taskId,
        data: {
          'id': taskId,
          'title': addtodoModel.title,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String()
        });

    return docs.$id;
  }

  Future<Unit> updateTask(String id, TodoModel1 todoModel) async {
    await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.todoTitleID,
        documentId: id,
        data: {
          'id': id,
          'title': todoModel.title,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String()
        });

    return unit;
  }

  // Future<TodoModel1> getIdTask() async {
  //   final documents = await _databases.getDocument(
  //       databaseId: Config.userdbId,
  //       collectionId: Config.todoTitleID,
  //       documentId: );

  //   //return dre kay list todo model
  //   return TodoModel1.fromJson(documents.data);
  // }

  Future<TodoModel1> deleteTask(String id) async {
    final documents = await _databases.deleteDocument(
        databaseId: Config.userdbId,
        collectionId: Config.todoTitleID,
        documentId: id);

    return TodoModel1.fromJson(documents.data);
  }
}
