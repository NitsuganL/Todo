import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:todo_list/features/auth/presentation/pages/login.dart';
import 'package:todo_list/features/auth/todo/domain/models/add_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/delete.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/update_todo.models.dart';
import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DeleteTaskModel deleteTaskModel;
  late AuthBloc _authBloc;
  late TodoBloc _todoBloc;

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _todoBloc = BlocProvider.of<TodoBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _authListener,
      builder: (context, state) {
        if (state.stateStatus == StateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
              leading: const SizedBox(),
              title: const Text('Home'),
              actions: <Widget>[
                IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
              ],
            ),
            body: BlocConsumer<TodoBloc, TodoState>(
              bloc: _todoBloc,
              listener: _todoListener,
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.todoList.length,
                  itemBuilder: (context, index) {
                    final item = state.todoList[index];

                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.title} deleted'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        _deleteTask(context, item.id);
                      },
                      background: Container(color: Colors.red),
                      child: GestureDetector(
                        onTap: () {
                          _updateFormDialog(context);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(item.title),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _displayAddDialog(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context);
      return;
    }

    if (state.stateStatus == StateStatus.initial) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider.value(
                    value: _authBloc,
                    child: const LoginPage(),
                  )),
          ModalRoute.withName('/'));
    }
  }

  void _todoListener(BuildContext context, TodoState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context);
    }
  }

  void _logout() {
    _authBloc.add(AuthLogoutEvent());
  }

  Future _displayAddDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: Column(
              children: [
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  minLines: 3,
                  maxLines: 15,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('ADD'),
                onPressed: () {
                  _addTask(context);
                  Navigator.of(context).pop();
                  _titleController.clear();
                },
              ),
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future _updateFormDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update Task'),
            content: Column(
              children: [
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  minLines: 3,
                  maxLines: 15,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () {
                  //todo update
                  _updateTask(context);
                  Navigator.of(context).pop();
                  _titleController.clear();
                },
              ),
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _addTask(BuildContext context) {
    _todoBloc.add(
      AddTodoEvent(
        addtodoModel: AddTodoModel(title: _titleController.text),
      ),
    );
  }

  void _updateTask(BuildContext context) {
    _todoBloc.add(UpdateTodoEvent(
      updateTodoModel: UpdateTodoModel(id: '', title: _titleController.text),
    ));
  }

  void _deleteTask(BuildContext context, String id) {
    _todoBloc.add(
      DeleteTodoEvent(
        deleteTaskModel: DeleteTaskModel(id: id),
      ),
    );
  }
}
