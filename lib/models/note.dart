import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String uuid;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  // @HiveField(3)
  // final DateTime date;

  Note({
    required this.uuid,
    required this.title,
    required this.content,
    // required this.date,
  });
}
