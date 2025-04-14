import 'package:flutter/material.dart';
import 'add_session_screen/add_session_screen.dart';
import 'statistic_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Diese Methode erzeugt eine "Swipe"-Route von rechts nach links.
  Route _createSwipeRouteLeft(Widget page) {
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

  Route _createSwipeRouteRight(Widget page) {
    return PageRouteBuilder(
      // Wie lange soll das Vorwärts-Navigieren dauern?
      transitionDuration: const Duration(milliseconds: 400),
      // Wie lange soll das Zurück-Navigieren dauern?
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Wir starten rechts außerhalb des Bildschirms (x=1.0) ...
        const begin = Offset(-1.0, 0.0);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'H O M E',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button für "Add Session" mit Swipe-Animation:
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                child: const Text('Add Session'),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(_createSwipeRouteRight(const AddSessionScreen()));
                },
              ),
            ),
            const SizedBox(width: 20),
            // Button für "Statistic" mit Swipe-Animation:
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                child: const Text('Statistic'),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(_createSwipeRouteLeft(const StatisticScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
