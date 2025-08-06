import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/models/prompt_model.dart';
import 'package:frameapp/stores/firebase/prompt_firebase_repository.dart';

part 'prompt_state.dart';

class PromptCubit extends Cubit<PromptState> {
  final PromptFirebaseRepository _promptRepository = sl<PromptFirebaseRepository>();

  PromptCubit() : super(const PromptInitial());

  Future<void> loadAllPrompts({required String ownerUid}) async {
    emit(PromptLoading(state.mainPromptState.copyWith(message: 'Loading prompts')));
    try {
      List<PromptModel> prompts = await _promptRepository.loadPrompts(ownerUid: ownerUid);
      emit(PromptLoaded(state.mainPromptState.copyWith(prompts: prompts, message: 'Loaded ${prompts.length} prompts')));
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> createNewPrompt(PromptModel newPrompt) async {
    emit(CreatingPrompt(state.mainPromptState.copyWith(message: 'Adding new prompt')));
    try {
      List<PromptModel> prompts = List.from(state.mainPromptState.prompts ?? []);
      PromptModel prompt = await _promptRepository.createPrompt(newPrompt);
      prompts.add(prompt);
      emit(PromptCreated(state.mainPromptState.copyWith(prompts: prompts, message: 'New prompt added', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> updatePrompt(PromptModel prompt) async {
    emit(UpdatingPrompt(state.mainPromptState.copyWith(message: 'Updating prompt')));
    try {
      List<PromptModel> prompts = List.from(state.mainPromptState.prompts ?? []);
      PromptModel updatedPrompt = await _promptRepository.updatePrompt(prompt);
      int index = prompts.indexWhere((p) => p.uid == updatedPrompt.uid);
      if (index != -1) {
        prompts[index] = updatedPrompt;
      }
      emit(PromptUpdated(state.mainPromptState.copyWith(prompts: prompts, message: 'Prompt updated')));
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  void setSelectedPrompt(PromptModel selectedPrompt) {
    emit(PromptLoading(state.mainPromptState.copyWith(message: 'Selecting prompt')));
    emit(PromptLoaded(state.mainPromptState.copyWith(selectedPrompt: selectedPrompt)));
  }

  void unSelectPrompt() {
    emit(PromptLoading(state.mainPromptState.copyWith(message: 'Selecting prompt')));
    emit(PromptLoaded(state.mainPromptState.copyWithNull(selectedPrompt: null)));
  }

}