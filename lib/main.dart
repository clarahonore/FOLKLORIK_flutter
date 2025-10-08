import 'package:flutter/material.dart';
import 'package:mon_app/pages/enigme_1/enigme1_mauvaise_reponse.dart';
import 'package:mon_app/pages/enigme_1/enigme1_porte.dart';
import 'package:mon_app/pages/enigme_1/enigme1_reussite.dart';
import 'package:mon_app/pages/home.dart';
import 'package:mon_app/pages/ia/ia_meneur_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
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
      initialRoute: '/home',

      routes: {
        '/home': (context) => const HomePage(),
        '/porte_enigme1': (context) => const Enigme1PortePage(),
        '/enigme1_reussite': (context) => const Enigme1Reussite(),
        '/enigme1_echec': (context) => const Enigme1MauvaiseReponse(),
        '/ia_meneur': (context) => const IAMeneurPage(),
      },
    );
  }
}