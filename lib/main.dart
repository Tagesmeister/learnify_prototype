import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home.dart';
import 'statistic_screen.dart';
import 'add_session_screen/add_session_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive initialisieren
  await Hive.initFlutter();

  // Eine Box (so nennt man in Hive Speicherbereiche) öffnen
  await Hive.openBox('HiveDB');
  runApp(const MyApp());
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
