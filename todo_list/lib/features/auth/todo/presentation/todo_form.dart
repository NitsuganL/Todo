import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/dependency_injection/di_container.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:todo_list/features/auth/presentation/pages/home.dart';
import 'package:todo_list/features/auth/todo/domain/models/create_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/update_todo.models.dart';
import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';

class MyFormPage extends StatefulWidget {
  const MyFormPage({super.key, required this.todoModel});
  final TodoModel todoModel;

  @override
  State<MyFormPage> createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final DIContainer diContainer = DIContainer();

  late TextEditingController _updatedId;
  late TextEditingController _updateTitleController;
  late TextEditingController _updateDescriptionController;
  late TodoBloc _todoBloc;

  @override
  void initState() {
    super.initState();
    _todoBloc = BlocProvider.of<TodoBloc>(context);
    widget.todoModel;
    _updateTitleController =
        TextEditingController(text: widget.todoModel.title);
    _updateDescriptionController =
        TextEditingController(text: widget.todoModel.description);
    _updatedId = TextEditingController(text: widget.todoModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(height: 10,width: 10, child: Icon(Icons.update)),
        title: const Text('Update Task'),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        bloc: _todoBloc,
        listener: _todoListener,
        builder: (context, state) {
          return Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: SizedBox(
                    width: 600,
                    child: TextField(
                      controller: _updateTitleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal()),
                            labelText: 'Title'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: SizedBox(
                    width: 600,
                    child: TextField(
                      controller: _updateDescriptionController,
                      autofocus: true,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal()),
                            labelText: 'Description'),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: ElevatedButton(
                            onPressed: () {
                              _updateTask(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${_updateTitleController.text} successfully updated'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MultiBlocProvider(providers: [
                                            BlocProvider<AuthBloc>(
                                                create:
                                                    (BuildContext context) =>
                                                        diContainer.authBloc),
                                            BlocProvider<TodoBloc>(
                                                create:
                                                    (BuildContext context) =>
                                                        diContainer.todoBloc)
                                          ], child: const HomePage())),
                                  ModalRoute.withName('/'));
                            },
                            child: const Text('Update')),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            }, child: const Text('Cancel')),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _todoListener(BuildContext context, TodoState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context);
      return;
    }
  }

  void _updateTask(BuildContext context) {
    _todoBloc.add(
      UpdateTodoEvent(
        updateTodoModel: UpdateTodoModel(
            id: _updatedId.text,
            title: _updateTitleController.text,
            description: _updateDescriptionController.text),
      ),
    );
  }
}
