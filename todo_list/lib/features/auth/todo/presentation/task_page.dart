// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todo_list/features/auth/todo/domain/models/todo.models.dart';
// import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';

// class TaskPage extends StatefulWidget {
//   const TaskPage({super.key});

//   @override
//   State<TaskPage> createState() => _TaskPageState();
// }

// class _TaskPageState extends State<TaskPage> {
//   late TodoBloc _todoBloc;
//   final List<String> todoList = <String>[];

//   final TextEditingController _titleController = TextEditingController();

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _todoBloc = BlocProvider.of<TodoBloc>(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const SizedBox(),
//         title: const Text('Home'),
//       ),
//       body: BlocConsumer<TodoBloc, TodoState>(
//         bloc: _todoBloc,
//         listener: (context, state) {
//           // TODO: implement listener
//         },
//         builder: (context, state) {
//           return ListView(children: [
//             ...todoList.map((e) {
//               return const Column(
//                 children: [
//                   ListTile(
//                     title: Text('data'),
//                     subtitle: Text('data'),
//                   )
//                 ],
//               );
//             }),
//             TextField(
//               controller: _titleController,
//               autofocus: true,
//               minLines: 3,
//               maxLines: 15,
//               decoration: const InputDecoration(hintText: 'Title'),
//             ),
//             const SizedBox(
//               width: 40,
//               height: 50,
//             ),
//             ElevatedButton(
//               child: const Text('ADD'),
//               onPressed: () {
//                 _addTask(context);
//                 // Navigator.of(context).pop();
//               },
//             ),
//             const SizedBox(
//               width: 40,
//               height: 50,
//             ),
//             ElevatedButton(
//               child: const Text('CANCEL'),
//               onPressed: () {
//                 // Navigator.of(context).pop();
//               },
//             )
//           ]);
//         },
//       ),
//     );
//   }

//   void _addTask(BuildContext context) {
//     _todoBloc
//         .add(AddTodoEvent(todoModel: TodoModel1(title: _titleController.text)));
//   }
// }
