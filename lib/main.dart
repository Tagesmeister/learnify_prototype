import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learnify_prototype/Data/SessionModel.dart';
import 'home.dart';
import 'statistic_screen.dart';
import 'add_session_screen/add_session_screen.dart';

import 'package:do_not_disturb/do_not_disturb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ensureDndAndActivate();

  await Hive.initFlutter();
  Hive.registerAdapter(SessionModelAdapter());
  await Hive.openBox<SessionModel>('sessions');

  // Notifications initialisieren

  runApp(const MyApp());
}

/// Ruft diese Methode z. B. beim App‑Start oder auf einen Button‑Tap auf.
Future<void> ensureDndAndActivate() async {
  final dnd = DoNotDisturbPlugin();

  // 1. Prüfen, ob die App den „Nicht‑Stören‑Zugriff“ schon hat
  final granted = await dnd.isNotificationPolicyAccessGranted();

  if (!granted) {
    // Noch nicht gewährt → einmalig in die passende Systemeinstellung springen
    await dnd.openNotificationPolicyAccessSettings();

    // Hier KEINE weitere Aktion ausführen; der Nutzer muss erst zurückkommen.
    return;
  }
  // https://chatgpt.com/share/68017bb6-1568-800f-87d5-1b44d143b82b ----------------------------------------------------------------------------------
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // Disables Material 3 so the old theming works
      ),
      home: const HomePage(),
      routes: {
        '/statisticscreen': (context) => const StatisticScreen(),
        '/addsessionscreen': (context) => const AddSessionScreen(),
      },
    );
  }
}
