import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BarkBeacon',
      //theme: ThemeData(
      //useMaterial3: true,
      //scaffoldBackgroundColor: const Color(0xFFF8F5ED),
      //colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF789477)),
      //),

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFE8F0FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFFF59E0B),
          surface: const Color(0xFFFFFFFF),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
