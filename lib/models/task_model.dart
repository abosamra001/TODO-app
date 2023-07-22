import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveField(0)
const uuid = Uuid();

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String id;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime dueToDate;
  @HiveField(5)
  bool? isFav;
  @HiveField(6)
  bool? done;

  Task({
    required this.title,
    required this.dueToDate,
    this.isFav = false,
    this.done = false,
  })  : createdAt = DateTime.now(),
        id = uuid.v4();
}
