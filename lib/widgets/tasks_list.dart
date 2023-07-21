import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../widgets/task_item.dart';

class NewTasksList extends StatelessWidget {
  const NewTasksList({super.key, required this.newTasks});
  final List<Task> newTasks;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...newTasks.map((e) => TaskItem(task: e)),
      ],
    );
  }
}

//------------------------------------------------------------------------------

class CompletedTasksList extends StatefulWidget {
  const CompletedTasksList({super.key, required this.completedTasks});
  final List<Task> completedTasks;

  @override
  State<CompletedTasksList> createState() => _CompletedTasksListState();
}

class _CompletedTasksListState extends State<CompletedTasksList> {
  bool isVisable = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              isVisable = !isVisable;
            });
          },
          icon: Icon(
            isVisable ? Icons.arrow_drop_down : Icons.arrow_right,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          label: Text(
            'Completed ${widget.completedTasks.length}',
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.background.withOpacity(0.95),
          ),
        ),
        const SizedBox(height: 5),
        if (isVisable) ...widget.completedTasks.map((e) => TaskItem(task: e)),
      ],
    );
  }
}
