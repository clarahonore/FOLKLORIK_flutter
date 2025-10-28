import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_service.dart';

class InventairePage extends StatelessWidget {
  const InventairePage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryService>();
    final objets = inventory.objets;

    return Scaffold(
      backgroundColor: Colors.brown.shade900,
      appBar: AppBar(
        title: const Text(
          "Inventaire",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 🔙 Retour à la page précédente
        ),
      ),
      body: objets.isEmpty
          ? const Center(
        child: Text(
          "Inventaire vide 🪶",
          style: TextStyle(color: Colors.white70, fontSize: 20),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: objets.length,
          itemBuilder: (context, index) {
            final objet = objets[index];
            return GestureDetector(
              onTap: () => _showObjetPopup(context, objet),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown.shade800,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      objet["image"]!,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      objet["nom"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showObjetPopup(BuildContext context, Map<String, String> objet) {
    final inventory = Provider.of<InventoryService>(context, listen: false);

    bool isCalice = objet["nom"] == "Calice sacré";
    bool isCaliceRempli = objet["nom"] == "Calice d’eau pure";

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.brown.shade900.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(objet["image"]!, height: 100, fit: BoxFit.contain),
              const SizedBox(height: 16),
              Text(
                objet["nom"]!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                objet["description"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),

              // 🌊 Bouton spécial si c’est le calice sacré
              if (isCalice && !inventory.eauPureRecuperee)
                ElevatedButton.icon(
                  onPressed: () {
                    objet["nom"] = "Calice d’eau pure";
                    objet["description"] =
                    "Le calice est désormais rempli de l’eau pure de la source Viviane.";
                    objet["image"] = "assets/images/calice_eau.png";

                    inventory.marquerEauPureRecuperee();

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("💧 Vous avez rempli le calice d’eau pure !"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.water_drop, color: Colors.white),
                  label: const Text(
                    "Remplir d’eau de la source Viviane",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

              // ✅ Message si déjà rempli
              if (isCaliceRempli || inventory.eauPureRecuperee)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "💧 Le calice est déjà rempli d’eau pure.",
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(color: Colors.lightBlueAccent, fontSize: 16),
                  ),
                ),

              const SizedBox(height: 20),

              // 🔘 Bouton Fermer (commun à tous les objets)
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade700,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Fermer",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
