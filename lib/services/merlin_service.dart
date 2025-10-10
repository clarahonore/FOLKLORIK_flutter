// lib/services/merlin_service.dart
import 'package:dart_openai/dart_openai.dart';

class MerlinService {
  static Future<String> askMerlin(String userMessage) async {
    try {
      final res = await OpenAI.instance.chat.create(
        model: "gpt-4o-mini",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                """
Tu es MERLIN, le grand enchanteur et meneur d'un escape game magique en Bretagne.
Tu guides les joueurs avec bienveillance et sagesse.
Parle comme un vieil homme mystérieux et drôle.
Ne donne jamais la réponse directement, mais des indices progressifs.
Reste toujours dans ton rôle.
""",
              ),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                userMessage,
              ),
            ],
          ),
        ],
        temperature: 0.7,
      );

      // ✅ Correction : item.text est déjà une String ici
      final items = res.choices.first.message.content ?? [];
      final buffer = StringBuffer();
      for (final item in items) {
        if (item.type == "text" && item.text != null) {
          buffer.writeln(item.text);
        }
      }

      final reply = buffer.toString().trim();
      return reply.isEmpty
          ? "Hmm… je ne comprends pas encore, jeune aventurier."
          : reply;
    } catch (e) {
      return "Par les astres ! Une perturbation magique m'empêche de répondre : $e";
    }
  }
}