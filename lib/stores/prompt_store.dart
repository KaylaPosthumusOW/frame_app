import 'package:frameapp/models/prompt_model.dart';

abstract class PromptStore {
  Future<List<PromptModel>> loadAvailablePrompts({required String ownerUid});
  Future<List<PromptModel>> loadAllPreviousPrompts();
  Future<PromptModel> getCurrentPrompt();
  Future<void> createPrompt(PromptModel newPrompt);
  Future<PromptModel> updatePrompt(PromptModel prompt);
}
