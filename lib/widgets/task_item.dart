import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/constants/const.dart';

import '../models/task_model.dart';
import '../screens/task_details.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
    this.enabled = true,
  });
  final Task task;
  final bool enabled;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final newTasksBox = Hive.box<Task>(kNewTasksBox);
  final completedTasksBox = Hive.box<Task>(kCompletedTasksBox);
  // final favTasksBox = Hive.box<Task>(kFavoriteTasksBox);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: widget.enabled
            ? Theme.of(context).colorScheme.background
            : const Color.fromARGB(255, 50, 50, 50),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        enabled: widget.enabled,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => TaskDetails(task: widget.task),
          );
        },
        leading: Checkbox(
          value: widget.task.done ?? false,
          onChanged: (val) {
            debugPrint('=============== id :  ${widget.task.id}');
            setState(() {
              widget.task.done = val!;
            });
            if (newTasksBox.containsKey(widget.task.id)) {
              newTasksBox.delete(widget.task.id);
            }
            if (completedTasksBox.containsKey(widget.task.id)) {
              completedTasksBox.delete(widget.task.id);
            }
            // if (favTasksBox.containsKey(widget.task.copy.id)) {
            //   favTasksBox.delete(widget.task.copy.id);
            // }

            if (val!) {
              completedTasksBox.put(widget.task.id, widget.task);
            } else {
              newTasksBox.put(widget.task.id, widget.task);
              // if (widget.task.isFav!) {
              //   favTasksBox.put(
              //     widget.task.copy.id,
              //     widget.task.copy..isFav = true,
              //   );
              // }
            }
          },
          shape: const CircleBorder(),
          activeColor: Colors.grey,
          side: BorderSide(
            color: Theme.of(context).colorScheme.onBackground.withAlpha(180),
            width: 2,
          ),
        ),
        title: Text(
          widget.task.title,
          style: widget.task.done ?? false
              ? const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 1,
                )
              : TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
        ),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              widget.task.isFav = !widget.task.isFav!;
            });
            newTasksBox.delete(widget.task.id);

            newTasksBox.put(widget.task.id, widget.task);

            // if (widget.task.isFav! && !widget.task.done!) {
            //   favTasksBox.put(
            //     widget.task.copy.id,
            //     widget.task.copy..isFav = true,
            //   );
            // } else {
            //   favTasksBox.delete(widget.task.copy.id);
            // }
          },
          icon: Icon(
            Icons.star,
            color: widget.task.isFav ?? false ? Colors.amber : Colors.grey,
            key: ValueKey(widget.task.id),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        horizontalTitleGap: 1.0,
      ),
    );
  }
}
