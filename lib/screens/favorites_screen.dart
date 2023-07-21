import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/const.dart';
import '../models/task_model.dart';
import '../widgets/tasks_list.dart';

class FavoriteSscreen extends StatefulWidget {
  const FavoriteSscreen({super.key});
  @override
  State<FavoriteSscreen> createState() => _FavoriteSscreenState();
}

class _FavoriteSscreenState extends State<FavoriteSscreen> {
  // final favTasksBox = Hive.box<Task>(kFavoriteTasksBox);
  final newTasksBox = Hive.box<Task>(kNewTasksBox);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(kSettingsBox).listenable(),
      builder: (context, settings, _) {
        final int drawerIndex = Hive.box(kSettingsBox).get('drawerIndex');
        final index = Hive.box(kSettingsBox).get('background$drawerIndex');
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
                  Text(
                    'Favorits',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ValueListenableBuilder(
                    valueListenable: newTasksBox.listenable(),
                    builder: (context, fav, _) {
                      return NewTasksList(
                        newTasks: fav.values.where((e) => e.isFav!).toList(),
                      );
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
