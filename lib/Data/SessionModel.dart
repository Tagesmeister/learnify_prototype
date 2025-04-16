import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'SessionModel.g.dart';

@HiveType(typeId: 0)
class SessionModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String subject;

  @HiveField(2)
  String date;

  @HiveField(3)
  String plannedTime;

  @HiveField(4)
  List<String> sourceString;

  @HiveField(5)
  List<int?> sourceInt;

  @HiveField(6)
  bool isBook;

  // Der Konstruktor verwendet nun benannte Parameter mit Default-Werten.
  // Dadurch kann SessionModel() ohne Argumente aufgerufen werden.
  SessionModel(
    String subject,
    String parsedDate,
    List<String> source,
    List<int?> sourceInt,
    String parsedTime,
    bool isBook,
  ) : id = Uuid().v4(),
      subject = subject,
      date = parsedDate,
      plannedTime = parsedTime,
      sourceString = source,
      sourceInt = sourceInt,
      isBook = isBook;
}
