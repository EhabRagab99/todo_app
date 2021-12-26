import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_last_december/screens/archived_tasks_screen.dart';
import 'package:todo_last_december/screens/done_tasks_screen.dart';
import 'package:todo_last_december/screens/tasks_screen.dart';
import 'package:todo_last_december/todo_cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentScreenIndex = 0;
  Database database;
  bool isBottomSheet = false;
  IconData fabIcon = Icons.edit;
  List<Map> tasks = [];

  List<String> titlesList = [
    'Tasks',
    'Archived Tasks',
    'Done Tasks',
  ];
  List<Widget> widgetsList = [
    TasksScreen(),
    ArchivedTasksScreen(),
    DoneTasksScreen(),
  ];

  void changeIndex(int index) {
    currentScreenIndex = index;
    emit(ChangeNavBarItem());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE Table tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) => print('table created'))
          .catchError((onError) =>
              print('error when creating database ${onError.toString()}'));
    }, onOpen: (database) {
      print('database is opened !!');
    }).then((value) {
      database = value;
      emit(AppCreateDbState());
    });
  }

  insertIntoDatabase(
      {@required String title,
      @required String time,
      @required String date}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDbState());
        getDataFromDatabase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDbState());
        });
      }).catchError((onError) {
        print('error when inserting into database ${onError.toString()}');
      });
      return null;
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    emit(AppGetDbLoadingState());
    return await database.rawQuery('SELECT * FROM tasks');
  }

  void updateDate({
    @required String status,
    @required int id,
  }) async {
    return database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      emit(AppUpdateDbState());
    });
  }

  void changeBottomState({@required bool isShow, @required IconData icon}) {
    isBottomSheet = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheet());
  }
}
