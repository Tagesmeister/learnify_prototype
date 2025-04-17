import 'package:flutter/material.dart';
import 'package:learnify_prototype/add_session_dynamic_screen.dart';

import 'DataHandler.dart';

class Containerlistviewgenerate {
  static Widget createDynamicSessionsListCustom(
    dynamic dataAccess,
    int index,
    DataHandler dataHandler,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade300,
            child: const Icon(Icons.calculate, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dataAccess.subject}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dataAccess.plannedTime,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.delete, color: Colors.green.shade800),
                onPressed: () {
                  dataHandler.remove(index);
                },
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green.shade800),
                onPressed: () {
                  Navigator.of(context).push(
                    _createSwipeRouteLeft(
                      AddSessionDynamic(false, dataAccess.id),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Route _createSwipeRouteLeft(Widget page) {
    return PageRouteBuilder(
      // Wie lange soll das Vorwärts-Navigieren dauern?
      transitionDuration: const Duration(milliseconds: 400),
      // Wie lange soll das Zurück-Navigieren dauern?
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Wir starten rechts außerhalb des Bildschirms (x=1.0) ...
        const begin = Offset(1.0, 0.0);
        // ... und bewegen uns nach x=0.0 (im sichtbaren Bereich).
        const end = Offset.zero;

        // Für eine sanfte Beschleunigung/Abbremsung:
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.easeInOut));

        // Mit drive() kombinieren wir den Tween mit der Animation.
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
