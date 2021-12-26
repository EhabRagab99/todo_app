import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_last_december/todo_cubit/cubit.dart';
import 'package:todo_last_december/todo_cubit/states.dart';
import 'package:todo_last_december/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<BottomNavigationBarItem> bottomNavItList = [
    BottomNavigationBarItem(
      icon: Icon(Icons.menu),
      label: 'Tasks',
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.archive_outlined), label: 'Archived Tasks'),
    BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_outline), label: 'Done Tasks'),
  ];

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener:(context, state){

      },

      builder: (context, state)=> Scaffold(
        key: scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: Icon(cubit.fabIcon),
          onPressed: () {
            if (cubit.isBottomSheet) {
              if (formKey.currentState.validate()) {
                cubit.insertIntoDatabase(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text);
                // insertIntoDatabase(
                //         title: titleController.text,
                //         time: timeController.text,
                //         date: dateController.text)
                //     .then((value) {
                //   getDataFromDatabase(database).then((value) {
                //     Navigator.pop(context);
                //     // setState(() {
                //     //   isBottomSheet = false;
                //     //   fabIcon = Icons.edit;
                //     //   tasks = value;
                //     //   print(tasks);
                //     // });
                //   });
                // });
              }
            } else {
              scaffoldKey.currentState
                  .showBottomSheet(
                    (context) => Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            child: ReusableTextField(
                              valid: (String val) {
                                if (val.isEmpty)
                                  return 'Title must be entered';
                                else
                                  return null;
                              },
                              textController: titleController,
                              prefIcon: Icon(Icons.title),
                              label: 'Enter Task Name',
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            elevation: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: ReusableTextField(
                              valid: (String val) {
                                if (val.isEmpty)
                                  return 'Time must be entered!!';
                                else
                                  return null;
                              },
                              textController: timeController,
                              prefIcon: Icon(Icons.watch_later_outlined),
                              label: 'Enter Task Time',
                              onTapping: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text =
                                      value.format(context).toString();
                                  print(value.format(context));
                                });
                              },
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            elevation: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: ReusableTextField(
                              valid: (String val) {
                                if (val.isEmpty)
                                  return 'Date must be entered';
                                else
                                  return null;
                              },
                              textController: dateController,
                              prefIcon: Icon(Icons.calendar_today),
                              label: 'Enter Task Date!!!',
                              onTapping: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-05-03'),
                                ).then((value) {
                                  dateController.text = DateFormat.yMMMd()
                                      .format(value)
                                      .toString();
                                  print(DateFormat.yMMMd().format(value));
                                });
                              },
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            elevation: 5,
                          ),
                        ],
                      ),
                    ),
                  )
                  .closed
                  .then((value) {
                cubit.changeBottomState(isShow: false, icon: Icons.edit);
              });
              cubit.changeBottomState(isShow: true, icon: Icons.add);
            }
          },
        ),
        appBar: AppBar(
          title: Text(cubit.titlesList[cubit.currentScreenIndex]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavItList,
          selectedItemColor: Colors.deepPurple,
          currentIndex: cubit.currentScreenIndex,
          onTap: (index) {
            cubit.changeIndex(index);
          },
        ),
        body: cubit.widgetsList[cubit.currentScreenIndex],
      ),
    );
  }
}
