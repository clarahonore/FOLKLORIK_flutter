import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_openai/dart_openai.dart';

import 'package:mon_app/pages/intro_folklorik.dart';
import 'package:mon_app/pages/enigme_1/enigme1_mauvaise_reponse.dart';
import 'package:mon_app/pages/enigme_1/enigme1_porte.dart';
import 'package:mon_app/pages/enigme_1/enigme1_reussite.dart';
import 'package:mon_app/pages/home.dart';
import 'package:mon_app/pages/bretagne_page.dart';
import 'package:mon_app/pages/accessibilite_page.dart';
import 'package:mon_app/services/accessibilite_status.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  OpenAI.apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  OpenAI.requestsTimeOut = const Duration(seconds: 40);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AccessibiliteStatus(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibiliteStatus>();

    final theme = access.contraste
        ? ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.highContrastDark(),
      textTheme: ThemeData.dark()
          .textTheme
          .apply(fontSizeFactor: access.texteGrand ? 1.2 : 1.0),
    )
        : ThemeData.light().copyWith(
      textTheme: ThemeData.light()
          .textTheme
          .apply(fontSizeFactor: access.texteGrand ? 1.2 : 1.0),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Folklorik',
      theme: theme,
      initialRoute: '/intro_folklorik',
      routes: {
        '/intro_folklorik': (context) => const IntroFolklorik(),
        '/home': (context) => const HomePage(),
        '/bretagne': (context) => const BretagnePage(),
        '/accessibilite': (context) => const AccessibilitePage(),
        '/porte_enigme1': (context) => const Enigme1PortePage(),
        '/enigme1_reussite': (context) => const Enigme1Reussite(),
        '/enigme1_echec': (context) => const Enigme1MauvaiseReponse(),
      },
    );
  }
}