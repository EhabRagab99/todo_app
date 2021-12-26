import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_last_december/todo_cubit/cubit.dart';
import 'package:todo_last_december/todo_cubit/states.dart';
import 'package:todo_last_december/widgets/widgets.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var tasks = AppCubit.get(context).tasks;
        return ListView.separated(
            itemBuilder: (context, index) => TasksItem(
                  map: tasks[index],
                  context: context,
                ),
            separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: Colors.grey,
                ),
            itemCount: tasks.length);
      },
    );
  }
}
