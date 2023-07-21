import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:todo/constants/const.dart';

import '../models/task_model.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsBox = Hive.box(kSettingsBox);
    int favCount = 0;
    int mydayCount = 0;
    for (var i in Hive.box<Task>(kNewTasksBox).values) {
      if (i.createdAt.day == DateTime.now().day) {
        mydayCount++;
      }
      if (i.isFav!) {
        favCount++;
      }
    }
    int alltasksCount = mydayCount + Hive.box<Task>(kCompletedTasksBox).length;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 4,
                  margin: const EdgeInsets.only(right: 5),
                  color: Theme.of(context).colorScheme.primary,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TODO',
                      style: GoogleFonts.pacifico(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                      ),
                    ),
                    const Text('Make sure you can & will do'),
                  ],
                ),
              ],
            ),
          ),
          CustomDrawerListTile(
            onTap: () {
              settingsBox.put('drawerIndex', 0);
              Navigator.pop(context);
            },
            index: 0,
            count: mydayCount,
            icon: Icons.wb_sunny_outlined,
            title: 'My Day',
          ),
          CustomDrawerListTile(
            onTap: () {
              settingsBox.put('drawerIndex', 1);
              Navigator.pop(context);
            },
            index: 1,
            count: favCount,
            icon: Icons.favorite,
            title: 'Favorites',
          ),
          CustomDrawerListTile(
            onTap: () {
              settingsBox.put('drawerIndex', 2);
              Navigator.pop(context);
            },
            index: 2,
            count: alltasksCount,
            title: 'All Tasks',
            icon: Icons.select_all_rounded,
          )
        ],
      ),
    );
  }
}

class CustomDrawerListTile extends StatefulWidget {
  const CustomDrawerListTile({
    super.key,
    required this.count,
    required this.index,
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final int count;
  final int index;
  final String title;
  final IconData icon;
  final void Function() onTap;

  @override
  State<CustomDrawerListTile> createState() => _CustomDrawerListTileState();
}

class _CustomDrawerListTileState extends State<CustomDrawerListTile> {
  bool isSelected = false;
  int drawerIndex = Hive.box(kSettingsBox).get('drawerIndex');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: ListTile(
        selected: isSelected = widget.index == drawerIndex,
        onTap: widget.onTap,
        selectedTileColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(widget.icon),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: CircleAvatar(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[800],
          foregroundColor: Colors.white,
          radius: 11,
          child: Text(
            widget.count.toString(),
          ),
        ),
      ),
    );
  }
}
