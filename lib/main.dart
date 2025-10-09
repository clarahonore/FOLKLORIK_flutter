import 'package:flutter/material.dart';
import 'package:mon_app/pages/home.dart';
import 'package:mon_app/pages/enigme_1/enigme1_porte.dart';
import 'package:mon_app/pages/enigme_1/enigme1_reussite.dart';
import 'package:mon_app/pages/enigme_1/enigme1_mauvaise_reponse.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Folklorik',
      theme: ThemeData.dark(),
      initialRoute: '/porte_enigme1',
      routes: {
        '/home': (context) => const HomePage(),
        '/porte_enigme1': (context) => const Enigme1PortePage(),
        '/enigme1_reussite': (context) => const Enigme1Reussite(),
        '/enigme1_echec': (context) => const Enigme1MauvaiseReponse(),
      },
    );
  }
}