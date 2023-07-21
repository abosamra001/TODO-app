import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/task_model.dart';
import '../screens/all_tasks.dart';
import '../screens/favorites_screen.dart';
import '../screens/my_day_screen.dart';
import '../widgets/main_drawer.dart';
import '../widgets/more_section.dart';
import '../constants/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  late Widget content;

  final newTasksBox = Hive.box<Task>(kNewTasksBox);
  final completedTasksBox = Hive.box<Task>(kCompletedTasksBox);
  // final favTasksBox = Hive.box<Task>(kFavoriteTasksBox);
  final settingsBox = Hive.box(kSettingsBox);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int sortingTypes(Task a, Task b) {
    if (settingsBox.get('sortType') == 'Created date') {
      return a.createdAt.compareTo(b.createdAt);
    } else if (settingsBox.get('sortType') == 'Alphabetically') {
      return a.title.compareTo(b.title);
    } else {
      if (a.isFav! && !b.isFav!) {
        return -1;
      } else {
        return 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int drawerIndex = settingsBox.get('drawerIndex', defaultValue: 0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.background,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
              debugPrint('new tasks length : ${newTasksBox.length}');
              debugPrint(
                  'completed tasks length : ${completedTasksBox.length}');
              // debugPrint('Fav tasks : ${favTasksBox.length}');
            },
            icon: const Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const MoreSection(),
              );
            },
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      //=========================== value listenable builder
      body: ValueListenableBuilder(
        valueListenable: Hive.box(kSettingsBox).listenable(),
        builder: (context, settings, _) {
          var index = settings.get('drawerIndex');
          if (index == 0) {
            content = MyDayScreen(
              sortFunction: sortingTypes,
            );
          } else if (index == 1) {
            content = const FavoriteSscreen();
          } else {
            content = AllTasksScreen(
              sortFunction: sortingTypes,
            );
          }
          return content;
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withAlpha(200),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Form(
          key: formKey,
          autovalidateMode: _autovalidateMode,
          child: TextFormField(
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Field is required';
              } else {
                return null;
              }
            },
            controller: _controller,
            keyboardAppearance: Theme.of(context).brightness,
            onFieldSubmitted: (value) {
              if (formKey.currentState!.validate()) {
                final task = Task(
                  title: value,
                  createdAt: DateTime.now(),
                );

                if (drawerIndex == 1) {
                  task.isFav = true;
                  // favTasksBox.put(task.id, task.copy..isFav = true);
                }
                setState(() {
                  newTasksBox.put(task.id, task);
                });

                _controller.clear();
              } else {
                _autovalidateMode = AutovalidateMode.always;
              }
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.add),
              hintText: 'Add a task',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
