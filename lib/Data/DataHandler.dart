import 'package:hive_flutter/hive_flutter.dart';
import 'package:learnify_prototype/Data/SessionModel.dart';
import 'package:learnify_prototype/add_session_screen/Observer/I_observer.dart';
import 'dart:developer' as developer;

final box = Hive.box<SessionModel>('sessions');

class DataHandler {
  late List<Observer> observers = [];

  /// Speichert die übergebenen Daten in der Hive-Box.
  static Future<void> storeDatainHive(SessionModel sessionModel) async {
    await box.add(sessionModel);

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

  static SessionModel getCurrentSession(String id) {
    var list = box.values.toList();
    var currentSession = list.where((x) => x.id == id).toList();
    return currentSession[0];
  }
}
