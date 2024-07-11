import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.createdAtTime,
    required this.createdAtDate,
    required this.isCompleted,
  });

  @HiveField(0) // Id
  final String id;
  @HiveField(1) // Title
  String title;
  @HiveField(2) // SubTitle
  String subTitle;
  @HiveField(3) // CreatedAtTime
  DateTime createdAtTime;
  @HiveField(4) // CreatedAtDate
  DateTime createdAtDate;
  @HiveField(5) // IsCompleted
  bool isCompleted;

  // create new task
  factory Task.create({
    required String? title,
    required String? subTitle,
    DateTime? createdAtTime,
    DateTime? createdAtDate,
  }) =>
      Task(
        id: Uuid().v1(),
        title: title ?? "",
        subTitle: subTitle ?? "",
        createdAtTime: createdAtTime ?? DateTime.now(),
        createdAtDate: createdAtDate ?? DateTime.now(),
        isCompleted: false,
      );
}
