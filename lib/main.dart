import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'database/dao.dart';
import 'database/scenario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MonApp());

  //Insertion hardcodé
  var scenar = Scenario(
      nom: 'Bretagne',
      description : 'Un scenario sur les mythes de la bretagne',
      pisteAudio: "audio.exemple.lespistesnesontpasprêtes");
  scenar = await Dao.createScenario(scenar);

}

class MonApp extends StatelessWidget {
  const MonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}