import 'package:frameapp/models/prompt_model.dart';

abstract class PromptStore {
  Future<List<PromptModel>> loadPrompts({required String ownerUid});
  Future<void> createPrompt(PromptModel newPrompt);
  Future<PromptModel> updatePrompt(PromptModel prompt);
}
