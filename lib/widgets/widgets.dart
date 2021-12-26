import 'package:flutter/material.dart';
import 'package:todo_last_december/todo_cubit/cubit.dart';

class ReusableTextField extends StatelessWidget {
  final TextInputType kebadType;
  final Function valid;
  final TextEditingController textController;
  final Icon prefIcon;
  final String label;
  final Function onTapping;

  ReusableTextField(
      {this.kebadType,
      this.valid,
      this.textController,
      this.prefIcon,
      this.label,
      this.onTapping});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTapping,
      controller: textController,
      validator: valid,
      decoration: InputDecoration(
        prefixIcon: prefIcon,
        labelText: label,
      ),
      keyboardType: kebadType,
    );
  }
}

class TasksItem extends StatelessWidget {
  final Map map;
  final BuildContext context;
  TasksItem({this.map, this.context});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${map['time']}'),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${map['title']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${map['date']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(context).updateDate(status: 'Done', id: map['id']);
              }),
          SizedBox(
            width: 20,
          ),
          IconButton(
              icon: Icon(
                Icons.archive_outlined,
                color: Colors.red,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updateDate(status: 'Archives', id: map['id']);
              }),
        ],
      ),
    );
  }
}
