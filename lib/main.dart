import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screen/home_screen.dart';

Future<void> main() async {
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

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF9F0),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF789477),
          primary: const Color(0xFF789477),
          secondary: const Color(0xFFF4A261),
          surface: const Color(0xFFFFFFFF),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
