import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:todo_list/features/auth/presentation/pages/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();

    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _authListener,
      builder: (context, state) {
        if(state.stateStatus == StateStatus.loading){
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
        body: ListView(
          children: [
            Card(
              child: Row(
                children: [
                  const Text('TODO1'),
                  Checkbox(value: false, onChanged: (bool? val) {})
                ],
              ),
            ),
            Card(
              child: Row(
                children: [
                  const Text('TODO2'),
                  Checkbox(value: false, onChanged: (bool? val) {})
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
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

  void _logout() {
    _authBloc.add(AuthLogoutEvent());
  }
}
