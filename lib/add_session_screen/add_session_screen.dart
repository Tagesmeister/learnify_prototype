import 'package:flutter/material.dart';
import 'package:learnify_prototype/Data/DataHandler.dart';
import 'package:learnify_prototype/add_session_screen/Observer/I_observer.dart';

import '../add_session_dynamic_screen.dart';
import '../Data/ContainerListViewGenerate.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({super.key});

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen>
    implements Observer {
  late DataHandler dataHandler = DataHandler();
  late List<dynamic> list = dataHandler.getSessionData();
  @override
  void initState() {
    super.initState();
    dataHandler.addObserver(this);
  }

  /// Aktualisiert die lokale Liste aus der Hive-Box.
  Future<void> _refreshLocalData() async {
    setState(() {
      list = dataHandler.getSessionData();
    });
  }

  /// Persistiert die Reihenfolge in der Hive-Box, indem diese geleert und neu befüllt wird.
  Future<void> _persistOrder() async {
    // Option: Hier ließe sich auch gezielter nur geänderte Einträge updaten,
    // allerdings ist das bei einer kleinen Datenmenge meist unkritisch.
    await box.clear();
    for (var item in list) {
      await box.add(item);
    }
  }

  /// Erzeugt eine Swipe-Transition von unten nach oben.
  Route _createSwipeRouteUp(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.easeInOut));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD SECTION'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Navigiere zum "Add Session Dynamic"-Screen
              await Navigator.of(
                context,
              ).push(_createSwipeRouteUp(const AddSessionDynamic(true, "")));
              // Nach dem Zurückkehren werden die Daten neu geladen
              await _refreshLocalData();
            },
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ReorderableDragStartListener(
            key: ValueKey('$index-${list[index].subject}'),
            index: index,
            // Erstelle das Listenelement anhand der übergebenen Daten
            child: Containerlistviewgenerate.createDynamicSessionsListCustom(
              list[index],
              index,
              dataHandler,
              context,
            ),
          );
        },
        onReorder: (oldIndex, newIndex) async {
          if (newIndex > oldIndex) newIndex -= 1;
          final movedItem = list.removeAt(oldIndex);
          list.insert(newIndex, movedItem);
          setState(() {}); // UI sofort aktualisieren
          // Persistiere die neue Reihenfolge in Hive
          await _persistOrder();
        },
      ),
    );
  }

  @override
  void update() {
    setState(() {
      list = dataHandler.getSessionData();
    });
  }
}
