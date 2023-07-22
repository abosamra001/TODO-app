import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/constants/const.dart';

import '../models/task_model.dart';
import '../widgets/tasks_list.dart';

class AllTasksScreen extends StatelessWidget {
  AllTasksScreen({super.key, required this.sortFunction});
  final int Function(Task a, Task b) sortFunction;
  final completedTasksBox = Hive.box<Task>(kCompletedTasksBox);

  final newTasksBox = Hive.box<Task>(kNewTasksBox);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(kSettingsBox).listenable(),
      builder: (context, settings, _) {
        final int drawerIndex = settings.get('drawerIndex', defaultValue: 2);
        final index = settings.get('background$drawerIndex', defaultValue: 8);
        return Container(
          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 80),
          width: double.infinity,
          height: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background$index.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Tasks',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ValueListenableBuilder(
                    valueListenable: newTasksBox.listenable(),
                    builder: (context, newTasks, _) {
                      return NewTasksList(
                        newTasks: newTasks.values.toList()..sort(sortFunction),
                      );
                    },
                  ),
                  if (completedTasksBox.isNotEmpty)
                    ValueListenableBuilder(
                      valueListenable: completedTasksBox.listenable(),
                      builder: (context, completed, _) {
                        final comtasks = completed.values.toList()
                          ..sort(sortFunction);
                        return CompletedTasksList(completedTasks: comtasks);
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
