import 'package:hive_flutter/hive_flutter.dart';
import 'package:learnify_prototype/add_session_screen/Observer/I_observer.dart';
import 'dart:developer' as developer;

final box = Hive.box('HiveDB');

class DataHandler {
  late List<Observer> observers = [];

  /// Speichert die übergebenen Daten in der Hive-Box.
  static Future<void> storeDatainHive(
    String subject,
    DateTime date,
    List<String> sourceString,
    List<int?> sourceInt,
    DateTime plannedTime,
    bool isBook,
  ) async {
    await box.add({
      'subject': subject,
      'date': date.toIso8601String(),
      'plannedTime': plannedTime.toIso8601String(),
      'sourceString': sourceString,
      'sourceInt': sourceInt,
      'isBook': isBook,
    });

    final allEntries = box.toMap();
    developer.log(
      'Aktuelle Inhalte der Box: $allEntries',
      name: 'storeDatainHive',
    );
  }

  void remove(int index) {
    box.deleteAt(index);
    notify();
  }

  /// Liefert die Anzahl der Einträge in der Hive-Box.
  static int countEntries() {
    return box.length;
  }

  List<dynamic> getSessionData() {
    return box.values.toList();
  }

  void addObserver(Observer observer) {
    observers.add(observer);
  }

  void removeObserver(Observer observer) {
    observers.remove(observer);
  }

  void notify() {
    for (var o in observers) {
      o.update();
    }
  }
}
