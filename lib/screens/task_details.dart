import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/task_item.dart';
import '../models/task_model.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({
    super.key,
    required this.task,
  });
  final Task task;

  String formatDueToDate(DateTime dueto) {
    if (dueto.day == DateTime.now().day) {
      return 'Due To: My Day';
    } else if (dueto.day == DateTime.now().day + 1) {
      return 'Due To: Tomorrow';
    } else {
      return DateFormat.MMMMEEEEd().format(dueto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String createdDate = DateFormat.MMMMEEEEd().format(task.createdAt);
    final String dueToDate = formatDueToDate(task.dueToDate);
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
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.alarm),
                  title: Text('Remind me'),
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(dueToDate),
                  shape: const UnderlineInputBorder(),
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                const ListTile(
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
