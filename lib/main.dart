import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/seat_manager.dart';
import 'view/splash_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SeatManager()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: "My UWL auditorium",
    );
  }
}
