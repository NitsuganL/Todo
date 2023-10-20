import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:todo_list/features/auth/presentation/pages/login.dart';
import 'package:todo_list/features/auth/todo/domain/models/add_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/delete.model.dart';
import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';
import 'package:todo_list/features/auth/todo/presentation/todo_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthBloc _authBloc;
  late TodoBloc _todoBloc;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _todoBloc = BlocProvider.of<TodoBloc>(context);
    _todoBloc.add(GetTodoEvent());
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

        return BlocConsumer<TodoBloc, TodoState>(
          bloc: _todoBloc,
          listener: _todoListener,
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                appBar: AppBar(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  actions: <Widget>[
                    IconButton(
                        onPressed: _logout, icon: const Icon(Icons.logout))
                  ],
                ),
                body: ListView.builder(
                  itemCount: state.todoList.length,
                  itemBuilder: (context, index) {
                    final item = state.todoList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Confirmation!'),
                              content: Text(
                                  'Are you sure you want to delete ${item.title}?'),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                      _deleteTask(context, item.id);
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('${item.title} deleted'),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: const Text('Delete')),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'))
                              ],
                            );
                          },
                        );
                        // _displayConfirmDelete(context, item.title, item.id);
                      },
                      background: Container(
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Icon(Icons.delete), Text('Delete')],
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: _todoBloc,
                                child: MyFormPage(
                                  todoModel: item,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(item.title),
                            subtitle: Text(item.description),
                            trailing: Checkbox(
                                value: item.isChecked,
                                onChanged: (bool? newIsChecked) {
                                  item.isChecked = newIsChecked!;
                                  _checkListener(newIsChecked);
                                }),
                          ),
                        ),
                      ),
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

  void _checkListener(bool isChecked) {
    _todoBloc.add(CheckedEvent());
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
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _titleController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal()),
                        labelText: 'Title'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _descriptionController,
                      autofocus: true,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal()),
                          labelText: 'Description'),
                    ),
                  ),
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
                  _descriptionController.clear();
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
        addtodoModel: AddTodoModel(
            title: _titleController.text,
            description: _descriptionController.text),
      ),
    );
  }

  void _deleteTask(BuildContext context, String id) {
    _todoBloc.add(
      DeleteTodoEvent(
        deleteTaskModel: DeleteTaskModel(id: id),
      ),
    );
  }

  // void _displayConfirmDelete(
  //     BuildContext context, String title, String id) async {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Delete Confirmation'),
  //         content: Text('Are you sure you want to delete $title?'),
  //         actions: <Widget>[
  //           ElevatedButton(
  //               onPressed: () {
  //                 _deleteTask(context, id);
  //                 Navigator.of(context).pop();
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text('$title deleted'),
  //                     duration: const Duration(seconds: 2),
  //                   ),
  //                 );
  //               },
  //               child: const Text('Delete')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('Cancel'))
  //         ],
  //       );
  //     },
  //   );
  // }
}
