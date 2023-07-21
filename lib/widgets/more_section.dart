import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/constants/const.dart';

const List<String> dropdownItems = [
  'Created date',
  'Alphabetically',
  'Imporance',
  'Due date',
];
String? dropdownValue = dropdownItems.first;

class MoreSection extends StatefulWidget {
  const MoreSection({super.key});

  @override
  State<MoreSection> createState() => _MoreSectionState();
}

class _MoreSectionState extends State<MoreSection> {
  final settingsBox = Hive.box(kSettingsBox);

  @override
  Widget build(BuildContext context) {
    final drawerIndex = settingsBox.get('drawerIndex');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 30,
      ),
      child: ValueListenableBuilder(
        valueListenable: settingsBox.listenable(),
        builder: (context, box, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(right: 10),
              leading: const Icon(Icons.sort),
              title: const Text('Sort by'),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  items: dropdownItems
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value;
                    });
                    settingsBox.put('sortType', value);
                  },
                  icon: const Icon(Icons.arrow_forward),
                  iconDisabledColor: Colors.grey[600],
                ),
              ),
            ),
            const Text('Themes'),
            const SizedBox(height: 5),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 5,
                ),
                itemCount: 10,
                itemBuilder: (context, i) => InkWell(
                  onTap: () {
                    settingsBox.put('background$drawerIndex', i);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: settingsBox.get('background$drawerIndex') == i
                          ? Colors.blue
                          : null,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/background$i.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
