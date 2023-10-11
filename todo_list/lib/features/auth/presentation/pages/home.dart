import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:todo_list/features/auth/presentation/pages/login.dart';
import 'package:todo_list/features/auth/todo/domain/models/add_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthBloc _authBloc;
  late TodoBloc _todoBloc;
  late bool istrue = false;

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
                        key: Key(item.id),
                        onDismissed: (direction) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$item deleted')));
                        },
                        background: Container(color: Colors.red),
                        child: SizedBox(
                          height: 40,
                          width: 300,
                          child: Card(
                            child: 
                            Text(item.title)),
                        ));
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

  Widget _buildTodoItems(String title) {
    return SizedBox(
      width: 100,
      child: Card(
        child: ListTile(
          title: Text(title),
        ),
      ),
    );
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
}
