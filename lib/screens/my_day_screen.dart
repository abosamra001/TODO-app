import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todo/constants/const.dart';

import '../models/task_model.dart';
import '../widgets/tasks_list.dart';

class MyDayScreen extends StatelessWidget {
  MyDayScreen({super.key, required this.sortFunction});
  final int Function(Task a, Task b) sortFunction;
  final completedTasksBox = Hive.box<Task>(kCompletedTasksBox);

  final newTasksBox = Hive.box<Task>(kNewTasksBox);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(kSettingsBox).listenable(),
      builder: (context, settings, _) {
        final int drawerIndex = settings.get('drawerIndex');
        final index = settings.get('background$drawerIndex');
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
              child: ValueListenableBuilder(
                valueListenable: completedTasksBox.listenable(),
                builder: (context, c, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Day',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                        Text(
                          DateFormat.MMMMEEEEd().format(DateTime.now()),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ValueListenableBuilder(
                      valueListenable: newTasksBox.listenable(),
                      builder: (context, newTasks, _) {
                        final tasks = newTasks.values
                            .where((element) =>
                                element.createdAt.day == DateTime.now().day)
                            .toList()
                          ..sort(sortFunction);
                        return NewTasksList(newTasks: tasks);
                      },
                    ),
                    if (completedTasksBox.isNotEmpty)
                      ValueListenableBuilder(
                        valueListenable: completedTasksBox.listenable(),
                        builder: (context, completed, _) {
                          final comtasks = completed.values
                              .where((element) =>
                                  element.createdAt.day == DateTime.now().day)
                              .toList()
                            ..sort(sortFunction);
                          return CompletedTasksList(completedTasks: comtasks);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
