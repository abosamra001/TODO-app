import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
// import 'package:todo/constants/const.dart';

import '../widgets/task_item.dart';
import '../models/task_model.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({
    super.key,
    required this.task,
  });
  final Task task;

  @override
  Widget build(BuildContext context) {
    final String createdDate = DateFormat.MMMMEEEEd().format(task.createdAt);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 30,
      ),
      child: Column(
        children: [
          TaskItem(
            task: task,
            enabled: false,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 50, 50, 50),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.alarm),
                  title: Text('Remind me'),
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text('Add due date'),
                  shape: UnderlineInputBorder(),
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: Icon(Icons.repeat),
                  title: Text('Repeat'),
                ),
              ],
            ),
          ),
          Text(
            'Created on $createdDate',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // if (Hive.box<Task>(kFavoriteTasksBox).containsKey(task.id)) {
              //   Hive.box<Task>(kFavoriteTasksBox).delete(task.id);
              // }
              task.delete();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Colors.white),
          )
        ],
      ),
    );
  }
}
